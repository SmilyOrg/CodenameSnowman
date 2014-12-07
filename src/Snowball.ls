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
	public class Snowball extends Entity
	{
		public var owner:Actor;
		private var image:Image;
		private var shadowImage:Image;
		private static var texture:Texture;
		private static var shadowTexture:Texture;
		private var yellowSnow:Boolean = false;
		private static const MAX_TIME = 1.0;
		private static const MIN_TIME = 0.33;
		private var time:Number;
		private var initTime:Number;
		
		public function Snowball(container:DisplayObjectContainer, owner:Actor, origin:Point, direction:Point, charge:Number, maxCharge:Number) 
		{
			this.owner = owner;
			
			if (texture == null)
				texture = Texture.fromAsset("assets/snowball.png");
				
			if (shadowTexture == null)
				shadowTexture = Texture.fromAsset("assets/snowball-shadow.png");
			
			image = new Image(texture);
			shadowImage = new Image(shadowTexture);
			
			container.addChild(image);
			environment.getShadowLayer().addChild(shadowImage);
			
			direction.normalize();
			
			time = MIN_TIME + (charge / maxCharge) * (MAX_TIME - MIN_TIME);
			initTime = time;
			
			if (charge >= maxCharge)
			{
				image.color = 0xDFDF00;
				yellowSnow = true;
			}
			
			var speed = yellowSnow ? 360 : 240;
			
			v.x = direction.x * speed;
			v.y = direction.y * speed;
			p.x = origin.x;
			p.y = origin.y;
			
			bounds = new Rectangle( -4, -4, 8, 8);
		}
		
		override public function tick(t:Number, dt:Number):void
		{
			time -= dt;
			
			if (time <= 0 && !yellowSnow)
			{
				destroy();
				var hole = new SnowballHole();
				hole.setPosition(p.x, p.y);
				
				environment.addEntity(hole);
			}
			
			super.tick(t, dt);
		}
		
		override public function render(t:Number):void
		{
			
			var factor = time / initTime;
			
			if (yellowSnow)
				factor = 1;
			
			image.x = p.x + bounds.left;
			image.y = p.y + bounds.top + Math.floor(8 * (1-factor));
			
			shadowImage.x = image.x + Math.floor(6 * factor);
			shadowImage.y = image.y - Math.floor(8 * factor);
			
			super.render(t);
		}
		
		public function isYellowSnow():Boolean
		{
			return yellowSnow;
		}
		
		public function destroy():Boolean
		{
			if (!super.destroy()) return false;
			image.removeFromParent(true);
			shadowImage.removeFromParent(true);
			owner = null;
			return true;
		}
	}
}