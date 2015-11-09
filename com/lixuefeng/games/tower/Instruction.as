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
	
	public class Instruction extends BasicScreen
	{
		private var tileSheetData:TileSheetData;
		
		public function Instruction(tileSheetData:TileSheetData) 
		{
			this.tileSheetData = tileSheetData;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);
			init();
		}
		
		private function init():void 
		{
			setBackgroundBitmap(tileSheetData.imageLibrary["instructionScreen"]);
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			//R
			if (e.keyCode == 71 || e.keyCode == 81) {
				//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_MENU_CLOSE, false, 1, 0,0.2));
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER,"instructionQuit"));
			}
		}
		
	}

}