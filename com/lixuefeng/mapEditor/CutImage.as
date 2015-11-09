package com.lixuefeng.mapEditor
{
	/**
	 * ...
	 * @author li xuefeng
	 */


	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CutImage {
		
		public var colCount:uint;
		public var rowCount:uint;
		public var bitmapDataArray:Array;
		private	var col:uint;
		private	var row:uint;
		private var singleBD:BitmapData;
		public function CutImage( sourceBitmapData :BitmapData, tileHeight:uint, tileWidth:uint )
		{
			colCount = sourceBitmapData.width / tileWidth;
			rowCount = sourceBitmapData.height / tileHeight;
			
			bitmapDataArray = new Array;

			for (row = 0; row < rowCount; row++) 
			{
				for (col = 0; col < colCount; col++) 
				{
					singleBD = new BitmapData( tileWidth, tileHeight );
					singleBD.copyPixels( sourceBitmapData, 
					new Rectangle( col * tileWidth, row * tileHeight, tileWidth, tileHeight ), new Point( 0, 0 ) );
					bitmapDataArray.push(singleBD);
				}
			}
			
		}

	}
}