package  
{
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Snowball extends Entity
	{
		private var image:Image;
		
		public function Snowball(container:DisplayObjectContainer) 
		{
			image = new Image(Texture.fromAsset("assets/snowball.png"));
			
			container.addChild(image);
			
			v.x = 40;
			v.y = -40;
			p.x = 0;
			p.y = 195;
			
			bounds = new Rectangle( -4, -4, 8, 8);
		}
		
		override public function render(t:Number):void
		{			
			super.render(t);
		}
		
		override public function tick(t:Number, dt:Number):void 
		{
			image.x = p.x - bounds.left;
			image.y = p.y - bounds.top;
			
			super.tick(t, dt);
		}
		
		public function destroy()
		{
			image.removeFromParent(true);
		}
	}
}