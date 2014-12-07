package  {
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import loom2d.events.KeyboardEvent;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	public class Environment {
		
		private var w:int;
		private var h:int;
		
		private var background:Image;
		
		private var display:Sprite = new Sprite();
		
		private var arena:Entity;
		
		private var ais = new Vector.<AI>();
		private var player:Player;
		private var pine:Pine;
		private var snowballs = new Vector.<Snowball>();
		
		private var entities = new Vector.<Entity>();
		
		private var spawnTimer = 0;
		private var spawnTime = 0.5;
		private var spawnMax = 5;
		
		private var snowOverlay:SnowOverlay;
		private var spawnRadiusMin:Number;
		private var spawnRadiusMax:Number;
		private var spawnRadiusStretch:Number;
		
		public function Environment(stage:Stage, w:int, h:int) {
			this.w = w;
			this.h = h;
			
			background = new Image(Texture.fromAsset("assets/bg_perspective.png"));
			display.addChild(background);
			
			addEntity(player = new Player(display));
			addEntity(pine = new Pine(display));
			
			arena = new Entity();
			arena.bounds = new Rectangle(0, 0, background.width, background.height);
			
			snowOverlay = new SnowOverlay();
			display.addChild(snowOverlay);
			snowOverlay.initialize(w, h);
			
			spawnRadiusMin = 200;
			spawnRadiusMax = 300;
			
			display.scale = 2;
			
			stage.addChild(display);
			
			reset();
		}
		
		private function addAI(ai:AI) {
			ais.push(ai);
			entities.push(ai);
		}
		
		private function addEntity(entity:Entity) {
			entities.push(entity);
		}
		
		public function reset() {
			for (var i:int = 0; i < ais.length; i++) {
				var ai = ais[i];
				ai.setPosition(w*0.5, h*0.25);
			}
			player.setPosition(w*0.5, h*0.5);
		}
		
		public function onKeyDown(e:KeyboardEvent) {
			switch (e.keyCode) {
				case 26: // W
					player.moveUp = true;
					break;
				case 22: // S
					player.moveDown = true;
					break;
				case 4: // A
					player.moveLeft = true;
					break;
				case 7: // D
					player.moveRight = true;
					break;
			}
		}
		
		public function onKeyUp(e:KeyboardEvent) {
			switch (e.keyCode) {
				case 26: // W
					player.moveUp = false;
					break;
				case 22: // S
					player.moveDown = false;
					break;
				case 4: // A
					player.moveLeft = false;
					break;
				case 7: // D
					player.moveRight = false;
					break;
				case 44:
					var snowball = new Snowball(display, player.getPosition(), player.getDirection());
					snowballs.push(snowball);
					addEntity(snowball);
					break;
			}
		}
		
		public override function tick(t:Number, dt:Number) {
			var ai:AI;
			
			spawnTimer += dt;
			if (spawnTimer > spawnTime && ais.length < spawnMax) {
				spawnTimer = 0;
				ai = new SimpleAI(display);
				var angle = Math.randomRange(0, Math.TWOPI);
				var radius = Math.randomRange(spawnRadiusMin, spawnRadiusMax);
				ai.setPosition(w/2+Math.cos(angle)*radius, h/2+Math.sin(angle)*radius);
				addAI(ai);
			}
			
			player.tick(t, dt);
			pine.tick(t, dt);
			snowOverlay.tick(dt);
			
			var i:int;
			var j:int;
			
			for (i = 0; i < snowballs.length; i++) {
				var snowball = snowballs[i];
				snowball.tick(t, dt);
				if (snowball.checkCollision(pine))
				{
					pine.hit();
					snowball.destroy();
				}
				
				if (!snowball.checkCollision(arena))
				{
					snowball.destroy();
				}
				//
				for (j = 0; j < ais.length; j++) {
					ai = ais[j];
					if (snowball.checkCollision(ai)) {
						ai.destroy();
						snowball.destroy();
					}
				}
			}
			
			var playerPos:Point = player.getPosition();
			for (i = 0; i < ais.length; i++) {
				ai = ais[i];
				ai.target = playerPos;
				ai.tick(t, dt);
			}
			
			flush();
			
			t += dt;
		}
		
		public override function render(t:Number) {
			for (var i = 0; i < entities.length; i++) {
				var entity = entities[i];
				entity.render(t);
			}
		}
		
		private function flush() {
			removeCorpses(entities);
			removeCorpses(ais);
			removeCorpses(snowballs);
		}
		
		private function removeCorpses(vector:Vector.<Entity>) {
			for (var i = vector.length-1; i >= 0; i--) {
				var entity = vector[i];
				if (entity.state == Entity.STATE_DESTROYED) {
					vector.splice(i, 1);
				}
			}
		}
		
	}
	
}