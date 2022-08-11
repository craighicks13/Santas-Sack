package com.madcowmedia.santassack.core
{
	import com.madcowmedia.santassack.controllers.GameCenterController;
	import com.madcowmedia.santassack.interfaces.IState;
	import com.madcowmedia.santassack.models.Assets;
	import com.madcowmedia.santassack.state.GameOver;
	import com.madcowmedia.santassack.state.Main;
	import com.madcowmedia.santassack.state.Play;
	import com.madcowmedia.santassack.utils.Constants;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public static const MAIN_STATE:int = 0;
		public static const PLAY_STATE:int = 1;
		public static const GAME_OVER_STATE:int = 2;
		
		private var current_state:IState;
		
		public var gameCenterController:GameCenterController;
		
		public function Game()
		{
			//Starling.current.showStats = true;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function changeState(state:int):void
		{
			if(current_state != null)
			{
				current_state.destroy();
				current_state = null;
			}
			
			switch(state)
			{
				case MAIN_STATE:
					current_state = new Main(this);
					break;
				
				case PLAY_STATE:
					current_state = new Play(this);
					break;
				
				case GAME_OVER_STATE:
					current_state = new GameOver(this);
					break;
			}
			
			addChild(Sprite(current_state));
		}
		
		private function update(event:Event):void
		{
			current_state.update();
		}
		
		private function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.stageWidth  = Constants.STAGE_WIDTH;
			stage.stageHeight = Constants.STAGE_HEIGHT;

			Assets.contentScaleFactor = Starling.current.contentScaleFactor;
			
			// prepare assets
			Assets.loadBitmapFonts();
			Assets.loadData();
			
			changeState(MAIN_STATE);
			addEventListener(Event.ENTER_FRAME, update);
		}
	}
}