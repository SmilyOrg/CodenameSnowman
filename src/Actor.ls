package  {
	import loom.sound.Sound;
	import loom2d.math.Point;
	
	public class Actor extends Entity {
		
		public var moveUp:Boolean = false;
		public var moveDown:Boolean = false;
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		
		protected var speed = 3000;
		protected var moving = false;
		private var footstepTime = 0;
		private var footstepTreshold = 0.2;
		protected var moving0 = false;
		
		private var footstep:Sound;
		
		public function Actor() {
			footstep = Sound.load("assets/sound/snow_tread_1.ogg");
			footstep.setGain(0.1);
		}
		
		public function getPosition():Point {
			return p;
		}
		
		public function setPosition(x:Number, y:Number) {
			p.x = x;
			p.y = y;
		}
		
		override public function tick(t:Number, dt:Number) {
			if (moveLeft) a.x -= 1;
			if (moveRight) a.x += 1;
			if (moveUp) a.y -= 1;
			if (moveDown) a.y += 1;
			moving = v.length > 10;
			if (moving || moving0) {
				if (footstepTime > footstepTreshold || moving0 != moving) {
					footstep.setPitch(Math.random() * 0.5 + 0.7);
					footstep.play();
					if (moving0 != moving) {
						footstepTime = 0;
					} else {
						footstepTime -= footstepTreshold;
					}
				}
				
				footstepTime += dt;
			}
			moving0 = moving;
			
			a.normalize(speed);
			
			drag(dt, 0.5);
			
			super.tick(t, dt);
		}
		
	}
	
}