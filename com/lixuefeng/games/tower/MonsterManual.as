package  com.lixuefeng.games.tower

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
	public class MonsterManual extends BasicScreen
	{
		private var currFloorMonster:Array;
		private var tempMonster:Monster;
		private var tileSheetData:TileSheetData;
		
		public static const MONSTER_IMAGE:int = 0;
		public static const MONSTER_HP_TEXT:int = 1;
		public static const MONSTER_STR_TEXT:int = 2;
		public static const MONSTER_DEF_TEXT:int = 3;
		public static const MONSTER_FW_TEXT:int = 4;
		
		public function MonsterManual(currFloorMonster:Array, tileSheetData:TileSheetData)  
		{
			this.currFloorMonster = currFloorMonster;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			this.tileSheetData = tileSheetData;
			init();
		}
		
		private function init():void 
		{
			setBackgroundBitmap(tileSheetData.imageLibrary["monsterManualPng"]);	
			var length:int = currFloorMonster.length;
			var i:int;
			var j:int;
			
			for (j = 0; j < 6; j++ ) {
				for (i = 0; i < length; i++ ) {
					if (currFloorMonster[i] == null) {
						currFloorMonster.splice(i, 1);
					}
				}
			}
			
			
			length = currFloorMonster.length;			
			for (i = 0; i < length - 1; i++ ) {
				for (j = i + 1; j < length; j ++ ){
					if (currFloorMonster[i].data.STR > currFloorMonster[j].data.STR) {
						tempMonster = currFloorMonster[j];
						currFloorMonster[j] = currFloorMonster[i];
						currFloorMonster[i] = tempMonster;
					}
				}
			}
			var textFormat:TextFormat = new TextFormat("Gill Sans MT", 20,0xff000000, true,null, null,null,null,TextFormatAlign.CENTER);
			length = currFloorMonster.length;
			for (i = 0; i < length; i++ ) {
				addImageBitmap(i, 80, i * 33.5 + 120, currFloorMonster[i].view);
				createDisplayText(MONSTER_HP_TEXT * 10 + i, String(currFloorMonster[i].data.HP), 90, 103, i * 33.5 + 123, textFormat);
				createDisplayText(MONSTER_STR_TEXT * 10 + i, String(currFloorMonster[i].data.STR), 90, 160, i * 33.5 + 123, textFormat);
				createDisplayText(MONSTER_DEF_TEXT * 10 + i, String(currFloorMonster[i].data.DEF), 90,215, i * 33.5 + 123, textFormat);
				createDisplayText(MONSTER_FW_TEXT * 10 + i, String(currFloorMonster[i].data.CP), 90, 260, i * 33.5 + 123,textFormat);
			}
			
		}
		
		private function keyDownListener(e:KeyboardEvent):void {
			if (e.keyCode == 69 || e.keyCode == 81) {
				//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_MENU_CLOSE, false, 1, 0,0.2));
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER,"monsterManualQuit"));
			}
		}
		
	}

}