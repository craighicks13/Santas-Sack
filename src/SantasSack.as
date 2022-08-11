package
{
	import com.madcowmedia.santassack.core.Game;
	import com.madcowmedia.santassack.utils.Constants;
	import com.madcowmedia.santassack.utils.MusicManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(frameRate="40", backgroundColor='0x000000')]
	public class SantasSack extends Sprite
	{
		[Embed(source="../assets/1x/loading-screen.png")]
		private static var DefaultBackground:Class;
		
		[Embed(source="../assets/2x/loading-screen.png")]
		private static var DefaultBackground_2x:Class;
		
		private var s:Starling;
		
		public function SantasSack()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			var stageWidth:int   = Constants.STAGE_WIDTH;
			var stageHeight:int  = Constants.STAGE_HEIGHT;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			//var viewPort:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			
			var bg:Bitmap = scaleFactor == 1 ? new DefaultBackground() : new DefaultBackground_2x();
			DefaultBackground = DefaultBackground_2x = null; // no longer needed!
			
			bg.cacheAsBitmap = true;
						
			if(Capabilities.cpuArchitecture == "ARM")
			{				
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			}
			
			bg.x = viewPort.x;
			bg.y = viewPort.y;
			bg.width  = viewPort.width;
			bg.height = viewPort.height;
			bg.smoothing = true;
			addChild(bg);
			
			Starling.handleLostContext = true;
			
			s = new Starling(Game, stage, viewPort);
			s.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			s.stage.stageHeight = stageHeight; // <- same size on all devices!
			//s.stage.stageWidth = 320;
			//s.stage.stageHeight = 480;
			s.addEventListener(starling.events.Event.ROOT_CREATED,
				function onRootCreated(event:Object, app:Game):void
				{
					s.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
					removeChild(bg);
					
					//var bgTexture:Texture = Texture.fromBitmap(bg, false, false, scaleFactor);
					
					//app.start(bgTexture, assets);
					s.start();
				});
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, function (e:*):void { s.start(); MusicManager.wake(); });
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, function (e:*):void { s.stop(); MusicManager.sleep(); });
		}
		
		/**
		 * Define handlers:
		 */		
		
		private function handleKeys(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK)
			{
				s.stop();
				MusicManager.sleep();
			}
		}
	}
}