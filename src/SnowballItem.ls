package  
{
	import loom.sound.Sound;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class SnowballItem extends Entity
	{
		private static var texture:Texture = null;
		private var image:Image = null;
		private var isFresh = true;
		private var fades:Boolean;
		private var fadeTimer = 0;
		private static const FADE_DURATION = 20;
		
		private static var pickupSound:Sound = null;
		
		public function SnowballItem(doesFade:Boolean) 
		{
			v.x = 0;
			v.y = 0;
			a.x = 0;
			a.y = 0;
			
			fades = doesFade;
			
			if (texture == null)
			{
				texture = Texture.fromAsset("assets/snowball.png");
			}
			
			if (pickupSound == null)
			{
				pickupSound = Sound.load("assets/sound/pickup.ogg");
				pickupSound.setGain(0.1);
			}
			
			image = new Image(texture);
			
			environment.getDisplay().addChild(image);
			
			isCollidable = false;
		}
		
		public function enablePickUp()
		{
			isFresh = false;
		}
		
		public function canPickUp():Boolean
		{
			return !isFresh;
		}
		
		override public function tick(t:Number, dt:Number)
		{
			image.x = p.x - 4;
			image.y = p.y - 4;
			
			if (fades)
			{
				fadeTimer += dt;
				image.alpha = 1 - fadeTimer / FADE_DURATION;
				
				if (fadeTimer > FADE_DURATION)
				{
					destroy();
				}
			}
			
			super.tick(t, dt);
		}
		
		public override function destroy():Boolean
		{
			pickupSound.play();
			
			if (!super.destroy()) return false;
			image.removeFromParent();
			return true;
		}
		
	}
	
}