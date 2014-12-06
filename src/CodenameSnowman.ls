package
{
    import loom.Application;
    import loom2d.display.StageScaleMode;
    import loom2d.display.Image;
    import loom2d.events.KeyboardEvent;
    import loom2d.textures.Texture;
    import loom2d.textures.TextureSmoothing;
    import loom2d.ui.SimpleLabel;

    public class CodenameSnowman extends Application
    {
        private var environment:Environment;
        
        override public function run():void
        {
            // Comment out this line to turn off automatic scaling.
            stage.scaleMode = StageScaleMode.LETTERBOX;
            
            TextureSmoothing.defaultSmoothing = TextureSmoothing.NONE;
            
            environment = new Environment(stage);
            
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            
        }
        
        private function onKeyDown(e:KeyboardEvent):void {
            trace(e.keyCode);
        }
    }
}