package  {
	import extensions.PDParticleSystem;
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.Loom2D;
	import loom2d.math.Color;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class Player extends Actor {
		
		private var display:AnimActor;
		private var pdps:PDParticleSystem;
		
		public function Player(container:DisplayObjectContainer) {
			//display = new Image(Texture.fromAsset("assets/eskimo.png"));
			display = new AnimActor("assets/eskimo-walk.png", 4);
			display.play();
			display.center();
			container.addChild(display);
			
			pdps = PDParticleSystem.loadLiveSystem("assets/particles/explosion.pex");
			container.addChild(pdps);
			
			pdps.emitterX = 60;
			pdps.emitterY = 60;
			pdps.startColor = new Color(1,0,0,1);
			pdps.populate(10);
			Loom2D.juggler.add(pdps);
		}
		
		override public function tick(t:Number, dt:Number) {
			super.tick(t, dt);
			//pdps.advanceTime(dt);
			display.advanceTime(dt * v.length * 0.02);
			if (!moving) {
				display.currentFrame = 0;
			}
			pdps.populate(5);
			pdps.emitterX = this.getPosition().x;
			pdps.emitterY = this.getPosition().y;
		}
		
		override public function render(t:Number) {
			display.x = p.x;
			display.y = p.y;
			super.render(t);
		}
		
	}
	
}