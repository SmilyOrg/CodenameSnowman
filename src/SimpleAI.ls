package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	
	public class SimpleAI extends AI {
		
		private var display:Image;
		
		public function SimpleAI(container:DisplayObjectContainer) {
			display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display.center();
			display.color = 0xFF0000;
			container.addChild(display);
		}
		
		override public function tick(t:Number, dt:Number) {
			a.x = Math.random()-0.5;
			a.y = Math.random()-0.5;
			a.normalize(speed*0.2);
			super.tick(t, dt);
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}