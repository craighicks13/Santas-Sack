package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	import com.madcowmedia.santassack.state.Play;
	
	import flash.geom.Point;
	import flash.media.Sound;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	
	public class Santa extends MovieClip
	{
		private var cursorPosStage:Point;
		private var isDragging:Boolean;
		private var stars:PDParticleSystem;
		private var play:Play;
		private var sound:Sound;
		public var bag:Bag;
		
		public function Santa(play:Play)
		{
			this.play = play;
			
			super(Assets.getGameTextures('bag animation'), 24);
			super.loop = false;
						
			pivotX = width * .5;
			pivotY = height;
			
			sound = Assets.getSound('Coin');
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Starling.juggler.add(this);
			stop();
			super.addEventListener(Event.COMPLETE, onAnimationComplete);
			
			stars = new PDParticleSystem(XML(new Assets.particleXML()), Assets.getGameTexture('texture'));
			stars.emitterY = this.y - 100;
			Starling.juggler.add(stars);
			play.addChild(stars);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		protected function onAnimationComplete(event:Event):void
		{
			stop();			
		}
		
		protected function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this);
			
			for each (var touch:Touch in touches)
			{
				cursorPosStage = touch.getLocation(stage);
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						isDragging = true;
						//niceCatch();
						break;
					case TouchPhase.MOVED:
						this.scaleX = (cursorPosStage.x < x) ? -1 : 1;
						x = cursorPosStage.x;
						break;
					case TouchPhase.ENDED:
						isDragging = false;
						break;
				}
			}
		}
		
		public function niceCatch():void
		{
			stars.start(.35);
			super.currentFrame = 0;
			super.play();
			if(!Assets.muted) sound.play();
		}
		
		public function set pauseState(value:Boolean):void
		{
			this.touchable = !value;
		}
		
		public function update():void
		{
			stars.emitterX = this.x + 15 * this.scaleX;
			bag.x = stars.emitterX - 4;
		}
		
		public function destroy():void
		{
			super.removeEventListener(Event.COMPLETE, onAnimationComplete);
			
			removeEventListener(TouchEvent.TOUCH, onTouch);
			play.removeChild(stars);
			stars.dispose();
			stars = null;
		}
	}
}