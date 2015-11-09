package   com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	import com.lixuefeng.framework.*;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign; 
	import flash.text.Font;
	
	public class Transmit extends BasicScreen
	{
		private var tileSheetData:TileSheetData;
		private var currFloor:int;
		private var floorLock:Array;
		private var unLockFloor:Array = [];
		
		private var lastX1:int = 85;
		private var lastX2:int = 215;
		
		
		public function Transmit(currFloor:int,floorLock:Array,tileSheetData:TileSheetData) 
		{
			this.tileSheetData = tileSheetData;
			this.currFloor = currFloor;
			this.floorLock = floorLock;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Global.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			init();
		}
		
		private function init():void {
			setBackgroundBitmap(tileSheetData.imageLibrary["transmitPng"]);
			var textFormat:TextFormat = new TextFormat("Gill Sans MT", 20, 0xff000000, true, null, null, null, null, TextFormatAlign.CENTER);
			addImageBitmap(0, lastX1, 130, tileSheetData.imageLibrary["transmitPointPng"]);
			addImageBitmap(1, lastX2, 130, tileSheetData.imageLibrary["transmitPointPng"]);
			imageBitmaps[1].rotation = 180;
			imageBitmaps[1].y += imageBitmaps[1].height;
			createDisplayText(0, String(currFloor) , 100, 100, 130, textFormat);
			
			for (var i:int = 0; i < floorLock.length; i++ ) {
				if (floorLock[i] == true) {
					unLockFloor.push(i);
				}
			}
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			//M
			if (e.keyCode == 70 || e.keyCode == 81) {
				//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_MENU_CLOSE, false, 1, 0,0.2));
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER,"transmitQuit"));
			}
			//左
			else if (e.keyCode == 37) {
				var i:int = unLockFloor.indexOf(currFloor);
				i--;
				if (i < 0) {
					i = unLockFloor.length - 1;
				}
				currFloor = unLockFloor[i];
				imageBitmaps[0].x = lastX1 - 2;
				changeDisplayText(0, String(currFloor));
			}
			//右
			else if (e.keyCode == 39) {
				var j:int = unLockFloor.indexOf(currFloor);
				j++;
				if (j >= unLockFloor.length) {
					j = 0;
				}
				currFloor = unLockFloor[j];
				imageBitmaps[1].x = lastX2 + 2;
				changeDisplayText(0, String(currFloor));
			}
			//Enter
			else if (e.keyCode == 13 || e.keyCode == 32) {
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER,"transmitOver",currFloor, true));
			}
			else {
				
			}
		}
		
		private function keyUpListener(e:KeyboardEvent):void {
			imageBitmaps[0].x = lastX1;
			imageBitmaps[1].x = lastX2;
		}
		
	}

}