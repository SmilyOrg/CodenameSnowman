package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class ThinkyAI extends AI {
		
		private var STATE_WANDER = 10;
		
		private var display:AnimActor;
		private var direction:Point = new Point(1, 0);
		private var anims:Vector.<AnimActor>;
		private var animDirections:Vector.<int> = [0, 7, 6, 5, 4, 3, 2, 1];
		private var activeAnim:AnimActor;
		
		public function ThinkyAI(container:DisplayObjectContainer) {
			anims = new Vector.<AnimActor>();
			anims.push(new AnimActor("assets/eskimo-walk.png"));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 7));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 2));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 3));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 4));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 5));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 6));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 1));
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].play();
				anims[i].center();
				anims[i].color = 0xFF0000;
				container.addChild(anims[i]);
			}
			
			speed *= 0.7;
			bounds.x = -8;
			bounds.y = -8;
			bounds.width = 12;
			bounds.height = 12;
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
			
			if (moving0 && v.length > 70)
			{
				handleDirection();
				direction = v;
			}
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].advanceTime(dt * v.length * 0.02);
				if (!moving || anims[i].currentFrame == 3) {
					anims[i].currentFrame = 0;
				}
			}
			
			super.tick(t, dt);
		}
		
		private function handleDirection() {
			var angle = Math.round(((Math.atan2(direction.x, -direction.y)) % Math.TWOPI / Math.TWOPI) * 8);
			angle = angle == 8 ? 0 : angle;
			
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].visible = false;
			}
			anims[animDirections[angle]].visible = true;
		}
		
		override public function render(t:Number) {
			for (var i = 0; i < anims.length; i++) {
				anims[i].x = p.x;
				anims[i].y = p.y;
			}
			
			super.render(t);
		}
		
		override public function destroy():Boolean {
			if (!super.destroy()) return false;
			for (var i = 0; i < anims.length; i++) {
				anims[i].removeFromParent(true);
			}
			return true;
		}
		
	}
	
}