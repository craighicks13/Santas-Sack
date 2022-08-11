package com.madcowmedia.santassack.models
{
	public class AssetEmbeds_1x
	{				
		// Menu Texture Atlas
		
		[Embed(source="../../../../../assets/menu-assets.xml", mimeType="application/octet-stream")]
		public static const MenuAtlasXml:Class;
		
		[Embed(source="../../../../../assets/menu-assets.png")]
		public static const MenuAtlasTexture:Class;

		// Texture Atlas
		
		[Embed(source="../../../../../assets/game-assets.xml", mimeType="application/octet-stream")]
		public static const GameAtlasXml:Class;
		
		[Embed(source="../../../../../assets/game-assets.png")]
		public static const GameAtlasTexture:Class;

	}
}