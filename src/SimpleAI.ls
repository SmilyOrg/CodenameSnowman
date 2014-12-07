package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	public class SimpleAI extends AI {
		
		private var basic:BasicActor;
		
		public function SimpleAI(container:DisplayObjectContainer) {
			basic = new BasicActor(container, environment.getShadowLayer(), 0xFF0000);
			
			speed *= 0.7;
			bounds = new  Rectangle(-10, -16, 20, 32);
			
			basic.handleDirection(v);
		}
		
		override public function tick(t:Number, dt:Number) {
			if (state == STATE_DESTROYED) return;
			
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
			
			basic.tick(t, dt, p, v);
			
			super.tick(t, dt);
		}
		
		override public function render(t:Number) {
			basic.render(p);
			super.render(t);
		}
		
		override public function destroy():Boolean {
			if (!super.destroy()) return false;
			basic.destroy();
			return true;
		}
		
	}
	
}