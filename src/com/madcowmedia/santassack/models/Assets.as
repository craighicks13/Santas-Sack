package com.madcowmedia.santassack.models
{	
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		
		/**
		 * Bitmap Font
		 **/
		
		[Embed(source="../../../../../assets/GameFont.fnt", mimeType="application/octet-stream")]
		public static const GameFontXML:Class;
		
		[Embed(source="../../../../../assets/GameFont.png")]
		public static const GameFont:Class;
				
		/**
		 * Particles
		 **/
		
		[Embed(source="../../../../../assets/particle.pex", mimeType="application/octet-stream")]
		public static var particleXML:Class;
		
		/**
		 * Sounds
		 **/
		
		[Embed(source="../../../../../assets/audio/coin.mp3")]
		private static const Coin:Class;
		
		[Embed(source="../../../../../assets/audio/bottle-smash-5.mp3")]
		private static const Smash:Class;
		
		[Embed(source="../../../../../assets/audio/jingle-bells.mp3")]
		private static const Music:Class;
		
		[Embed(source="../../../../../assets/audio/game-over.mp3")]
		private static const GameOver:Class;
		
		// static members
		
		private static var sContentScaleFactor:int = 1;
		private static var sTextures:Dictionary = new Dictionary();
		private static var sSounds:Dictionary = new Dictionary();
		private static var sGameAtlas:TextureAtlas;
		private static var sMenuAtlas:TextureAtlas;
		private static var sBitmapFontsLoaded:Boolean = false;
		private static var sMuted:Boolean = false;
		
		public static var gameData:SharedObject;
		public static var volume:SoundTransform = new SoundTransform(1);
		
		public static function getTexture(name:String):Texture
		{
			if (sTextures[name] == undefined)
			{
				var data:Object = create(name);
				
				if (data is Bitmap)
					sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, sContentScaleFactor);
				else if (data is ByteArray)
					sTextures[name] = Texture.fromAtfData(data as ByteArray, sContentScaleFactor);
			}
			
			return sTextures[name];
		}
		
		public static function getGameTexture(name:String):Texture
		{
			prepareGameAtlas();
			return sGameAtlas.getTexture(name);
		}
		
		public static function getMenuTexture(name:String):Texture
		{
			prepareMenuAtlas();
			return sMenuAtlas.getTexture(name);
		}
		
		public static function getGameTextures(prefix:String):Vector.<Texture>
		{
			prepareGameAtlas();
			return sGameAtlas.getTextures(prefix);
		}
		
		public static function getSound(name:String):Sound
		{
			var sound:Sound = sSounds[name] as Sound;
			if (sound) return sound;
			else throw new ArgumentError("Sound not found: " + name);
		}
		
		public static function loadBitmapFonts():void
		{
			if (!sBitmapFontsLoaded)
			{
				TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new GameFont()), XML(new GameFontXML())));
				sBitmapFontsLoaded = true;
			}
		}
		
		public static function prepareGameSounds():void
		{
			sSounds["Coin"] = new Coin();   
			Sound(sSounds["Coin"]).play(0, 0, new SoundTransform(0));
			
			sSounds["Smash"] = new Smash();   
			Sound(sSounds["Smash"]).play(0, 0, new SoundTransform(0));
			
			sSounds["Music"] = new Music();   
			Sound(sSounds["Music"]).play(0, 0, new SoundTransform(0));
			
			sSounds["GameOver"] = new GameOver();   
			Sound(sSounds["GameOver"]).play(0, 0, new SoundTransform(0));
		}
		
		private static function prepareMenuAtlas():void
		{
			if (sMenuAtlas == null)
			{
				var texture:Texture = getTexture("MenuAtlasTexture");
				var xml:XML = XML(create("MenuAtlasXml"));
				sMenuAtlas = new TextureAtlas(texture, xml);
			}
		}
		
		private static function prepareGameAtlas():void
		{
			if (sGameAtlas == null)
			{
				var texture:Texture = getTexture("GameAtlasTexture");
				var xml:XML = XML(create("GameAtlasXml"));
				sGameAtlas = new TextureAtlas(texture, xml);
			}
		}
		
		private static function create(name:String):Object
		{
			var textureClass:Class = sContentScaleFactor == 1 ? AssetEmbeds_1x : AssetEmbeds_2x;
			return new textureClass[name];
		}
		
		public static function loadData():void
		{
			
			gameData = SharedObject.getLocal("GAME_DATA"); 
			if(!gameData.data.muted) gameData.data.muted = muted;
			if(!gameData.data.high) gameData.data.high = new Array();
			if(!gameData.data.last) gameData.data.last = new Array();
			
			var oldData:SharedObject = SharedObject.getLocal("highScore");
			if(oldData.data.muted)
			{
				gameData.data.muted = oldData.data.muted;
				gameData.data.high.push({'score':oldData.data.high, 'date':'PRE UPDDATE'});
				gameData.data.last.push({'score':oldData.data.last, 'date':'PRE UPDDATE'});
				if(oldData.data.last != oldData.data.high)
				{
					gameData.data.high.push({'score':oldData.data.last, 'date':'PRE UPDDATE'});
					gameData.data.high.sortOn(['score'], Array.DESCENDING | Array.NUMERIC);
				}
				oldData.clear();
			}
			
			while(gameData.data.high.length < 5)
			{
				gameData.data.high.push({'score': '0', 'date':''});
			}
			
			while(gameData.data.last.length < 5)
			{
				gameData.data.last.push({'score': '0', 'date':''});
			}
			
			gameData.flush();
			
			muted = gameData.data.muted;
		}
		
		public static function updateScores(value:int):void
		{
			var date:Date = new Date();
			var current_date:String = date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear().toString().substring(2, 4);
			
			Assets.gameData.data.last.unshift({'score':value, 'date':current_date});
			Assets.gameData.data.high.push({'score':value, 'date':current_date});
			Assets.gameData.data.high.sortOn(['score'], Array.DESCENDING | Array.NUMERIC);
			Assets.gameData.data.high.splice(5);
			Assets.gameData.data.last.splice(5);
			Assets.gameData.flush();
		}
		
		public static function get muted():Boolean { return sMuted; }
		public static function set muted(value:Boolean):void
		{
			gameData.data.muted = sMuted = value;
			volume.volume = sMuted ? 0 : 1;
			gameData.flush();
		}
		
		public static function get contentScaleFactor():Number { return sContentScaleFactor; }
		public static function set contentScaleFactor(value:Number):void 
		{
			for each (var texture:Texture in sTextures)
			texture.dispose();
			
			sTextures = new Dictionary();
			sContentScaleFactor = value < 1.5 ? 1 : 2; // assets are available for factor 1 and 2 
		}
	}
}