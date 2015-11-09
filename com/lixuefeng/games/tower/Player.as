package  com.lixuefeng.games.tower
{

	import com.lixuefeng.framework.*;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import com.lixuefeng.framework.AnimationFactory;
	import com.lixuefeng.framework.AnimationObject;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class Player extends Sprite 
	{
		
		private var tileSheetData:TileSheetData;
		
		private var visitBackgroundSheetData:int;
		private	var visitRoleSheetData:int;
		
		private	var visitItemSheetData:int;
		private	var visitItemSheetTypeData:int;
		private var visitLastItemSheetData:int;
		private var visitLastItemSheetTypeData:int;
		private var visitFaceItemSheetData:int;
		private var visitFaceItemSheetTypeData:int;
		
		// 楼层
		public var currFloor:int = 0;
		public var upFloor:Boolean = false;
		public var downFloor:Boolean = false;
		public var isChangeFloor:Boolean = false;
		public var isTransmit:Boolean = false;
		
		// 机关
		public var lastSwitchState:Array;
		public var keyUsed:Boolean = false;
		
		//位置变量
		public var currRow:int;
		public var currCol:int;
		public var lastRow:int;
		public var lastCol:int;
		public var nextRow:int;
		public var nextCol:int;
		public var faceNextRow:int;
		public var faceNextCol:int;
		public var nextX:Number = 0;
		public var nextY:Number = 0;
		public var dx:Number=0;
		public var dy:Number = 0;
		private var row:int;
		private var col:int;
		private var xCenter:int;
		private var yCenter:int;
		
		//外观和相关属性
		public var view:AnimationList;
		public var viewArray:Array;
		public var data:PlayerData;
		
		// 地图二维数组
		public var floorDataArray:Array;
		private var backgroundArray:Array;
		private var roleArray:Array;
		private var itemArray:Array;
		
		private var tileWidth:int = 40;
		private var tileHeight:int = 40;
		private var mapRowCount:int = 11;
		private var mapColumnCount:int = 11;
		


		
		public static const MOVE_UP:int = 3;
		public static const MOVE_DOWN:int = 0;
		public static const MOVE_LEFT:int = 1;
		public static const MOVE_RIGHT:int = 2;
		public static const MOVE_STOP:int = 4;
		
		public var faceMovement:int = MOVE_UP;
		public var currMovement:int = MOVE_UP;
		public var moveSpeed:Number;
		public var keyPressList:Array;
		public var switchDic:Object;
		
		public var stopFight:Boolean = false;
		
		public var goods:Object;
		
		private var footStepSound:int = 0;
		

		
		public function Player(tileSheetData:TileSheetData) 
		{
			this.tileSheetData = tileSheetData;
			initView();
			initData();
		}

		
		private function initView():void
		{
			
			
			
			viewArray = new Array;
			var source:BitmapData = new PlayerPng(0, 0);
			var i:int;
			for(i = 0; i<4; i++ )
			{
				//使用切图工厂进行原始素材图片转换成动画图片序列工作
				viewArray[i] = AnimationFactory.imgListFactory( source, i, 4, 40, 40 );
			}
			
			view = new AnimationList();
			view.init(viewArray[currMovement], 0);
			view.animationDelay = 3;
			view.x = -.5 * tileWidth;
			view.y = -.5 * tileHeight;
			
			
			addChild(view);
						

		}
		
		
		public function initData():void 
		{
			data = new PlayerData;			
		}
		
		//读取floor中二维数组
		public function readFloorData(currFloor:int):void {			
			backgroundArray = floorDataArray[Tower.ARRAY_BACKGROUND][currFloor];
			roleArray = floorDataArray[Tower.ARRAY_ROLE][currFloor];
			itemArray = floorDataArray[Tower.ARRAY_ITEM][currFloor];					
		}
		
		
		public function walk(keyPressList:Array):void 
		{
			this.keyPressList = keyPressList;

			changeDirtection(keyPressList);	

			view.updateCurrentTile();
			
			visit();
			
			
			nextX = x + dx * moveSpeed;
			nextY = y + dy * moveSpeed;
			
	
			currRow = int(nextY * 0.025);
			currCol = int(nextX * 0.025);

			x = nextX;
			y = nextY;
			
			
			
			if (checkCenterTile()) {
					switchMovement(MOVE_STOP);
					//setCurrentRegion(player);

			}
			
		}
		
		public function changeDirtection(keyPressList:Array):void 
		{
			var playSound:Boolean = false;
			var lastMovement:int = currMovement;
			
			if (keyPressList[38]) {
				if (nextTileCanMove(MOVE_UP)) {
					if (currMovement == MOVE_UP || currMovement == MOVE_DOWN || currMovement == MOVE_STOP  ) {
						switchMovement(MOVE_UP);
						playSound = true;
					}else if (checkCenterTile()) {
						switchMovement(MOVE_UP);
						playSound = true;
					}
				}else if(currMovement == MOVE_STOP){
					//trace("can't move up");
					view.tileList = viewArray[MOVE_UP];
					faceMovement = MOVE_UP;
				}
				
			}
			
			if (keyPressList[40]) {
				if (nextTileCanMove(MOVE_DOWN)) {
					if (currMovement == MOVE_DOWN || currMovement == MOVE_UP || currMovement == MOVE_STOP) {
						switchMovement(MOVE_DOWN);
						playSound = true;
					}else if (checkCenterTile()) {
						switchMovement(MOVE_DOWN);
						playSound = true;
					}
				
				}else if(currMovement == MOVE_STOP){
					//trace("can't move down");
					view.tileList = viewArray[MOVE_DOWN];
					faceMovement = MOVE_DOWN;
				}
				
			}
			
			if (keyPressList[39]) {
				if (nextTileCanMove(MOVE_RIGHT)) {
					if (currMovement == MOVE_RIGHT || currMovement == MOVE_LEFT || currMovement == MOVE_STOP) {
						switchMovement(MOVE_RIGHT);
						playSound = true;
					}else if (checkCenterTile()) {
						switchMovement(MOVE_RIGHT);
						playSound = true;
					}
					
				}else if(currMovement == MOVE_STOP){
				//	trace("can't move right");
					view.tileList = viewArray[MOVE_RIGHT];
					faceMovement = MOVE_RIGHT;
				}
				
			}
			
			if (keyPressList[37]) {
				if (nextTileCanMove(MOVE_LEFT)) {
					if (currMovement == MOVE_LEFT || currMovement == MOVE_RIGHT || currMovement == MOVE_STOP) {
						switchMovement(MOVE_LEFT);
						playSound = true;
					}else if (checkCenterTile()) {
						switchMovement(MOVE_LEFT);
						playSound = true;
					}
				
				}else if(currMovement == MOVE_STOP){
					//trace("can't move left");
					view.tileList = viewArray[MOVE_LEFT];
					faceMovement = MOVE_LEFT;
				}
				
			}
			
			if (keyPressList[32]) {
				//if (ammo >0) firePlayerMissile();
				
			}
			
			if (lastMovement == MOVE_STOP && playSound) {
				if(footStepSound == 0) {
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PLAYER_MOVE1, false, 1, 0, 0.1));
					footStepSound = 1;
				} else {
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PLAYER_MOVE2, false, 1, 0, 0.1));
					footStepSound = 0;
				}
			}
			
		}
		
				
		//检查游戏对象的下一个方块是否可行
		private function nextTileCanMove(Movement:int):Boolean {
			
			row = currRow;
			col = currCol;
			//设置下一个方块行和列
			switch(Movement) {
				case MOVE_UP:
					row--;
					break;
				case MOVE_DOWN:
					row++;
					
					break;
				case MOVE_LEFT:
					col--;

					break;
				case MOVE_RIGHT:
					col++;

					break;
			}
			
			
			//下一个坐标是TILE_MOVE就可以行走
			if(row >= 0 && row < mapRowCount && col >= 0 && col < mapColumnCount) {
				if (tileSheetData.backgroundSheetData[backgroundArray[row][col]] > 0 && roleArray[row][col] == 0 && tileSheetData.itemSheetWalkData[itemArray[row][col]] == TileSheetData.ITEM_WALKABLE) //
				{

					//trace("can move");
						return true;
				}
				else 
				{
					//trace("can't move");
					return false;
				}
			}
			else 
			{ 
					return false;
			}
		
			
			
		}
		
		
		//检查坐标在不在方块的中心
		private function checkCenterTile():Boolean {
			xCenter = (currCol * tileWidth) + (.5 * tileWidth);
			yCenter = (currRow * tileHeight) + (.5 * tileHeight);
			
			if (x == xCenter && y == yCenter) {
				//trace("in center tile");
				return true;
				
			}else {
				//trace("not in center tile");
				return false;
				
			}
		}
		
		
		//运动吧
		public function switchMovement(Movement:int):void{
			switch(Movement) {
				case MOVE_UP:
					//trace("move up");
					dx = 0;
					dy = -1;
					currMovement = MOVE_UP;
					faceMovement = MOVE_UP;
					view.tileList = viewArray[currMovement];
					view.animationLoop = true;

					break;
				case MOVE_DOWN:
					//trace("move down");
					dx = 0;
					dy = 1;
					currMovement = MOVE_DOWN;
					faceMovement = MOVE_DOWN;
					view.tileList = viewArray[currMovement];
					view.animationLoop = true;
					break;
				case MOVE_LEFT:
					//trace("move left");
					currMovement = MOVE_LEFT;
					faceMovement = MOVE_LEFT;
					view.tileList = viewArray[currMovement];
					view.animationLoop = true;
					dx = -1;
					dy = 0;
					break;
				case MOVE_RIGHT:
					//trace("move right");
					currMovement = MOVE_RIGHT;
					faceMovement = MOVE_RIGHT;
					view.tileList = viewArray[currMovement];
					view.animationLoop = true;
					dx = 1;
					dy = 0;
					break;
				case MOVE_STOP:
					//trace("move stop");
					currMovement = MOVE_STOP;					
					view.animationLoop = false;

					dx = 0;
					dy = 0;
					
					break;
			}
			
			nextRow = currRow + dy;
			nextCol = currCol + dx;
			
			

		}
		
		private function fightCharge(monster:Monster):Boolean {
			var playerHP:int = data.HP;
			var playerSTR:int =  data.STR;
			var playerDEF:int = data.DEF;

			var monsterHP:int = monster.data.HP;
			var monsterSTR:int = monster.data.STR;
			var monsterDEF:int =  monster.data.DEF;
			
			var hurtMonster:int = playerSTR - monsterDEF;
			var hurtPlayer:int = monsterSTR - playerDEF;
			
			while(true) {
				if(hurtMonster > 0) {
					monsterHP -= hurtMonster;					
				}
				if(monsterHP <= 0) {
					monsterHP = 0;				
					break;
					
				}
				if(hurtPlayer > 0) {
					playerHP -= hurtPlayer;
					
				}
				if(playerHP <= 0) {
					playerHP = 0;
					break;
					
				}
				if (hurtMonster <= 0 && hurtPlayer <= 0) {
					break;
				}

			}
			if (monsterHP == 0) {
				return true;
			} else if (playerHP == 0) {
				return false;
			} else {
				return false;
			}
		}
		
		
		private function visit():void 
		{
			
			faceNextRow = currRow;
			faceNextCol = currCol;
			
			lastRow = currRow;
			lastCol = currCol;

			switch(faceMovement) {
				case MOVE_UP:
					faceNextRow--;
					lastRow++;
					if (faceNextRow < 0) {
						faceNextRow = 0;

					} else if (lastRow > 10) {
						lastRow = 10;
					}
					break;
				case MOVE_DOWN:
					faceNextRow++;
					lastRow--;
					if (faceNextRow > 10) {
						faceNextRow = 10;
					} else if (lastRow < 0) {
						lastRow = 0;
					}
					break;
				case MOVE_LEFT:
					faceNextCol--;
					lastCol++
					if (faceNextCol < 0) {
						faceNextCol = 0;
					} else if (lastCol > 10) {
						lastCol = 10;
					}
					break;
				case MOVE_RIGHT:
					faceNextCol++;
					lastCol--;
					if (faceNextCol > 10) {
						faceNextCol = 10;
					} else if (lastCol < 0) {
						lastCol = 0;
					}
					break;
			}
			

			//trace(faceNextCol + "             " + faceNextRow);
			//trace(lastRow + "              " + lastCol);
			
			visitBackgroundSheetData = tileSheetData.backgroundSheetData[backgroundArray[currRow][currCol]];
			visitRoleSheetData = tileSheetData.roleSheetData[(roleArray[faceNextRow][faceNextCol])];
			
			visitItemSheetData = tileSheetData.itemSheetData[itemArray[currRow][currCol]];
			visitItemSheetTypeData = tileSheetData.itemSheetTypeData[itemArray[currRow][currCol]];
			
			visitLastItemSheetData = tileSheetData.itemSheetData[itemArray[lastRow][lastCol]];
			visitLastItemSheetTypeData = tileSheetData.itemSheetTypeData[itemArray[lastRow][lastCol]];

			visitFaceItemSheetData = tileSheetData.itemSheetData[itemArray[faceNextRow][faceNextCol]];
			visitFaceItemSheetTypeData = tileSheetData.itemSheetTypeData[itemArray[faceNextRow][faceNextCol]];
			
			//trace(tileSheetData.itemSheetData[itemArray[3][5]]);
			//trace(visitItemSheetTypeData);
			//遇到怪物	
			
			if ( visitRoleSheetData == TileSheetData.ROLE_MONSTER)
			{   
				if (keyPressList[32] == true) {
					isChangeFloor = false;
					var monster:Monster = new Monster(roleArray[faceNextRow][faceNextCol] / 3, tileSheetData);
					trace(fightCharge(monster));
					if (fightCharge(monster)) {
						dispatchEvent(new FightEvent(FightEvent.FIGHT_START, faceNextRow, faceNextCol));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "普通战斗无法取胜"));
					}
				}
				
				if(keyPressList[65] == true || keyPressList[67] == true) {
					isChangeFloor = false;
					//isTransmit = false;
					dispatchEvent(new FightEvent(FightEvent.FIGHT_START, faceNextRow, faceNextCol));			
				}
			} 

			//遇到NPC
			else if (visitRoleSheetData == TileSheetData.ROLE_NPC)
			{
				
				if (keyPressList[32] == true || keyPressList[67] == true) {
					trace("遇到NPC");
					isChangeFloor = false;
					//isTransmit = false;
					var npcRow:int = roleArray[faceNextRow][faceNextCol] / 3;
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START,"manual", npcRow));
				}
				
				
			}
			
			//钥匙开门
			if (visitFaceItemSheetTypeData == TileSheetData.ITEM_DOOR && keyPressList[32] == true) 
			{
				trace("遇到门");
				isChangeFloor = false;
				dispatchEvent(new DoorEvent(DoorEvent.OPEN_DOOR, visitFaceItemSheetData));
			}
			//捡东西
			if (visitItemSheetTypeData == TileSheetData.ITEM_ITEM) 
			{
				isChangeFloor = false;
				dispatchEvent(new PickEvent(PickEvent.PICK, visitItemSheetData));
			}
			
			//踩机关
			if (visitItemSheetTypeData == TileSheetData.ITEM_SWITCH)
			{
				dispatchEvent(new SwitchEvent(SwitchEvent.ON_SWITCH,"floor", visitItemSheetData, visitItemSheetTypeData));
			}
			//开开关
			else if (visitFaceItemSheetData == TileSheetData.ITEM_SWITCH_STICK && keyPressList[32] == true) 
			{
				dispatchEvent(new SwitchEvent(SwitchEvent.ON_SWITCH,"face", visitFaceItemSheetData, visitFaceItemSheetTypeData));
			}
			
			//遇到上楼梯
			if (visitBackgroundSheetData == TileSheetData.BACKGROUND_UPSTAIR) 
			{
				if (isTransmit == true) {
					isTransmit = false;
					isChangeFloor = true;
				} 
				else if (isChangeFloor == false) 
				{
					currFloor++;
					trace("上楼梯后当前楼层:    " + currFloor);
					upFloor = true;
					isChangeFloor = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, currFloor,"up"));
					
				}
				
				
			//遇到下楼梯	
			} 
			else if (visitBackgroundSheetData == TileSheetData.BACKGROUND_DOWNSTAIR) 
			{
				if (isTransmit == true) {
					isTransmit = false;
					isChangeFloor = true;
				} 
				else if (isChangeFloor == false) {		
					currFloor--;
					trace("下楼梯后当前楼层:    " + currFloor );
					downFloor = true;
					isChangeFloor = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, currFloor,"down"));
					
				}
				
			} else {
				isChangeFloor = false;
			}
			//遇到提示
			if (visitFaceItemSheetTypeData == TileSheetData.ITEM_NEWS && keyPressList[32] == true )
			{
				isChangeFloor = false;
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"manual",null, visitFaceItemSheetData));
			}
			
			
			//恢复开关
			if (visitLastItemSheetTypeData == TileSheetData.ITEM_SWITCH) {
				
				lastSwitchState = switchDic[String(currFloor) + String(lastRow) + String(lastCol)];
				lastSwitchState[Tower.SWITCH_ON_OUT] = Tower.OUT_SWITCH;
				
				if (visitLastItemSheetData == TileSheetData.ITEM_FLOOR_SWITCH1 || visitLastItemSheetData == TileSheetData.ITEM_FLOOR_SWITCH2) {
					lastSwitchState[Tower.SWITCH_UP_DOWN] = Tower.SWITCH_UP;
				}
			}			
			
		}
		
	}

}