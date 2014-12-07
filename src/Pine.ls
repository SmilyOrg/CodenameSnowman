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
		
		private static var shadowTexture:Texture = null;
		private static var shadowTextureOverlay:Texture = null;
		
		private static const MAX_OVERLAY_TIME = 30;
		private var overlayTime:Number = 0;
		private var display:Sprite = new Sprite();
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
			display.addChild(image);
			
			overlay = new Image(textureOverlay);
			display.addChild(overlay);
			
			overlay.y = image.y = -image.height + 4;
			overlay.x = image.x = -image.width / 2;
			
			container.addChild(display);
			
			shadow = new Image(shadowTexture);
			environment.getShadowLayer().addChild(shadow);
			
			overlayTime = MAX_OVERLAY_TIME;
			
			v = new Point(0, 0);
			a = new Point(0, 0);
			p = new Point(100, 100);
			
			bounds = new Rectangle( -16, -60, 32, 60);
		}
		
		override public function setPosition(x:Number, y:Number)
		{
			super.setPosition(x, y);
			
			if (children != null)
				children.clear();
				
			addCollisionEntity(p.x, p.y, -2, -40, 4, 25);
			addCollisionEntity(p.x, p.y, -10, -25, 20, 10);
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
				overlay.alpha = Math.max(0.2, overlayTime / MAX_OVERLAY_TIME);
			}
			
			display.x = p.x;
			display.y = p.y;
			
			shadow.x = display.x + 12 + image.x;
			shadow.y = display.y + image.y;
		}
		
		/* INTERFACE IHittable */
		
		public function hit():void 
		{	
			var dropCount = Math.floor((overlayTime / MAX_OVERLAY_TIME) * 3);
			trace("drop count", dropCount);
			
			for (var i = 0; i < dropCount; i++)
			{
				trace(p.x + i % 2 * ( -1) * 8, p.y + 4);
				environment.addSnowball(p.x + (i % 2 * 2 - 1) * Math.floor((i+1) / 2) * 12, p.y + 8);
			}
			
			overlayTime = 0;
		}
		
	}
	
}