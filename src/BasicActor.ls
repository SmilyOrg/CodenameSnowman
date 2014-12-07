package  {
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.math.Point;
	
	public class BasicActor {
		
		private var footstepTime = 0;
		private var footstepTreshold = 0.2;
		protected var moving = false;
		protected var moving0 = false;
		
		private var direction:Point = new Point(1, 0);
		private var anims:Vector.<AnimActor>;
		private var animsShadow:Vector.<AnimActor>;
		private var animDirections:Vector.<int> = [0, 7, 6, 5, 4, 3, 2, 1];
		private var activeAnim:AnimActor;
		
		private var footstep:Sound;
		
		public function BasicActor(container:DisplayObjectContainer, shadowContainer:DisplayObjectContainer, color:int = 0xFFFFFF) {
			footstep = Sound.load("assets/sound/snow_tread_1.ogg");
			footstep.setGain(0.1);
			
			anims = new Vector.<AnimActor>();
			anims.push(new AnimActor("assets/eskimo-walk.png"));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 7));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 2));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 3));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 4));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 5));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 6));
			anims.push(new AnimActor("assets/eskimo-walk.png", 32, 32, 1));
			
			animsShadow = new Vector.<AnimActor>();
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 0));
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 7));
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 2));
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 3));
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 4));
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 5));
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 6));
			animsShadow.push(new AnimActor("assets/eskimo-walk-shadows.png", 36, 32, 1));
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].play();
				anims[i].center();
				anims[i].color = color;
				animsShadow[i].play();
				animsShadow[i].center();
				container.addChild(anims[i]);
				shadowContainer.addChild(animsShadow[i]);
			}
		}
		
		public function tick(t:Number, dt:Number, p:Point, v:Point) {
			if (moving0 && v.length > 70)
			{
				direction = v;
				handleDirection(v);
			}
			
			moving = v.length > 10;
			if (moving || moving0) {
				if (footstepTime > footstepTreshold || moving0 != moving) {
					onFootstep(p);
					if (moving0 != moving) {
						footstepTime = 0;
					} else {
						footstepTime -= footstepTreshold;
					}
				}
				
				footstepTime += dt;
			}
			moving0 = moving;
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].advanceTime(dt * v.length * 0.02);
				animsShadow[i].advanceTime(dt * v.length * 0.02);
				if (!moving || anims[i].currentFrame == 3) {
					anims[i].currentFrame = 0;
					animsShadow[i].currentFrame = 0;
				}
			}
		}
		
		private function onFootstep(p:Point)
		{
			footstep.setPitch(Math.random() * 0.5 + 0.7);
			footstep.play();
			
			var footprint = new Footprint();
			footprint.setPosition(p.x, p.y + 8);
			Entity.environment.addEntity(footprint);
		}
		
		public function handleDirection(v:Point) {
			var angle = Math.round(((Math.atan2(direction.x, -direction.y)) % Math.TWOPI / Math.TWOPI) * 8);
			angle = angle == 8 ? 0 : angle;
			
			for (var i = 0; i < anims.length; i++) {
				anims[i].visible = false;
				animsShadow[i].visible = false;
			}
			anims[animDirections[angle]].visible = true;
			animsShadow[animDirections[angle]].visible = true;
		}
		
		public function getDirection():Point {
			
			return direction;
		}
		
		public function render(p:Point) {
			for (var i = 0; i < anims.length; i++) {
				anims[i].x = p.x;
				anims[i].y = p.y;
				
				animsShadow[i].x = p.x + 10;
				animsShadow[i].y = p.y;
			}
		}
		
		public function destroy() {
			for (var i = 0; i < anims.length; i++) {
				anims[i].removeFromParent(true);
				animsShadow[i].removeFromParent(true);
			}
		}
		
	}
	
}