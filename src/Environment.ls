package  {
    import loom2d.display.Sprite;
    import loom2d.display.Stage;
    
    public class Environment {
        
        private var display:Sprite = new Sprite();
        
        private var player:Player;
        
        public function Environment(stage:Stage) {
            player = new Player(display);
            
            stage.addChild(display);
        }
        
    }
    
}