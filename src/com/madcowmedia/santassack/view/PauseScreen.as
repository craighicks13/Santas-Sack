package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PauseScreen extends Sprite
	{
		public function PauseScreen()
		{
			addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
		}
		
		protected final function init():void
		{
			
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			
			var background:Image = new Image(Assets.getMenuTexture('game_background'));
			background.touchable = false;
			addChild(background);
		}
	}
}