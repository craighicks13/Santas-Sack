package com.madcowmedia.santassack.state
{
	import com.madcowmedia.santassack.interfaces.IState;
	import com.madcowmedia.santassack.core.Game;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameOver extends Sprite implements IState
	{
		private var game:Game;
		
		public function GameOver(game:Game)
		{
			this.game = game;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
	}
}
