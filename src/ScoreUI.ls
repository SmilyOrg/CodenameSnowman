package  
{
	import loom2d.display.DisplayObjectContainer;
	import loom2d.ui.SimpleLabel;
	
	/**
	 * ...
	 * @author Tadej
	 */
	public class ScoreUI extends Entity
	{
		private var score:int = 0;
		
		private var scoreLabel:SimpleLabel;
		
		public function ScoreUI(container:DisplayObjectContainer, stageH:Number = 0) 
		{
			scoreLabel = new SimpleLabel("assets/square-font-bordered-export.fnt");
			scoreLabel.text = "score: " + score;
			scoreLabel.x = 20;
			scoreLabel.y = stageH - 20 - scoreLabel.height;
			container.addChild(scoreLabel);
		}
		
		public function addScore(num:int = 0) {
			score += num;
			updateScore();
		}
		
		public function setScore(num:int) {
			score = num;
			updateScore();
		}
		
		private function updateScore() {
			scoreLabel.text = "score: " + score;
		}
	}
	
}