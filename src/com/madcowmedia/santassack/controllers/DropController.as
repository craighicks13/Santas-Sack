package com.madcowmedia.santassack.controllers
{
	import com.madcowmedia.santassack.models.Assets;
	import com.madcowmedia.santassack.state.Play;
	import com.madcowmedia.santassack.utils.Constants;
	
	import starling.core.Starling;
	import starling.display.MovieClip;

	public class DropController
	{
		private var play:Play;
		private var _drops:int = 0;
		private var board:MovieClip;
		
		public function DropController(play:Play)
		{
			this.play = play;
			
			board = new MovieClip(Assets.getGameTextures('dropped'), 1);
			board.touchable = false;
			board.loop = false;
			board.pivotX = board.width *.5;
			board.x = Constants.STAGE_WIDTH * .5;
			board.y = 10;
			
			Starling.juggler.add(board);
			board.stop();
			
			play.addChild(board);
		}
		
		public function addDrop():void
		{
			_drops++;
			board.currentFrame = _drops;
			if(board.currentFrame == board.numFrames - 1)
			{
				play.gameOver();
			}
		}
		
		public function getDrops():int
		{
			return _drops;
		}
		
		public function reset():void
		{
			_drops = 0;
			board.currentFrame = 0;
		}
		
		public function destroy():void
		{
			play.removeChild(board);
			board.dispose();
			board = null;
			
			_drops = 0;
		}
	}
}