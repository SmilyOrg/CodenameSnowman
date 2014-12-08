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
		
		public function AnimActor(tex:Texture, spriteWidth:int = 32, spriteHeight:int = 32, spriteRow:int = 0) 
		{
			var textures = new Vector.<Texture>();
			var spriteCount = tex.width / spriteWidth;
			spriteRow = spriteRow < 0 ? 0 : spriteRow;
			spriteRow = spriteRow >= tex.height / spriteHeight ? tex.height / spriteHeight : spriteRow;
			for (var i = 0; i < spriteCount; i++) {
				textures.push(Texture.fromTexture(tex, new Rectangle(i * spriteWidth, spriteRow*spriteHeight, spriteWidth, spriteHeight)));
			}
			super(textures, 5);
			//loop = false;
			center();
		}
		
	}
	
}