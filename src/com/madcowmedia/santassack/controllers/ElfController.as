package com.madcowmedia.santassack.controllers
{
	import com.madcowmedia.santassack.utils.Constants;
	import com.madcowmedia.santassack.view.Elf;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;

	public class ElfController
	{
		private static const INIT_SPEED:int = 1;
		
		private var elf:Elf;
		private var tween:Tween;
		private var destination_speed:Number = 1;
		
		public var speed:Number = INIT_SPEED;

		private var destination:int;
		
		public function ElfController(elf:Elf)
		{
			this.elf = elf;
		}
		
		protected function nextDestination():void
		{
			destination = Math.floor(Math.random() * (Constants.STAGE_WIDTH - 30)) + 15;
			
			destination_speed = (3 / speed) * Math.abs((destination - elf.x) / (Constants.STAGE_WIDTH - 30));
			
			elf.scaleX = (destination < elf.x) ? -1 : 1;
			
			tween = new Tween(elf, destination_speed, Transitions.EASE_IN_OUT);
			tween.onComplete = nextDestination;
			tween.animate('x', destination);
			Starling.juggler.add(tween);	
		}
		
		public function reset():void
		{
			speed = INIT_SPEED;
		}
		
		public function start():void
		{
			nextDestination();
		}
		
		public function resume():void
		{
			Starling.juggler.add(tween);
		}
		
		public function stop():void
		{
			if(!tween.isComplete)
				Starling.juggler.remove(tween);
		}
		
		public function update():void
		{
			
		}
	}
}