package  
{
	import loom2d.display.MovieClip;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Tadej
	 */
	public class AnimActor extends MovieClip
	{
		
		public function AnimActor(path:String, spriteCount:int = 1) 
		{
			var tex = Texture.fromAsset(path);
			var textures = new Vector.<Texture>();
			var spriteWidth = tex.width / spriteCount;
			for (var i = 0; i < spriteCount; i++) {
				textures.push(Texture.fromTexture(tex, new Rectangle(i * spriteWidth, 0, spriteWidth, tex.height)));
			}
			super(textures, 5);
			//loop = false;
			center();
		}
		
	}
	
}