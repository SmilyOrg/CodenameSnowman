package  {
	import extensions.PDParticleSystem;
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.math.Color;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	import system.platform.Path;
	import system.xml.XMLDocument;
	
	public class Player extends Actor {
		
		private var basic:BasicActor;
		
		private var pdps:PDParticleSystem;
		private var breathTime:Number = 0;
		private var emmiterLocations:Vector.<Point> = [
														new Point(16, 3), //up
														new Point(22, 7), //up-right
														new Point(16, 18), //right
														new Point(20, 18), //down-right
														new Point(8, 18), //down
														new Point(12, 18), //down-left
														new Point(24, 18), //left
														new Point(10, 8) //up-left
													];
		private var currDir:int = 2;
		
		private var chargeSound:Sound;
		private var chargeTimer = -1;
		private var chargeTime = 0.3;
		
		public function Player(container:DisplayObjectContainer) {
			//display = new Image(Texture.fromAsset("assets/eskimo.png"));
			basic = new BasicActor(container, environment.getShadowLayer());
			
			basic.handleDirection(v);
			
			chargeSound = Sound.load("assets/sound/zzzip.ogg");
			
			var path = "assets/particles/coldy-breath.pex";
			var tex = Texture.fromAsset("assets/particles/coldy-breath.png");
			pdps = PDParticleSystem.loadLiveSystem(path, tex);
			container.addChild(pdps);
		}
		
		override public function tick(t:Number, dt:Number) {
			pdps.advanceTime(dt);
			//Player breath
			var breathDelay = 2;
			if (breathTime > breathDelay) {
				pdps.emitterX = p.x + (emmiterLocations[currDir].x - 16);
				pdps.emitterY = p.y + (emmiterLocations[currDir].y - 16);
				trace(currDir + " | " + (emmiterLocations[currDir].x - 16) + " : " + (emmiterLocations[currDir].y - 16));
				pdps.populate(5, 0);
				breathTime -= breathDelay;
				trace("PUFF PUFF PASS!");
			}
			breathTime += dt;
			
			if (chargeTimer != -1) {
				chargeTimer = Math.min(chargeTime, chargeTimer+dt);
				if (chargeTimer > 0.2) {
					if (!chargeSound.isPlaying() && chargeTimer < chargeTime) chargeSound.play();
				}
			}
			
			basic.tick(t, dt, p, v);
			super.tick(t, dt);
		}
		
		public function charge() {
			chargeTimer = 0;
			chargeSound.play();
		}
		
		public function resetCharge() {
			chargeTimer = -1;
			chargeSound.stop();
		}
		
		public function get currentCharge():Number {
			return chargeTimer;
		}
		
		public function get maxCharge():Number {
			return chargeTime;
		}
		
		override public function render(t:Number) {
			basic.render(p);
			
			super.render(t);
		}
		
		public function getDirection():Point {
			
			return basic.getDirection();
		}
		
		public function getPosition():Point {
			return p;
		}
		
		override public function destroy():Boolean {
			if (!super.destroy()) return false;
			basic.destroy();
			return true;
		}
		
	}
	
}