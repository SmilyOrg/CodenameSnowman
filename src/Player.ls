package  {
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class Player extends Actor {
		
		private var display:Image;
		
		public function Player(container:DisplayObjectContainer) {
			display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display.center();
			container.addChild(display);
		}
		
		override public function tick(t:Number, dt:Number) {
			super.tick(t, dt);
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}