package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.core.Game;
	import com.madcowmedia.santassack.models.Assets;
	import com.madcowmedia.santassack.state.Play;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	
	import flash.media.Sound;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class GameOverWindow extends Sprite
	{
		private var play:Play;
		private var again:Button;
		private var main:Button;
		private var sound:Sound;
		private var leaderboard:Button;
		
		public function GameOverWindow(play:Play)
		{
			this.play = play;
			
			sound = Assets.getSound('GameOver');
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var background:Image = new Image(Assets.getGameTexture('game_over_background'));
			background.touchable = false;
			addChild(background);
			
			this.pivotX = background.width * .5;
			this.pivotY = background.height * .5;
			
			var score:TextField = new TextField(80, 35, "X " + play.scoreboard.score.toString(), 'Helvetica', 26, 0xFFFFFF, true);
			score.touchable = false;
			score.autoScale = true;
			score.hAlign = 'left';
			score.x = 120;
			score.y = 82;
			addChild(score);
			
			again = new Button(Assets.getGameTexture('game_over_play_again'));
			again.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			again.pivotX = again.width * .5;
			again.x = this.pivotX;
			again.y = 135;
			addChild(again);
			
			
			main = new Button(Assets.getGameTexture('game_over_main_menu'));
			main.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			main.pivotX = main.width * .5;
			main.x = this.pivotX;
			main.y = again.y + 75;
			addChild(main);
			
			if(GameCenter.isSupported())
			{
				leaderboard = new Button(Assets.getGameTexture('game_over_game_center'));
				leaderboard.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
				leaderboard.pivotX = leaderboard.width * .5;
				leaderboard.x = this.pivotX;
				leaderboard.y = main.y + 75;
				addChild(leaderboard);
			}
			
			if(!Assets.muted) sound.play();
		}
		
		
		private function onMenuItemTouched(event:TouchEvent):void
		{
			if (event.getTouch(main, TouchPhase.ENDED))
			{
				play.changeState(Game.MAIN_STATE);
			}
			
			if (event.getTouch(again, TouchPhase.ENDED))
			{
				play.restart();
			}
			
			if (event.getTouch(leaderboard, TouchPhase.ENDED))
			{
				play.game.gameCenterController.showLeaderboard();
			}
		}
		
		public function destroy():void
		{
			again.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			main.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			
			if(leaderboard != null)
				leaderboard.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			
			removeChildren(0, -1, true);
		}
	}
}