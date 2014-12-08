package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	public class ThinkyAI extends AI {
		
		private var STATE_WANDER = 10;
		private var STATE_AIMING = 11;
		
		private var basic:BasicActor;
		
		private var aimTimer = 0;
		private var aimTime = 0.2;
		private var difficulty:Number;
		
		public function ThinkyAI(container:DisplayObjectContainer, difficulty:Number = 1) {
			this.difficulty = difficulty;
			basic = new BasicActor(container, environment.getShadowLayer(), 0xFF0000);
			bounds = new Rectangle(-10, -16, 20, 32);
			basic.handleDirection(v);
		}
		
		private function changeDirection(directionality:Number = 0.25) {
			var deadzone = 20;
			moveLeft = Math.random() > (target.x > p.x+deadzone ? 0.5+directionality : target.x < p.x-deadzone ? 0.5-directionality : 1);
			moveRight = Math.random() > (target.x > p.x+deadzone ? 0.5-directionality : target.x < p.x-deadzone ? 0.5+directionality : 1);
			moveUp = Math.random() > (target.y > p.y+deadzone ? 0.5+directionality : target.y < p.y-deadzone ? 0.5-directionality : 1);
			moveDown = Math.random() > (target.y > p.y+deadzone ? 0.5-directionality : target.y < p.y-deadzone ? 0.5+directionality : 1);
		}
		
		private function getParam(min:Number, max:Number):Number {
			return min+(max-min)*(1-Math.exp(-difficulty));
		}
		
		override public function tick(t:Number, dt:Number) {
			if (state == STATE_DESTROYED) return;
			
			
			switch (state) {
				case STATE_IDLE:
					moveLeft = moveRight = moveUp = moveDown = false;
					if (Math.random() < getParam(0.01, 0.2)) {
						state = STATE_WANDER;
						changeDirection();
					} else if (Math.random() < getParam(0.005, 0.2)) {
						state = STATE_AIMING;
					}
					break;
				case STATE_AIMING:
					changeDirection(1);
					aimTimer += dt;
					if (aimTimer > aimTime*getParam(1, 0.5)) {
						aimTimer = 0;
						onSnowball(this, p, v, 0, 1);
						state = STATE_IDLE;
					}
					break;
				case STATE_WANDER:
					if (Math.random() < getParam(0.01, 0.03)) {
						state = STATE_IDLE;
					}
					
					if (Math.random() < getParam(0.05, 0.3)) {
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
			
			basic.tick(t, dt, this);
			super.tick(t, dt);
		}
		
		override public function get score():int {
			return baseScore * (difficulty+1);
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