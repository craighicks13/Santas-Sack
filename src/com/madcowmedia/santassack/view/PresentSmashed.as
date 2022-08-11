package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	
	import flash.media.Sound;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PresentSmashed extends Sprite
	{
		private var present:MovieClip;
		private var tween:Tween;
		private var sound:Sound;
		public function PresentSmashed()
		{
			this.touchable = false;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			present = new MovieClip(Assets.getGameTextures('presents/smashed'), 1);
			present.touchable = false;
			present.loop = false;
			present.alpha = 0;
			addChild(present);
			
			Starling.juggler.add(present);
			present.stop();
			
			this.pivotX = present.width *.5;
			this.pivotY = present.height *.5;
			
			sound = Assets.getSound('Smash');
		}
		
		public function show(value:int, type:int):void
		{
			if(tween && !tween.isComplete)
			{
				tween.advanceTime(2);
			}
			
			this.x = value;			
			present.alpha = 1;
			present.currentFrame = type;
			
			if(!Assets.muted) sound.play();
			
			tween = new Tween(present, 1, Transitions.EASE_IN_OUT);
			tween.fadeTo(0);
			tween.delay = .5;
			Starling.juggler.add(tween);	
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			removeChild(present);
			present.dispose();
			present = null;
		}
	}
}