package  {
	import loom.sound.Sound;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	public class Actor extends Entity {
		
		public var moveUp:Boolean = false;
		public var moveDown:Boolean = false;
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		
		protected var isMakingSnowball:Boolean = false;		
		protected var snowballProgress:Number = 0;
		private static const SNOWBALL_MAKING_TIME = 3;
		protected var speed = 3000;
		
		protected var progressBgTexture:Texture = null;
		protected var progressFgTexture:Texture = null;
		
		protected var progressBg:Image = null;
		protected var progressFg:Sprite = null;
		
		public function Actor() {
			if (progressBgTexture == null)
				progressBgTexture = Texture.fromAsset("assets/progress-bar-bg.png");
			
			if (progressFgTexture == null)
				progressFgTexture = Texture.fromAsset("assets/progress-bar-fg.png");
			
			progressBg = new Image(progressBgTexture);
			progressFg = new Sprite();
			progressFg.addChild(new Image(progressFgTexture));
			
			Entity.environment.getUi().addChild(progressBg);
			Entity.environment.getUi().addChild(progressFg);
		}
		
		override public function tick(t:Number, dt:Number) {
			
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
			return true;
		}
	}
	
}