package  
{
	import loom2d.display.Image;
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
		private var snowballCount = 5;
		
		private var background:Image = null;
		private var snowballs:Vector.<Image> = new Vector.<Image>(5);
		
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
		
		public function pickUpSnowball():void
		{
			if (snowballCount < MAX_SNOWBALLS)
			{
				snowballCount++;
			}
		}
		
		override public function tick(t:Number, dt:Number)
		{
			super.tick(t, dt);
			
			for (var i = 0; i < MAX_SNOWBALLS; i++)
			{
				snowballs[i].visible = i < snowballCount;
			}
		}
		
		public function hasMax():Boolean
		{
			return snowballCount >= MAX_SNOWBALLS;
		}
	}
	
}