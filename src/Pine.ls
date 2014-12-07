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
	public class Pine extends Entity implements IHittable
	{
		private static var texture:Texture = null;
		private static var textureOverlay:Texture = null;
		
		private static var shadowTexture:Texture = null;
		private static var shadowTextureOverlay:Texture = null;
		
		private static const MAX_OVERLAY_TIME = 10;
		private var overlayTime:Number = 0;
		private var image:Image;
		private var overlay:Image;
		private var shadow:Image;
		
		public function Pine(container: DisplayObjectContainer):void
		{
			if (texture == null)
				texture = Texture.fromAsset("assets/Tree.png");
			if(shadowTexture == null)
				shadowTexture = Texture.fromAsset("assets/Tree-shadow.png");
			if(textureOverlay == null)
				textureOverlay = Texture.fromAsset("assets/Tree-snow-overlay.png");
			
			image = new Image(texture);
			container.addChild(image);
			
			overlay = new Image(textureOverlay);
			container.addChild(overlay);
			
			shadow = new Image(shadowTexture);
			environment.getShadowLayer().addChild(shadow);
			
			overlayTime = MAX_OVERLAY_TIME;
			
			v = new Point(0, 0);
			a = new Point(0, 0);
			p = new Point(100, 100);
			
			bounds = new Rectangle(-8, -40, 16, 30);
		}
		
		public override function tick(t:Number, dt:Number):void
		{			
			if (overlayTime > MAX_OVERLAY_TIME)
			{
				image.alpha = 1;
			}
			else
			{
				overlayTime += dt;
				overlay.alpha = overlayTime / MAX_OVERLAY_TIME;
			}
			
			image.x = p.x - 32;
			image.y = p.y - 56;
			
			overlay.x = image.x;
			overlay.y = image.y;
			
			shadow.x = image.x + 12;
			shadow.y = image.y;
		}
		
		/* INTERFACE IHittable */
		
		public function hit():void 
		{
			overlayTime = 0;
		}
		
	}
	
}