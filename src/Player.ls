package  {
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class Player extends Actor {
		
		private var display:AnimActor;
		
		public function Player(container:DisplayObjectContainer) {
			//display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display = new AnimActor("assets/eskimo-walk.png", 4);
			display.play();
			display.center();
			container.addChild(display);
		}
		
		override public function tick(t:Number, dt:Number) {
			super.tick(t, dt);
			display.advanceTime(dt * v.length * 0.02);
			if (!moving) {
				display.currentFrame = 0;
			}
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}