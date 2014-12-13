package
{
	import loom.Application;
	import loom.sound.Sound;
	import loom2d.core.TouchProcessor;
	import loom2d.display.StageScaleMode;
	import loom2d.display.Image;
	import loom2d.events.KeyboardEvent;
	import loom2d.events.Touch;
	import loom2d.events.TouchEvent;
	import loom2d.events.TouchPhase;
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
        
        private var keysDown:Vector.<Boolean> = new Vector.<Boolean>(256);
		
		override public function run():void
		{	
			// Comment out this line to turn off automatic scaling.
			stage.scaleMode = StageScaleMode.LETTERBOX;
			
			TextureSmoothing.defaultSmoothing = TextureSmoothing.NONE;
			
			environment = new Environment(stage, w, h, restart);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function restart()
		{
			stage.removeChildren(0, stage.numChildren - 1, true);
			
			environment = new Environment(stage, w, h, restart);
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
            if (e.keyCode >= 0 && e.keyCode < keysDown.length) {
                if (keysDown[e.keyCode]) return;
                keysDown[e.keyCode] = true;
            }
			environment.onKeyDown(e);
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
            if (e.keyCode >= 0 && e.keyCode < keysDown.length) {
                keysDown[e.keyCode] = false;
            }
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