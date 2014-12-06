package  {
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class Player extends Actor {
		
		private var display:Image;
		private var direction:Point = new Point(1, 0);
		
		public function Player(container:DisplayObjectContainer) {
			display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display.center();
			container.addChild(display);
		}
		
		override public function tick(t:Number, dt:Number) {
			super.tick(t, dt);
			
			if (moving0 && v.length > 70)
			{
				direction = v;
			}
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			
			super.render(t);
		}
		
		public function getDirection():Point {
			
			return direction;
		}
		
		public function getPosition():Point {
			return p;
		}
	}
	
}