package com.madcowmedia.santassack.view
{
	import com.madcowmedia.santassack.models.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class ScoreBoard extends Sprite
	{
		private var icon:Image;
		private var score_board:TextField;
		private var high_score:TextField;
		
		public var score:int = 0;
		
		public function ScoreBoard()
		{
			this.touchable = false;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			high_score = new TextField(40, 15, "BEST " + Assets.gameData.data.high[0].score.toString(), 'Helvetica', 12, 0xFFFFFF, true);
			high_score.touchable = false;
			high_score.autoScale = true;
			high_score.hAlign = 'right';
			addChild(high_score);
			
			score_board = new TextField(40, 25, "X " + score.toString(), 'Helvetica', 20, 0xFFFFFF, true);
			score_board.touchable = false;
			score_board.autoScale = true;
			score_board.hAlign = 'right';
			score_board.y = 15;
			addChild(score_board);
			
			icon = new Image(Assets.getGameTexture('score-present'));
			icon.touchable = false;
			icon.pivotX = 33;
			icon.y = 15;
			addChild(icon);
		}
		
		public function reset():void
		{
			score = 0;
			score_board.text = "X " + score.toString();
		}
		
		public function updateBest():void
		{
			high_score.text = "BEST " + Assets.gameData.data.high[0].score.toString();
		}
		
		public function increaseScore():void
		{
			score++;
			score_board.text = "X " + score.toString();
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			removeChild(icon);
			icon.dispose();
			icon = null;
			
			removeChild(score_board);
			score_board.dispose();
			score_board = null;
		}
	}
}