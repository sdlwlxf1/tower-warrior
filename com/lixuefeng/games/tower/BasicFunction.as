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
	import gs.*; 
	import gs.easing.*;
	public class BasicFunction extends BasicScreen
    {
		
		public static const BASICFUNCTION:int = 0;
		public static const LOADPNG:int = 1;
		public static const ADDPOINTLEFT:int = 2;
		public static const ADDPOINTRIGHT:int = 3;
		
		private var tileSheetData:TileSheetData;
		private var laberArray:Array;
		private var laberArray1:Array = [0, 1, 2];
		private var laberArray2:Array = [0, 1, 2, 3, 4, 5, 6];
		private var currLaber:int = 0;
		private var i:int;
		
		private static const LABER_LOAD:int = 0;
		private static const LABER_RELOAD:int = 1;
		private static const LABER_BACK:int = 2;
		
		private var order:int;
		
		private var lastX1:int = 63;
		private var lastX2:int = 237;
		
		private var firstY:int;
		private var firstY1:int = 130;
		private var firstY2:int = 46;

		private var dy:int;
		private var dy1:int = 58;
		private var dy2:int = 38;
		
		public function BasicFunction(tileSheetData:TileSheetData) 
		{
			laberArray = laberArray1;
			dy = dy1;
			firstY = firstY1;
			this.tileSheetData = tileSheetData;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			//Global.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			init();
		}
		
		private function init():void 
		{
			setBackgroundBitmap(tileSheetData.imageLibrary["basicWindowPng"]);
			addImageBitmap(BASICFUNCTION, 0, 0, tileSheetData.imageLibrary["basicFunctionPng"]);
			addImageBitmap(LOADPNG, 0, 0, tileSheetData.imageLibrary["loadPng"]);
			imageBitmaps[1].alpha = 0;
			addImageBitmap(ADDPOINTLEFT, lastX1, firstY, tileSheetData.imageLibrary["addPointPointPng"]);
			addImageBitmap(ADDPOINTRIGHT, lastX2, firstY, tileSheetData.imageLibrary["addPointPointPng"]);
			imageBitmaps[ADDPOINTRIGHT].rotation = 180;
			imageBitmaps[ADDPOINTRIGHT].y += imageBitmaps[ADDPOINTRIGHT].height;
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			//下
			if (e.keyCode == 40) {
				i = currLaber;
				i++;
				if (i >= laberArray.length) {
					i = 0;
				}
				currLaber = i;
				if (i == 0) {
					imageBitmaps[ADDPOINTLEFT].y = firstY;
					imageBitmaps[ADDPOINTRIGHT].y = firstY + imageBitmaps[ADDPOINTRIGHT].height;
				} else{
					imageBitmaps[ADDPOINTLEFT].y += dy;
					imageBitmaps[ADDPOINTRIGHT].y += dy;
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
				if (i == laberArray.length - 1) {
					imageBitmaps[ADDPOINTLEFT].y = firstY + (laberArray.length - 1) * dy;
					imageBitmaps[ADDPOINTRIGHT].y = firstY + imageBitmaps[ADDPOINTRIGHT].height + (laberArray.length - 1) * dy;
				} else {
					imageBitmaps[ADDPOINTLEFT].y -= dy;
					imageBitmaps[ADDPOINTRIGHT].y -= dy;
				}
			} 
			
			//Q
			else if (e.keyCode == 81) {
				if(laberArray == laberArray1) {
					//dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_MENU_CLOSE, false, 1, 0,0.2));
					Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
					//Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
					dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER, "basicFunctionQuit"));
				} else if (laberArray == laberArray2) {
					TweenLite.to(imageBitmaps[BASICFUNCTION], 0.8, { alpha:1, ease:Quint.easeOut } );
					TweenLite.to(imageBitmaps[LOADPNG], 0.8, { alpha:0, ease:Quint.easeOut } );
					laberArray = laberArray1;
					currLaber = 0;
					dy = dy1;
					firstY = firstY1;
					imageBitmaps[ADDPOINTLEFT].y = firstY;
					imageBitmaps[ADDPOINTRIGHT].y = firstY + imageBitmaps[ADDPOINTRIGHT].height;
					
				}
			}
			
			else if (e.keyCode == 13 || e.keyCode == 32) {
				if(laberArray == laberArray1){
					if (currLaber == LABER_LOAD || currLaber == LABER_RELOAD) {
						if (currLaber == LABER_LOAD) {
							order = LABER_LOAD;
						} else if(currLaber == LABER_RELOAD) {
							order = LABER_RELOAD;
						}
						
						laberArray = laberArray2;
						currLaber = 0;
						dy = dy2;
						firstY = firstY2;
						
						TweenLite.to(imageBitmaps[BASICFUNCTION], 0.8, { alpha:0, ease:Quint.easeOut } );
						TweenLite.to(imageBitmaps[LOADPNG], 0.8, { alpha:1, ease:Quint.easeOut } );
						
						imageBitmaps[ADDPOINTLEFT].y = firstY;
						imageBitmaps[ADDPOINTRIGHT].y = firstY + imageBitmaps[ADDPOINTRIGHT].height;
			
						
					} else if (currLaber == LABER_BACK ) {
						Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
						dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER, "back"));
					}
				} else if (laberArray  == laberArray2) {
					if (order == LABER_LOAD) {
						dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER, "load", currLaber));
					} else if (order == LABER_RELOAD) {
						dispatchEvent(new OrderEvent(OrderEvent.ORDER_OVER, "reload", currLaber));
					}
					Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				}
			}
		}
		

		/*
		private function keyUpListener(e:KeyboardEvent):void {
			imageBitmaps[1].x = lastX1;
			imageBitmaps[2].x = lastX2;
		}
		*/
	}

}