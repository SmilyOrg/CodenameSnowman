package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class SimpleAI extends AI {
		
		private var display:AnimActor;
		
		public function SimpleAI(container:DisplayObjectContainer) {
			//display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display = new AnimActor("assets/eskimo-walk.png", 4);
			display.play();
			display.center();
			display.color = 0xFF0000;
			container.addChild(display);
			speed *= 0.7;
			bounds.x = -8;
			bounds.y = -8;
			bounds.width = 12;
			bounds.height = 12;
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
			
			super.tick(t, dt);
			display.advanceTime(dt);
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
		override public function destroy():Boolean {
			if (!super.destroy()) return false;
			display.removeFromParent(true);
			return true;
		}
		
	}
	
}