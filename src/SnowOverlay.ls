package  
{
	import loom.admob.InterstitialAd;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.display.Quad;
	import loom2d.display.Sprite;
	import loom2d.display.DisplayObject;
	import loom2d.textures.Texture;
	import util.SimplexNoise;
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class SnowOverlay extends Sprite
	{		
		private var MAX_SNOWFLAKES = 1000;
		private var snowflakeTexture = Texture.fromAsset("assets/snowflake.png");
		private var time = 0;
		
		private var noise:SimplexNoise;
		
		private var _w:int;
		private var _h:int;
	
		
		public function SnowOverlay() 
		{
			noise = new SimplexNoise();
		}
		
		public function initialize(w:int, h:int):void
		{
			_w = w;
			_h = h;
			
			// Randomly generate initial state
			for (var i = 0; i < MAX_SNOWFLAKES; i++)
			{
				 generateSnowflake(true);
			}
		}
		
		public function generateSnowflake(isYRandom:Boolean, child:DisplayObject = null):void
		{
			if (child == null)
			{
				child = new Image(snowflakeTexture);
				addChild(child);
			}
			
			child.x = Math.randomRange(0, _w);
			child.y = isYRandom ? Math.randomRange(0, _h) : 0;
			
			child.width = 1;
			child.height = 1;
		}
		
		public function tick(dt:Number):void
		{
			time += dt;
			
			// foreach - move down, delete if too low, then generate next one
			for (var i = 0;  i < this.numChildren; i++)
			{
				var child = this.getChildAt(i);
				
				child.y += 60 * dt;
				var wind = noise.harmonicNoise2D(time, child.y + time, 3, 0.1, 0.0005, 3);
				child.x += wind * dt * 120;
				
				if (child.y > _h)
				{
					generateSnowflake(false, child);
				}
				
				if (child.x < 0)
					child.x += _w;
					
				if (child.x > _w)
					child.x -= _w;
			}
		}
	}
}