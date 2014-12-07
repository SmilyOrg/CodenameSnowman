package  {
	import loom2d.display.DisplayObjectContainer;
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
		
		private var ground:Sprite = new Sprite();
		private var display:Sprite = new Sprite();
		
		private var arena:Entity;
		
		private var ais = new Vector.<AI>();
		private var player:Player;
		private var pine:Pine;
		private var snowballs = new Vector.<Snowball>();
		
		private var entities = new Vector.<Entity>();
		
		private var snowOverlay:SnowOverlay;
		
		public function Environment(stage:Stage, w:int, h:int) {
			this.w = w;
			this.h = h;
			
			Entity.environment = this;
			
			background = new Image(Texture.fromAsset("assets/bg_perspective.png"));
			ground.addChild(background);
			
			for (var i:int = 0; i < 3; i++) {
				var ai = new SimpleAI(display);
				ais.push(ai);
				addEntity(ai);
			}
			
			addEntity(player = new Player(display));
			addEntity(pine = new Pine(display));
			
			arena = new Entity();
			arena.bounds = new Rectangle(0, 0, background.width, background.height);
			
			snowOverlay = new SnowOverlay();
			display.addChild(snowOverlay);
			snowOverlay.initialize(w, h);
			
			display.scale = 2;
			ground.scale = 2;
			
			stage.addChild(ground);
			stage.addChild(display);
			
			reset();
		}
		
		public function addEntity(entity:Entity) {
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
			player.tick(t, dt);
			pine.tick(t, dt);
			snowOverlay.tick(dt);
			
			var i:int;
			var j:int;
			var ai:AI;
			
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
			
			for (i = 0; i < entities.length; i++) {
				var entity:Entity = entities[i];
				entity.tick(t, dt);
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
					entity.destroy();
				}
			}
		}
		
		public function getDisplay():DisplayObjectContainer
		{
			return display;
		}
		
		public function getGround():DisplayObjectContainer
		{
			return ground;
		}
		
	}
	
}