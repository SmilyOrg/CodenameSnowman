package  
{
	import loom2d.display.Image;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Walls extends Entity
	{
		private static var texture:Texture = null;
		private var image:Image = null;
		
		public function Walls() 
		{
			v.x = 0;
			v.y = 0;
			a.x = 0;
			a.y = 0;
			
			p.x = 320;
			p.y = 180;
			
			bounds = new Rectangle(p.x - 95, p.y - 53, 190, 106);
			
			if (texture == null)
			{
				texture = Texture.fromAsset("assets/walls.png");
			}
			
			image = new Image(texture);
			image.x = bounds.left;
			image.y = bounds.top;
			
			environment.getDisplay().addChild(image);
			
			addCollisionEntity(p.x, p.y, -95, - 35, 64, 5);
			addCollisionEntity(p.x, p.y, -95, - 35, 5, 70);
			addCollisionEntity(p.x, p.y, -95, 30, 64, 5);
			
			addCollisionEntity(p.x, p.y, 31, - 35, 64, 5);
			addCollisionEntity(p.x, p.y, 90, - 35, 5, 70);
			addCollisionEntity(p.x, p.y, 31, 30, 64, 5);
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