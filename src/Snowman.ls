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
	 * @author Tadej
	 */
	public class Snowman extends Entity implements IHittable
	{
		private static var texture:Texture = null;
		
		private var image:Image;
		private var display:Sprite = new Sprite();
		
		public function Snowman(container:DisplayObjectContainer):void 
		{
			if (texture == null)
				texture = Texture.fromAsset("assets/snowman.png");
			
			state = STATE_IDLE;
			
			image = new Image(texture);
			display.addChild(image);
			
			image.y = -image.height +10;
			image.x = -image.width / 2;
			
			v = new Point(0, 0);
			a = new Point(0, 0);
			p = new Point(100, 100);
			
			container.addChild(display);
			
			bounds = new Rectangle(-8,image.y + 16,16,8);
		}
		
		override public function setPosition(x:Number, y:Number)
		{
			super.setPosition(x, y);
		}
		
		override public function tick(t:Number, dt:Number)
		{
			super.tick(t, dt);
			
			display.x = p.x;
			display.y = p.y;
		}
		
		
		/* INTERFACE IHittable */
		
		public function hit():void 
		{	
			/*var dropCount = Math.floor((overlayTime / MAX_OVERLAY_TIME) * 3);
			trace("drop count", dropCount);
			
			for (var i = 0; i < dropCount; i++)
			{
				trace(p.x + i % 2 * ( -1) * 8, p.y + 4);
				environment.addSnowball(p.x + (i % 2 * 2 - 1) * Math.floor((i+1) / 2) * 12, p.y + 8);
			}
			
			state = STATE_SHAKING;
			lastFrame = -1;
			pineAnim.currentFrame = 0;
			
			overlayTime = 0;*/
		}
	}
	
}