package  {
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	
	public class Player extends Entity {
		
		public var moveUp:Boolean = false;
		public var moveDown:Boolean = false;
		public var moveLeft:Boolean = false;
		public var moveRight:Boolean = false;
		
		private var display:Image;
		
		public function Player(container:DisplayObjectContainer) {
			display = new Image(Texture.fromAsset("assets/eskimo.png"));
			container.addChild(display);
		}
		
		override public function tick(t:Number, dt:Number) {
			var speed = 3000;
			if (moveLeft) a.x -= 1;
			if (moveRight) a.x += 1;
			if (moveUp) a.y -= 1;
			if (moveDown) a.y += 1;
			
			a.normalize(speed);
			
			drag(dt, 0.5);
			super.tick(t, dt);
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}