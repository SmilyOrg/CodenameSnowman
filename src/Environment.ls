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
		
		private var ais = new Vector.<AI>();
		private var player:Player;
		private var pine:Pine;
		private var snowball:Snowball;
		private var arena:Entity;
		private var snowOverlay:SnowOverlay;
		
		public function Environment(stage:Stage, w:int, h:int) {
			this.w = w;
			this.h = h;
			
			background = new Image(Texture.fromAsset("assets/background.png"));
			display.addChild(background);
			
			for (var i:int = 0; i < 10; i++) {
				ais.push(new SimpleAI(display));
			}
			
			player = new Player(display);
			pine = new Pine(display);
			snowball = null;
			
			arena = new Entity();
			arena.bounds = new Rectangle(0, 0, background.width, background.height);
			
			snowOverlay = new SnowOverlay();
			display.addChild(snowOverlay);
			snowOverlay.initialize(w, h);
			
			display.scale = 2;
			reset();
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
					if(snowball == null)
						snowball = new Snowball(display, player.getPosition(), player.getDirection());
					break;
			}
		}
		
		public override function tick(t:Number, dt:Number) {
			player.tick(t, dt);
			pine.tick(t, dt);
			snowOverlay.tick(dt);
			
			while (snowball != null)
			{
				snowball.tick(t, dt);
				if (snowball.checkCollision(pine))
				{
					pine.hit();
					snowball.destroy();
					snowball = null;
					break;
				}
				
				if (!snowball.checkCollision(arena))
				{
					snowball.destroy();
					snowball = null;
					break;
				}
				
				break;
			}
			
			var ai:AI;
			var i:int;
			
			if (snowball != null)
			{
				for (i = 0; i < ais.length; i++) {
					ai = ais[i];
					if (ai != null && snowball.checkCollision(ai))
					{
						ai.destroy();
						ais[i] = null;
						
						snowball.destroy();
						snowball = null;
						
						break;
					}
				}
			}
			
			var playerPos:Point = player.getPosition();
			for (i = 0; i < ais.length; i++) {
				ai = ais[i];
				if (ai != null)
				{
					ai.target = playerPos;
					ai.tick(t, dt);
				}
			}
			
			t += dt;
		}
		
		public override function render(t:Number) {
			player.render(t);
			for (var i:int = 0; i < ais.length; i++) {
				var ai = ais[i];
				if (ai != null)
				{
					ai.render(t);
				}
			}
		}
		
	}
	
}