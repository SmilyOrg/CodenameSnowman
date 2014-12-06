package
{
	import loom.Application;
	import loom.sound.Sound;
	import loom2d.display.StageScaleMode;
	import loom2d.display.Image;
	import loom2d.events.KeyboardEvent;
	import loom2d.math.Color;
	import loom2d.textures.Texture;
	import loom2d.textures.TextureSmoothing;
	import loom2d.ui.SimpleLabel;
	import system.Void;

	public class CodenameSnowman extends Application
	{
		/** Simulation delta time */
		private var dt = 1/60;
		
		/** Simulation time */
		private var t = 0;
		
		private var w = 640;
		private var h = 360;
		
		private var environment:Environment;
		
		override public function run():void
		{
			// Comment out this line to turn off automatic scaling.
			stage.scaleMode = StageScaleMode.LETTERBOX;
			
			TextureSmoothing.defaultSmoothing = TextureSmoothing.NONE;
			
			environment = new Environment(stage, w, h);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			environment.onKeyDown(e);
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			environment.onKeyUp(e);
		}
		
		override public function onTick() {
			environment.tick(t, dt);
			return super.onTick();
		}
		
		override public function onFrame() {
			environment.render(t);
			return super.onFrame();
		}
	}
}