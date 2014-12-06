package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class SimpleAI extends AI {
		
		private var display:Image;
		
		public function SimpleAI(container:DisplayObjectContainer) {
			display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display.center();
			display.color = 0xFF0000;
			container.addChild(display);
			speed *= 0.7;
		}
		
		override public function tick(t:Number, dt:Number) {
			var s:Point;
			var d:Point;
			
			d.x = Math.random()-0.5;
			d.y = Math.random()-0.5;
			d.normalize(0.8);
			s += d;
			
			d = target-p;
			d.normalize(0.3);
			s += d;
			
			var threshold = 0.1;
			
			moveLeft = s.x < -threshold;
			moveRight = s.x > threshold;
			moveUp = s.y < -threshold;
			moveDown = s.y > threshold;
			
			super.tick(t, dt);
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}