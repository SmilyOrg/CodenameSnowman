package  {
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.math.Point;
	import loom2d.textures.Texture;
	
	public class BasicActor {
		
		private static var walk:Texture;
		private static var walkShadow:Texture;
		
		private var footstepTime = 0;
		private var footstepTreshold = 0.2;
		protected var moving = false;
		protected var moving0 = false;
		
		private var direction:Point = new Point(1, 0);
		private var anims:Vector.<AnimActor>;
		private var animsShadow:Vector.<AnimActor>;
		private var animDirections:Vector.<int> = [0, 7, 6, 5, 4, 3, 2, 1];
		private var activeAnim:AnimActor;
		private var activeShadow:AnimActor;
		
		private var footstep:Sound;
		private var lastFootprint:Point = new Point(-100, -100);
		
		private var at:Number = 0;
		
		public function BasicActor(container:DisplayObjectContainer, shadowContainer:DisplayObjectContainer, color:int = 0xFFFFFF) {
			//footstep = Sound.load("assets/sound/snow_tread_1.ogg");
			//footstep.setGain(0.1);
			
			if (walk == null) walk = Texture.fromAsset("assets/eskimo-walk.png");
			if (walkShadow == null) walkShadow = Texture.fromAsset("assets/eskimo-walk-shadows.png");
			
			anims = new Vector.<AnimActor>();
			anims.push(new AnimActor(walk));
			anims.push(new AnimActor(walk, 32, 32, 1));
			anims.push(new AnimActor(walk, 32, 32, 2));
			anims.push(new AnimActor(walk, 32, 32, 3));
			anims.push(new AnimActor(walk, 32, 32, 4));
			anims.push(new AnimActor(walk, 32, 32, 5));
			anims.push(new AnimActor(walk, 32, 32, 6));
			anims.push(new AnimActor(walk, 32, 32, 7));
			
			animsShadow = new Vector.<AnimActor>();
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 0));
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 7));
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 2));
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 3));
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 4));
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 5));
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 6));
			animsShadow.push(new AnimActor(walkShadow, 36, 32, 1));
			
			for (var i = 0; i < anims.length; i++) {
				//anims[i].play();
				anims[i].center();
				anims[i].color = color;
				//animsShadow[i].play();
				animsShadow[i].center();
				container.addChild(anims[i]);
				shadowContainer.addChild(animsShadow[i]);
			}
		}
		
		public function tick(t:Number, dt:Number, a:Actor) {
			var v = a.getVelocity();
			var p = a.getPosition();
			if (moving0 && v.length > 70)
			{
				direction = v;
				handleDirection(v);
			}
			
			moving = v.length > 10;
			if (moving || moving0) {
				if (footstepTime > footstepTreshold || moving0 != moving) {
					//onFootstep(p);
					if (moving0 != moving) {
						footstepTime = 0;
					} else {
						footstepTime -= footstepTreshold;
					}
				}
				
				footstepTime += dt;
			}
			moving0 = moving;
			
			at += dt * v.length * 0.02;
		}
		
		private function onFootstep(p:Point)
		{
			if (Point.distance(p.add(new Point(0,8)), lastFootprint) > 5) {
				footstep.setPitch(Math.random() * 0.5 + 0.7);
				footstep.play();
			
				var footprint = new Footprint();
				footprint.setPosition(p.x, p.y + 8);
				Entity.environment.addEntity(footprint);
				lastFootprint = footprint.getPosition();
			}
		}
		
		public function handleDirection(v:Point) {
			var angle = Math.round(((Math.atan2(direction.x, -direction.y)) % Math.TWOPI / Math.TWOPI) * 8);
			angle = angle == 8 ? 0 : angle;
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].visible = false;
				animsShadow[i].visible = false;
			}
			activeAnim = anims[animDirections[angle]];
			activeShadow = animsShadow[animDirections[angle]];
			activeAnim.visible = true;
			activeShadow.visible = true;
		}
		
		public function getDirection():Point {
			return direction;
		}
		
		public function render(a:Actor) {
			var p = a.getPosition();
			setAnimTime(activeAnim, at);
			setAnimTime(activeShadow, at);
			
			switch (a.state) {
				case Actor.STATE_DYING:
					activeAnim.currentFrame = 6;
					activeShadow.currentFrame = 6;
					break;
				case Actor.STATE_DEAD:
					activeAnim.currentFrame = 7;
					activeShadow.currentFrame = 7;
					break;
				case Actor.STATE_THROWING:
				case ThinkyAI.STATE_AIMING:
					activeAnim.currentFrame = 4;
					activeShadow.currentFrame = 4;
					break;
				case Actor.STATE_THROWN:
					activeAnim.currentFrame = 5;
					activeShadow.currentFrame = 5;
					break;
				case Entity.STATE_IDLE:
					if (activeAnim.currentFrame > 3) {
						activeAnim.currentFrame = 0;
						activeShadow.currentFrame = 0;
						at = 0;
					}
					break;
				default:
					if (!moving || activeAnim.currentFrame == 4 || activeAnim.currentFrame > 5) {
						activeAnim.currentFrame = 0;
						activeShadow.currentFrame = 0;
						at = 0;
					}
			}
			
			
			activeAnim.x = p.x;
			activeAnim.y = p.y;
			
			activeShadow.x = p.x + 9;
			activeShadow.y = p.y + 1;
		}
		
		private function setAnimTime(anim:AnimActor, at:Number) {
			anim.currentFrame = Math.floor((at*anim.fps)%anim.numFrames);
		}
		
		public function destroy() {
			for (var i = 0; i < anims.length; i++) {
				anims[i].removeFromParent(true);
				animsShadow[i].removeFromParent(true);
			}
		}
		
	}
	
}