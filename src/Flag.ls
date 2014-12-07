package  
{
	import loom2d.display.Image;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Flag extends Entity
	{
		private static var texture:Texture = null;
		private var image:Image = null;
		
		public function Flag() 
		{
			v.x = 0;
			v.y = 0;
			a.x = 0;
			a.y = 0;
			
			p.x = 320;
			p.y = 180;
			
			bounds = new Rectangle(p.x - 4, p.y - 4, 8, 8);
			
			if (texture == null)
			{
				texture = Texture.fromAsset("assets/flag.png");
			}
			
			image = new Image(texture);
			
			image.x = p.x - 4;
			image.y = p.y - 112;
			
			environment.getDisplay().addChild(image);
		}
		
		override public function tick(t:Number, dt:Number)
		{
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