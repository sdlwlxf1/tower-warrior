package   com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	
	import com.lixuefeng.framework.BasicScreen;
	import com.lixuefeng.framework.ChatEvent;
	import flash.display.BitmapData;
	import com.lixuefeng.framework.NewsEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign; 
	import flash.text.Font;
	import gs.*; 
	import gs.easing.*;
	
	public class News  extends BasicScreen
	{
		private var newsType:String;
		private var visitItemId:int;
		private var tileSheetData:TileSheetData;
		private var newsContent:String;
		private var lastTime:Number;
		private var gameRemoveKey:Boolean;
		
		public function News(tileSheetData:TileSheetData, newsType:String, newsContent:String = null, visitItemId:int = 0, lastTime:Number = 0.8,gameRemoveKey:Boolean = true) 
		{
			trace("信息");
			this.newsType = newsType;
			this.visitItemId = visitItemId;
			this.tileSheetData = tileSheetData;
			this.newsContent = newsContent;
			this.lastTime = lastTime;
			this.gameRemoveKey = gameRemoveKey;
			if (newsType == "auto") {
				normalNews();
			} else if(newsType == "manual") {		
				readNews();				
			}
			if (gameRemoveKey) {
				Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			}
			
		}
		
		private function normalNews():void {
			addImageBitmap(0, 255, 300, tileSheetData.imageLibrary["normalNewsPng"]);
			var textFormat:TextFormat = new TextFormat("Gill Sans MT", 20,0xff000000, true,null, null,null,null,TextFormatAlign.LEFT);
			createDisplayText(0, newsContent, 200, 0, 0, textFormat);
			displayTexts[0].x = (imageBitmaps[0].width - displayTexts[0].textWidth) * 0.5 + imageBitmaps[0].x;
			displayTexts[0].y = (imageBitmaps[0].height - displayTexts[0].textHeight) * 0.5 + imageBitmaps[0].y - 5;
			TweenLite.delayedCall(lastTime, onComplete);

		}
		
		private function onComplete():void {
			dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS_OVER,newsType,newsContent,visitItemId,lastTime,gameRemoveKey));
		}
		
		
		private function readNews():void {
			switch(visitItemId) {
				case TileSheetData.ITEM_NEWS_TREASUREMAP1:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap1"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP2:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap2"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP3:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap3"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP4:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap4"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP5:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap5"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP6:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap6"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP7:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap7"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP8:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap8"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP9:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap9"]);
					break;
				case TileSheetData.ITEM_NEWS_TREASUREMAP10:
					addImageBitmap(0, 230, 100, tileSheetData.imageLibrary["treasureMapBG"]);
					addImageBitmap(1, 230, 100, tileSheetData.imageLibrary["treasureMap10"]);
					break;
				case TileSheetData.ITEM_NEWS_BOOKS1:
					addImageBitmap(0, 100, 20, tileSheetData.imageLibrary["book1Png"]);
					break;
					
			}
		}
		
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			if (e.keyCode == 32) {
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS_OVER,newsType,newsContent,visitItemId,lastTime,gameRemoveKey));
			}
		}
		
	}

}