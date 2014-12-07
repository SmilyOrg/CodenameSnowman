package  {
	import loom2d.display.DisplayObject;
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
		
		private var shadowLayer:Sprite = new Sprite();
		private var ground:Sprite = new Sprite();
		private var display:Sprite = new Sprite();
		private var ui:Sprite = new Sprite();
		
		private var scoreUI:ScoreUI;
		
		private var arena:Entity;
		
		private var ais = new Vector.<AI>();
		private var player:Player;
		private var walls:Walls;
		private var flag:Flag;
		private var snowballs = new Vector.<Snowball>();
		private var snowballItems = new Vector.<SnowballItem>();
		private var pines = new Vector.<Pine>();
		
		private var entities = new Vector.<Entity>();
		
		private var spawnTimer = 0;
		private var spawnTime = 0.5;
		private var spawnMax = 5;
		
		private var snowOverlay:SnowOverlay;
		private var snowballUi:SnowballUI;
		private var spawnRadiusMin:Number;
		private var spawnRadiusMax:Number;
		private var spawnRadiusStretch:Number;
		
		public function Environment(stage:Stage, w:int, h:int) {
			this.w = w;
			this.h = h;
			
			Entity.environment = this;
			
			background = new Image(Texture.fromAsset("assets/bg_perspective.png"));
			ground.addChild(background);
			
			addEntity(player = new Player(display));
			addEntity(walls = new Walls());
			addEntity(flag = new Flag());
			
			addSnowball(307, 180, false);
			addSnowball(333, 180, false);
			addSnowball(320, 193, false);
			addSnowball(320, 167, false);
			addSnowball(310, 170, false);
			addSnowball(310, 190, false);
			addSnowball(330, 170, false);
			addSnowball(330, 190, false);
			
			addPine(50, 40);
			addPine(75, 60);
			addPine(30, 75);
			addPine(600, 60);
			addPine(580, 90);
			addPine(605, 330);
			addPine(40, 340);
			addPine(60, 290);
			addPine(100, 330);
			
			//addAI(new ThinkyAI(display, 10));
			//addAI(new ThinkyAI(display, 1));
			//addAI(new ThinkyAI(display, 10));
			//addAI(new ThinkyAI(display, 100));
			
			arena = new Entity();
			arena.bounds = new Rectangle(0, 0, background.width, background.height);
			
			snowOverlay = new SnowOverlay();
			display.addChild(snowOverlay);
			snowOverlay.initialize(w, h);
			
			snowballUi = new SnowballUI();
			
			scoreUI = new ScoreUI(ui, h);
			
			spawnRadiusMin = 200;
			spawnRadiusMax = 300;
			
			display.scale = 2;
			shadowLayer.scale = 2;
			ground.scale = 2;
			ui.scale = 2;
			
			stage.addChild(ground);
			stage.addChild(shadowLayer);
			stage.addChild(display);
			stage.addChild(ui);
			
			reset();
		}
		
		public function addPine(x:int, y:int)
		{
			var pine = new Pine(display);
			pine.setPosition(x, y);
			pines.push(pine);
			addEntity(pine);
			
		}
		
		public function addSnowball(x:int, y:int, fades:Boolean = true)
		{
			var snowball = new SnowballItem(fades);
			snowball.setPosition(x, y);
			snowballItems.push(snowball);
			addEntity(snowball);
		}
		
		private function addAI(ai:AI) {
			ai.onSnowball += throwSnowball;
			ais.push(ai);
			entities.push(ai);
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
				case 8: // E
					player.startMakingSnowball();
					break;
				case 44: // Space
					player.charge();
					break;
			}
		}
		
		public function onKeyUp(e:KeyboardEvent) {
			trace(e.keyCode);
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
				case 8: // E
					player.endMakingSnowball();
					break;
				case 44: // space
					scoreUI.addScore(5);
					if (snowballUi.throwSnowball())
					{
						throwSnowball(player, player.getPosition(), player.getDirection(), player.currentCharge, player.maxCharge);
					}
					break;
				case 10: // G
					if (snowballUi.throwSnowball())
					{
						var pos = player.getPosition();
						addSnowball(pos.x, pos.y + 12, false);
					}
					break;
			}
		}
		
		private function throwSnowball(owner:Actor, position:Point, velocity:Point, charge:Number, maxCharge:Number) {
			//trace(position, velocity, charge, maxCharge);
			var snowball = new Snowball(display, owner, position, velocity, charge, maxCharge);
			snowballs.push(snowball);
			addEntity(snowball);
		}
		
		public override function tick(t:Number, dt:Number) {
			var ai:AI;
			
			var i:int;
			var j:int;
			
			spawnTimer += dt;
			if (spawnTimer > spawnTime && ais.length < spawnMax) {
				spawnTimer = 0;
				if (Math.random() < 0.6) {
					ai = new ThinkyAI(display);
				} else {
					ai = new SimpleAI(display);
				}
				var angle = Math.randomRange(0, Math.TWOPI);
				var radius = Math.randomRange(spawnRadiusMin, spawnRadiusMax);
				ai.setPosition(w/2+Math.cos(angle)*radius, h/2+Math.sin(angle)*radius);
				addAI(ai);
			}
			
			for (i = 0; i < entities.length; i++) {
				var entity:Entity = entities[i];
				entity.tick(t, dt);
			}

			snowOverlay.tick(dt);
			snowballUi.tick(t, dt);
			
			snowOverlay.tick(dt);
			
			for (i = 0; i < snowballs.length; i++) {
				var snowball = snowballs[i];
				
				for (j = 0; j < pines.length; j++)
				{
					var pine = pines[j];
					if (snowball.checkCollision(pine))
					{
						pine.hit();
						snowball.destroy();
					}
				}
				
				if (!snowball.checkCollision(arena))
				{
					snowball.destroy();
				}
				
				for (j = 0; j < ais.length; j++) {
					ai = ais[j];
					if (snowball.checkCollision(ai) && snowball.owner != ai) {
						//ai.destroy();
						snowball.destroy();
					}
				}
			}
			
			for (i = 0; i < snowballItems.length; i++)
			{
				var sb = snowballItems[i];
				
				var pp = player.getPosition();
				pp.y += 10;
				
				var d = Point.distance(pp, sb.getPosition());
				
				if (sb.canPickUp())
				{
					if (d < 7)
					{
						if (snowballUi.pickUpSnowball())
						{
							sb.destroy();
							snowballItems.splice(i, 1);
						}
						break;
					}
				}
				else
				{
					if (d >= 7)
					{
						sb.enablePickUp();
					}
				}
			}
			
			var playerPos:Point = player.getPosition();
			for (i = 0; i < ais.length; i++) {
				ai = ais[i];
				ai.target = playerPos;
			}
			
			flush();
			
			t += dt;
		}
		
		public override function render(t:Number) {
			display.sortChildren(sortByY);
			for (var i = 0; i < entities.length; i++) {
				var entity = entities[i];
				entity.render(t);
			}
		}
		
		private function sortByY(a:DisplayObject, b:DisplayObject):int {
			return a.y < b.y ? -1 : a.y > b.y ? 1 : 0;
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
		
		public function getDisplay():DisplayObjectContainer
		{
			return display;
		}
		
		public function getGround():DisplayObjectContainer
		{
			return ground;
		}
		
		public function getUi():DisplayObjectContainer
		{
			return ui;
		}
		public function getShadowLayer():DisplayObjectContainer
		{
			return shadowLayer;
		}
		
		public function getSnowballUi(): SnowballUI
		{
			return snowballUi;
		}
		
		public function getScoreUi():ScoreUI
		{
			return scoreUI;
		}
	}
	
}