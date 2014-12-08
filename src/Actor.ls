package  {
	import loom.sound.Sound;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	public delegate SnowballThrow(owner:Actor, position:Point, velocity:Point, charge:Number, maxCharge:Number);
	
	public class Actor extends Entity {
		
		public static const STATE_THROWING = 3;
		public static const STATE_THROWN   = 4;
		public static const STATE_DYING	   = 5;
		public static const STATE_DEAD	   = 6;
		
		public var moveUp:Boolean = false;
		public var moveDown:Boolean = false;
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		
		public var onSnowball:SnowballThrow;
		
		protected var isMakingSnowball:Boolean = false;
		protected var snowballProgress:Number = 0;
		private static const SNOWBALL_MAKING_TIME = 3;
		protected var speed = 3000;
		protected var cd = -1;
		protected var cdTreshold = .10;
		
		protected var progressBgTexture:Texture = null;
		protected var progressFgTexture:Texture = null;
		
		protected var progressBg:Image = null;
		protected var progressFg:Sprite = null;
		
		//private var footstep:Sound;
		private static var makingSound:Sound = null;
		
		//DYING ANIMATONS
		private var deathTime:Number = 0.25;
		public var decays:Boolean = true;
		private var decayTime:Number = 1;
		private var deathTimer:Number = 0;
		
		public function Actor() {
			//footstep = Sound.load("assets/sound/snow_tread_1.ogg");
			//footstep.setGain(0.1);
			
			if (makingSound == null)
			{
				makingSound = Sound.load("assets/sound/make-snowball.ogg");
				makingSound.setLooping(true);
				makingSound.setGain(0.05);
			}
			
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
		
		override public function tick(t:Number, dt:Number) {
			if (!(state == STATE_DEAD || state == STATE_DYING)) {
				if (!isMakingSnowball)
				{
					if (moveLeft) a.x -= 1;
					if (moveRight) a.x += 1;
					if (moveUp) a.y -= 1;
					if (moveDown) a.y += 1;
					
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
			}
			
			drag(dt, 0.5);
			
			progressBg.x = p.x - 16;
			progressBg.y = p.y - 24;
			progressFg.x = progressBg.x + 2;
			progressFg.y = progressBg.y + 1;
			
			progressFg.clipRect = new Rectangle(0, 0, (snowballProgress / SNOWBALL_MAKING_TIME) * progressFgTexture.width, progressFgTexture.height);
			
			
			progressBg.visible = isMakingSnowball;
			progressFg.visible = isMakingSnowball;
			
			if (state == STATE_DYING) {
				deathTimer += dt;
				
				if (deathTimer > deathTime) {
					state = STATE_DEAD;
					deathTimer -= deathTime;
				}
			} else if (state == STATE_DEAD && decays) {
				deathTimer += dt;
				if (deathTimer > decayTime) {
					destroy();
				}
			}
			
			super.tick(t, dt);
		}
		
		public function startMakingSnowball():void {
			
			if (!environment.getSnowballUi().hasMax())
			{
				makingSound.play();
				isMakingSnowball = true;
				snowballProgress = 0;
			}
		}
		
		public function endMakingSnowball():void {
			
			makingSound.stop();
			isMakingSnowball = false;
			snowballProgress = 0;
		}
		
		public function die():void {
			state = STATE_DYING;
			isCollidable = false;
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