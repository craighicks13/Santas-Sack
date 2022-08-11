package com.madcowmedia.santassack.controllers
{
	import com.madcowmedia.santassack.state.Play;
	import com.madcowmedia.santassack.utils.Constants;
	import com.madcowmedia.santassack.utils.ObjectPool;
	import com.madcowmedia.santassack.view.Present;
	import com.madcowmedia.santassack.view.PresentSmashed;

	public class PresentController
	{
		public static const INIT_RATE:int = 40;
		public static const INIT_SPEED:int = 2;
		
		private var play:Play;
		private var pool:ObjectPool;
		public var presents:Array;
		public var count:int = 0;
		public var smashed:PresentSmashed;
		
		private var rate:int = INIT_RATE;
		private var speed:Number = INIT_SPEED;
		
		public var level:int = 1;
		
		public function PresentController(play:Play)
		{
			this.play = play;
			presents = new Array();
			pool = new ObjectPool(Present, 30);
			smashed = new PresentSmashed();
			smashed.y = Constants.GROUND;
			play.addChild(smashed);
		}
		
		public function reset():void
		{
			var p:Present;
			var len:int = presents.length;
			for(var i:int = 0; i < len; i++)
			{
				p = presents[i];
				p.removeFromParent(true);
				pool.returnSprite(p);
			}
			presents = new Array();
			rate = INIT_RATE;
			speed = INIT_SPEED;
			level = 1;
		}
		
		public function update():void
		{
			var p:Present;
			var len:int = presents.length;
			for(var i:int = len - 1; i >= 0; i--)
			{
				p = presents[i];
				p.y += p.speed;
				if(p.y >= Constants.GROUND)
				{
					destroyPresent(p);
					smashed.show(p.x, p.presentType);
					play.dropController.addDrop();
				}
			}
			
			if(count % rate == 0)
				fire();
			
			count++;
		}
		
		private function fire():void
		{
			var p:Present = pool.getSprite() as Present;
			play.addChild(p);
			p.x = play.elf.x;
			p.y = play.elf.y + 18;
			p.presentType = (level - 1);
			p.speed = speed; // * Math.random();
			presents.push(p);
		}
		
		public function destroyPresent(p:Present):void
		{
			var len:int = presents.length;
			for(var i:int = 0; i < len; i++)
			{
				if(presents[i] == p)
				{
					presents.splice(i, 1);
					p.removeFromParent(true);
					pool.returnSprite(p);
				}
			}
		}
		
		public function increaseLevel():void
		{
			speed += speed * .1;
			rate = rate > 10 ? rate - 2 : rate;
			level++;
		}
	}
}