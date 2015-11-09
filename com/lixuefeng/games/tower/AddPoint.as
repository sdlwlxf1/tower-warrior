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
	
	public class AddPoint extends BasicScreen
	{
		private var tileSheetData:TileSheetData;
		
		
		private var player:Player;
		private static const PLAYER_IMAGE:int = 0;
		private static const PLAYER_STR_TEXT:int = 0;
		private static const PLAYER_DEF_TEXT:int = 1;
		private static const PLAYER_CP_TEXT:int = 2;
		
		private static const LABER_PLAYER_STR:int = 0;
		private static const LABER_PLAYER_DEF:int = 1;
		
		private var laberArray:Array = [0, 1];
		private var currLaber:int = 0;
		private var i:int;
		
		private var player_HP:int;
		private var player_STR:int;
		private var player_DEF:int;
		private var player_CP:int;
		
		private var lastX1:int = 90;
		private var lastX2:int = 210;
		
		public function AddPoint(player:Player, tileSheetData:TileSheetData) 
		{
			this.player = player;
			this.tileSheetData = tileSheetData;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Global.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			init();
		}
		
		private function init():void {
			
			player_HP = player.data.HP;
			player_STR = player.data.STR;
			player_DEF = player.data.DEF;
			player_CP = player.data.CP;
			
			

			setBackgroundBitmap(tileSheetData.imageLibrary["addPointPng"]);			
			addImageBitmap(PLAYER_IMAGE, 130, 60, player.viewArray[0][0].clone());
			addImageBitmap(1, lastX1, 145, tileSheetData.imageLibrary["addPointPointPng"]);
			addImageBitmap(2, lastX2, 145, tileSheetData.imageLibrary["addPointPointPng"]);
			imageBitmaps[2].rotation = 180;
			imageBitmaps[2].y += imageBitmaps[2].height;
			
			var textFormat:TextFormat = new TextFormat("Gill Sans MT", 20,0xff000000, true,null, null,null,null,TextFormatAlign.CENTER);
			createDisplayText(PLAYER_STR_TEXT, String(player.data.STR), 70, 115, 143, textFormat);						
			createDisplayText(PLAYER_DEF_TEXT, String(player.data.DEF), 70, 115,210, textFormat);
			createDisplayText(PLAYER_CP_TEXT, String(player.data.CP), 70, 115,275, textFormat);
			
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			//R
			if (e.keyCode == 82 || e.keyCode == 81) {
				//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_MENU_CLOSE, false, 1, 0,0.2));
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER,"addPointQuit"));
			}
			//下
			else if (e.keyCode == 40) {
				i = currLaber;
				i++;
				if (i >= laberArray.length) {
					i = 0;
				}
				currLaber = i;
				if (i == 0) {
					imageBitmaps[1].y = 145;
					imageBitmaps[2].y = 145 + imageBitmaps[2].height;
				} else if (i == 1) {
					imageBitmaps[1].y = 210;
					imageBitmaps[2].y = 210 + imageBitmaps[2].height;
				}
			}
			//上
			else if (e.keyCode == 38) {				
				i = currLaber;
				i--;
				if (i < 0) {
					i = laberArray.length - 1;
				}
				currLaber = i;
				if (i == 0) {
					imageBitmaps[1].y = 145;
					imageBitmaps[2].y = 145 + imageBitmaps[2].height;
				} else if (i == 1) {
					imageBitmaps[1].y = 210;
					imageBitmaps[2].y = 210 + imageBitmaps[2].height;
				}
			}
			//左
			else if (e.keyCode == 37) {
				if (currLaber == LABER_PLAYER_STR) {
					if (player_STR > player.data.STR) {
						player_STR--;
						player_CP += 20;
						imageBitmaps[1].x = lastX1 - 2;
						changeDisplayText(PLAYER_STR_TEXT, String(player_STR));
						changeDisplayText(PLAYER_CP_TEXT, String(player_CP));
					}
					
				} else if (currLaber == LABER_PLAYER_DEF) {
					if (player_DEF > player.data.DEF) {
						player_DEF--;
						player_CP += 20;
						imageBitmaps[1].x = lastX1 - 2;
						changeDisplayText(PLAYER_DEF_TEXT, String(player_DEF));
						changeDisplayText(PLAYER_CP_TEXT, String(player_CP));
					}
				}
				

			}
			//右
			else if (e.keyCode == 39) {
				if (currLaber == LABER_PLAYER_STR) {
					if (player_CP - 20 >= 0) {
						player_STR++;
						player_CP -= 20;
						imageBitmaps[2].x = lastX2 + 2;
						changeDisplayText(PLAYER_STR_TEXT, String(player_STR));
						changeDisplayText(PLAYER_CP_TEXT, String(player_CP));
					}
					
				} else if (currLaber == LABER_PLAYER_DEF) {
					if (player_CP - 20 >= 0) {
						player_DEF++;
						player_CP -= 20;
						imageBitmaps[2].x = lastX2 + 2;
						changeDisplayText(PLAYER_DEF_TEXT, String(player_DEF));
						changeDisplayText(PLAYER_CP_TEXT, String(player_CP));
					}
				}
			}
			//Enter
			else if (e.keyCode == 13 || e.keyCode == 32) {
				
				player.data.CP = player_CP;
				player.data.STR = player_STR;
				player.data.DEF = player_DEF;
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER,"addPointOver"));
			}
			else {
				
			}
		}
		
		private function keyUpListener(e:KeyboardEvent):void {
			imageBitmaps[1].x = lastX1;
			imageBitmaps[2].x = lastX2;
		}
		
	}

}