package  {
	import loom.sound.Sound;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	public delegate SnowballThrow(owner:Actor, position:Point, velocity:Point, charge:Number, maxCharge:Number);
	
	public class Actor extends Entity {
		
		public var moveUp:Boolean = false;
		public var moveDown:Boolean = false;
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		
		public var onSnowball:SnowballThrow;
		
		protected var isMakingSnowball:Boolean = false;		
		protected var snowballProgress:Number = 0;
		private static const SNOWBALL_MAKING_TIME = 3;
		protected var speed = 3000;
		protected var moving = false;
		private var footstepTime = 0;
		private var footstepTreshold = 0.2;
		protected var moving0 = false;
		
		protected var progressBgTexture:Texture = null;
		protected var progressFgTexture:Texture = null;
		
		protected var progressBg:Image = null;
		protected var progressFg:Sprite = null;
		
		private var footstep:Sound;
		
		public function Actor() {
			footstep = Sound.load("assets/sound/snow_tread_1.ogg");
			footstep.setGain(0.1);
			
			if (progressBgTexture == null)
				progressBgTexture = Texture.fromAsset("assets/progress-bar-bg.png");
			
			if (progressFgTexture == null)
				progressFgTexture = Texture.fromAsset("assets/progress-bar-fg.png");
			
			progressBg = new Image(progressBgTexture);
			progressFg = new Sprite();
			progressFg.addChild(new Image(progressFgTexture));
			
			Entity.environment.getUi().addChild(progressBg);
			Entity.environment.getUi().addChild(progressFg);
			
			hasFreeWill = true;
		}
		
		/*private function onFootstep()
		{
			footstep.setPitch(Math.random() * 0.5 + 0.7);
			footstep.play();
			
			var footprint = new Footprint();
			footprint.setPosition(p.x, p.y + 8);
			Entity.environment.addEntity(footprint);
		}*/
		
		override public function tick(t:Number, dt:Number) {
			
			if (!isMakingSnowball)
			{
				if (moveLeft) a.x -= 1;
				if (moveRight) a.x += 1;
				if (moveUp) a.y -= 1;
				if (moveDown) a.y += 1;
				moving = v.length > 10;
				if (moving || moving0) {
					if (footstepTime > footstepTreshold || moving0 != moving) {
						//onFootstep();
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
			}
			else
			{
				snowballProgress += dt;
				
				if (snowballProgress >= SNOWBALL_MAKING_TIME)
				{
					trace("finished making snowball");
					environment.getSnowballUi().pickUpSnowball();
					endMakingSnowball();
				}
			}
			
			drag(dt, 0.5);
			
			progressBg.x = p.x - 16;
			progressBg.y = p.y - 24;
			progressFg.x = progressBg.x + 2;
			progressFg.y = progressBg.y + 1;
			
			progressFg.clipRect = new Rectangle(0, 0, (snowballProgress / SNOWBALL_MAKING_TIME) * progressFgTexture.width, progressFgTexture.height);
			
			
			progressBg.visible = isMakingSnowball;
			progressFg.visible = isMakingSnowball;
			
			super.tick(t, dt);
		}
		
		public function startMakingSnowball():void {
			trace("start making snowball");
			if (!environment.getSnowballUi().hasMax())
			{
				isMakingSnowball = true;
				snowballProgress = 0;
			}
		}
		
		public function endMakingSnowball():void {
			trace("end making snowball");
			isMakingSnowball = false;
			snowballProgress = 0;
		}
		
		override public function destroy():Boolean 
		{
			if (!super.destroy()) return false;
			progressBg.removeFromParent();
			progressFg.removeFromParent();
			onSnowball = null;
			return true;
		}
	}
	
}