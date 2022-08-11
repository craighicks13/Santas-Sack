package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	import com.madcowmedia.santassack.state.Main;
	import com.madcowmedia.santassack.utils.Constants;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.Color;
	
	public class Menu extends Sprite
	{
		public static const SUB_SCORES:String = 'scores';
		public static const SUB_SETTINGS:String = 'settings';
		
		private var background:Image;
		private var mPlay:Image;
		private var mScores:Image;
		private var mSettings:Image;
		private var presents:Image;
		private var main:Main;
		
		public var onPlayTriggered:Function;
		public var onSubsectionTriggered:Function;
		public var onCheckGameCenter:Function;
		public var onMenuOut:Function;
		
		public function Menu(value:Main)
		{
			this.main = value;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function destroy():void
		{
			mPlay.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			mScores.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			mSettings.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			
			removeChildren(0, -1, true);
		}
		
		private function animateIn():void
		{
			
			mPlay = new Image(Assets.getMenuTexture("main_menu_play"));
			mPlay.touchable = false;
			mPlay.y = -50;
			addChild(mPlay);
			
			mScores = new Image(Assets.getMenuTexture("main_menu_scores"));
			mScores.touchable = false;
			mScores.y = -50;
			addChild(mScores);
			
			mSettings = new Image(Assets.getMenuTexture("main_menu_settings"));
			mSettings.touchable = false;
			mSettings.y = -50;
			addChild(mSettings);
			
			presents = new Image(Assets.getMenuTexture('main_menu_presents'));
			presents.touchable = false;
			presents.y = Constants.STAGE_HEIGHT + 100;
			addChild(presents);
			
			var play_tween:Tween = new Tween(mPlay, .75, Transitions.EASE_OUT_BOUNCE);
			play_tween.onComplete = onMenuReady;
			play_tween.delay = 1;
			play_tween.animate('y', 175);
			
			var scores_tween:Tween = new Tween(mScores, .75, Transitions.EASE_OUT_BOUNCE);
			scores_tween.delay = .5;
			scores_tween.animate('y', 225);
			
			var settings_tween:Tween = new Tween(mSettings, .5, Transitions.EASE_OUT);
			settings_tween.delay = 0;
			settings_tween.animate('y', 275);
			
			var presents_tween:Tween = new Tween(presents, 1.5, Transitions.EASE_OUT);
			presents_tween.animate('y', Constants.STAGE_HEIGHT - presents.height);
			
			Starling.juggler.add(presents_tween);
			Starling.juggler.add(play_tween);
			Starling.juggler.add(scores_tween);
			Starling.juggler.add(settings_tween);
		}
		
		private function animateOut():void
		{
			main.removeGameCenterIcon();
			
			var l:TextField = new TextField(100, 30, "Loading", 'GameFont', 24, Color.WHITE);
			l.autoScale = true;
			l.x = Constants.STAGE_WIDTH * .5 - 50;
			l.y = Constants.STAGE_HEIGHT * .5 - 15;
			l.touchable = false;
			l.alpha = 0;
			addChild(l);
			
			var l_tween:Tween = new Tween(l, .25, Transitions.EASE_OUT);
			l_tween.onComplete = onPlayTriggered;
			l_tween.delay = .75;
			l_tween.fadeTo(1);
			
			var play_tween:Tween = new Tween(mPlay, .25, Transitions.EASE_OUT);
			play_tween.delay = .5;
			play_tween.animate('y', Constants.STAGE_HEIGHT);
			
			var scores_tween:Tween = new Tween(mScores, .25, Transitions.EASE_OUT);
			scores_tween.delay = .25;
			scores_tween.animate('y', Constants.STAGE_HEIGHT);
			
			var settings_tween:Tween = new Tween(mSettings, .25, Transitions.EASE_OUT);
			settings_tween.delay = 0;
			settings_tween.animate('y', Constants.STAGE_HEIGHT);
			
			Starling.juggler.add(play_tween);
			Starling.juggler.add(scores_tween);
			Starling.juggler.add(settings_tween);
			Starling.juggler.add(l_tween);
		}
		
		private function onMenuReady():void
		{
			mPlay.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			mSettings.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			mScores.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			
			mPlay.touchable = true;
			mSettings.touchable = true;
			mScores.touchable = true;
			
			onCheckGameCenter();
		}
		
		private function onMenuItemTouched(event:TouchEvent):void
		{
			if (event.getTouch(mPlay, TouchPhase.BEGAN))
			{
				if(onPlayTriggered != null) animateOut();
				//Assets.getSound("Click").play();
			}
			else if (event.getTouch(mSettings, TouchPhase.BEGAN))
			{
				if(onSubsectionTriggered != null) onSubsectionTriggered(Menu.SUB_SETTINGS);
			}
			else if (event.getTouch(mScores, TouchPhase.BEGAN))
			{
				if(onSubsectionTriggered != null) onSubsectionTriggered(Menu.SUB_SCORES);
			}
		}
		
		private function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			background = new Image(Assets.getMenuTexture("main_menu_background"));
			background.touchable = false;
			addChild(background);
			
			animateIn();
		}
	}
}