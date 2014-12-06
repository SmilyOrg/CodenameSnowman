package  {
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.display.Stage;
	import loom2d.events.KeyboardEvent;
	import loom2d.textures.Texture;
	
	public class Environment {
		
		/** Simulation delta time */
		private var dt = 1/60;
		
		/** Simulation time */
		private var t = 0;
		
		private var background:Image;
		
		private var display:Sprite = new Sprite();
		
		private var player:Player;
		
		public function Environment(stage:Stage) {
			
			background = new Image(Texture.fromAsset("assets/background.png"));
			
			display.addChild(background);
			
			player = new Player(display);
			
			display.scale = 2;
			
			stage.addChild(display);
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
			}
		}
		
		public function tick() {
			player.tick(t, dt);
			t += dt;
		}
		
		public function render() {
			player.render(t);
		}
		
	}
	
}