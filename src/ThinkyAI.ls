package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	public class ThinkyAI extends AI {
		
		private var STATE_WANDER = 10;
		
		private var basic:BasicActor;
		
		public function ThinkyAI(container:DisplayObjectContainer) {
			basic = new BasicActor(container, environment.getShadowLayer(), 0xFF0000);
			bounds = new Rectangle(-10, -16, 20, 32);
			basic.handleDirection(v);
		}
		
		
		
		private function changeDirection() {
			var directionality = 0.25;
			moveLeft = Math.random() > (target.x > p.x ? 0.5+directionality : 0.5-directionality);
			moveRight = Math.random() > (target.x < p.x ? 0.5+directionality : 0.5-directionality);
			moveUp = Math.random() > (target.y > p.y ? 0.5+directionality : 0.5-directionality);
			moveDown = Math.random() > (target.y < p.y ? 0.5+directionality : 0.5-directionality);
		}
		
		override public function tick(t:Number, dt:Number) {
			if (state == STATE_DESTROYED) return;
			
			
			switch (state) {
				case STATE_IDLE:
					moveLeft = moveRight = moveUp = moveDown = false;
					if (Math.random() < 0.01) {
						state = STATE_WANDER;
						changeDirection();
					}
					break;
				case STATE_WANDER:
					if (Math.random() < 0.02) {
						state = STATE_IDLE;
					}
					
					if (Math.random() < 0.1) {
						changeDirection();
					}
					
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
					
					//moveLeft = moveLeft && s.x > -threshold ? s.x < -threshold : s.x < -threshold*2;
					//moveRight = s.x > threshold;
					//moveUp = s.y < -threshold;
					//moveDown = s.y > threshold;
					break;
			}
			
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