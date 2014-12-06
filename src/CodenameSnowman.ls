package
{
	import loom.Application;
	import loom2d.display.StageScaleMode;
	import loom2d.display.Image;
	import loom2d.events.KeyboardEvent;
	import loom2d.textures.Texture;
	import loom2d.textures.TextureSmoothing;
	import loom2d.ui.SimpleLabel;
	import system.Void;

	public class CodenameSnowman extends Application
	{
		private var environment:Environment;
		private var snowOverlay:SnowOverlay;
		
		override public function run():void
		{
			// Comment out this line to turn off automatic scaling.
			stage.scaleMode = StageScaleMode.LETTERBOX;
			
			TextureSmoothing.defaultSmoothing = TextureSmoothing.NONE;
			
			environment = new Environment(stage);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			snowOverlay = new SnowOverlay();
			stage.addChild(snowOverlay);
			snowOverlay.initialize();
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			trace(e.keyCode);
			environment.onKeyDown(e);
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			trace(e.keyCode);
			environment.onKeyUp(e);
		}
		
		override public function onTick() {
			snowOverlay.tick(1 / 60);
			environment.tick();
			return super.onTick();
		}
		
		override public function onFrame() {
			environment.render();
			return super.onFrame();
		}
	}
}