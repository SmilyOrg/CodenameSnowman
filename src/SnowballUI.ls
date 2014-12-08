package  
{
	import loom2d.display.Image;
	import loom2d.display.Quad;
	import loom2d.display.Sprite;
	import loom2d.math.Rectangle;
	import loom2d.textures.Texture;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class SnowballUI extends Entity
	{
		private static var backgroundTexture:Texture = null;
		private static var snowballTexture:Texture = null;
		
		private static const MAX_SNOWBALLS = 5;
		private static const MAX_HEALTH = 5;
		private var snowballCount = 5;
		private var healthCount = 5;
		
		private var background:Image = null;
		private var snowballs:Vector.<Image> = new Vector.<Image>(5);
		private var healthRed:Sprite = null;
		private var healthBlue:Sprite = null;
		
		public function SnowballUI() 
		{
			if (backgroundTexture == null)
			{
				backgroundTexture = Texture.fromAsset("assets/snowball-bg.png");
			}
			
			if (snowballTexture == null)
			{
				snowballTexture = Texture.fromAsset("assets/snowball-item.png");
			}
			
			background = new Image(backgroundTexture);
			background.x = 478;
			background.y = 302;
			
			environment.getUi().addChild(background);
			
			for (var i = 0; i < MAX_SNOWBALLS; i++)
			{
				snowballs[i] = new Image(snowballTexture);
				snowballs[i].x = background.x + 10 + i * 26;
				snowballs[i].y = background.y + 10;
				
				environment.getUi().addChild(snowballs[i]);
			}
			
			healthBlue = new Sprite();
			healthRed = new Sprite();
			
			var blue = new Image(Texture.fromAsset("assets/health-blue.png"));
			var red = new Image(Texture.fromAsset("assets/health-red.png"));
			
			healthBlue.addChild(blue);
			healthRed.addChild(red);
			
			healthBlue.x = 478;
			healthBlue.y = 336;
			healthRed.x = 478;
			healthRed.y = 336;
			
			environment.getUi().addChild(healthBlue);
			environment.getUi().addChild(healthRed);
		}
		
		public function throwSnowball():Boolean
		{
			if (snowballCount > 0)
			{
				snowballCount--;
				return true;
			}
			
			return false;
		}
		
		public function setHealthValue(value:Number)
		{
			healthCount = value;
		}
		
		public function pickUpSnowball():Boolean
		{
			if (snowballCount < MAX_SNOWBALLS)
			{
				snowballCount++;
				return true;
			}
			
			return false;
		}
		
		override public function tick(t:Number, dt:Number)
		{
			super.tick(t, dt);
			
			for (var i = 0; i < MAX_SNOWBALLS; i++)
			{
				snowballs[i].visible = i < snowballCount;
			}
			
			healthRed.clipRect = new Rectangle(0, 0, (healthCount / MAX_HEALTH) * (146), healthRed.height);
			healthBlue.clipRect = new Rectangle((healthCount / MAX_HEALTH) * (146), 0, healthBlue.width, healthBlue.height);
		}
		
		public function hasMax():Boolean
		{
			return snowballCount >= MAX_SNOWBALLS;
		}
		
		public function numOfSnowballs():Number
		{
			return snowballCount;
		}
	}
	
}