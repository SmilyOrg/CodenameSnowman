package  
{
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	import loom2d.ui.SimpleLabel;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class WhiteoutUI extends Entity
	{		
		private var texture:Texture;
		private var timeout:Number;
		private var image:Image;
		private var direction:Number;
		private var callback:Function;
		
		public function WhiteoutUI(container:DisplayObjectContainer) 
		{
			texture = Texture.fromAsset("assets/snowflake.png");
			image = new Image(texture);
			image.x = 0;
			image.y = 0;
			image.scaleX = 640;
			image.scaleY = 360;
			container.addChild(image);
			
			timeout = -1;
		}
		
		public function fadeIn(cb:Function)
		{
			timeout = 2;
			image.visible = true;
			direction = 0;
			callback = cb;
		}
		
		public function fadeOut(cb:Function)
		{
			timeout = 2;
			image.visible = true;
			direction = 1;
			callback = cb;
		}
		
		public function tick(t:Number, dt:Number)
		{
			if (timeout > 0)
			{
				timeout -= dt;
			}
			
			image.alpha = direction > 0 ? (1 - (timeout / 2)) : (timeout / 2);
			
			if (timeout < 0)
			{
				image.visible = false;
				timeout = 0;
				
				if (callback != null)
					callback();
			}
		}
	}
	
}