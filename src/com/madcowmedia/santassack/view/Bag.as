package com.madcowmedia.santassack.view
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Bag extends starling.display.Sprite
	{
		public static const RADIUS:int = 33;
		public function Bag()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.touchable = false;
			
			this.pivotX = RADIUS;
			this.pivotY = RADIUS;
			
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
	}
}