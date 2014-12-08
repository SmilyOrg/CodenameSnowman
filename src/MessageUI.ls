package  
{
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Point;
	import loom2d.ui.SimpleLabel;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class MessageUI extends Entity
	{		
		private var label:SimpleLabel;
		private var timeout:Number;
		private var callback:Function = null;
		
		public function MessageUI(container:DisplayObjectContainer) 
		{
			label = new SimpleLabel("assets/square-font-bordered-export.fnt");
			container.addChild(label);
			
			setMessage("", 0);
		}
		
		public function setMessage(message:String, t:Number, cb:Function = null) {
			label.text = message;
			
			label.x = 320 - label.width / 2;
			label.y = 15 + label.height;
			
			trace(timeout);
			timeout = t;
			
			label.visible = true;
			
			callback = cb;
		}
		
		public function tick(t:Number, dt:Number) {
			
			if (timeout > 0)
			{
				timeout -= dt;
			}
			
			if (timeout < 0)
			{
				label.visible = false;
				timeout = 0;
				if(callback)
					callback();
			}
		}
	}
	
}