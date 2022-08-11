package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.controllers.GameCenterController;
	import com.madcowmedia.santassack.models.Assets;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameCenterIcon extends Sprite
	{
		private var button:Button;
		private var game_center:GameCenterController;
		
		public function GameCenterIcon(game_center:GameCenterController)
		{
			super();
			this.game_center = game_center;
			
			button = new Button(Assets.getMenuTexture('game_center_button'));
			button.addEventListener(Event.TRIGGERED, onGameCenter);
			addChild(button);
		}
		
		protected final function onGameCenter(event:Event):void
		{
			game_center.showLeaderboard();
		}
		
		public final function destroy():void
		{
			removeChild(button);
			button.removeEventListener(Event.TRIGGERED, onGameCenter);
			button.dispose();
		}
	}
}