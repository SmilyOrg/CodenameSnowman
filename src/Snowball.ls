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
		private var shadowImage:Image;
		private static var texture:Texture;
		private static var shadowTexture:Texture;
		
		public function Snowball(container:DisplayObjectContainer, origin:Point, direction:Point, charge:Number, maxCharge:Number) 
		{
			if (texture == null)
				texture = Texture.fromAsset("assets/snowball.png");
				
			if (shadowTexture == null)
				shadowTexture = Texture.fromAsset("assets/snowball-shadow.png");
			
			image = new Image(texture);
			shadowImage = new Image(shadowTexture);
			
			container.addChild(image);
			environment.getShadowLayer().addChild(shadowImage);
			
			direction.normalize();
			
			var speed = 240;
			
			trace(charge, maxCharge);
			
			if (charge == maxCharge) image.color = 0xDFDF00;
			
			v.x = direction.x * speed;
			v.y = direction.y * speed;
			p.x = origin.x;
			p.y = origin.y;
			
			bounds = new Rectangle( -4, -4, 8, 8);
		}
		
		override public function render(t:Number):void
		{
			image.x = p.x + bounds.left;
			image.y = p.y + bounds.top;
			
			shadowImage.x = image.x + 4;
			shadowImage.y = image.y - 6;
			
			super.render(t);
		}
		
		public function destroy():Boolean
		{
			if (!super.destroy()) return false;
			image.removeFromParent(true);
			shadowImage.removeFromParent(true);
			return true;
		}
	}
}