package  com.lixuefeng.games.tower
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author li xuefeng
	 */
	
	public class Switch 
	{
		
		private var switchPosition:String;
		private var switchDic:Object;
		private var doorDic:Object;
		private var floorDataArray:Array;
		
		private var switchMapJudge:Array = [];
		
		private var gameProgress:Object;

		
		public function Switch(switchPosition:String,switchDic:Object, doorDic:Object, floorDataArray:Array,gameProgress:Object) 
		{
			this.switchPosition = switchPosition;
			this.switchDic = switchDic;
			this.doorDic = doorDic;
			this.floorDataArray = floorDataArray;
			this.gameProgress = gameProgress;
			
			switchLogic();
		}
		private function switchLogic():void 
		{	
			switch (switchPosition) {
				case "441":
					switch(doorDic["287"]) {
						case 0:
							doorDic["287"] = 1;
							floorDataArray[Tower.ARRAY_ITEM][2][8][7] = 17;
							break;
					}
				

				case "882":
					switch(doorDic["835"]) {
						case 0:
							doorDic["835"] = 1;
							break;
						case 1:
							doorDic["835"] = 0;
							break;
							
					}
					break;
				case "884":
					switch(String(doorDic["875"]) + String(doorDic["855"])) {
						case "00":
							doorDic["875"] = 1;
							doorDic["855"] = 0;
							break;
						case "01":
							doorDic["875"] = 1;
							doorDic["855"] = 0;
							break;
						case "10":
							doorDic["875"] = 0;
							doorDic["855"] = 1;
							break;
						case "11":
							doorDic["875"] = 0;
							doorDic["855"] = 1;
							break;

					}
					break;
				case "886":
					switch(String(doorDic["835"]) + String(doorDic["855"])) {
						case "00":
							doorDic["835"] = 1;
							doorDic["855"] = 0;
							break;
						case "01":
							doorDic["835"] = 1;
							doorDic["855"] = 0;
							break;
						case "10":
							doorDic["835"] = 0;
							doorDic["855"] = 1;
							break;
						case "11":
							doorDic["835"] = 0;
							doorDic["855"] = 1;
							break;
					}
					break;
				case "888":
					switch(doorDic["835"]) {
						case 0:
							doorDic["835"] = 1;
							break;
						case 1:
							doorDic["835"] = 0;
							break;
							
					}
					switch(doorDic["855"]) {
						case 0:
							doorDic["855"] = 1;
							break;
						case 1:
							doorDic["855"] = 0;
							break;
							
					}
					switch(doorDic["875"]) {
						case 0:
							doorDic["875"] = 1;
							break;
						case 1:
							doorDic["875"] = 0;
							break;
							
					}
					break;
				case "395":
					var length:int = Floor.switchMapArray.length;
					for (var i:int = 0; i < length; i++ ) {
						switchMapJudge[i] = true;
					}
					
					for (i = 2; i < 9 ; i ++ ) {
						for (var j:int = 2; j < 9; j ++ ) {
							for (var k:int = 0; k <  length; k++ ) {
							
								if (switchMapJudge[k] == true && switchDic["3" + String(i) + String(j)][Tower.SWITCH_UP_DOWN] != Floor.switchMapArray[k][i - 2][j - 2] ) {
									
									switchMapJudge[k] = false;
								}
							}
							switchDic["3" + String(i) + String(j)][Tower.SWITCH_UP_DOWN] = Tower.SWITCH_UP;
						}
					}
					
					trace(gameProgress["news50Open"]);
					if (switchMapJudge[0] == true && gameProgress["news29Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 51;
					} else if (switchMapJudge[1] == true && gameProgress["news49Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 56;
					} else if (switchMapJudge[2] == true && gameProgress["news50Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 52;
					} else if (switchMapJudge[3] == true && gameProgress["news51Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 57;
					} else if (switchMapJudge[4] == true && gameProgress["news52Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 53;
					} else if (switchMapJudge[5] == true && gameProgress["news53Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 58;
					} else if (switchMapJudge[6] == true && gameProgress["news54Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 54;
					} else if (switchMapJudge[7] == true && gameProgress["news55Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 59;
					} else if (switchMapJudge[8] == true && gameProgress["news56Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 55;
					} else if (switchMapJudge[9] == true && gameProgress["news57Open"]) {
						floorDataArray[Tower.ARRAY_ITEM][3][1][5] = 60;
					} else if (switchMapJudge[10] == true) {
						floorDataArray[Tower.ARRAY_ROLE][3][1][5] = 35;
					} 

					break;	
			}
		}
		
	}

}