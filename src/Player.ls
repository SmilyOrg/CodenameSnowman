package  {
    import loom2d.display.DisplayObjectContainer;
    import loom2d.display.Image;
    import loom2d.textures.Texture;
    
    public class Player extends Entity {
        
        private var display:Image;
        
        public function Player(container:DisplayObjectContainer) {
            display = new Image(Texture.fromAsset("assets/logo.png"));
            container.addChild(display);
        }
        
    }
    
}