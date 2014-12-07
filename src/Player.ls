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
		
		private var display:AnimActor;
		private var pdps:PDParticleSystem;
		private var direction:Point = new Point(1, 0);
		private var breathTime:Number = 0;
		private var anims:Vector.<AnimActor>;
		private var animDirections:Vector.<int> = [0, 7, 6, 5, 4, 3, 2, 1];
		private var emmiterLocations:Vector.<Point> = [
														new Point(16, 3), //up
														new Point(16, 3), //up-right
														new Point(16, 18), //right
														new Point(16, 18), //down-right
														new Point(8, 18), //down
														new Point(8, 18), //down-left
														new Point(24, 18), //left
														new Point(24, 18) //up-left
													];
		private var activeAnim:AnimActor;
		//private var direction:int = 2;
		
		private var chargeSound:Sound;
		private var chargeTimer = -1;
		private var chargeTime = 0.3;
		
		public function Player(container:DisplayObjectContainer) {
			//display = new Image(Texture.fromAsset("assets/eskimo.png"));
			
			anims = new Vector.<AnimActor>();
			anims.push(new AnimActor("assets/eskimo-walk.png"));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 7));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 2));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 3));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 4));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 5));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 6));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 1));
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].play();
				anims[i].center();
				container.addChild(anims[i]);
			}
			
			/*display = new AnimActor("assets/eskimo-walk.png");
			display.play();
			display.center();
			container.addChild(display);*/
			
			
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
				pdps.emitterX = this.getPosition().x;
				pdps.emitterY = this.getPosition().y;
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
			
			if (moving0 && v.length > 70)
			{
				handleDirection();
				direction = v;
			}
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].advanceTime(dt * v.length * 0.02);
				if (!moving || anims[i].currentFrame == 3) {
					anims[i].currentFrame = 0;
				}
			}
			
			super.tick(t, dt);
			
			/*display.advanceTime(dt * v.length * 0.02);
			if (!moving) {
				display.currentFrame = 0;
			}*/
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
		
		private function setActiveAnim(anim:AnimActor = null) {
			if (anim == null) return;
			
			activeAnim = anim;
		}
		
		private function handleDirection() {
			var angle = Math.round(((Math.atan2(direction.x, -direction.y)) % Math.TWOPI / Math.TWOPI) * 8);
			angle = angle == 8 ? 0 : angle;
			
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].visible = false;
			}
			anims[animDirections[angle]].visible = true;
		}
		
		override public function render(t:Number) {
			for (var i = 0; i < anims.length; i++) {
				anims[i].x = p.x;
				anims[i].y = p.y;
			}
			
			/*display.x = p.x;
			display.y = p.y;*/
			
			super.render(t);
		}
		
		public function getDirection():Point {
			
			return direction;
		}
		
		public function getPosition():Point {
			return p;
		}
		
		override public function destroy():Boolean {
			if (!super.destroy()) return false;
			display.removeFromParent(true);
			return true;
		}
		
	}
	
}