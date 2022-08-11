package com.madcowmedia.santassack.controllers
{
	import com.madcowmedia.santassack.state.Play;
	import com.madcowmedia.santassack.view.Present;
	
	import flash.geom.Point;

	public class CollisionController
	{
		private var play:Play;
		private var pp:Point = new Point();
		private var sp:Point = new Point();
		private var bagY:Number;
		
		public function CollisionController(play:Play)
		{
			this.play = play;
			bagY = play.bag.y - 10;
		}
		
		public function update():void
		{
			var pa:Array = play.presentController.presents;
			
			var p:Present;
			var len:int = pa.length;
			for(var i:int = len - 1; i >= 0; i--)
			{
				p = pa[i];
				pp.x = p.x;
				pp.y = p.y;
				
				sp.x = play.bag.x;
				sp.y = play.bag.y;
				
				if(Point.distance(pp, sp) < p.pivotX + play.bag.pivotY && p.y < bagY)
				{
					play.presentController.destroyPresent(p);
					play.santa.niceCatch();
					play.increaseScore();
				}
			}
		}
	}
}