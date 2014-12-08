package  
{
	import feathers.core.PopUpManager;
	import loom2d.math.Point;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */	
	public class SpawnPoint 
	{
		private var location:Point;
		private var type:EnemyType;
		private var maxCount:Number;
		private var interval:Number;
		private var onSpawn:Function;
		private var onDeath:Function;
		private var delay:Number;
		
		private var lastSpawnTime = 0;
		private var currentCount = 0;
		
		public function SpawnPoint(l:Point, t:EnemyType, c:Number, i:Number, d:Number, spawned:Function, died:Function) 
		{
			location = l;
			type = t;
			maxCount = c;
			interval = i;
			lastSpawnTime = interval;
			onSpawn = spawned;
			onDeath = died;
			delay = d;
		}
		
		public function isExhausted():Boolean
		{
			return currentCount == maxCount;
		}
		
		public function spawn():AI
		{
			var ai:AI;
			
			switch(type)
			{
				case EnemyType.SIMPLE:
					ai = new SimpleAI(Entity.environment.getDisplay());
					break;
				case EnemyType.THINKY:
					ai = new ThinkyAI(Entity.environment.getDisplay());
					break;
			}
			
			ai.setPosition(location.x, location.y);
			ai.onDeath = onDeath;
			currentCount++;
			
			return ai;
		}
		
		public function tick(dt:Number)
		{
			if (delay >= 0)
			{
				delay -= dt;
				return;
			}
			
			lastSpawnTime += dt;
			
			if (currentCount >= maxCount)
				return;
				
			if (lastSpawnTime >= interval)
			{
				var ai = spawn();
				onSpawn(ai);
				
				lastSpawnTime -= interval;
			}
		}
	}
	
	enum EnemyType
	{
			SIMPLE,
			THINKY
	}	
}