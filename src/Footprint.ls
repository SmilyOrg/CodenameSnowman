package  
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Footprint extends Entity
	{
		private static var texture:Texture = null;
		private var image:Image = null;
		
		private var timeAlive:Number = 0;
		
		private static const MAX_TIME_ALIVE = 10;
		
		public function Footprint() 
		{
			v.x = 0;
			v.y = 0;
			a.x = 0;
			a.y = 0;
			
			if (texture == null)
			{
				texture = Texture.fromAsset("assets/footprint.png");
			}
			
			image = new Image(texture);
			
			environment.getGround().addChild(image);
			
			isCollidable = false;
		}
		
		override public function tick(t:Number, dt:Number)
		{
			image.x = p.x - 8;
			image.y = p.y - 8;
			
			timeAlive += dt;
			
			image.alpha = 1 - (timeAlive / MAX_TIME_ALIVE);
			
			if (timeAlive > MAX_TIME_ALIVE)
			{
				destroy();
			}
			
			super.tick(t, dt);
		}
		
		public override function destroy():Boolean
		{
			if (!super.destroy()) return false;
			image.removeFromParent();
			return true;
		}
		
	}
	
}