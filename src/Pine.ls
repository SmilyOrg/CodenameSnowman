package  
{
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Pine extends Image implements IHittable
	{
		private static var _texture:Vector.<Texture> = new <Texture>(3);
		
		private var state:Number = 1;
		private var counter:Number = 0;
		
		public function Pine():void
		{
			if (_texture[0] == null)
			{
				_texture[0] = Texture.fromAsset("assets/Tree.png");
				_texture[1] = Texture.fromAsset("assets/Tree2.png");
				_texture[2] = Texture.fromAsset("assets/Tree3.png");
			}
			
			texture = _texture[1];
			scale = 2;
		}
		
		public function tick(dt:Number):void
		{			
			if (state < 2)
			{
				counter += dt;
				
				if (counter > 1)
				{
					state++;
					counter -= 1;
				}
			}
			
			texture = _texture[state];
		}
		
		/* INTERFACE IHittable */
		
		public function hit():void 
		{
			state = 0;
			counter = 0;
			texture = _texture[state];
		}
		
	}
	
}