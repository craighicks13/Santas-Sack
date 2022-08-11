package com.madcowmedia.santassack.state
{
	import com.madcowmedia.santassack.controllers.GameCenterController;
	import com.madcowmedia.santassack.core.Game;
	import com.madcowmedia.santassack.interfaces.IState;
	import com.madcowmedia.santassack.utils.Constants;
	import com.madcowmedia.santassack.view.GameCenterIcon;
	import com.madcowmedia.santassack.view.Menu;
	import com.madcowmedia.santassack.view.Scores;
	import com.madcowmedia.santassack.view.Settings;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite implements IState
	{
		private var game:Game;

		private var menu:Menu;
		private var settings:Settings;
		private var scores:Scores;
		
		private var sub:Sprite;
		private var gameCenterIcon:GameCenterIcon;
		
		public function Main(game:Game)
		{
			this.game = game;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			menu = new Menu(this);
			menu.onSubsectionTriggered = showSubsection;
			menu.onCheckGameCenter = checkGameCenter;
			menu.onPlayTriggered = playGame;
			addChild(menu);
		}
		
		private function checkGameCenter():void
		{
			if(GameCenter.isSupported())
			{
				if(game.gameCenterController == null)
				{
					game.gameCenterController = new GameCenterController();
					game.gameCenterController.initGameCenter();
				}
				
				gameCenterIcon = new GameCenterIcon(game.gameCenterController);
				gameCenterIcon.x = Constants.STAGE_WIDTH - gameCenterIcon.width;
				gameCenterIcon.y = -100;
				addChild(gameCenterIcon);
				
				var t:Tween = new Tween(gameCenterIcon, 1.5, Transitions.EASE_OUT_BOUNCE);
				t.animate('y', Constants.STAGE_HEIGHT - gameCenterIcon.height);
				Starling.juggler.add(t);
			}
		}
		
		public function removeGameCenterIcon():void
		{
			var t:Tween = new Tween(gameCenterIcon, .75, Transitions.EASE_IN_BACK);
			t.animate('y', Constants.STAGE_HEIGHT + 50);
			Starling.juggler.add(t);
		}
		
		private function playGame():void
		{
			game.changeState(Game.PLAY_STATE);
		}
		
		private function showSubsection(value:String):void
		{
			menu.flatten();
			sub = (value == Menu.SUB_SCORES) ? scores : settings;
			
			if(sub == null)
			{
				if(value ==  Menu.SUB_SCORES)
				{
					scores = new Scores();
					scores.onBackTriggered = backToMenu;
					scores.y = Constants.STAGE_HEIGHT;
					addChild(scores);
					sub = scores;
				}
				else
				{
					settings = new Settings();
					settings.onBackTriggered = backToMenu;
					settings.y = Constants.STAGE_HEIGHT;
					addChild(settings);
					sub = settings;
				}
			}
			
			sub.flatten();
			
			var menu_up:Tween = new Tween(menu, 1, Transitions.EASE_OUT);
			menu_up.onComplete = sub.unflatten;
			menu_up.onUpdate = function():void {sub.y = menu.y + menu.height};
			menu_up.animate('y', -Constants.STAGE_HEIGHT);
			
			Starling.juggler.add(menu_up);
		}
		
		private function backToMenu():void
		{
			sub.flatten();
			
			var menu_down:Tween = new Tween(menu, 1.5, Transitions.EASE_OUT);
			menu_down.onComplete = menu.unflatten;
			menu_down.onUpdate = function():void {sub.y = menu.y + menu.height};
			menu_down.animate('y', 0);
			
			Starling.juggler.add(menu_down);
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			removeChild(menu);
			menu.destroy();
			menu = null;
			
			if(scores != null)
			{
				removeChild(scores);
				scores.destroy();
				scores = null;
			}
			
			if(settings != null)
			{
				removeChild(settings);
				settings.destroy();
				settings = null;
			}
			
			if(gameCenterIcon != null)
			{
				removeChild(gameCenterIcon);
				gameCenterIcon.destroy();
				gameCenterIcon = null;
			}
			
			removeChildren(0, -1, true);
		}
	}
}