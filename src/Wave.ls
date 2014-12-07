package  
{
	import loom2d.math.Point;
	
	/**
	 * ...
	 * @author Jure Gregorin
	 */
	public class Wave 
	{
		private var spawnPoints:Vector.<SpawnPoint> = new Vector.<SpawnPoint>();
		private var liveSpawns:Vector.<AI> = new Vector.<AI>();
		
		public function Wave() 
		{
			
		}
		
		public function addSpawnPoint(location:Point, type:EnemyType, count:Number, interval:Number, delay:Number)
		{
			var spawnPoint = new SpawnPoint(location, type, count, interval, delay, spawned, died);
			spawnPoints.push(spawnPoint);
		}
		
		private function spawned(ai:AI)
		{
			Entity.environment.addAI(ai);
			liveSpawns.push(ai);
		}
		
		private function died(ai:AI)
		{
			for (var i = 0; i < liveSpawns.length; i++)
			{
				if (liveSpawns[i] == ai)
					liveSpawns.splice(i, 1);
			}
		}
		
		public function tick(dt:Number)
		{
			for (var i = 0; i < spawnPoints.length; i++)
			{
				var sp = spawnPoints[i];
				sp.tick(dt);
			}
		}
		
		public function isFinished():Boolean
		{
			
			for (var i = 0; i < spawnPoints.length; i++)
			{
				if (!spawnPoints[i].isExhausted())
					return false;
			}
			
			return liveSpawns.length == 0;
		}
	}
	
}