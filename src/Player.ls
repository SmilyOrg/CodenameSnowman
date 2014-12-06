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
			display = new Image(Texture.fromAsset("assets/logo.png"));
			container.addChild(display);
		}
		
		override public function tick(t:Number, dt:Number) {
			var speed = 5000;
			if (moveLeft) a.x -= speed;
			if (moveRight) a.x += speed;
			if (moveUp) a.y -= speed;
			if (moveDown) a.y += speed;
			
			drag(dt, 0.2);
			super.tick(t, dt);
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}