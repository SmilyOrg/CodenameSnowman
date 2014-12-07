package  {
	import loom2d.math.Point;
	
	public class AI extends Actor {
		
		public var target:Point;
		
		public var onDeath:Function = null;
		
		public function AI() {
			
		}
		
		public override function destroy():Boolean
		{
			if(onDeath != null)
				onDeath(this);
			
			return super.destroy();
		}
		
	}
	
}