package  
{
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
		
		public function SnowballItem() 
		{
			v.x = 0;
			v.y = 0;
			a.x = 0;
			a.y = 0;
			
			if (texture == null)
			{
				texture = Texture.fromAsset("assets/snowball.png");
			}
			
			image = new Image(texture);
			
			environment.getGround().addChild(image);
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