package  {
	import loom.admob.InterstitialAd;
	import loom2d.display.DisplayObject;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.display.Quad;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import loom2d.events.KeyboardEvent;
	import loom2d.events.Touch;
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
		
		private var navPoints:Vector.<Point> = new Vector.<Point>();
		
		private var waves:Vector.<Wave> = new Vector.<Wave>();
		private var currentWave:Number = 0;
		
		private var debug:Quad;
		
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
			addPine(25, 75);
			addPine(600, 60);
			addPine(570, 90);
			addPine(605, 330);
			addPine(35, 340);
			addPine(75, 285);
			addPine(110, 330);
			
			
			var goal = new Point(w/2, h/2);
			
			navPoints.push(goal);
			
			navPoints.push(new Point(256, 178));
			navPoints.push(new Point(380, 178));
			
			navPoints.push(new Point(320, 216));
			navPoints.push(new Point(320, 260));
			navPoints.push(new Point(320, 300));
			
			navPoints.push(new Point(320, 122));
			navPoints.push(new Point(320, 86));
			navPoints.push(new Point(320, 62));
			
			navPoints.push(new Point(250, 62));
			navPoints.push(new Point(131, 119));
			navPoints.push(new Point(104, 205));
			navPoints.push(new Point(165, 293));
			navPoints.push(new Point(238, 312));
			navPoints.push(new Point(394, 309));
			navPoints.push(new Point(506, 272));
			navPoints.push(new Point(532, 188));
			navPoints.push(new Point(516, 112));
			navPoints.push(new Point(468, 54));
			navPoints.push(new Point(374, 44));
			
			
			
			navPoints.sort(function(a:Point, b:Point):int {
				var da = Point.distanceSquared(goal, a);
				var db = Point.distanceSquared(goal, b);
				return da < db ? -1 : da > db ? 1 : 0;
			});
			
			
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
			debug = new Quad(5, 5, 0x00FF00, true, true);
			display.addChild(debug);
			
			var wave = new Wave();
			wave.addSpawnPoint(new Point(320, 0), EnemyType.SIMPLE, 2, 20);
			wave.addSpawnPoint(new Point(320, 360), EnemyType.SIMPLE, 2, 20);
			wave.addSpawnPoint(new Point(0, 180), EnemyType.SIMPLE, 2, 20);
			wave.addSpawnPoint(new Point(640, 180), EnemyType.SIMPLE, 2, 20);
			waves.push(wave);
			
			wave = new Wave();
			wave.addSpawnPoint(new Point(320, 0), EnemyType.SIMPLE, 3, 10);
			wave.addSpawnPoint(new Point(320, 360), EnemyType.SIMPLE, 3, 10);
			wave.addSpawnPoint(new Point(0, 180), EnemyType.SIMPLE, 3, 10);
			wave.addSpawnPoint(new Point(640, 180), EnemyType.SIMPLE, 3, 10);
			waves.push(wave);
			
			wave = new Wave();
			wave.addSpawnPoint(new Point(320, 0), EnemyType.THINKY, 2, 10);
			wave.addSpawnPoint(new Point(320, 360), EnemyType.THINKY, 2, 10);
			wave.addSpawnPoint(new Point(0, 180), EnemyType.THINKY, 2, 10);
			wave.addSpawnPoint(new Point(640, 180), EnemyType.THINKY, 2, 10);
			waves.push(wave);
			
			reset();
		}
		
		public function getClosestNavPoint(actor:Actor):Point {
			var source = actor.getPosition();
			var np:Point;
			var result:Point;
			var los:Entity;
			var found:Vector.<Point> = new Vector.<Point>();
			var i:int;
			for (i = 0; i < navPoints.length; i++) {
				np = navPoints[i];
				los = lineOfSight(source, np, entities, actor, result);
				if (!los) {
					found.push(np);
					if (found.length > 3) break;
				}
			}
			var minDist = Number.MAX_VALUE;
			var min = np;
			for (i = 0; i < found.length; i++) {
				var f = found[i];
				var dist = Point.distanceSquared(f, source);
				if (dist < minDist) {
					minDist = dist;
					min = f;
				}
			}
			return min;
		}
		
		private function lineOfSight(source:Point, target:Point, ents:Vector.<Entity>, ignore:Entity, result:Point):Entity {
			for (var i = 0; i < ents.length; i++) {
				var entity:Entity = ents[i];
				if (entity == ignore) continue;
				if (!entity.isCollidable) continue;
				if (entity.children) {
					return lineOfSight(source, target, entity.children, ignore, result);
				} else {
					if (entity.intersectBounds(source, target, result)) {
						return entity;
					}
				}
			}
			return null;
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
		
		public function addAI(ai:AI) {
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
					scoreUI.addScore(5);
					player.charge();
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
				case 8: // E
					player.endMakingSnowball();
					break;
				case 44: // space
					if (snowballUi.throwSnowball())
					{
						throwSnowball(player, player.getPosition(), player.getDirection(), player.currentCharge, player.maxCharge);
						player.resetCharge();
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
			
			var center = new Point(w/2, h/2);
			
			if (currentWave < waves.length)
			{
				waves[currentWave].tick(dt);
				
				if (waves[currentWave].isFinished())
				{
					currentWave++;
					trace("new wave");
				}
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
						if(!snowball.isYellowSnow())
							snowball.destroy();
					}
				}
				
				if (!snowball.checkCollision(arena))
				{
					snowball.destroy();
				}
				
				if (snowball.checkCollision(walls))
				{
					snowball.destroy();
				}
				
				for (j = 0; j < ais.length; j++) {
					ai = ais[j];
					if (snowball.checkCollision(ai) && snowball.owner != ai) {
						ai.destroy();
						if(!snowball.isYellowSnow())
							snowball.destroy();
					}
				}
			}
			
			//var cnp = getClosestNavPoint(player);
			//var cnp = player.walkableLineOfSight(center, new Point(center.x, 0));
			//trace(player.intersectBounds(center, new Point(center.x, 0), new Point()));
			//var cnp = navPoints[Math.floor(navPoints.length*Math.random())];
			//debug.x = cnp.x;
			//debug.y = cnp.y;
			
			for (i = 0; i < snowballItems.length; i++)
			{
				var sb = snowballItems[i];
				
				var pp = player.getPosition();
				pp.y += 10;
				
				var d = Point.distance(pp, sb.getPosition());
				
				if (sb.canPickUp())
				{
					if (d < 10)
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
					if (d >= 10)
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
		
		public function checkCollisionWithEntities(e:Entity):Boolean
		{
			for (var i = 0; i < entities.length; i++) {
				var ent = entities[i];
				if (e != ent && e.checkCollision(ent)) {
					if(e.getTypeName() == "Player")
					return true;
				}
			}
				
			return false;
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