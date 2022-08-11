package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Settings extends Sprite
	{
		private var background:Image;
		private var back:Image;
		
		public var onBackTriggered:Function;
		private var mute:Image;
		private var check:Image;
		
		private var in_game:Boolean = false;
		
		public function Settings(is_in_game:Boolean = false)
		{
			this.in_game = is_in_game;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function destroy():void
		{
			back.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			mute.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			removeChildren(0, -1, true);
		}
		
		private function onMenuItemTouched(event:TouchEvent):void
		{
			if (event.getTouch(back, TouchPhase.BEGAN))
			{
				if(onBackTriggered != null) onBackTriggered();
			}
			else if (event.getTouch(mute, TouchPhase.BEGAN))
			{
				if(onBackTriggered != null) onToggleMute();
			}
		}
		
		private function onToggleMute():void
		{
			Assets.muted = !Assets.muted;
			check.visible = Assets.muted;
		}
		
		private function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			background = new Image(Assets.getMenuTexture('settings_background'));
			background.touchable = false;
			addChild(background);
			
			back = new Image(Assets.getMenuTexture(in_game ? "back-to-game-button" : "back-to-menu-button"));
			back.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			addChild(back);
			
			mute = new Image(Assets.getMenuTexture('settings-mute-button'));
			mute.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			mute.x = 225;
			mute.y = 172;
			addChild(mute);
			
			check = new Image(Assets.getMenuTexture('settings-check-mark'));
			check.touchable = false;
			check.x = 220;
			check.y = 163;
			addChild(check);
			
			check.visible = Assets.muted;
		}
	}
}