package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Elf extends Sprite
	{
		private var elf:Image;
		public function Elf()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			elf = new Image(Assets.getGameTexture('elf'));
			elf.touchable = false;
			addChild(elf);
			
			this.pivotX = elf.width *.5;
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			removeChild(elf);
			elf.dispose();
			elf = null;
		}
	}
}