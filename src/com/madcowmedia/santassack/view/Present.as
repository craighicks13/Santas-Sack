package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Present extends starling.display.Sprite
	{
		private var present:MovieClip;
		private var _speed:Number = 1;
		
		public function Present()
		{
			this.touchable = false;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			present = new MovieClip(Assets.getGameTextures('presents/present'), 1);
			present.touchable = false;
			present.loop = false;
			present.x = -8;
			present.y = -3;
			addChild(present);
			
			Starling.juggler.add(present);
			present.stop();
			
			this.pivotX = this.pivotY = 17;
			
			//drawHitArea();
		}
		/*
		public final function drawHitArea():void
		{
			var shape:flash.display.Sprite = new flash.display.Sprite();
			var color:uint = Math.random() * 0xFFFFFF;
			var radius:uint = this.pivotY;
			
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(radius, radius, radius);
			shape.graphics.endFill();
			var bmd:BitmapData = new BitmapData(radius * 2, radius * 2, true, 0x00000000);
			bmd.draw(shape);
			var tex:Texture = Texture.fromBitmapData(bmd);
			
			var img:Image = new Image(tex);
			addChild(img);
		}
		*/
		public function set presentType(value:int):void
		{
			present.currentFrame = Math.floor(Math.random() * (value > present.numFrames ? present.numFrames : value));
		}
		
		public function get presentType():int
		{
			return present.currentFrame;
		}
		
		public function set speed(value:Number):void
		{
			// REMOVED THE VARIABLE SPEED FOR THE DIFFERENT PRESENT COLOURS
			_speed = value; // + (present.currentFrame + present.currentFrame * .5);
		}
		
		public function get speed():Number
		{
			return _speed;
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