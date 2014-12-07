package  {
	import loom.admob.InterstitialAd;
	import loom.Application;
	import loom2d.display.DisplayObject;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import loom2d.events.KeyboardEvent;
	import loom2d.events.Touch;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	import loom2d.ui.ButtonClickCallback;
	
	public class Environment {
		
		private var w:int;
		private var h:int;
		
		private var background:Image;
		
		private var shadowLayer:Sprite = new Sprite();
		private var fogLayer:Sprite = new Sprite();
		private var ground:Sprite = new Sprite();
		private var display:Sprite = new Sprite();
		private var ui:Sprite = new Sprite();
		
		private var scoreUI:ScoreUI;
		private var messageUI:MessageUI;
		private var whiteoutUI:WhiteoutUI;
		
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
		
		private var waves:Vector.<Wave> = new Vector.<Wave>();
		private var currentWave:Number = 0;
		private var realRestart:Function;
		private var shouldBeRestarted:Boolean = false;
		
		private var started:Boolean;
		private var stopped:Boolean;
		
		public function Environment(stage:Stage, w:int, h:int, restart:Function) {
			this.w = w;
			this.h = h;
			realRestart = restart;
			
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
			
			arena = new Entity();
			arena.bounds = new Rectangle(0, 0, background.width, background.height);
			
			snowOverlay = new SnowOverlay();
			display.addChild(snowOverlay);
			snowOverlay.initialize(w, h);
			
			snowballUi = new SnowballUI();
			scoreUI = new ScoreUI(ui, h);
			messageUI = new MessageUI(ui);
			whiteoutUI = new WhiteoutUI(ui);
			
			spawnRadiusMin = 200;
			spawnRadiusMax = 300;
			
			display.scale = 2;
			shadowLayer.scale = 2;
			fogLayer.scale = 2;
			ground.scale = 2;
			ui.scale = 2;
			
			stage.addChild(ground);
			stage.addChild(shadowLayer);
			stage.addChild(display);
			stage.addChild(fogLayer);
			stage.addChild(ui);
			
			var wave = new Wave();
			wave.addSpawnPoint(new Point(320, 0), EnemyType.SIMPLE, 1, 20, 1);
			//wave.addSpawnPoint(new Point(320, 360), EnemyType.SIMPLE, 2, 20);
			//wave.addSpawnPoint(new Point(0, 180), EnemyType.SIMPLE, 2, 20);
			//wave.addSpawnPoint(new Point(640, 180), EnemyType.SIMPLE, 2, 20);
			waves.push(wave);
			
			wave = new Wave();
			wave.addSpawnPoint(new Point(320, 0), EnemyType.SIMPLE, 1, 10, 4);
			//wave.addSpawnPoint(new Point(320, 360), EnemyType.SIMPLE, 3, 10);
			//wave.addSpawnPoint(new Point(0, 180), EnemyType.SIMPLE, 3, 10);
			//wave.addSpawnPoint(new Point(640, 180), EnemyType.SIMPLE, 3, 10);
			waves.push(wave);
			
			wave = new Wave();
			wave.addSpawnPoint(new Point(320, 0), EnemyType.THINKY, 1, 10, 4);
			//wave.addSpawnPoint(new Point(320, 360), EnemyType.THINKY, 2, 10);
			//wave.addSpawnPoint(new Point(0, 180), EnemyType.THINKY, 2, 10);
			//wave.addSpawnPoint(new Point(640, 180), EnemyType.THINKY, 2, 10);
			waves.push(wave);
			
			reset();
			
			// just to init everything before the actual ticking of waves
			started = false;
			stopped = false;
			
			whiteoutUI.fadeIn(getReady);
		}
		
		private function getReady()
		{
			setMessage("Get ready!", start);
		}
		
		private function start()
		{
			setMessage("Wave " + (currentWave + 1), reallyStart);
		}
		
		private function reallyStart()
		{
			started = true;
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
			
			if (!started)
				return;
			
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
			
			if (!started)
				return;
			
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
		
		private function victory()
		{
			setMessage("Victory", restart);
			started = false;
			stopped = true;
		}
		
		private function death()
		{
			setMessage("You were defeated!", restart);
			started = false;
			stopped = true;
		}
		
		private function defeat()
		{
			setMessage("You were defeated!", restart);
			started = false;
			stopped = true;
		}
		
		private function restart()
		{
			trace("restart");
			whiteoutUI.fadeOut(doRestart);
		}
		
		private function doRestart()
		{
			shouldBeRestarted = true;
		}
		
		public override function tick(t:Number, dt:Number) {
			
			if(!stopped)
				snowOverlay.tick(dt);
			snowballUi.tick(t, dt);
			messageUI.tick(t, dt);
			whiteoutUI.tick(t, dt);
			
			var ai:AI;
			
			var i:int;
			var j:int;
						
			if (currentWave < waves.length)
			{
				if (started)
				{
					waves[currentWave].tick(dt);
					
					if (waves[currentWave].isFinished())
					{
						currentWave++;
						setMessage("Wave " + (currentWave + 1));
					}
				}
			}
			else
			{
				if (started)
				{
					victory();
				}
			}
			
			if (!stopped)
			{
				for (i = 0; i < entities.length; i++) {
					var entity:Entity = entities[i];
					entity.tick(t, dt);
				}
			}
			
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
					if (snowball.owner != ai && snowball.checkCollision(ai)) {
						ai.destroy();
						if(!snowball.isYellowSnow())
							snowball.destroy();
					}
				}
				
				if (snowball.owner != player && snowball.checkCollision(player))
				{
					if (player.takeDamage())
					{
						death();
					}
					
					snowball.destroy();
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
			
			flag.isBeingTaken = false;
			var playerPos:Point = player.getPosition();
			for (i = 0; i < ais.length; i++) {
				ai = ais[i];
				ai.target = playerPos;
				
				if (Point.distance(ai.getPosition(), flag.getPosition()) < 12)
				{
					flag.isBeingTaken = true;
				}
			}
			
			if (flag.isTaken() && !stopped)
			{
				defeat();
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
			
			if(shouldBeRestarted)
				realRestart();
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
		
		public function checkCollissionWithEntities(e:Entity):Boolean
		{
			for (var i = 0; i < entities.length; i++) {
				var ent = entities[i];
				if (e != ent && e.checkCollision(ent)) {
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
		
		public function getFogLayer():DisplayObjectContainer
		{
			return fogLayer;
		}
		
		public function getSnowballUi(): SnowballUI
		{
			return snowballUi;
		}
		
		public function getScoreUi():ScoreUI
		{
			return scoreUI;
		}
		
		public function setMessage(message:String, callback:Function = null)
		{
			messageUI.setMessage(message, 2, callback);
		}
	}
}