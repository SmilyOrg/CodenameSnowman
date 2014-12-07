package  
{
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.display.Sprite;
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
		
		private static const MAX_OVERLAY_TIME = 10;
		private var overlayTime:Number = 0;
		private var display:Sprite = new Sprite();
		private var image:Image;
		private var overlay:Image;
		
		public function Pine(container: DisplayObjectContainer):void
		{
			texture = Texture.fromAsset("assets/Tree.png");
			textureOverlay = Texture.fromAsset("assets/Tree-snow-overlay.png");
			
			image = new Image(texture);
			display.addChild(image);
			
			overlay = new Image(textureOverlay);
			display.addChild(overlay);
			
			overlay.y = image.y = -image.height+4;
			
			container.addChild(display);
			
			overlayTime = MAX_OVERLAY_TIME;
			
			v = new Point(0, 0);
			a = new Point(0, 0);
			p = new Point(50, 100);
			
			bounds = new Rectangle(20, image.y, 8, 48);
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
			
			display.x = p.x;
			display.y = p.y;
		}
		
		/* INTERFACE IHittable */
		
		public function hit():void 
		{
			overlayTime = 0;
		}
		
	}
	
}