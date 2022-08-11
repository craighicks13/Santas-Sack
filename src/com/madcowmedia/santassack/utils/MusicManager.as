package com.madcowmedia.santassack.utils
{
	import com.madcowmedia.santassack.models.Assets;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import starling.errors.AbstractClassError;

	public class MusicManager
	{
		private static var music:Sound;
		private static var music_channel:SoundChannel;
		private static var musicPausePos:Number;
		
		public function MusicManager() { throw new AbstractClassError(); }
		
		public static function play():void
		{
			if(Assets.muted) return;
			
			music = Assets.getSound('Music');
			music_channel = music.play();
			music_channel.addEventListener(Event.SOUND_COMPLETE, restartMusic);
		}
		
		public static function sleep():void
		{
			if(music_channel) pause();
		}
		
		public static function wake():void
		{
			if(music_channel) resume();
		}
		
		public static function pause():void
		{
			if(Assets.muted) return;
			
			musicPausePos = music_channel.position;
			music_channel.stop();
			music_channel.removeEventListener(Event.SOUND_COMPLETE, restartMusic);
		}
		
		public static function resume():void
		{
			if(Assets.muted) return;
			
			music_channel = music.play(musicPausePos);
			music_channel.addEventListener(Event.SOUND_COMPLETE, restartMusic);
		}
		
		public static function stop():void
		{
			if(music_channel) 
			{
				music_channel.stop();
				music_channel.removeEventListener(Event.SOUND_COMPLETE, restartMusic);
				music_channel = null;
			}
		}
		
		protected static function restartMusic(event:Event):void
		{
			music_channel.removeEventListener(Event.SOUND_COMPLETE, restartMusic);
			play();
		}
	}
}