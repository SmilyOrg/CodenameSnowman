package  {
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class Player extends Entity {
		
		public var moveUp:Boolean = false;
		public var moveDown:Boolean = false;
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		
		private var display:Image;
		private var lastPos:Point;
		private var footstep:Sound;
		private var speed = 5;
		private var footstepTime = 0;
		private var footstepTreshold = 0.3;
		private var moving0 = false;
		
		public function Player(container:DisplayObjectContainer) {
			display = new Image(Texture.fromAsset("assets/eskimo.png"));
			container.addChild(display);
			
			lastPos = this.p;
			
			footstep = Sound.load("assets/sound/snow_tread_1.ogg");
		}
		
		override public function tick(t:Number, dt:Number) {
			var speed = 3000;
			if (moveLeft) a.x -= 1;
			if (moveRight) a.x += 1;
			if (moveUp) a.y -= 1;
			if (moveDown) a.y += 1;
			var moving = v.length > 10;
			//trace(moving);
			if (moving || moving0) {
				if (footstepTime > footstepTreshold || moving0 != moving) {
					footstep.setPitch(Math.random() * 0.5 + 0.7);
					footstep.play();
					if (moving0 != moving) {
						footstepTime = 0;
					} else {
						footstepTime -= footstepTreshold;
					}
					trace("step");
					trace(footstepTime);
				}
				
				footstepTime += dt;
			}
			moving0 = moving;
			
			
			a.normalize(speed);
			
			drag(dt, 0.5);
			super.tick(t, dt);
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}