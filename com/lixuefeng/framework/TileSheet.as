package com.lixuefeng.framework
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	public class TileSheet  
	{
		public var sourceBitmapData:BitmapData;
		public var width:int;
		public var height:int;
		public var tileWidth:int;
		public var tileHeight:int;
		public var tilesPerRow:int;
		public var tilesPerRowDown:Number;
		
		public function TileSheet(sourceBitmapData:BitmapData,tileWidth:int, tileHeight:int ) 
		{
			
			this.sourceBitmapData = sourceBitmapData;
			width = sourceBitmapData.width;
			height =  sourceBitmapData.height;
			this.tileHeight = tileHeight;
			this.tileWidth = tileWidth;
			tilesPerRow = int(width / this.tileWidth);
			tilesPerRowDown = this.tileWidth / width;
		}
		
	
		
	}
}