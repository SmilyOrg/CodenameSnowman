package  
{
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Snowball extends Entity
	{
		private var image:Image;
		
		public function Snowball(container:DisplayObjectContainer, origin:Point, direction:Point) 
		{
			image = new Image(Texture.fromAsset("assets/snowball.png"));
			
			container.addChild(image);
			
			direction.normalize();
			
			v.x = direction.x * 240;
			v.y = direction.y * 240;
			p.x = origin.x;
			p.y = origin.y;
			
			bounds = new Rectangle( -4, -4, 8, 8);
		}
		
		override public function render(t:Number):void
		{
			image.x = p.x + bounds.left;
			image.y = p.y + bounds.top;
			
			super.render(t);
		}
		
		public override function destroy():Boolean
		{
			if (!super.destroy()) return false;
			image.removeFromParent();
			return true;
		}
	}
}