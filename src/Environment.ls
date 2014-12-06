package  {
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import loom2d.events.KeyboardEvent;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class Environment {
		
		/** Simulation delta time */
		private var dt = 1/60;
		
		/** Simulation time */
		private var t = 0;
		
		private var w:int;
		private var h:int;
		
		private var background:Image;
		
		private var display:Sprite = new Sprite();
		
		private var ais = new Vector.<AI>();
		private var player:Player;
		private var pine:Pine;
		
		public function Environment(stage:Stage, w:int, h:int) {
			this.w = w;
			this.h = h;
			
			background = new Image(Texture.fromAsset("assets/background.png"));
			
			display.addChild(background);
			
			for (var i:int = 0; i < 10; i++) {
				ais.push(new SimpleAI(display));
			}
			
			player = new Player(display);
			pine = new Pine();
			
			pine.x = 100;
			pine.y = 100;
			
			display.scale = 2;
			
			stage.addChild(display);
			
			
			stage.addChild(pine);
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
					pine.hit();
					break;
			}
		}
		
		public function tick() {
			player.tick(t, dt);
			
			pine.tick(dt);
			var playerPos:Point = player.getPosition();
			for (var i:int = 0; i < ais.length; i++) {
				var ai = ais[i];
				ai.target = playerPos;
				ai.tick(t, dt);
			}
			
			t += dt;
		}
		
		public function render() {
			player.render(t);
			for (var i:int = 0; i < ais.length; i++) {
				var ai = ais[i];
				ai.render(t);
			}
		}
		
	}
	
}