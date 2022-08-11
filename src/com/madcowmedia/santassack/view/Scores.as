package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	import com.madcowmedia.santassack.utils.Constants;
	
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class Scores extends Sprite
	{
		private var background:Image;
		private var back:Image;
		private var latest:Image;
		private var best:Image;
		
		private var table:Dictionary = new Dictionary();
		
		public var onBackTriggered:Function;
		
		public function Scores()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function destroy():void
		{
			back.removeEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			latest.removeEventListener(TouchEvent.TOUCH, onToggleScore);
			best.removeEventListener(TouchEvent.TOUCH, onToggleScore);
			
			removeChildren(0, -1, true);
		}
		
		private function onMenuItemTouched(event:TouchEvent):void
		{
			if (event.getTouch(back, TouchPhase.BEGAN))
			{
				if(onBackTriggered != null) onBackTriggered();
			}
		}
		
		private function onToggleScore(event:TouchEvent):void
		{
			var i:int;
			if (event.getTouch(best, TouchPhase.BEGAN))
			{
				best.removeEventListener(TouchEvent.TOUCH, onToggleScore);
				latest.addEventListener(TouchEvent.TOUCH, onToggleScore);
				
				best.texture = Assets.getMenuTexture("best-button-active");
				latest.texture = Assets.getMenuTexture("latest-button-inactive");
				
				for(i = 0; i < 5; i++)
				{
					table[i]['score'].text = Assets.gameData.data.high[i].score;
					table[i]['date'].text = Assets.gameData.data.high[i].date;
				}
				
			}
			else if (event.getTouch(latest, TouchPhase.BEGAN))
			{
				latest.removeEventListener(TouchEvent.TOUCH, onToggleScore);
				best.addEventListener(TouchEvent.TOUCH, onToggleScore);
				
				best.texture = Assets.getMenuTexture("best-button-inactive");
				latest.texture = Assets.getMenuTexture("latest-button-active");
				
				for(i = 0; i < 5; i++)
				{
					table[i]['score'].text = Assets.gameData.data.last[i].score;
					table[i]['date'].text = Assets.gameData.data.last[i].date;
				}
			}
		}
		
		private function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			background = new Image(Assets.getMenuTexture('scores_background'));
			background.touchable = false;
			addChild(background);
			
			back = new Image(Assets.getMenuTexture("back-to-menu-button"));
			back.addEventListener(TouchEvent.TOUCH, onMenuItemTouched);
			addChild(back);
			
			latest = new Image(Assets.getMenuTexture("latest-button-active"));
			latest.x = Constants.STAGE_WIDTH * .5 - latest.width;
			latest.y = 134;
			addChild(latest);
			
			best = new Image(Assets.getMenuTexture("best-button-inactive"));
			best.addEventListener(TouchEvent.TOUCH, onToggleScore);
			best.x = latest.x + latest.width;
			best.y = latest.y;
			addChild(best);
			
			var s:TextField, d:TextField;
			var colour:uint = 0xfff600;
			for(var i:int = 0; i < 5; i++)
			{
				s = new TextField(81, 37, Assets.gameData.data.last[i].score, 'Arial', 27, colour, true);
				s.autoScale = true;
				s.x = 84;
				s.y = 234 + (40 * i);
				addChild(s);
				
				d = new TextField(141, 37, Assets.gameData.data.last[i].date, 'Arial', 27, colour, true);
				d.autoScale = true;
				d.x = 170;
				d.y = 234 + (40 * i);
				addChild(d);
				
				table[i] = {'score': s, 'date': d};
				
				colour = 0xFFFFFF;
			}
		}
	}
}

