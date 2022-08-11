package com.madcowmedia.santassack.utils
{
	import starling.display.DisplayObject;

	public class ObjectPool
	{
		private var counter:int;
		private var pool:Array;
		
		public function ObjectPool(type:Class, len:int)
		{
			this.counter = len;
			this.pool = new Array();
			
			var i:int = len;
			while (--i > -1)
			{
				pool[i] = new type();
			}
		}
		
		public function getSprite():DisplayObject
		{
			if(counter > 0)
				return pool[--counter];
			else
				throw new Error ('pool is empty');
		}
		
		public function returnSprite(value:DisplayObject):void
		{
			pool[counter++] = value;
		}
		
		public function destroy():void
		{
			pool = null;
		}
	}
}