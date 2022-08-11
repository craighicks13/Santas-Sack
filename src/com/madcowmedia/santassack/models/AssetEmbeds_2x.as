package com.madcowmedia.santassack.models
{
	public class AssetEmbeds_2x
	{
		// Menu Texture Atlas
		
		[Embed(source="../../../../../assets/menu-assets@2x.xml", mimeType="application/octet-stream")]
		public static const MenuAtlasXml:Class;
		
		[Embed(source="../../../../../assets/menu-assets@2x.png")]
		public static const MenuAtlasTexture:Class;
		
		// Texture Atlas
		
		[Embed(source="../../../../../assets/game-assets@2x.xml", mimeType="application/octet-stream")]
		public static const GameAtlasXml:Class;
		
		[Embed(source="../../../../../assets/game-assets@2x.png")]
		public static const GameAtlasTexture:Class;
	}
}