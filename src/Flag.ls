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
	public class Flag extends Entity
	{
		private static var texture:Texture = null;
		private var sprite:Sprite = null;
		private var animActor:AnimActor = null;
		private var image:Image = null;
		public var isBeingTaken:Boolean = false;
		
		private var life = 8;
		
		public function Flag() 
		{
			v.x = 0;
			v.y = 0;
			a.x = 0;
			a.y = 0;
			
			p.x = 320;
			p.y = 180;
			
			bounds = new Rectangle(p.x - 2, p.y - 2, 4, 4);
			
			if (texture == null)
			{
				texture = Texture.fromAsset("assets/pole.png");
			}
			
			image = new Image(texture);
			
			image.x =  - 4;
			image.y =  - 126;
			
			sprite = new Sprite();
			sprite.addChild(image);
			sprite.x = p.x;
			sprite.y = p.y;
			
			animActor = new AnimActor(Texture.fromAsset("assets/flag.png"), 32, 32, 0);
			animActor.play();
			animActor.center();
			animActor.x = image.x + 18;
			animActor.y = image.y + 16;
			sprite.addChild(animActor);
			
			environment.getDisplay().addChild(sprite);
		}
		
		override public function tick(t:Number, dt:Number)
		{
			animActor.advanceTime(dt * 2);
			
			animActor.y = image.y + 16 + (80 - life * 10);
			
			if (isBeingTaken)
				life -= dt;
			
			super.tick(t, dt);
		}
		
		public override function destroy():Boolean
		{
			if (!super.destroy()) return false;
			sprite.removeFromParent(true);
			return true;
		}
		
		public function isTaken():Boolean
		{
			return life <= 0;
		}
	}
}