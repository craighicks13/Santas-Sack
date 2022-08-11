package com.madcowmedia.santassack.state
{
	import com.madcowmedia.santassack.controllers.CollisionController;
	import com.madcowmedia.santassack.controllers.DropController;
	import com.madcowmedia.santassack.controllers.ElfController;
	import com.madcowmedia.santassack.controllers.PresentController;
	import com.madcowmedia.santassack.core.Game;
	import com.madcowmedia.santassack.interfaces.IState;
	import com.madcowmedia.santassack.models.Assets;
	import com.madcowmedia.santassack.utils.Constants;
	import com.madcowmedia.santassack.utils.MusicManager;
	import com.madcowmedia.santassack.view.Bag;
	import com.madcowmedia.santassack.view.Elf;
	import com.madcowmedia.santassack.view.GameOverWindow;
	import com.madcowmedia.santassack.view.Santa;
	import com.madcowmedia.santassack.view.ScoreBoard;
	import com.madcowmedia.santassack.view.Settings;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Play extends Sprite implements IState
	{
		public var game:Game;
		private var background:Image;
		private var pause:Image;
		public var elf:Elf;
		public var santa:Santa;

		private var elfController:ElfController;
		public var presentController:PresentController;
		public var collisionController:CollisionController;
		public var dropController:DropController;
		public var bag:Bag;
		public var paused:Boolean = false;
		public var scoreboard:ScoreBoard;

		private var gameover:GameOverWindow;
		private var soundtrackPausePos:Number;
		private var settings:Settings;
		
		public function Play(game:Game)
		{
			this.game = game;
			Assets.prepareGameSounds();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:starling.events.Event):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			
			background = new Image(Assets.getGameTexture('game_background'));
			background.touchable = false;
			addChild(background);
			
			pause = new Image(Assets.getGameTexture('pause_button'));
			pause.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			addChild(pause);
			
			scoreboard = new ScoreBoard();
			scoreboard.x = Constants.STAGE_WIDTH - 58;
			scoreboard.y = 5;
			addChild(scoreboard);
			
			elf = new Elf();
			elf.x = Constants.STAGE_WIDTH * .5;
			elf.y = 31;
			addChild(elf);
			
			santa = new Santa(this);
			santa.x = Constants.STAGE_WIDTH * .5;
			santa.y = Constants.STAGE_HEIGHT + 25;
			addChild(santa);
			
			bag = new Bag();
			bag.x = santa.x + 16;
			bag.y = santa.y - 76;
			addChild(bag);
			
			santa.bag = bag;
			
			presentController = new PresentController(this);
			collisionController = new CollisionController(this);
			dropController = new DropController(this);
			
			elfController = new ElfController(elf);
			elfController.start();
			
			MusicManager.play();
		}
		
		public function changeState(value:int):void
		{
			game.changeState(value);
		}
		
		
		private function onMenuItemTouched(event:TouchEvent):void
		{
			if (event.getTouch(pause, TouchPhase.BEGAN))
			{
				pauseGame();
				
				settings = new Settings(true);
				settings.onBackTriggered = pauseDown;
				settings.y = Constants.STAGE_HEIGHT;
				addChild(settings);
				
				settings.flatten();
				
				var pause_tween:Tween = new Tween(settings, 1, Transitions.EASE_OUT);
				pause_tween.onComplete = settings.unflatten;
				pause_tween.animate('y', 0);
				
				Starling.juggler.add(pause_tween);
			}
		}
		
		public function update():void
		{
			if(!paused)
			{
				santa.update();
				presentController.update();
				collisionController.update();
			}
		}
		
		public function pauseGame():void
		{
			paused = true;
			elfController.stop();
			santa.pauseState = true;
			pause.touchable = false;
			
			MusicManager.pause();
		}
		
		protected function pauseDown():void
		{
			settings.flatten();
			
			var pause_tween:Tween = new Tween(settings, 1, Transitions.EASE_OUT);
			pause_tween.onComplete = resumeGame;
			pause_tween.animate('y', Constants.STAGE_HEIGHT);
			
			Starling.juggler.add(pause_tween);
		}
		
		public function resumeGame():void
		{
			removeChild(settings);
			settings.destroy();
			settings = null;
			
			elfController.resume();
			santa.pauseState = false;
			pause.touchable = true;
			paused = false;
			
			MusicManager.resume();
		}
		
		public function increaseScore():void
		{
			scoreboard.increaseScore();
			if(scoreboard.score % 10 == 0)
			{
				elfController.speed++;
				presentController.increaseLevel();
			}
		}
		
		public function gameOver():void
		{
			pauseGame();
			
			Assets.updateScores(scoreboard.score);
			scoreboard.updateBest();
			
			MusicManager.stop();
			
			gameover = new GameOverWindow(this);
			gameover.x = Constants.STAGE_WIDTH *.5;
			gameover.y = Constants.STAGE_HEIGHT * .5;
			addChild(gameover);
			
			if(GameCenter.isSupported())
				game.gameCenterController.reportScore(scoreboard.score);
		}
		
		public function restart():void
		{
			gameover.flatten();
			var tween:Tween = new Tween(gameover, .5, Transitions.EASE_IN_BACK);
			tween.animate('y', Constants.STAGE_HEIGHT + gameover.height);
			tween.onComplete = removeGameOver;
			Starling.juggler.add(tween);
			
			dropController.reset();
			scoreboard.reset();
			presentController.reset();
			elfController.reset();
		}
		
		protected function removeGameOver():void
		{
			removeChild(gameover);
			gameover.destroy();
			gameover = null;
			
			paused = false;
			elfController.start();
			santa.pauseState = false;
			pause.touchable = true;
			
			MusicManager.play();
		}
		
		public function destroy():void
		{
			pause.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			
			elfController.stop();
			santa.destroy();
			elf.destroy();
			dropController.destroy();
			gameover.destroy();
			
			removeChildren(0, -1, true);
		}
	}
}

