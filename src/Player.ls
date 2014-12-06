package  {
	import extensions.PDParticleSystem;
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.Loom2D;
	import loom2d.math.Color;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	import system.platform.Path;
	import system.xml.XMLDocument;
	
	public class Player extends Actor {
		
		private var display:AnimActor;
		private var pdps:PDParticleSystem;
		private var direction:Point = new Point(1, 0);
		
		public function Player(container:DisplayObjectContainer) {
			//display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display = new AnimActor("assets/eskimo-walk.png", 4);
			display.play();
			display.center();
			container.addChild(display);
			
			var path = "assets/particles/coldy-breath.pex";
			var config = new XMLDocument();
			config.loadFile(path);
			var basePath = Path.folderFromPath(path);
			var tex = Texture.fromAsset("assets/particles/coldy-breath.png");
			pdps = new PDParticleSystem(config, tex, basePath);
			container.addChild(pdps);
			
			pdps.emitterX = 60;
			pdps.emitterY = 60;
			//pdps.startColor = new Color(1,0,0,1);
			pdps.populate(1);
			Loom2D.juggler.add(pdps);
		}
		
		override public function tick(t:Number, dt:Number) {
			super.tick(t, dt);
			
			if (moving0 && v.length > 70)
			{
				direction = v;
			}
			display.advanceTime(dt * v.length * 0.02);
			if (!moving) {
				display.currentFrame = 0;
			}
			pdps.populate(1);
			pdps.emitterX = this.getPosition().x;
			pdps.emitterY = this.getPosition().y;
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			
			super.render(t);
		}
		
		public function getDirection():Point {
			
			return direction;
		}
		
		public function getPosition():Point {
			return p;
		}
	}
	
}