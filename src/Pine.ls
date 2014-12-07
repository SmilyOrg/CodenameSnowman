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
		private static var _texture:Vector.<Texture> = new <Texture>(3);
		
		private var frame:Number = 1;
		private var counter:Number = 0;
		private var image:Image;
		
		public function Pine(container: DisplayObjectContainer):void
		{
			if (_texture[0] == null)
			{
				_texture[0] = Texture.fromAsset("assets/Tree.png");
				_texture[1] = Texture.fromAsset("assets/Tree2.png");
				_texture[2] = Texture.fromAsset("assets/Tree3.png");
			}
			
			image = new Image(_texture[frame]);
			container.addChild(image);
			
			v = new Point(0, 0);
			a = new Point(0, 0);
			p = new Point(50, 100);
			
			bounds = new Rectangle(20, 0, 8, 48);
		}
		
		public override function tick(t:Number, dt:Number):void
		{			
			if (frame < 2)
			{
				counter += dt;
				
				if (counter > 1)
				{
					frame++;
					counter -= 1;
				}
			}
			
			image.texture = _texture[frame];
			image.x = p.x;
			image.y = p.y;
		}
		
		/* INTERFACE IHittable */
		
		public function hit():void 
		{
			frame = 0;
			counter = 0;
			image.texture = _texture[frame];
		}
		
	}
	
}