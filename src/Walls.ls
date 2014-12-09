package  
{
	import loom2d.display.Image;
	import loom2d.display.Sprite;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Walls extends Entity
	{
		private static var textureTop:Texture = null;
		private static var textureBottom:Texture = null;
		private static var textureBottomRight:Texture = null;
		private static var textureBottomLeft:Texture = null;
		private static var textureTopRight:Texture = null;
		private static var textureTopLeft:Texture = null;
		
		private var spriteTop:Sprite;
		private var spriteTopLeft:Sprite;
		private var spriteTopRight:Sprite;
		private var spriteBottom:Sprite;
		private var spriteBottomLeft:Sprite;
		private var spriteBottomRight:Sprite;
		
		private var imageTop:Image;
		private var imageTopLeft:Image;
		private var imageTopRight:Image;
		private var imageBottom:Image;
		private var imageBottomLeft:Image;
		private var imageBottomRight:Image;
		
		public function Walls() 
		{
			v.x = 0;
			v.y = 0;
			a.x = 0;
			a.y = 0;
			
			p.x = 320;
			p.y = 180;
			
			bounds = new Rectangle(p.x - 95, p.y - 53, 190, 106);
			
			if (textureTop == null)
			{
				textureTop = Texture.fromAsset("assets/wall-top.png");
			}
			
			if (textureBottom == null)
			{
				textureBottom = Texture.fromAsset("assets/wall-bottom.png");
			}
			
			if (textureTopLeft == null)
			{
				textureTopLeft = Texture.fromAsset("assets/wall-top-left.png");
			}
			
			if (textureTopRight == null)
			{
				textureTopRight = Texture.fromAsset("assets/wall-top-right.png");
			}
			
			if (textureBottomLeft == null)
			{
				textureBottomLeft = Texture.fromAsset("assets/wall-bottom-left.png");
			}
			
			if (textureBottomRight == null)
			{
				textureBottomRight = Texture.fromAsset("assets/wall-bottom-right.png");
			}
			
			spriteTop = new Sprite();
			spriteTopLeft = new Sprite();
			spriteTopRight = new Sprite();
			spriteBottom = new Sprite();
			spriteBottomLeft = new Sprite();
			spriteBottomRight = new Sprite();
			
			imageTop = new Image(textureTop);
			imageTopLeft = new Image(textureTopLeft);
			imageTopRight = new Image(textureTopRight);
			imageBottom = new Image(textureBottom);
			imageBottomLeft = new Image(textureBottomLeft);
			imageBottomRight = new Image(textureBottomRight);
			
			spriteTop.addChild(imageTop);
			environment.getDisplay().addChild(spriteTop);
			spriteTopLeft.addChild(imageTopLeft);
			environment.getDisplay().addChild(spriteTopLeft);
			spriteTopRight.addChild(imageTopRight);
			environment.getDisplay().addChild(spriteTopRight);
			spriteBottom.addChild(imageBottom);
			environment.getDisplay().addChild(spriteBottom);
			spriteBottomLeft.addChild(imageBottomLeft);
			environment.getDisplay().addChild(spriteBottomLeft);
			spriteBottomRight.addChild(imageBottomRight);
			environment.getDisplay().addChild(spriteBottomRight);
			
			spriteTop.x = 220;
			spriteTop.y = 129;
			imageTop.x = 0;
			imageTop.y = 0;
			
			addCollisionEntity(220, 129, 2, 6, 56, 1);
			addCollisionEntity(415, 129, -56, 6, 50, 1);
			
			spriteTopLeft.x = 220;
			spriteTopLeft.y = 142;
			imageTopLeft.x = 0;
			imageTopLeft.y = 0;
			
			addCollisionEntity(220, 129, 2, 6, 12, 20);
			
			spriteTopRight.x = 396;
			spriteTopRight.y = 142;
			imageTopRight.x = 0;
			imageTopRight.y = 0;
			
			addCollisionEntity(415, 129, -18, 6, 12, 20);
			
			spriteBottom.x = 220;
			spriteBottom.y = 223;
			imageBottom.x = 0;
			imageBottom.y = 0;
			
			addCollisionEntity(220, 224, 6, 6, 52, 1);
			addCollisionEntity(415, 224, -56, 6, 50, 1);
			
			spriteBottomLeft.x = 220;
			spriteBottomLeft.y = 190;
			imageBottomLeft.x = 0;
			imageBottomLeft.y = 0;
			
			addCollisionEntity(220, 190, 6, 12, 12, 20);
			
			spriteBottomRight.x = 387;
			spriteBottomRight.y = 190;
			imageBottomRight.x = 0;
			imageBottomRight.y = 0;
			
			addCollisionEntity(415, 224, -18, -22, 12, 16);
		}
		
		override public function tick(t:Number, dt:Number)
		{			
			super.tick(t, dt);
		}
		
		public override function destroy():Boolean
		{
			if (!super.destroy()) return false;
			imageTop.removeFromParent();
			imageTopRight.removeFromParent();
			imageTopLeft.removeFromParent();
			imageBottom.removeFromParent();
			imageBottomLeft.removeFromParent();
			imageBottomRight.removeFromParent();
			return true;
		}
	}
}