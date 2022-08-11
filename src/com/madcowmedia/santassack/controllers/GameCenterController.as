package com.madcowmedia.santassack.controllers
{
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import com.milkmangames.nativeextensions.ios.events.GameCenterErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	
	import starling.core.Starling;

	public class GameCenterController
	{
		
		/** Leaderboard ID
		 * 
		 * This needs to exactly match a leaderboard you created in iTunes Connect!
		 * */
		private static const LEADERBOARD_ID:String = "SantasSackCatchTotal";
		
		/** Achievement ID 
		 * 
		 * Must exactly match an achievement you created in iTunes Connect!
		 * 
		 * */
		//private static const ACHIEVEMENT_ID:String = "airachievement01";
		
		protected var gameCenter:GameCenter;
		
		public function GameCenterController()
		{
			
		}
		/***************************************************************
		 *	GAME CENTER CODE
		 ***************************************************************/
		/** Authenticate Local User */
		protected final function authenticateUser():void
		{
			gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED, onAuthSucceeded);
			gameCenter.addEventListener(GameCenterErrorEvent.AUTH_FAILED, onAuthFailed);
			GameCenter.gameCenter.authenticateLocalUser();
		}
		
		/** Report score */
		public final function reportScore(value:int):void
		{
			// we make sure you're logged in before bothering to report the score.
			// later iOS versions may take care of waiting/resubmitting for you, but earlier ones won't.
			if (!checkAuthentication()) return;
			GameCenter.gameCenter.reportScoreForCategory(value, LEADERBOARD_ID);
		}
		
		/** Report Achievement */
		/*
		protected final function reportAchievement():void
		{
		if (!checkAuthentication()) return;
		
		// the '1.0' is a float (Number) value from 0.0-100.0 the percent completion of the achievement.
		GameCenter.gameCenter.reportAchievement(ACHIEVEMENT_ID, 100.0);
		}
		*/
		/** Show Leaderboards */
		public final function showLeaderboard():void
		{
			if (!checkAuthentication())
			{
				authenticateUser();
				return;
			}
			GameCenter.gameCenter.showLeaderboardForCategory(LEADERBOARD_ID);
		}
		
		/** Show Achievements */
		public final function showAchievements():void
		{
			if (!checkAuthentication()) return;
			
			try
			{
				GameCenter.gameCenter.showAchievements();
			}
			catch (e:Error)
			{
				trace("ERR showachievements:"+e.message+"/"+e.name+"/"+e.errorID);
			}
			
		}
		
		/** Reset Achievements */
		protected final function resetAchievements():void
		{
			if (!checkAuthentication()) return;
			GameCenter.gameCenter.resetAchievements();
		}
		
		//
		// Events
		//
		
		protected final function onAuthSucceeded(event:GameCenterEvent):void
		{
			gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, onAuthSucceeded);
			gameCenter.removeEventListener(GameCenterErrorEvent.AUTH_FAILED, onAuthFailed);
		}
		
		protected final function onAuthFailed(event:GameCenterErrorEvent):void
		{
			gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, onAuthSucceeded);
			gameCenter.removeEventListener(GameCenterErrorEvent.AUTH_FAILED, onAuthFailed);
		}
		
		protected final function onScoreReported(event:GameCenterEvent):void
		{
			gameCenter.removeEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED, onScoreReported);
			gameCenter.removeEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED, onScoreFailed);
		}
		
		protected final function onScoreFailed(event:GameCenterErrorEvent):void
		{
			gameCenter.removeEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED, onScoreReported);
			gameCenter.removeEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED, onScoreFailed);
			trace("score report failed:msg=" + event.message + ",cd=" + event.errorID + ",scr=" + event.score + ",cat=" + event.category);
		}
		
		public final function initGameCenter():void
		{			
			try
			{			
				gameCenter = GameCenter.create(Starling.current.nativeStage);
			}
			catch (e:Error)
			{
				trace("ERROR:" + e.message);
				return;
			}
			
			// GameCenter doesn't work on iOS versions < 4.1, so always check this first!
			if (!gameCenter.isGameCenterAvailable()) return;	
			
			authenticateUser();
		}
		
		/** Check Authentication */
		protected final function checkAuthentication():Boolean
		{
			if (!GameCenter.gameCenter.isUserAuthenticated())
			{
				trace("not logged in!");
				return false;
			}
			return true;
		}
		/***************************************************************
		 * END GAME CENTER CODE
		 ***************************************************************/
	}
}