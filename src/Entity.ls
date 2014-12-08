package
{
	import loom.sound.Listener;
	import loom.sound.Sound;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.math.Point;
	import loom2d.math.Rectangle;
	
	/**
	 * Base entity class for the simple physics engine.
	 * Uses velocity verlet for motion integration.
	 */
	public class Entity
	{
		public static var STATE_IDLE      = 0;
		public static var STATE_DESTROYED = 1;
		public var state                  = STATE_IDLE;
		protected var hasFreeWill         = false;
		public var isCollidable        = true;
		
		public var children:Vector.<Entity>;
		
		/** Position */
		protected var p:Point;
		
		/** Velocity */
		protected var v:Point;
		
		/** Old acceleration - used for integration */
		private var oa:Point;
		
		/** Acceleration */
		protected var a:Point;
		
		public var bounds:Rectangle = new Rectangle();
		
		protected static const DRAG_AIR = 0.01;
		protected static const DRAG_WATER = 0.05;
		protected static const SOUND_SCALE = 0.15;
		
		public static var environment:Environment = null;
		
		public function Entity() { }
		
		public function setPosition(x: Number, y: Number)
		{
			p.x = x;
			p.y = y;
		}
		
		public function getPosition():Point {
			return p;
		}
		
		public function getVelocity():Point {
			return v;
		}
		
		protected function addCollisionEntity(px:int, py:int, x:int, y:int, w:int, h:int)
		{
			var entity = new Entity();
			entity.p.x = px;
			entity.p.y = py;
			entity.bounds = new Rectangle(x, y, w, h);
			
			if(children == null)
				children = new Vector.<Entity>();
			
			children.push(entity);
		}
		
		/** Set sound position and velocity to entity position and velocity */
		protected function placeSound(sound:Sound)
		{
			sound.setPosition(p.x*SOUND_SCALE, 0, p.y*SOUND_SCALE);
			sound.setVelocity(v.x*SOUND_SCALE, 0, v.y*SOUND_SCALE);
		}
		
		/** Set listener position and velocity to entity position and velocity */
		protected function placeListener()
		{
			Listener.setPosition(p.x*SOUND_SCALE, 0, p.y*SOUND_SCALE);
			Listener.setVelocity(v.x*SOUND_SCALE, 0, v.y*SOUND_SCALE);
		}
		
		protected function resetPhysics()
		{
			p = v = oa = a = Point.ZERO;
		}
		
		public function intersectBounds(p1:Point, p2:Point, result:Point):Boolean {
			var lp1:Point = p1-p;
			var lp2:Point = p2-p;
			
			var rect = bounds;
			return intersectLineLine(lp1, lp2, new Point(rect.left, rect.top), new Point(rect.right, rect.top), result) ||
			       intersectLineLine(lp1, lp2, new Point(rect.right, rect.top), new Point(rect.right, rect.bottom), result) ||
			       intersectLineLine(lp1, lp2, new Point(rect.right, rect.bottom), new Point(rect.left, rect.bottom), result) ||
			       intersectLineLine(lp1, lp2, new Point(rect.left, rect.bottom), new Point(rect.left, rect.top), result);
		}
		
		public static function intersectLineLine(p1:Point, p2:Point, p3:Point, p4:Point, result:Point):Boolean {
			var div:Number = ((p4.y-p3.y)*(p2.x-p1.x)-(p4.x-p3.x)*(p2.y-p1.y));
			var ua:Number = ((p4.x-p3.x)*(p1.y-p3.y)-(p4.y-p3.y)*(p1.x-p3.x))/div;
			var ub:Number = ((p2.x-p1.x)*(p1.y-p3.y)-(p2.y-p1.y)*(p1.x-p3.x))/div;
			if (((ua >= 0) && (ua <= 1)) && ((ub >= 0) && (ub <= 1))) {
				result.x = p1.x+ua*(p2.x-p1.x);
				result.y = p1.y+ua*(p2.y-p1.y);
				return true;
			}
			return false;
		}
		
		/**
		 * Entity-entity collision check based on bounds AABB, returns true if they intersect.
		 */
		public function checkCollision(entity:Entity):Boolean
		{
			if (!entity.isCollidable)
				return false;
			
			if (!isCollidable)
				return false;
			
			if (children != null)
			{
				for (var i = 0; i < children.length; i++)
				{
					if (children[i].checkCollision(entity))
					{
						return true;
					}
				}
				
				return false;
			}
			
			if (entity.children != null)
			{
				for (i = 0; i < entity.children.length; i++)
				{
					if (checkCollision(entity.children[i]))
					{
						return true;
					}
				}
				
				return false;
			}
			
			var px = p.x;
			var py = p.y;
			var epx = entity.p.x;
			var epy = entity.p.y;
			var b = bounds;
			var eb = entity.bounds;
			return py+b.bottom > epy+eb.top   &&
			       py+b.top    < epy+eb.bottom &&
			       px+b.right  > epx+eb.left  &&
			       px+b.left   < epx+eb.right;
		}
		
		/**
		 * Adds drag as acceleration.
		 */
		public function drag(dt:Number, coefficient:Number)
		{
			var amount = -coefficient/dt;
			a.offset(amount*v.x, amount*v.y);
		}
		
		public function moveByX(dt:Number):Number
		{
			return v.x * dt + 0.5 * oa.x * dt * dt;
		}
		
		public function moveByY(dt:Number):Number
		{
			return v.y * dt + 0.5 * oa.y * dt * dt;
		}
		
		public function tick(t:Number, dt:Number)
		{
			// Velocity verlet integration

			if (hasFreeWill)
			{
				var opx = p.x;
				p.x += moveByX(dt);
				
				if (environment.checkCollisionWithEntities(this))
				{
					p.x = opx;
				}
				
				var opy = p.y;
				p.y += moveByY(dt);
				
				if (environment.checkCollisionWithEntities(this))
				{
					p.y = opy;
				}				
			}
			else
			{
				p.x += moveByX(dt);
				p.y += moveByY(dt);
			}
			
			
			v.x += (a.x+oa.x)*0.5*dt;
			v.y += (a.y+oa.y)*0.5*dt;
			// Set the current acceleration as old acceleration and reset it
			oa.x = a.x;
			oa.y = a.y;
			a.x = 0;
			a.y = 0;
		}
		
		public function render(t:Number) { }
		
		public function destroy():Boolean {
			if (state == STATE_DESTROYED) return false;
			state = STATE_DESTROYED;
			return true;
		}		
	}
}