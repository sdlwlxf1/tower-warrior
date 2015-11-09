package com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.lixuefeng.framework.TileSheet;
	import com.lixuefeng.games.tower.Player;
	import com.lixuefeng.games.tower.Global;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import com.lixuefeng.framework.*;
	import gs.*; 
	import gs.easing.*;

	public class Tower extends Game
	{
		
		
		
		private var tileWidth:int = 40;
		private var tileHeight:int = 40;
		private var mapRowCount:int = 11;
		private var mapColumnCount:int = 11;
		
		//*** added iteration #1
		//player specific variables
		public var player:Player;
		private var playerStartRow:int = 10;
		private var playerStartCol:int = 5;
		
		private var upStairPosition:Array;
		private var downStairPosition:Array;
		
		private var playerStarted:Boolean = false;
		

		private var shakeTower:ShakeAnimation;

		
		//创建图片信息项
		private var tileSheetData:TileSheetData;		
		private var chatContentData:ChatContentData;
		
		// 楼层
		public var currFloor:int = 0;
		private var floorLock:Array = [];
		
		// 地图二维数组
		
		public static const ARRAY_BACKGROUND:int = 0;
		public static const ARRAY_ROLE:int = 1;
		public static const ARRAY_ITEM:int = 2;
		public static const ARRAY_EFFECT:int = 3;
		
		private var floorDataArray:Array;
		
		private var backgroundArray:Array;
		private var roleArray:Array;
		private var itemArray:Array;
		
		
		private var effectArray:Array;
		
				
		
		private var blitPoint:Point = new Point();
		private var tileBlitRectangle:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
		
		// 背景图层
		private var backgroundLayerDatas:Array;
		private var backgroundLayer:Bitmap = new Bitmap();
		private var backgroundAnimationCount:int = 0;
		
		// 下道具图层
		private var underItemLayerDatas:Array;
		private var underItemLayer:Bitmap = new Bitmap();
		private var itemAnimationCount:int = 0;
		private var itemAnimationLoop:Boolean = true;
		

		// 怪物图层
		private var roleLayerDatas:Array;
		private var roleLayer:Bitmap = new Bitmap();
		private var roleAnimationCount:int = 0;
		
		// 上道具图层
		private var aboveItemLayerDatas:Array;
		private var aboveItemLayer:Bitmap = new Bitmap();
		
		// 效果图层
		private var effectLayerData = new BitmapData(tileWidth * mapColumnCount, tileHeight * mapRowCount, true, 0x00000000);
		private var effectLayer = new Bitmap(effectLayerData);
		private var effectAnimationLoop:Boolean = false;
		private var effectAnimationCount:int = 0;
		//效果
		private var currEffectFrame:Array;
		
		//外部图片信息
		private var backgroundSheet:TileSheet = new TileSheet(new BackgroundPng(0, 0), tileWidth, tileHeight);
		private var roleSheet:TileSheet = new TileSheet(new RolePng(0, 0), tileWidth, tileHeight);
		private var itemSheet:TileSheet = new TileSheet(new ItemPng(0, 0), tileWidth, tileHeight);
		
		private var keyPressList:Array = [];
		
		//战斗
		private var fight:*;
		private var beAttackMonster:Monster;
		private var beAttackNPC:NPC;
		
		//交谈
		private var chat:Chat;
		private var beChatNPC:NPC;
		
		//传送
		private var transmit:Transmit;
		//加点
		private var addPoint:AddPoint;
		//基本功能
		private var basicFunction:BasicFunction;
		
		//提示
		private var news:News;
		//怪物手册
		private var monsterManual:MonsterManual;
		
		//说明
		private var instruction:Instruction;
		//存档
		public var loadId:int = 0;
		public var loadTitle:String = "Tower" + String(loadId);
		
		//机关
		private var switchGear:Switch;
		private var currSwitchState:Array;
		private	var renderCurrSwitchState:Array;
		private var currSwitchFrame:Array;
		private var switchDic:Object;
		
		public static const SWITCH_UP_DOWN:int = 0;
		public static const SWITCH_ON_OUT:int = 1;
		
		public static const SWITCH_DOWN:int = 1;
		public static const SWITCH_UP:int = 0;
		public static const SWITCH_CHANGE:int = 2;
		
		public static const OUT_SWITCH:int = 0;
		public static const ON_SWITCH:int = 1;
		
		//门	
		private var doorDic:Object;
		private var currDoorFrame:Array;
		public static const DOOR_OPEN:int = 1;
		public static const DOOR_CLOSE:int = 0;
		public static const DOOR_CHANGE:int = 2;
		

		private var gameProgress:Object;
		private var plotWaitTime:int;
		private var blackScreen:Bitmap;
		private var whiteScreen:Bitmap;
		private var blackCover:Bitmap;
		
		private var currFloorMonster:Array;
		
		private var _mainHold:Main;
		
		private var gameFile:Object;
		
		public function Tower(tileSheetData:TileSheetData) 
		{			
			this.tileSheetData = tileSheetData;		
		}
		
		public function setMainHold(hold:Main):void
		{
			_mainHold = hold;
		}
		
		
		private function updateStatueScreen():void {
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_TEXT_CURRFLOOR, String(currFloor)));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_TEXT_HP, String(player.data.HP)));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_TEXT_STR,String(player.data.STR)));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_TEXT_DEF,String(player.data.DEF)));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_TEXT_CP, String(player.data.CP)));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_TEXT_KEY_RED,String(player.data.RedKeyNum)));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_TEXT_KEY_BLUE, String(player.data.BlueKeyNum)));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_TEXT_KEY_YELLOW,String(player.data.YellowKeyNum)));

		}
		
		private function restartPlayer(upOrDown:Boolean = true):void {
			if (upOrDown == true) 
			{
				player.x = (downStairPosition[currFloor][0] * tileWidth)+(.5*tileWidth);
				player.y = (downStairPosition[currFloor][1] * tileHeight) + (.5 * tileHeight);
				player.currCol = downStairPosition[currFloor][0];
				player.currRow = downStairPosition[currFloor][1];
				player.nextX = player.x;
				player.nextY = player.y;

			} else if (upOrDown == false)
			{
				player.x = (upStairPosition[currFloor][0] * tileWidth)+(.5*tileWidth);
				player.y = (upStairPosition[currFloor][1] * tileHeight) + (.5 * tileHeight);
				player.currCol = upStairPosition[currFloor][0];
				player.currRow = upStairPosition[currFloor][1];
				player.nextX = player.x;
				player.nextY = player.y;
			}
		}
		
		private function resetFloorDataArray():void {
			floorDataArray[ARRAY_BACKGROUND] = DeepCopyUtil.clone(Floor.backgroundArray) as Array;
			floorDataArray[ARRAY_ITEM] = DeepCopyUtil.clone(Floor.itemArray) as Array;
			floorDataArray[ARRAY_ROLE] = DeepCopyUtil.clone(Floor.roleArray) as Array;
			floorDataArray[ARRAY_EFFECT] = DeepCopyUtil.clone(Floor.effectArray) as Array;
		}
		
		override public function initGame():void {
			addEventListener(FloorEvent.UPDATA_FLOOR, updataFloorListener, true);
			addEventListener(FloorEvent.UPDATA_FLOOR, updataFloorListener);
			
			addEventListener(ChatEvent.CHAT_START, chatStartListener, true);
			addEventListener(ChatEvent.CHAT_START, chatStartListener);
			
			addEventListener(ChatEvent.CHAT_OVER, chatOverListener);
			
			addEventListener(FightEvent.FIGHT_START, fightStartListener, true);
			addEventListener(FightEvent.FIGHT_START, fightStartListener);
			
			addEventListener(PickEvent.PICK, pickListener, true);
			
			addEventListener(SwitchEvent.ON_SWITCH, switchListener, true);
			
			addEventListener(DoorEvent.OPEN_DOOR, doorListener, true);

			addEventListener(NewsEvent.READ_NEWS, newsListener, true);
			addEventListener(NewsEvent.READ_NEWS, newsListener);
			
			addEventListener(OrderEvent.ORDER_START, orderListener);
			addEventListener(OrderEvent.ORDER_START, orderListener, true);
			
			addEventListener(OrderEvent.ORDER_OVER, orderListener);
			addEventListener(OrderEvent.ORDER_OVER, orderListener, true);
				
			//初始化
			backgroundLayerDatas = [];
			underItemLayerDatas = [];
			roleLayerDatas = [];
			aboveItemLayerDatas = [];
			
			upStairPosition = [];
			downStairPosition = [];
			
			chatContentData = new ChatContentData;
			
			player = new Player(tileSheetData);
			
			player.moveSpeed = 4;
			
			addKeyListener();
			Global.stage2 = this.stage;			
		}
		
		
		override public function newGame():void {
			
			if (firstOpen == true || reload == false) {
				
				
				//楼层锁
				floorLock = [];
				//游戏流程
				gameProgress = { };
				//楼层地图
				
				floorDataArray = [];
				player.floorDataArray = floorDataArray;
				resetFloorDataArray();
				//机关状态
				
				switchDic = {};				
				player.switchDic = switchDic;
				//门状态
				doorDic = {};
				
				//对话状态
				chatContentData.npcStartContentIdArray = [];
								
				//初始数值
				gameProgress["floor0plot1"] = true;//触发floor0的第二个剧情	
				//楼层
				currFloor = 0;
				player.currFloor = currFloor;
				//角色数值
				player.data.HP = 100;
				player.data.CP = 0;
				player.data.name = "李雪峰";
				player.data.STR = 15;
				player.data.DEF = 0;
				player.data.YellowKeyNum = 0;
				player.data.BlueKeyNum = 0;
				player.data.RedKeyNum = 0;
				//角色物品
				player.goods = { };
				player.goods["sword"] = 0;
				player.goods["equip"] = 0;
				//初始位置
				downStairPosition[0] = [playerStartCol, playerStartRow];			
				//NPC谈话开始编号
				chatContentData.npcStartContentIdArray[0] = 0;
				chatContentData.npcStartContentIdArray[1] = 0;
				chatContentData.npcStartContentIdArray[2] = 22;
				chatContentData.npcStartContentIdArray[3] = 275;
				chatContentData.npcStartContentIdArray[4] = 340;			
				
				//更新楼层
				updataFloor(currFloor);
				
				player.currCol = playerStartCol;
				player.currRow = playerStartRow;
				player.x = (playerStartCol * tileWidth)+(.5 * tileWidth);
				player.y = (playerStartRow * tileHeight) + (.5 * tileHeight);
				player.nextX = player.x;
				player.nextY = player.y;
				
				//状态栏更新
				var bitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
				dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, bitmapData));
				dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, bitmapData));
				
				firstOpen = false;
			}
			
			if (reload == true) {
				reloadGame();
			}
			
			
		}
		
		override public function overGame():void {
			removeEventListener(FloorEvent.UPDATA_FLOOR, updataFloorListener, true);
			removeEventListener(FloorEvent.UPDATA_FLOOR, updataFloorListener);
			
			removeEventListener(ChatEvent.CHAT_START, chatStartListener, true);
			removeEventListener(ChatEvent.CHAT_START, chatStartListener);
			
			removeEventListener(ChatEvent.CHAT_OVER, chatOverListener);
			
			removeEventListener(FightEvent.FIGHT_START, fightStartListener, true);
			removeEventListener(FightEvent.FIGHT_START, fightStartListener);
			
			removeEventListener(PickEvent.PICK, pickListener, true);
			
			removeEventListener(SwitchEvent.ON_SWITCH, switchListener, true);
			
			removeEventListener(DoorEvent.OPEN_DOOR, doorListener, true);

			removeEventListener(NewsEvent.READ_NEWS, newsListener, true);
			removeEventListener(NewsEvent.READ_NEWS, newsListener);
			
			removeEventListener(OrderEvent.ORDER_START, orderListener);
			removeEventListener(OrderEvent.ORDER_START, orderListener, true);
			
			removeEventListener(OrderEvent.ORDER_OVER, orderListener);
			removeEventListener(OrderEvent.ORDER_OVER, orderListener, true);
			
			for(var i:int=this.numChildren-1; i>=0; i--) {
				this.removeChildAt(0);
			}
			
			var bitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, bitmapData));
			dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, bitmapData));
		}
		
		/*
		override public function reloadGame():void {
			if (gameFile["floorLock"] != null) {
				//楼层锁
				floorLock = gameFile["floorLock"];
				//角色数据
				player.faceDirection = gameFile["playerDirection"];
				player.view.tileList = player.viewArray[player.faceDirection];
				player.data.HP = gameFile["playerDataHP"];
				player.data.STR = gameFile["playerDataSTR"];
				player.data.DEF = gameFile["playerDataDEF"];
				player.data.RedKeyNum = gameFile["RedKeyNum"];	
				player.data.YellowKeyNum = gameFile["YellowKeyNum"];
				player.data.BlueKeyNum = gameFile["BlueKeyNum"];
				player.goods = gameFile["playerGoods"];
				//状态栏装备
				var bitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
				if (player.goods["sword"] != 0) {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, searchTileBitmapData(player.goods["sword"], itemSheet, tileSheetData.itemSheetData)));
				} else {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, bitmapData));
				}
				if (player.goods["equip"] != 0) {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, searchTileBitmapData(player.goods["equip"], itemSheet, tileSheetData.itemSheetData)));
				} else {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, bitmapData));
				}
	
				
				//游戏流程
				gameProgress = gameFile["gameProgress"];
				//地图信息
				floorDataArray = gameFile["floorDataArray"];
				player.floorDataArray = floorDataArray;
				//机关状态
				switchDic = gameFile["switchDic"];				
				player.switchDic = switchDic;
				//门状态
				doorDic = gameFile["doorDic"];
				//谈话状态
				chatContentData.npcStartContentIdArray = gameFile["npcStartContentIdArray"];
				
				//楼层刷新
				var lastFloor:int = gameFile["currFloor"];
				if (lastFloor > currFloor) {
					player.upFloor = true;
					player.isTransmit = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, lastFloor));
				} else if (lastFloor < currFloor) {
					player.downFloor = true;
					player.isTransmit = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, lastFloor));
				} else {
					updataFloor(currFloor);
				}
				
				//角色位置
				player.x = gameFile["playerX"];
				player.y = gameFile["playerY"];
								
			
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "读档成功"));
			} else {
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "无存档可用"));
			}
		}
		*/
		
		override public function reloadGame():void {
			if (SCookie.getCookie(loadTitle, "floorLock") != null) {
				//楼层锁
				floorLock = SCookie.getCookie(loadTitle, "floorLock");
				//角色数据
				player.faceDirection = SCookie.getCookie(loadTitle, "playerDirection");
				player.view.tileList = player.viewArray[player.faceDirection];
				player.data.HP = SCookie.getCookie(loadTitle, "playerDataHP");
				player.data.STR = SCookie.getCookie(loadTitle, "playerDataSTR");
				player.data.DEF = SCookie.getCookie(loadTitle, "playerDataDEF");
				player.data.RedKeyNum = SCookie.getCookie(loadTitle, "RedKeyNum");	
				player.data.YellowKeyNum = SCookie.getCookie(loadTitle, "YellowKeyNum");
				player.data.BlueKeyNum = SCookie.getCookie(loadTitle, "BlueKeyNum");
				player.goods = SCookie.getCookie(loadTitle, "playerGoods");
				
				//状态栏装备
				var bitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
				if (player.goods["sword"] != 0) {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, searchTileBitmapData(player.goods["sword"], itemSheet, tileSheetData.itemSheetData)));
				} else {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, bitmapData));
				}
				if (player.goods["equip"] != 0) {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, searchTileBitmapData(player.goods["equip"], itemSheet, tileSheetData.itemSheetData)));
				} else {
					dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, bitmapData));
				}
		
				//游戏流程
				gameProgress = SCookie.getCookie(loadTitle, "gameProgress");
				//地图信息
				floorDataArray = SCookie.getCookie(loadTitle, "floorDataArray");
				player.floorDataArray = floorDataArray;
				
				//机关状态
				switchDic = SCookie.getCookie(loadTitle, "switchDic");				
				player.switchDic = switchDic;
				
				//门状态
				doorDic = SCookie.getCookie(loadTitle, "doorDic");
				//谈话状态
				chatContentData.npcStartContentIdArray = SCookie.getCookie(loadTitle, "npcStartContentIdArray");
				
				//楼层刷新
				var lastFloor:int = SCookie.getCookie(loadTitle, "currFloor");
				if (lastFloor > currFloor) {
					player.upFloor = true;
					player.isTransmit = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, lastFloor));
				} else if (lastFloor < currFloor) {
					player.downFloor = true;
					player.isTransmit = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, lastFloor));
				} else {
					updataFloor(currFloor);
				}
				//角色位置
				player.x = SCookie.getCookie(loadTitle, "playerX");
				player.y = SCookie.getCookie(loadTitle, "playerY");
				
				
				
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "读档成功"));
			} else {
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "无存档可用"));
			}
		}
		
		
						
		//新楼层
		public function updataFloor(floorNum:int):void 
		{
			readFloorData(floorNum);
			player.readFloorData(floorNum);
			if (backgroundLayerDatas[floorNum] != null) {				
				backgroundLayerDatas[floorNum].dispose();
			}
			if (underItemLayerDatas[floorNum] != null) {				
				underItemLayerDatas[floorNum].dispose();
			}
			if (roleLayerDatas[floorNum] != null) {				
				roleLayerDatas[floorNum].dispose();
			}
			if (aboveItemLayerDatas[floorNum] != null) {				
				aboveItemLayerDatas[floorNum].dispose();
			}
			//if (backgroundLayerDatas[floorNum] == null) {
				drawFloorBackground(floorNum);
			//}
			//if (underItemLayerDatas[floorNum] == null) {
				drawFloorItemUnder(floorNum);
			//}
			//if(roleLayerDatas[floorNum] == null) {
				drawFloorMonster(floorNum);
			//}
			//if (aboveItemLayerDatas[floorNum] == null) {
				drawFloorItemAbove(floorNum);
			//}
			
			backgroundLayer.bitmapData = backgroundLayerDatas[floorNum];
			underItemLayer.bitmapData = underItemLayerDatas[floorNum];
			roleLayer.bitmapData = roleLayerDatas[floorNum];
			aboveItemLayer.bitmapData = aboveItemLayerDatas[floorNum];
			
			this.alpha = 0;
			TweenLite.to(this, 1, {alpha:1});
			addChildAt(backgroundLayer, 0);
			addChildAt(underItemLayer, 1)
			addChildAt(roleLayer, 2);
			addChildAt(player, 3);
			addChildAt(aboveItemLayer, 4);
			addChildAt(effectLayer, 5);
			
			floorLock[floorNum] = true;
			
			if(gameProgress["firstEnterFloor" + String(floorNum)] == null) {
				gameProgress["firstEnterFloor" + String(floorNum)] = true;
			}

		}
		
		//移除楼层
		private function removeFloor():void 
		{
			TweenLite.to(this, 0.5, {alpha:0});
			removeChild(backgroundLayer);
			removeChild(underItemLayer);
			removeChild(roleLayer);
			removeChild(player);
			removeChild(aboveItemLayer);
			removeChild(effectLayer);
		}
		
		//读取floor中二维数组
		private function readFloorData(currFloor:int):void {
			
			backgroundArray = floorDataArray[ARRAY_BACKGROUND][currFloor];
			roleArray = floorDataArray[ARRAY_ROLE][currFloor];
			itemArray = floorDataArray[ARRAY_ITEM][currFloor];		
			effectArray = floorDataArray[ARRAY_EFFECT];
			
		}
		

		override public function runGame():void {

			player.walk(keyPressList);			
			renderBackgroundLayer(currFloor, true, 8);
			renderRoleLayer(currFloor, true, 10);
			renderItemLayer(currFloor, itemAnimationLoop, 3);
			renderEffectLayer(effectAnimationLoop, 5);
			updateStatueScreen();
			checkOrder();
			
			
			checkGameProgress();//剧情-----------------------------------------------------------------
		}
		
		private function checkOrder():void {
			if (keyPressList[70] == true) {
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_START, "transmit"));
			} else if (keyPressList[82] == true) {
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_START, "addPoint"));
			} else if (keyPressList[81] == true) {
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_START, "basicFunction"));
			} else if (keyPressList[69] == true) {
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_START, "monsterManual"));
			} else if (keyPressList[71] == true) {
				dispatchEvent(new OrderEvent(OrderEvent.ORDER_START, "instruction"));
			}
		}
		
		public function reloadScreen():void {
			dispatchEvent(new OrderEvent(OrderEvent.ORDER_START, "basicFunction"));	
		}
		

		
		
		
		//刷新角色图层
		private function renderRoleLayer(floorId:int, animationLoop:Boolean, animationDelay:int):void 
		{
			
			if (animationLoop) {
				if (roleAnimationCount > animationDelay) {
					roleAnimationCount = 0;
					var roleLayerData:BitmapData = roleLayerDatas[floorId];
					roleLayerData.lock();
					var blitTile:int;
					var rowCtr:int;
					var colCtr:int;
					
					for (rowCtr = 0;rowCtr < mapRowCount;rowCtr++) {
						for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {
							
							blitTile = roleArray[rowCtr][colCtr];
							if (blitTile > 2) {
								
								var i:int = int(blitTile * roleSheet.tilesPerRowDown);
								tileBlitRectangle.x = (blitTile - i * roleSheet.tilesPerRow) * tileWidth;
								tileBlitRectangle.y = i * tileHeight;

								
								blitPoint.x = colCtr * tileHeight;
								blitPoint.y = rowCtr * tileWidth;
								
								roleLayerData.copyPixels(roleSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
								
								blitTile ++;
								if (blitTile % roleSheet.tilesPerRow == 0) {
									blitTile = blitTile - 3;
								}
								roleArray[rowCtr][colCtr] = blitTile;
							}

						}
					}
					
					roleLayerData.unlock();

					roleLayerDatas[floorId] = roleLayerData;
				}
				roleAnimationCount++;
			}						
		}
		
		
		
		//刷新背景图层
		private function renderBackgroundLayer(floorId:int, animationLoop:Boolean, animationDelay:int):void 
		{
			
			if (animationLoop) {
				if (backgroundAnimationCount > animationDelay) {
					backgroundAnimationCount = 0;
					var backgroundLayerData:BitmapData = backgroundLayerDatas[floorId];
					backgroundLayerData.lock();
					var blitTile:int;
					var rowCtr:int;
					var colCtr:int;
					for (rowCtr = 0;rowCtr < mapRowCount;rowCtr++) {
						for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {
							
							blitTile = backgroundArray[rowCtr][colCtr];
							
							if (tileSheetData.backgroundSheetData[blitTile] == TileSheetData.BACKGROUND_WATER) 
							{
								blitTile = tileSheetData.waterFrame[randRange(0, 2)];
							}
							
							else if (tileSheetData.backgroundSheetData[blitTile] == TileSheetData.BACKGROUND_GLASS) 
							{
								blitTile = tileSheetData.glassFrame[randRange(0, 2)];
							}
							
							else if (tileSheetData.backgroundSheetData[blitTile] == TileSheetData.BACKGROUND_MAGMA) 
							{
								blitTile = tileSheetData.magmaFrame[randRange(0, 2)];
							} else {
								continue;
							}
									
							
							var i:int = int(blitTile * backgroundSheet.tilesPerRowDown);
							tileBlitRectangle.x = (blitTile - i * backgroundSheet.tilesPerRow) * tileWidth;
							tileBlitRectangle.y = i * tileHeight;
							
							blitPoint.x = colCtr * tileHeight;
							blitPoint.y = rowCtr * tileWidth;
							
							backgroundLayerData.copyPixels(backgroundSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
							

						}
					}
					
					backgroundLayerData.unlock();

					backgroundLayerDatas[floorId] = backgroundLayerData;
				}
				backgroundAnimationCount++;
			}						
		}
		
		//刷新物件图层
		private function renderItemLayer(floorId:int, animationLoop:Boolean, animationDelay:int):void 
		{
			
			if (animationLoop) {
				if (itemAnimationCount > animationDelay) {
					itemAnimationCount = 0;
					var underItemLayerData:BitmapData = underItemLayerDatas[floorId];
					underItemLayerData.lock();
					var blitTile:int;
					var rowCtr:int;
					var colCtr:int;

					for (rowCtr = 0;rowCtr < mapRowCount;rowCtr++) {
						for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {
							
							blitTile = itemArray[rowCtr][colCtr];
							
							if (tileSheetData.itemSheetTypeData[blitTile] == TileSheetData.ITEM_SWITCH)  {
								switch(tileSheetData.itemSheetData[blitTile]) {
									case TileSheetData.ITEM_FLOOR_SWITCH1:
										currSwitchFrame = tileSheetData.floorSwitch1Frame;
										break;
									case TileSheetData.ITEM_FLOOR_SWITCH2:
										currSwitchFrame = tileSheetData.floorSwitch2Frame;
										break;
									case TileSheetData.ITEM_FLOOR_SWITCH_TILE:
										currSwitchFrame = tileSheetData.floorSwitchTileFrame;
										break;
									case TileSheetData.ITEM_SWITCH_STICK:
										currSwitchFrame = tileSheetData.switchStickFrame;
										break;
									case TileSheetData.ITEM_SWITCH_PLOT:
										currSwitchFrame = tileSheetData.plotSwitchFrame;
										break;
								}
								renderCurrSwitchState = switchDic[String(currFloor) + String(rowCtr) + String(colCtr)];

								if (renderCurrSwitchState[SWITCH_UP_DOWN] == SWITCH_UP) {
									blitTile--;
									if (blitTile <= currSwitchFrame[0]) {
										blitTile = currSwitchFrame[0];
									}
									itemArray[rowCtr][colCtr] = blitTile;
									
								}
								
								else if (renderCurrSwitchState[SWITCH_UP_DOWN] == SWITCH_DOWN) {
									blitTile++;
									if (blitTile >= currSwitchFrame[currSwitchFrame.length - 1]) {
										blitTile = currSwitchFrame[currSwitchFrame.length - 1];
									}
									itemArray[rowCtr][colCtr] = blitTile;
								}
								
							} 
							else if (tileSheetData.itemSheetTypeData[blitTile] == TileSheetData.ITEM_DOOR) {
								currDoorFrame = [blitTile];
								switch(tileSheetData.itemSheetData[blitTile]) {
									case TileSheetData.ITEM_SWITCH_DOOR:
										currDoorFrame = tileSheetData.switchDoorFrame;
										break;
									case TileSheetData.ITEM_YELLOW_COL_DOOR:
										currDoorFrame = tileSheetData.yellowColDoorFrame;
										break;
									case TileSheetData.ITEM_BLUE_COL_DOOR:
										currDoorFrame = tileSheetData.blueColDoorFrame;
										break;
									case TileSheetData.ITEM_RED_COL_DOOR:
										currDoorFrame = tileSheetData.redColDoorFrame;
										break;
									case TileSheetData.ITEM_YELLOW_ROW_DOOR:
										currDoorFrame = tileSheetData.yellowRowDoorFrame;
										break;
									case TileSheetData.ITEM_BLUE_ROW_DOOR:
										currDoorFrame = tileSheetData.blueRowDoorFrame;
										break;
									case TileSheetData.ITEM_RED_ROW_DOOR:
										currDoorFrame = tileSheetData.redRowDoorFrame;
										break;
								}
								if (doorDic[String(currFloor) + String(rowCtr) + String(colCtr)] == 0) {

									blitTile--;
									if (blitTile <= currDoorFrame[0]) {
										blitTile = currDoorFrame[0];
										gameProgress["checkDoor" + String(currFloor) + String(rowCtr) + String(colCtr)] = null;
										player.keyUsed = false;
									}
									itemArray[rowCtr][colCtr] = blitTile;
									
								}
								
								else if (doorDic[String(currFloor) + String(rowCtr) + String(colCtr)] == 1) {
									blitTile++;
									if (blitTile >= currDoorFrame[currDoorFrame.length - 1]) {
										blitTile = currDoorFrame[currDoorFrame.length - 1];
										player.keyUsed = false;
									}
									itemArray[rowCtr][colCtr] = blitTile;
								}
								
								
							}
							
							var i:int = int(blitTile * itemSheet.tilesPerRowDown);
							tileBlitRectangle.x = (blitTile - i * itemSheet.tilesPerRow) * tileWidth;
							tileBlitRectangle.y = i * tileHeight;
							
							blitPoint.x = colCtr * tileHeight;
							blitPoint.y = rowCtr * tileWidth;
							
							underItemLayerData.copyPixels(itemSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
							
							underItemLayerData.unlock();

							underItemLayerDatas[floorId] = underItemLayerData;
			
						}
					}
				}
				itemAnimationCount++;
			}	

		}
		
		//刷新效果图层
		private function renderEffectLayer(animationLoop:Boolean, animationDelay:int):void 
		{

			if (animationLoop) {

				if (effectAnimationCount > animationDelay) {
					effectAnimationCount = 0;
					effectLayerData.lock();
					var blitTile:int;
					var rowCtr:int;
					var colCtr:int;

					for (rowCtr = 0;rowCtr < mapRowCount;rowCtr++) {
						for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {							
							blitTile = effectArray[rowCtr][colCtr];

							if (tileSheetData.itemSheetTypeData[blitTile] == TileSheetData.ITEM_EFFECT) {
								//trace(blitTile);
								switch(tileSheetData.itemSheetData[blitTile]) {
									case TileSheetData.ITEM_EFFECT_1:
										currEffectFrame = tileSheetData.effect1Frame;
										break;
									case TileSheetData.ITEM_EFFECT_2:
										currEffectFrame = tileSheetData.effect2Frame;
										break;
									case TileSheetData.ITEM_EFFECT_3:
										currEffectFrame = tileSheetData.effect3Frame;
										break;
									case TileSheetData.ITEM_EFFECT_4:
										currEffectFrame = tileSheetData.effect4Frame;
										break;
									case TileSheetData.ITEM_EFFECT_5:
										currEffectFrame = tileSheetData.effect5Frame;
										break;
									case TileSheetData.ITEM_EFFECT_6:
										currEffectFrame = tileSheetData.effect6Frame;
										break;
									case TileSheetData.ITEM_EFFECT_7:
										currEffectFrame = tileSheetData.effect7Frame;
										break;
								}

								blitTile++;
								if (blitTile > currEffectFrame[currEffectFrame.length - 1]) {

									blitTile = 0;
									//effectAnimationLoop = false;// 动画播放完毕后结束刷新
								}
								effectArray[rowCtr][colCtr] = blitTile;
								
								var i:int = int(blitTile * itemSheet.tilesPerRowDown);
								tileBlitRectangle.x = (blitTile - i * itemSheet.tilesPerRow) * tileWidth;
								tileBlitRectangle.y = i * tileHeight;
								
								blitPoint.x = colCtr * tileHeight;
								blitPoint.y = rowCtr * tileWidth;
								
								effectLayerData.copyPixels(itemSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
								
								effectLayerData.unlock(); 
							}
							
						}
					}
				}
				effectAnimationCount++;
			}	

		}
		private function randRange(min:Number, max:Number):Number {

			var randomNum:Number = uint(Math.random() * (max - min + 1)) + min;

			return randomNum;

		}
		

		
		


		//绘制背景图片
		private function drawFloorBackground(floorId:int):void
		{
			
			var backgroundLayerData:BitmapData = new BitmapData(tileWidth * mapColumnCount, tileHeight * mapRowCount, true, 0x00000000);
			backgroundLayerData.lock();
			var blitTile:int;
			var rowCtr:int;
			var colCtr:int;
			for (rowCtr = 0;rowCtr < mapRowCount;rowCtr++) {
				for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {
					
					blitTile = backgroundArray[rowCtr][colCtr];
					
					if (tileSheetData.backgroundSheetData[blitTile] == TileSheetData.BACKGROUND_UPSTAIR) 
					{
						upStairPosition[floorId] = [colCtr, rowCtr];
					}
					
					if (tileSheetData.backgroundSheetData[blitTile] == TileSheetData.BACKGROUND_DOWNSTAIR) 
					{
						downStairPosition[floorId] = [colCtr, rowCtr];
					}
							
					
					var i:int = int(blitTile * backgroundSheet.tilesPerRowDown);
					tileBlitRectangle.x = (blitTile - i * backgroundSheet.tilesPerRow) * tileWidth;
					tileBlitRectangle.y = i * tileHeight;
					
					blitPoint.x = colCtr * tileHeight;
					blitPoint.y = rowCtr * tileWidth;
					
					backgroundLayerData.copyPixels(backgroundSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
					

				}
			}
			
			backgroundLayerData.unlock();
			
			trace("下楼梯位置:   " + downStairPosition[floorId]);
			trace("上楼梯位置:   " + upStairPosition[floorId]);
					
			backgroundLayerDatas[floorId] = backgroundLayerData;
		}
		

		
		
		//绘制角色图片
		private function drawFloorMonster(floorId:int):void
		{
			currFloorMonster = [];
			var roleLayerData:BitmapData = new BitmapData(tileWidth * mapColumnCount, tileHeight * mapRowCount, true, 0x00000000);
			roleLayerData.lock();
			var blitTile:int;
			var rowCtr:int;
			var colCtr:int;
			for (rowCtr = 0;rowCtr < mapRowCount; rowCtr++) {
				for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {
					
					blitTile = roleArray[rowCtr][colCtr];
					if(blitTile > 2) {
						
						var i:int = int(blitTile * roleSheet.tilesPerRowDown);
						if (blitTile >= 15) {
							var monster:Monster = new Monster(i, tileSheetData);
							currFloorMonster[monster.data.id] = monster;
						}
						tileBlitRectangle.x = (blitTile - i * roleSheet.tilesPerRow) * tileWidth;
						tileBlitRectangle.y = i * tileHeight;
						
						blitPoint.x = colCtr * tileHeight;
						blitPoint.y = rowCtr * tileWidth;
						
						roleLayerData.copyPixels(roleSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
					}
				}
			}
			roleLayerData.unlock();
			roleLayerDatas[floorId] = roleLayerData;
		}
		
		//绘制下道具图片
		private function drawFloorItemUnder(floorId:int):void
		{
			
			var underItemLayerData:BitmapData = new BitmapData(tileWidth * mapColumnCount, tileHeight * mapRowCount, true, 0x00000000);
			underItemLayerData.lock();
			var blitTile:int;
			var rowCtr:int;
			var colCtr:int;
			for (rowCtr = 0;rowCtr < mapRowCount;rowCtr++) {
				for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {
					
					blitTile = itemArray[rowCtr][colCtr];
					
					if (tileSheetData.itemSheetTypeData[blitTile] != TileSheetData.ITEM_DECORATION_ABOVE) {
						
						if (tileSheetData.itemSheetTypeData[blitTile] == TileSheetData.ITEM_DOOR) {
							
							currDoorFrame = [blitTile];
							
							switch(tileSheetData.itemSheetData[blitTile]) {
								case TileSheetData.ITEM_SWITCH_DOOR:
									currDoorFrame = tileSheetData.switchDoorFrame;
									break;
								case TileSheetData.ITEM_YELLOW_COL_DOOR:
									currDoorFrame = tileSheetData.yellowColDoorFrame;
									break;
								case TileSheetData.ITEM_BLUE_COL_DOOR:
									currDoorFrame = tileSheetData.blueColDoorFrame;
									break;
								case TileSheetData.ITEM_RED_COL_DOOR:
									currDoorFrame = tileSheetData.redColDoorFrame;
									break;
								case TileSheetData.ITEM_YELLOW_ROW_DOOR:
									currDoorFrame = tileSheetData.yellowRowDoorFrame;
									break;
								case TileSheetData.ITEM_BLUE_ROW_DOOR:
									currDoorFrame = tileSheetData.blueRowDoorFrame;
									break;
								case TileSheetData.ITEM_RED_ROW_DOOR:
									currDoorFrame = tileSheetData.redRowDoorFrame;
									break;

							}
							if(blitTile == currDoorFrame[0]) {
								doorDic[String(currFloor) + String(rowCtr) + String(colCtr)] = DOOR_CLOSE;
							} else if (blitTile == currDoorFrame[currDoorFrame.length - 1]) {
								doorDic[String(currFloor) + String(rowCtr) + String(colCtr)] = DOOR_OPEN;
							} else {
								doorDic[String(currFloor) + String(rowCtr) + String(colCtr)] = DOOR_CHANGE;
							}
						}
						
						else if (tileSheetData.itemSheetTypeData[blitTile] == TileSheetData.ITEM_SWITCH) {
							switchDic[String(currFloor) + String(rowCtr) + String(colCtr)] = [];
							switch(tileSheetData.itemSheetData[blitTile]) {
								case TileSheetData.ITEM_FLOOR_SWITCH1:
									currSwitchFrame = tileSheetData.floorSwitch1Frame;
									break;
								case TileSheetData.ITEM_FLOOR_SWITCH2:
									currSwitchFrame = tileSheetData.floorSwitch2Frame;
									break;
								case TileSheetData.ITEM_FLOOR_SWITCH_TILE:
									currSwitchFrame = tileSheetData.floorSwitchTileFrame;
									break;
								case TileSheetData.ITEM_SWITCH_STICK:
									currSwitchFrame = tileSheetData.switchStickFrame;
									break;
								case TileSheetData.ITEM_SWITCH_PLOT:
									currSwitchFrame = tileSheetData.plotSwitchFrame;
									break;
							}
							if(blitTile == currSwitchFrame[0]) {
								switchDic[String(currFloor) + String(rowCtr) + String(colCtr)][0] = SWITCH_UP;
							} else if (blitTile == currSwitchFrame[currSwitchFrame.length - 1]) {
								switchDic[String(currFloor) + String(rowCtr) + String(colCtr)][0] = SWITCH_DOWN;
							} else {
								switchDic[String(currFloor) + String(rowCtr) + String(colCtr)][0] = SWITCH_CHANGE;
							}
							switchDic[String(currFloor) + String(rowCtr) + String(colCtr)][1] = OUT_SWITCH;
						}
											
						var i:int = int(blitTile * itemSheet.tilesPerRowDown);
						tileBlitRectangle.x = (blitTile - i * itemSheet.tilesPerRow) * tileWidth;
						tileBlitRectangle.y = i * tileHeight;
						
						blitPoint.x = colCtr * tileHeight;
						blitPoint.y = rowCtr * tileWidth;
						
						underItemLayerData.copyPixels(itemSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
					}
				}
			}
			underItemLayerData.unlock();
			
			underItemLayerDatas[floorId] = underItemLayerData;
		}
		
		
				
		//绘制上道具图片
		private function drawFloorItemAbove(floorId:int):void
		{
			
			var aboveItemLayerData:BitmapData = new BitmapData(tileWidth * mapColumnCount, tileHeight * mapRowCount, true, 0x00000000);
			aboveItemLayerData.lock();
			var blitTile:int;
			var rowCtr:int;
			var colCtr:int;
			for (rowCtr = 0;rowCtr<mapRowCount;rowCtr++) {
				for (colCtr = 0; colCtr < mapColumnCount; colCtr++) {
					
					blitTile = itemArray[rowCtr][colCtr];
					if (tileSheetData.itemSheetData[blitTile] == TileSheetData.ITEM_YELLOW_COL_DOOR || tileSheetData.itemSheetData[blitTile] == TileSheetData.ITEM_BLUE_COL_DOOR || tileSheetData.itemSheetData[blitTile] == TileSheetData.ITEM_RED_COL_DOOR) {
						blitTile = tileSheetData.colDoorCover;
					}
					if(tileSheetData.itemSheetTypeData[blitTile] == TileSheetData.ITEM_DECORATION_ABOVE) {
						var i:int = int(blitTile * itemSheet.tilesPerRowDown);
						tileBlitRectangle.x = (blitTile - i * itemSheet.tilesPerRow) * tileWidth;
						tileBlitRectangle.y = i * tileHeight;
						
						blitPoint.x = colCtr * tileHeight;
						blitPoint.y = rowCtr * tileWidth;
						
						aboveItemLayerData.copyPixels(itemSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
					}
				}
			}
			aboveItemLayerData.unlock();
			
			aboveItemLayerDatas[floorId] = aboveItemLayerData;
		}
		

		
//------------------------------------------监听器------------------------------------------------//

	//-----------------------------键盘-----------------------------------//
		//键盘监听器
		private function keyDownListener(e:KeyboardEvent):void {
			keyPressList[e.keyCode] = true;	
		}
		
		
		private function keyUpListener(e:KeyboardEvent):void {
			keyPressList[e.keyCode] = false;
		}
		
		
		//添加删除键盘监听器
		private function removeKeyListener():void {
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			keyPressList = [];
		}
		
		private function addKeyListener():void {
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Global.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		
		
	//-----------------------------------自定义事件监听器-----------------------------------------//
		//更新楼层监听器
		private function updataFloorListener(e:FloorEvent):void 
		{
			removeFloor();
			currFloor = e.floorId;
			player.currFloor = e.floorId;
			updataFloor(e.floorId);
			if (player.upFloor == true) {
				player.upFloor = false;
				restartPlayer(true);
			}
			
			if (player.downFloor == true) {
				player.downFloor = false;
				restartPlayer(false);

			}
			player.switchMovement(Player.MOVE_STOP);
			
		}
		
		//战斗开始监听器
		private function fightStartListener(e:FightEvent):void 
		{
			trace("战斗开始");
			var monsterRow:int = (roleArray[e.visitMonsterRow][e.visitMonsterCol] / 3);
			beAttackMonster = new Monster(monsterRow, tileSheetData);

			if (keyPressList[65] == true || e.fightType == "auto") {
				if (gameProgress["firstFight"] == null) {
					dispatchEvent(new OrderEvent(OrderEvent.ORDER_START, "instruction"));
					gameProgress["firstFight"] = true;
				} else {
					fight = new FightDemo(player, beAttackMonster, e.visitMonsterRow, e.visitMonsterCol, tileSheetData);
					fight.x = 50;
					fight.y = 0;
				}
			} else if (keyPressList[32] == true) {
				fight = new Fight(player, beAttackMonster, e.visitMonsterRow, e.visitMonsterCol, tileSheetData);
				fight.x = 140;
				fight.y = 60;
			} else if (keyPressList[67] == true) {
				
				fight = new FightCompare(player, beAttackMonster, e.visitMonsterRow, e.visitMonsterCol, tileSheetData);

				fight.x = 240;
				fight.y = 60;
			}
			
			
			removeKeyListener();
			
			if(fight != null) {
				fight.alpha = 0;
				TweenLite.to(fight, 0.8, { alpha:1, ease:Quint.easeOut } );
				Global.stage.addChild(fight);
				fight.addEventListener(FightEvent.FIGHT_OVER, fightOverListener);
			}
			

		}
		
		//战斗结束监听器
		private function fightOverListener(e:FightEvent):void 
		{
			if (e.fightFlee == false) {
				roleArray[e.visitMonsterRow][e.visitMonsterCol] = 0;
				removeTile(roleLayerDatas[currFloor], e.visitMonsterCol, e.visitMonsterRow, roleSheet);
			}
			Global.stage.removeChild(fight);
			fight.disposeText();
			fight = null;
			addKeyListener();
			e.target.removeEventListener(FightEvent.FIGHT_OVER, fightOverListener);
			if (gameProgress["monster" + String(currFloor) + String(e.visitMonsterRow) + String(e.visitMonsterCol) + "Over"] == null && e.fightFlee == false) {
				gameProgress["monster" + String(currFloor) + String(e.visitMonsterRow) + String(e.visitMonsterCol) + "Over"] = true;
			}
			//trace(player.data.HP);
			
		}
		//谈话开始监听器
		private function chatStartListener(e:ChatEvent):void
		{
			trace("谈话开始");
			if (chat != null && Global.stage.contains(chat)) {
				chat.removeKeyListener();
				Global.stage.removeChild(chat);
				chat = null;
			}
			if(e.chatType == "manual") {
				beChatNPC = new NPC(e.chatNum, tileSheetData);
				chat = new Chat( e.chatType, chatContentData, tileSheetData, beChatNPC);
			} else if (e.chatType == "auto") {
				chat = new Chat( e.chatType, chatContentData, tileSheetData, null, e.chatNum);
			}
			removeKeyListener();
			chat.alpha = 0;
			
			chat.x = 280;
			chat.y = 280;
			TweenLite.to(chat, 0.8, { alpha:1, ease:Quint.easeOut } );
			Global.stage.addChild(chat);
			chat.addEventListener(ChatEvent.CHAT_OVER, chatOverListener);
		}
		
		private function chatOverListener(e:ChatEvent):void 
		{
			if(chat != null) {
				Global.stage.removeChild(chat);
			}
			//chat.dispose();
			chat = null;
			addKeyListener();
			e.target.removeEventListener(ChatEvent.CHAT_OVER, chatOverListener);
			if (gameProgress["chatContentId" + e.chatType  + "Over"] == null) {
				gameProgress["chatContentId" + e.chatType  + "Over"] = true;
			}
		}

		//捡东西监听器
		private function pickListener(e:PickEvent):void 
		{
			itemArray[player.currRow][player.currCol] = 0;
			//effectArray[player.currRow][player.currCol] = tileSheetData.effect6Frame[0];
			//effectAnimationLoop = true;
			//removeTile(underItemLayerDatas[currFloor], player.currCol, player.currRow, itemSheet);
			
			switch(e.itemType) {
				case TileSheetData.ITEM_BLUE_DRUG:
					player.data.HP += 50;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_DRUG, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "生命值加 50",0,0.8,false));
					break;
				case TileSheetData.ITEM_GREEN_DRUG:
					player.data.HP += 20;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_DRUG, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "生命值加 20",0,0.8,false));
					break;
				case TileSheetData.ITEM_RED_DRUG:
					player.data.HP += 100;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_DRUG, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "生命值加 100",0,0.8,false));
					break;
				case TileSheetData.ITEM_YELLOW_KEY:
					player.data.YellowKeyNum += 1;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_KEY, false, 1, 0, 0.7));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得黄钥匙",0,0.8,false));
					break;
				case TileSheetData.ITEM_RED_KEY:
					player.data.RedKeyNum += 1;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_KEY, false, 1, 0, 0.7));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得红钥匙",0,0.8,false));
					break;
				case TileSheetData.ITEM_BLUE_KEY:
					player.data.BlueKeyNum += 1;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_KEY, false, 1, 0, 0.7));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得蓝钥匙",0,0.8,false));
					break;
				case TileSheetData.ITEM_GEM_RED:
					player.data.STR += 5;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_GEM1, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "红宝石 攻击力加5",0,1.2,false));
					break;
				case TileSheetData.ITEM_GEM_BLUE:
					player.data.DEF += 5;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_GEM1, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "蓝宝石 防御力加5",0,1.2,false));
					break;
				case TileSheetData.ITEM_GEM_WHITE:
					player.data.DEF += 10;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_GEM2, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "白玉宝石 防御力加10",0,1.2,false));
					break;
				case TileSheetData.ITEM_GEM_BLACK:
					player.data.STR += 10;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_GEM2, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "暗黑宝石 攻击力加10",0,1.2,false));
					break;
				case TileSheetData.ITEM_GEM_SPRITE1:
					gameProgress["switch214Down"] = null;
					gameProgress["getGemSprite1"] = true;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_GEM3, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "获得灵魂宝石",0,1.2,false));
					break;
				case TileSheetData.ITEM_GEM_SPRITE2:
					gameProgress["switch216Down"] = null;
					gameProgress["getGemSprite2"] = true;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_GEM3, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得灵魂宝石",0,1.2,false));
					break;
				case TileSheetData.ITEM_GEM_SPRITE3:
					gameProgress["switch205Down"] = null;
					gameProgress["getGemSprite3"] = true;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_PICK_GEM3, false, 1, 0, 0.4));
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得灵魂宝石",0,1.2,false));
					break;
				case TileSheetData.ITEM_EQUIP_SWORD_1:
					if (player.goods["sword"] < TileSheetData.ITEM_EQUIP_SWORD_1) {
						player.goods["sword"] = TileSheetData.ITEM_EQUIP_SWORD_1;
						player.data.STR += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "获得铁剑 攻击加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_SWORD, null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_SWORD_1, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_SWORD_1){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有铁剑",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_SWORD_2:
					if (player.goods["sword"] < TileSheetData.ITEM_EQUIP_SWORD_2) {
						player.goods["sword"] = TileSheetData.ITEM_EQUIP_SWORD_2;
						player.data.STR += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "暗黑之剑 攻击加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_SWORD_2, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_SWORD_2){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有暗黑之剑",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_SWORD_3:
					if (player.goods["sword"] < TileSheetData.ITEM_EQUIP_SWORD_3) {
						player.goods["sword"] = TileSheetData.ITEM_EQUIP_SWORD_3;
						player.data.STR += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "战争之剑 攻击加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_SWORD_3, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_SWORD_3){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有战争之剑",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_SWORD_4:
					if (player.goods["sword"] < TileSheetData.ITEM_EQUIP_SWORD_4) {
						player.goods["sword"] = TileSheetData.ITEM_EQUIP_SWORD_4;
						player.data.STR += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "光之剑 攻击加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_SWORD_4, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_SWORD_4){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有光之剑",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_SWORD_5:
					if (player.goods["sword"] < TileSheetData.ITEM_EQUIP_SWORD_5) {
						player.goods["sword"] = TileSheetData.ITEM_EQUIP_SWORD_5;
						player.data.STR += 10;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "审判之剑 攻击加10",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_SWORD,null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_SWORD_5, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_SWORD_5){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有审判之剑",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_ARMOUR_1:
					if (player.goods["equip"] < TileSheetData.ITEM_EQUIP_ARMOUR_1) {
						player.goods["equip"] = TileSheetData.ITEM_EQUIP_ARMOUR_1;
						player.data.DEF += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "获得皮甲 防御加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE,AddId.SCREEN_STATUS_IMAGE_ARMOUR,null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_ARMOUR_1, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_ARMOUR_1){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有皮甲",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_ARMOUR_2:
					if (player.goods["equip"] < TileSheetData.ITEM_EQUIP_ARMOUR_2) {
						player.goods["equip"] = TileSheetData.ITEM_EQUIP_ARMOUR_2;
						player.data.DEF += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得板甲 防御加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_ARMOUR_2, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_ARMOUR_2){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有板甲",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_ARMOUR_3:
					if (player.goods["equip"] < TileSheetData.ITEM_EQUIP_ARMOUR_3) {
						player.goods["equip"] = TileSheetData.ITEM_EQUIP_ARMOUR_3;
						player.data.DEF += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "锁子甲 防御加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_ARMOUR_3, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_ARMOUR_3){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有锁子甲",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_ARMOUR_4:
					if (player.goods["equip"] < TileSheetData.ITEM_EQUIP_ARMOUR_4) {
						player.goods["equip"] = TileSheetData.ITEM_EQUIP_ARMOUR_4;
						player.data.DEF += 5;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "凯撒铁甲 防御加5",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_ARMOUR_4, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_ARMOUR_4){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有凯撒铁甲",0,1.2,false));
					}
					break;
				case TileSheetData.ITEM_EQUIP_ARMOUR_5:
					if (player.goods["equip"] < TileSheetData.ITEM_EQUIP_ARMOUR_5) {
						player.goods["equip"] = TileSheetData.ITEM_EQUIP_ARMOUR_5;
						player.data.DEF += 10;
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "亚瑟金甲 防御加10",0,1.2,false));
						dispatchEvent(new StatusScreenUpdateEvent(StatusScreenUpdateEvent.UPDATE, AddId.SCREEN_STATUS_IMAGE_ARMOUR, null, searchTileBitmapData(TileSheetData.ITEM_EQUIP_ARMOUR_5, itemSheet, tileSheetData.itemSheetData)));
					} else if(player.goods["equip"] > TileSheetData.ITEM_EQUIP_ARMOUR_5){
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您拥有更强的装备",0,1.2,false));
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "您已拥有亚瑟金甲",0,1.2,false));
					}
					break;
			}
		}
		
		//开关监听器
		private function switchListener(e:SwitchEvent):void 
		{
			var row:int;
			var col:int;
			if (e.switchType == "face") {
				currSwitchState = switchDic[String(currFloor) + String(player.faceNextRow) + String(player.faceNextCol)];
				row = player.faceNextRow;
				col = player.faceNextCol;
			} else if(e.switchType == "floor") {
				currSwitchState = switchDic[String(currFloor) + String(player.currRow) + String(player.currCol)];
				row = player.currRow;
				col = player.currCol;
			}
			if(currSwitchState[SWITCH_ON_OUT] == OUT_SWITCH) {
				if (e.visitItemSheetData == TileSheetData.ITEM_FLOOR_SWITCH_TILE || e.visitItemSheetData == TileSheetData.ITEM_SWITCH_STICK) {
					if (currSwitchState[SWITCH_UP_DOWN] == SWITCH_UP) {
						currSwitchState[SWITCH_UP_DOWN] = SWITCH_DOWN;
					}else if (currSwitchState[SWITCH_UP_DOWN] == SWITCH_DOWN) {
						currSwitchState[SWITCH_UP_DOWN] = SWITCH_UP;
					}

				}else {
					if(currSwitchState[SWITCH_UP_DOWN] == SWITCH_UP) {
						currSwitchState[SWITCH_UP_DOWN] = SWITCH_DOWN;
						
					}
				}
				if ((String(currFloor) + String(row) + String(col)) == "395") {
					floorDataArray[ARRAY_ROLE][3][1][5] = 0;
					floorDataArray[ARRAY_ITEM][3][1][5] = 0;
					removeTile(roleLayerDatas[3], 5, 1, roleSheet);
					removeTile(underItemLayerDatas[3], 5, 1, itemSheet);
				}
				switchGear = new Switch((String(currFloor) + String(row) + String(col)),switchDic, doorDic, floorDataArray, gameProgress);
				currSwitchState[SWITCH_ON_OUT] = ON_SWITCH;
			}
			
			if (gameProgress["switch"  +  String(currFloor) + String(row) + String(col) + "Down"] == null && switchDic[String(currFloor) + String(row) + String(col)][SWITCH_UP_DOWN] == SWITCH_DOWN) 
			{
				gameProgress["switch"  +  String(currFloor) + String(row) + String(col) + "Down"] = true;
			}
			if (gameProgress["switch441Down"] == true) {
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS, "auto", "2层的铁门打开",0,1.2,false));
				gameProgress["switch441Down"] = false;
			}

		}
		
		//钥匙开门监听器
		private function doorListener(e:DoorEvent):void 
		{
			if (gameProgress["checkDoor" + String(currFloor) + String(player.faceNextRow) + String(player.faceNextCol)] == null) {
				gameProgress["checkDoor" + String(currFloor) + String(player.faceNextRow) + String(player.faceNextCol)] = true;
			}
			if(player.keyUsed == false) {
			
				if (itemArray[player.faceNextRow][player.faceNextCol] == tileSheetData.yellowColDoorFrame[0] || itemArray[player.faceNextRow][player.faceNextCol] == tileSheetData.yellowRowDoorFrame[0]) {
					if(player.data.YellowKeyNum > 0) {
						player.data.YellowKeyNum--;
						dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_DOOR_OPEN, false, 1, 0, 0.8));
						doorDic[String(currFloor) + String(player.faceNextRow) + String(player.faceNextCol)] = 1;
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "无黄钥匙",0,1.2,false));
					}
				} 
				else if (itemArray[player.faceNextRow][player.faceNextCol] == tileSheetData.blueColDoorFrame[0] || itemArray[player.faceNextRow][player.faceNextCol] == tileSheetData.blueRowDoorFrame[0]) {
					if( player.data.BlueKeyNum > 0) {
						player.data.BlueKeyNum--;
						dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_DOOR_OPEN, false, 1, 0, 0.8));
						doorDic[String(currFloor) + String(player.faceNextRow) + String(player.faceNextCol)] = 1;
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "无蓝钥匙",0,1.2,false));
					}
				}
				else if (itemArray[player.faceNextRow][player.faceNextCol] == tileSheetData.redColDoorFrame[0] || itemArray[player.faceNextRow][player.faceNextCol] == tileSheetData.redRowDoorFrame[0]) {
					if( player.data.RedKeyNum > 0) {
						player.data.RedKeyNum--;
						dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_DOOR_OPEN, false, 1, 0, 0.8));
						doorDic[String(currFloor) + String(player.faceNextRow) + String(player.faceNextCol)] = 1;
					} else {
						dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "无红钥匙",0,1.2,false));
					}
				}
				player.keyUsed = true;
			}
			
		}
		//提示监听器
		private function newsListener(e:NewsEvent):void 
		{
			if (gameProgress["news" + String(e.visitItemId) + "Open"] == null) {
				gameProgress["news" + String(e.visitItemId) + "Open"] = true;
			}
			if (news != null) {
				Global.stage.removeChild(news);
				news = null;
			}
			news = new News(tileSheetData, e.newsType, e.newsContent,e.visitItemId,e.lastTime,e.removeKey);

			if(e.removeKey) {
				removeKeyListener();
			}
			news.alpha = 0;

			TweenLite.to(news, 0.8, { alpha:1, ease:Quint.easeOut } );
			Global.stage.addChild(news);
			news.addEventListener(NewsEvent.READ_NEWS_OVER, newsOverListener);
		}
		//提示关闭
		private function newsOverListener(e:NewsEvent):void 
		{
			if (e.removeKey) {
				addKeyListener();
			}
			if (news != null) {
				Global.stage.removeChild(news);
				news = null;
			}			
			e.target.removeEventListener(NewsEvent.READ_NEWS_OVER, newsOverListener);
		}
		
		//命令监听器
		private function orderListener(e:OrderEvent):void 
		{
			dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_MENU_OPEN, false, 1, 0,0.3));
			removeKeyListener();
			if (e.orderType == "transmit") {
				transmit = new Transmit(currFloor,floorLock, tileSheetData);
				transmit.alpha = 0;
				transmit.x = 240;
				transmit.y = 60;
				TweenLite.to(transmit, 0.8, { alpha:1, ease:Quint.easeOut } );
				Global.stage.addChild(transmit);
				transmit.addEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			} else if(e.orderType == "addPoint") {
				addPoint = new AddPoint(player, tileSheetData);
				addPoint.alpha = 0;
				addPoint.x = 240;
				addPoint.y = 60;
				TweenLite.to(addPoint, 0.8, { alpha:1, ease:Quint.easeOut } );
				Global.stage.addChild(addPoint);
				addPoint.addEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			} else if (e.orderType == "basicFunction") {
				basicFunction = new BasicFunction(tileSheetData);
				basicFunction.alpha = 0;
				basicFunction.x = 240;
				basicFunction.y = 60;
				TweenLite.to(basicFunction, 0.8, { alpha:1, ease:Quint.easeOut } );
				Global.stage.addChild(basicFunction);
				basicFunction.addEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			} else if (e.orderType == "monsterManual") {
				monsterManual = new MonsterManual(currFloorMonster, tileSheetData);
				monsterManual.alpha = 0;
				monsterManual.x = 170;
				monsterManual.y = 10;
				TweenLite.to(monsterManual, 0.8, { alpha:1, ease:Quint.easeOut } );
				Global.stage.addChild(monsterManual);
				monsterManual.addEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			} else if (e.orderType == "instruction") {
				instruction = new Instruction(tileSheetData);
				instruction.alpha = 0;
				instruction.x = 50;
				instruction.y = 0;
				TweenLite.to(instruction, 0.8, { alpha:1, ease:Quint.easeOut } );
				Global.stage.addChild(instruction);
				instruction.addEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			}
		}
		//命令关闭
		private function orderOverListener(e:OrderEvent):void 
		{
			addKeyListener();
			if (e.orderType == "transmitQuit") {
				Global.stage.removeChild(transmit);
				transmit = null;			
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);

			} 
			else if (e.orderType == "transmitOver")
			{
				if (e.orderId > currFloor) {
					player.upFloor = true;
					player.isTransmit = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, e.orderId));
				} else if (e.orderId < currFloor) {
					player.downFloor = true;
					player.isTransmit = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, e.orderId));
				} else {
					
				}
				Global.stage.removeChild(transmit);
				transmit = null;			
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			}
			else if (e.orderType == "addPointQuit" || e.orderType == "addPointOver")
			{
				Global.stage.removeChild(addPoint);
				addPoint = null;			
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			}
			else if (e.orderType == "basicFunctionQuit") {
				Global.stage.removeChild(basicFunction);
				basicFunction = null;			
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			}
			else if (e.orderType == "load") {
				if (player.isChangeFloor == true) {
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "不能在楼梯口存档"));
				} else {
					
					loadId = e.orderId;
					loadTitle = "Tower" + String(e.orderId);
					
					/*
					gameFile = { };
					gameFile["floorLock"] = floorLock;
					gameFile["floorDataArray"] = floorDataArray;
					gameFile["playerX"] = player.x;
					gameFile["playerY"] = player.y;
					gameFile["playerDirection"] = player.faceDirection;
					gameFile["playerDataHP"] = player.data.HP;
					gameFile["playerDataSTR"] = player.data.STR;
					gameFile["playerDataDEF"] = player.data.DEF;
					gameFile["gameProgress"] = gameProgress;
					gameFile["currFloor"] = currFloor;
					gameFile["npcStartContentIdArray"] = chatContentData.npcStartContentIdArray;
					gameFile["RedKeyNum"] = player.data.RedKeyNum;
					gameFile["BlueKeyNum"] = player.data.BlueKeyNum;
					gameFile["playerGoods"] = player.goods;
					gameFile["switchDic"] = switchDic;
					gameFile["doorDic"] = doorDic;
					
					
					saveData(loadTitle, gameFile, false, loadId);
					*/
					
					
					SCookie.setCookie(loadTitle, "floorLock", floorLock);
					SCookie.setCookie(loadTitle, "floorDataArray", floorDataArray);
					SCookie.setCookie(loadTitle, "playerX", player.x);
					SCookie.setCookie(loadTitle, "playerY", player.y);
					SCookie.setCookie(loadTitle, "playerDirection", player.faceDirection);
					SCookie.setCookie(loadTitle, "playerDataHP", player.data.HP);
					SCookie.setCookie(loadTitle, "playerDataSTR", player.data.STR);
					SCookie.setCookie(loadTitle, "playerDataDEF", player.data.DEF);
					SCookie.setCookie(loadTitle, "gameProgress", gameProgress);
					SCookie.setCookie(loadTitle, "currFloor", currFloor);				
					SCookie.setCookie(loadTitle, "npcStartContentIdArray", chatContentData.npcStartContentIdArray);
					SCookie.setCookie(loadTitle, "RedKeyNum", player.data.RedKeyNum);	
					SCookie.setCookie(loadTitle, "YellowKeyNum", player.data.YellowKeyNum);
					SCookie.setCookie(loadTitle, "BlueKeyNum", player.data.BlueKeyNum);
					SCookie.setCookie(loadTitle, "playerGoods", player.goods);
					SCookie.setCookie(loadTitle, "switchDic", switchDic);
					SCookie.setCookie(loadTitle, "doorDic", doorDic);
					
					//SCookie.clearCookie(loadTitle);
					
					
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "存档成功"));
					
					
				}
				
				Global.stage.removeChild(basicFunction);
				basicFunction = null;			
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
				
			}
			
			else if (e.orderType == "reload") {
				loadId = e.orderId;
				loadTitle = "Tower" + String(e.orderId);
				
				//getData(false, loadId);
				reloadGame();
				Global.stage.removeChild(basicFunction);
				basicFunction = null;			
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			}
			else if (e.orderType == "back") {
				removeKeyListener();
				dispatchEvent(new Event(Game.BACK_TO_TITLE));
				Global.stage.removeChild(basicFunction);
				basicFunction = null;			
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			}
			else if (e.orderType == "monsterManualQuit") {
				Global.stage.removeChild(monsterManual);
				monsterManual = null;
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			} 
			else if (e.orderType == "instructionQuit") {
				Global.stage.removeChild(instruction);
				instruction = null;
				e.target.removeEventListener(OrderEvent.ORDER_OVER, orderOverListener);
			}
		}
		
		
		
		
		//根据类型获得相关的图片信息
		private function searchTileBitmapData(type:int, searchTileSheet:TileSheet, searchTileSheetData:Array):BitmapData {
			var blitTile:int;
			blitTile = searchTileSheetData.indexOf(type);
			var bitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
			var blitPoint:Point = new Point();
			var tileBlitRectangle:Rectangle = new Rectangle(0, 0, 40, 40);
			var i:int = int(blitTile * itemSheet.tilesPerRowDown);
			tileBlitRectangle.x = (blitTile - i * itemSheet.tilesPerRow) * tileWidth;
			tileBlitRectangle.y = i * tileHeight;
			
			blitPoint.x = 0;
			blitPoint.y = 0;
						
			bitmapData.copyPixels(searchTileSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
			
			return bitmapData;
		}
		
		//删除特定图层的图片信息
		private function removeTile(layerData:BitmapData, col:int, row:int, tileSheet:TileSheet) {
			layerData.lock();
			tileBlitRectangle.x = 0;
			tileBlitRectangle.y = 0;
			blitPoint.x = col * tileHeight;
			blitPoint.y = row * tileWidth;
			layerData.copyPixels(tileSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
			layerData.unlock();
		}
		//修改特定图层的图片信息
		private function changeTile(layerData:BitmapData, blitTile:int, col:int, row:int, tileSheet:TileSheet ) {
			layerData.lock();
			var i:int = int(blitTile * tileSheet.tilesPerRowDown);
			tileBlitRectangle.x = (blitTile - i * tileSheet.tilesPerRow) * tileWidth;
			tileBlitRectangle.y = i * tileHeight;
			blitPoint.x = col * tileHeight;
			blitPoint.y = row * tileWidth;
			layerData.copyPixels(tileSheet.sourceBitmapData, tileBlitRectangle, blitPoint);
			layerData.unlock();
		}
		
		
		
		
		private function saveData(title:String, data:Object, needUI:Boolean = true, index:int = 0):void
		{
			var canOpen:Boolean = true;

			if (canOpen)
			{
				_mainHold.saveData(title, data, needUI, index);
			}
		}
		
		public function getData(needUI:Boolean = true, index:int = 0):void
		{			
			_mainHold.getData(needUI, index);
		}
		
		private function openSaveUI():void
		{
			var canOpen:Boolean = true;
			
			
			if (canOpen)
			{
				//_mainHold.openSaveUI(_saveTitleTxt.text, _saveDataTxt.text);
			}
		}
		
		public function saveDataReturn(bol:Boolean):void
		{
			if (bol == true) {
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "存档成功"));
			} else {
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "存档失败"));
			}
		}
		
		public function getDataReturn(obj:Object):void
		{
			gameFile = obj;
			reloadGame();
		}
		
		public function logReturn(uid:String, name:String):void
		{
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function checkGameProgress():void
		{
			
			if (gameProgress["floor0plot1"] == true) {            // 塔外          第一个剧情
				if (gameProgress["firstEnterFloor0"] == true) {    
					removeKeyListener();
					TweenLite.delayedCall(1, waitCompleteAutoChat);				
					gameProgress["firstEnterFloor0"] = false;
				}else if (gameProgress["chatContentId2Over"] == true) {
					removeKeyListener();
					blackScreen = new Bitmap(tileSheetData.imageLibrary["blackScreen"]);
					blackScreen.alpha = 0;
					TweenLite.to(blackScreen, 1.5, { alpha:1, ease:Quint.easeOut, onComplete:waitCompleteAutoChat} );
					Global.stage.addChild(blackScreen);
					
					gameProgress["chatContentId2Over"] = false;
				}
				else if (gameProgress["chatContentId9Over"] == true) {  
					removeKeyListener();
					TweenLite.to(blackScreen, 1.5, { alpha:0, ease:Quint.easeOut, onComplete:waitCompleteAutoChat} );
					gameProgress["chatContentId9Over"] = false;
				}
				else if (gameProgress["chatContentId11Over"] == true) {
					removeKeyListener();
					TweenLite.to(blackScreen, 1.5, { alpha:1, ease:Quint.easeOut, onComplete:waitCompleteAutoChat} );
					gameProgress["chatContentId11Over"] = false;
				}
				else if (gameProgress["chatContentId18Over"] == true) {
					removeKeyListener();
					TweenLite.to(blackScreen, 1.5, { alpha:0, ease:Quint.easeOut, onComplete:waitComplete1} );
					gameProgress["chatContentId18Over"] = false;
				}
			} else if (gameProgress["floor1plot1"] == true) {
				if(gameProgress["switch135Down"] == true) {        //    第一层         遇到精灵
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "manual", 2));
					gameProgress["switch135Down"] = false;
					
				}else if (gameProgress["chatContentId46Over"] == true) {
					removeKeyListener();
					roleArray[2][5] = 0;
					removeTile(roleLayerDatas[currFloor], 5, 2, roleSheet);
					effectAnimationLoop = true;
					effectArray[2][5] = tileSheetData.effect4Frame[0];
					effectArray[2][4] = tileSheetData.effect6Frame[0];
					effectArray[2][6] = tileSheetData.effect6Frame[0];
					itemArray[2][4] = 51;
					itemArray[2][6] = 56;
					TweenLite.delayedCall(2, waitComplete2);
					gameProgress["chatContentId46Over"] = false;
				}
			} else if (gameProgress["floor2plot1"] == true) {  //    第二层  
				if (gameProgress["firstEnterFloor2"] == true && currFloor == 2) {  // 刚进二层
					removeKeyListener();
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					gameProgress["firstEnterFloor2"] = false;
				} else if (gameProgress["chatContentId65Over"] == true) {
					removeKeyListener();
					TweenLite.delayedCall(1, waitComplete3);
					gameProgress["chatContentId65Over"] = false;
				}
			} else if (gameProgress["floor3plot1"] == true) {
				
				if (gameProgress["firstEnterFloor3"] == true && currFloor == 3) {
					blackCover = new Bitmap(tileSheetData.imageLibrary["blackCoverPng"]);
					this.addChild(blackCover);
					gameProgress["blackCover"] = true;
					gameProgress["blackCoverAdd"] = true;
					removeKeyListener();
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					gameProgress["firstEnterFloor3"] = false;
				} else if (gameProgress["blackCover"] == true) {
					if (currFloor != 3 && gameProgress["blackCoverAdd"] == true) {
						this.removeChild(blackCover);
						gameProgress["blackCoverAdd"] = false;
					} else if(currFloor == 3 && gameProgress["blackCoverAdd"] == false) {
						this.addChild(blackCover);
						gameProgress["blackCoverAdd"] = true;
					}
				}
				if (gameProgress["switch3210Down"] == true) {
					gameProgress["blackCover"] = false;
					gameProgress["blackCoverAdd"] = false;
					this.removeChild(blackCover);					
					gameProgress["switch3210Down"] = false;
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["floor3plot1"] = false;
					gameProgress["floor6plot1"] = true;//触发floor6的剧情
				}
				//gameProgress["floor3plot1"] = true;
			} else if (gameProgress["floor6plot1"] == true) {
				if (gameProgress["switch635Down"] == true) {
					//player.stopFight = true;
					removeKeyListener();
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["switch635Down"] = false;
				} else if (gameProgress["chatContentId139Over"] == true) {
					removeKeyListener();
					gameProgress["chatContentId139Over"] = false;
					dispatchEvent(new FightEvent(FightEvent.FIGHT_START, 2, 5, false, "auto"));
				} else if (gameProgress["monster625Over"] == true) {
					removeKeyListener();
					effectAnimationLoop = true;
					effectArray[2][5] = tileSheetData.effect1Frame[0];
					itemArray[2][5] = 129;
					TweenLite.delayedCall(3, waitComplete4);
					gameProgress["monster625Over"] = false;
				}
				
				
			} else if (gameProgress["floor2plot2"] == true) {
				
				if (gameProgress["checkDoor615"] == true && doorDic["615"] == DOOR_CLOSE) {
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 57));
					gameProgress["checkDoor615"] = null;
				}
								
				if (gameProgress["switch214Down"] == true && gameProgress["getGemSprite1"]) {
					removeKeyListener();
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["switch214Down"] = false;
				} else if (gameProgress["chatContentId163Over"] == true) {
					removeKeyListener();
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_ADD_STONE, false, 1, 0, 0.2));
					TweenLite.delayedCall(2, waitComplete5);
					gameProgress["chatContentId163Over"] = false;
				} else if (gameProgress["chatContentId183Over"] == true) {
					removeKeyListener();
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					effectArray[0][5] = tileSheetData.effect4Frame[0];
					roleArray[0][5] = 6;
					gameProgress["chatContentId183Over"] = false;
				} else if (gameProgress["chatContentId194Over"] == true) {
					removeKeyListener();
					TweenLite.delayedCall(2, waitComplete6);
					effectArray[0][5] = tileSheetData.effect4Frame[0];
					roleArray[0][5] = 0;
					removeTile(roleLayerDatas[currFloor], 5, 0, roleSheet);
					removeTile(roleLayerDatas[currFloor], 5, 1, roleSheet);
					effectArray[1][5] = tileSheetData.effect6Frame[0];
					roleArray[1][5] = 0;
					gameProgress["chatContentId194Over"] = false;
				} 
				
				
				
			} else if (gameProgress["floor9plot1"] == true) {
				if (gameProgress["switch919Down"] == true) {
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["switch919Down"] = false;
					
				} else if (gameProgress["chatContentId204Over"] == true)  {
					floorDataArray[ARRAY_ROLE][2][6][5] = 3;
					floorDataArray[ARRAY_ITEM][2][8][5] = 137;
					switchDic["285"] = [0, 0];
					switchDic["216"] = [0, 0];
					floorDataArray[ARRAY_ITEM][2][1][6] = 137;
					gameProgress["chatContentId204Over"] = false;
					gameProgress["floor2plot3"] = true;// 触发floor2的第三个剧情
					gameProgress["floor9plot1"] = false;
				}
				
			
			} else if (gameProgress["floor2plot3"] == true) {
				if (gameProgress["checkDoor984"] == true && doorDic["984"] == DOOR_CLOSE) {
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 57));
					gameProgress["checkDoor984"] = null;
				}				
				if (gameProgress["switch285Down"] == true) {
					removeKeyListener();
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["switch285Down"] = false;
				} else if (gameProgress["chatContentId220Over"] == true) {
					floorDataArray[ARRAY_ROLE][2][6][5] = 0;
					removeTile(roleLayerDatas[2], 5, 6, roleSheet);
					effectAnimationLoop = true;
					effectArray[6][5] = tileSheetData.effect1Frame[0];
					gameProgress["chatContentId220Over"] = false;
				} else if (gameProgress["switch216Down"] == true && gameProgress["getGemSprite2"]) {
					removeKeyListener();
					TweenLite.delayedCall(2, waitComplete5);
					gameProgress["switch216Down"] = false;
				} else if (gameProgress["chatContentId242Over"] == true) {
					removeKeyListener();
					TweenLite.delayedCall(2, waitComplete7);
					roleArray[1][5] = 0;
					effectArray[1][5] = tileSheetData.effect6Frame[0];
					removeTile(roleLayerDatas[currFloor], 5, 1, roleSheet);
					
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "9层的铁门打开",0,1.2,false));
					doorDic["984"] = DOOR_OPEN;      // 剧情后自动开门
					floorDataArray[ARRAY_ITEM][9][8][4] = 17;
					removeTile(underItemLayerDatas[9], 4, 8, itemSheet);
					
					floorDataArray[ARRAY_ITEM][11][9][0] = 137;
					gameProgress["chatContentId242Over"] = false;
				}
				
			} else if (gameProgress["floor11plot1"] == true) {
				if (gameProgress["switch1190Down"] == true) {
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["switch1190Down"] = false;
				} else if (gameProgress["chatContentId251Over"] == true ) {
					floorDataArray[ARRAY_ITEM][2][0][5] = 137;
					switchDic["205"] = [0, 0];					
					gameProgress["chatContentId251Over"] = false;
					gameProgress["floor2plot4"] = true;// 触发floor2的第四个剧情
					gameProgress["floor11plot1"] = false;
				}
							
			} else if (gameProgress["floor2plot4"] == true) {
				if (gameProgress["checkDoor1175"] == true && doorDic["1175"] == DOOR_CLOSE) {
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 57));
					gameProgress["checkDoor1175"] = null;
				}
				
				if (gameProgress["switch205Down"] == true  && gameProgress["getGemSprite3"]) {
					removeKeyListener();
					TweenLite.delayedCall(2, waitComplete8);
					gameProgress["switch205Down"] = false;
				} else if (gameProgress["chatContentId265Over"] == true) {
					removeKeyListener();
					effectAnimationLoop = true;
					effectArray[1][6] = tileSheetData.effect6Frame[0];
					roleArray[1][6] = 6;
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					gameProgress["chatContentId265Over"] = false;
				} else if (gameProgress["chatContentId268Over"] == true) {
					shakeTower = new ShakeAnimation(this);
					shakeTower.startShake();
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_SHAKE_TOWER, false, 999, 0, 0,true,1,0.4));
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					removeKeyListener();
					gameProgress["chatContentId268Over"] = false;
				} else if (gameProgress["chatContentId271Over"] == true) {
					removeKeyListener();
					effectArray[1][6] = tileSheetData.effect4Frame[0];
					roleArray[1][6] = 0;
					removeTile(roleLayerDatas[2], 6, 1, roleSheet);
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					gameProgress["chatContentId271Over"] = false;
				} else if (gameProgress["chatContentId273Over"] == true) {
					removeKeyListener();
					effectArray[0][4] = tileSheetData.effect4Frame[0];
					roleArray[0][4] = 0;
					removeTile(roleLayerDatas[2], 4, 0, roleSheet);
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					
					dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "11层的铁门打开",0,1.2,false));
					doorDic["1175"] = DOOR_OPEN; //           剧情后自动开门
					floorDataArray[ARRAY_ITEM][11][7][5] = 17;
					removeTile(underItemLayerDatas[11], 5, 7, itemSheet);
					
					floorDataArray[ARRAY_ITEM][11][6][5] = 0;
					removeTile(underItemLayerDatas[11], 5, 6, itemSheet);	
					gameProgress["chatContentId273Over"] = false;
					gameProgress["floor2plot4"] = false;
					gameProgress["floor12plot1"] = true;//触发floor12的第一个剧情
				}
			
				
				
			} else if (gameProgress["floor12plot1"] == true) {
				if (gameProgress["firstEnterFloor12"] == true) {
					shakeTower.stopShake();
					dispatchEvent(new CustomEventSound(CustomEventSound.STOP_SOUND, AddId.SOUND_SHAKE_TOWER, false, 0, 0, 0,true,2,0));
					gameProgress["firstEnterFloor12"] = false;
				} else if (gameProgress["switch1255Down"] == true || gameProgress["switch1256Down"] == true) {
					removeKeyListener();
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					chatContentData.npcStartContentIdArray[2] = 333;
					chatContentData.npcStartContentIdArray[4] = 340;
					gameProgress["switch1255Down"] = false;
					gameProgress["switch1256Down"] = false;
				} else if (gameProgress["chatContentId337Over"] == true) {
					removeKeyListener();
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					player.downFloor = true;
					player.isTransmit = true;
					dispatchEvent(new FloorEvent(FloorEvent.UPDATA_FLOOR, 11));
					gameProgress["chatContentId337Over"] = false;
					gameProgress["floor2plot5"] = true;//触发floor2的第五个剧情					
					floorDataArray[ARRAY_ITEM][2][7][5] = 137;
					switchDic["275"] = [0, 0];
					floorDataArray[ARRAY_ROLE][2][4][5] = 3;
					gameProgress["remove1246"] = true;
				} else if (currFloor == 11 && gameProgress["remove1246"]) {
					floorDataArray[ARRAY_ROLE][12][4][6] = 0;
					removeTile(roleLayerDatas[12], 6, 4, roleSheet);
					gameProgress["floor12plot1"] = false;
				}
				
				
			} else if (gameProgress["floor2plot5"] == true) {
				if (gameProgress["switch275Down"] == true && currFloor == 2) {
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["switch275Down"] = false;
				} else if (gameProgress["chatContentId379Over"] == true && currFloor == 2) {
					effectAnimationLoop = true;
					effectArray[7][5] = tileSheetData.effect3Frame[0];				
					player.data.HP += 100;
					player.data.STR += 20;
					player.data.DEF += 20;
					TweenLite.delayedCall(1.5, waitComplete9);
					removeKeyListener();
					gameProgress["chatContentId379Over"] = false;
				} else if (gameProgress["monster245Over"] == true) {
					roleArray[4][5] = 3;
					removeKeyListener();
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					gameProgress["monster245Over"] = false;
				} else if (gameProgress["chatContentId385Over"] == true) {
					removeKeyListener();
					effectArray[5][5] = tileSheetData.effect2Frame[0];
					TweenLite.delayedCall(1, waitComplete10);
					gameProgress["chatContentId385Over"] = false;
				} else if (gameProgress["chatContentId386Over"] == true) {
					removeKeyListener();
					TweenLite.delayedCall(0.5, waitCompleteAutoChat);
					gameProgress["chatContentId386Over"] = false;
				} else if (gameProgress["chatContentId388Over"] == true) {
					removeKeyListener();
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
					
					//震动
					shakeTower = new ShakeAnimation(this);
					shakeTower.startShake();
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_SHAKE_TOWER, false, 999, 0, 0,true,0.5,0.4));
					//白屏
					whiteScreen = new Bitmap(tileSheetData.imageLibrary["whiteScreen"]);
					whiteScreen.alpha = 0;
					Global.stage.addChild(whiteScreen);
					//动画
					TweenLite.to(whiteScreen, 1.5, { alpha:1, ease:Quint.easeOut, delay:1, onComplete:waitComplete11} );
					//TweenLite.delayedCall(3, waitComplete11);
					gameProgress["chatContentId388Over"] = false;
				} else if (gameProgress["chatContentId389Over"] == true) {
					removeKeyListener();
					gameProgress["floor0plot2"] = true;//触发floor0的第二个剧情
					gameProgress["floor2plot5"] = false;
					gameProgress["chatContentId389Over"] = false;
				}
				
			} else if (gameProgress["floor0plot2"] == true) {
				if (gameProgress["firstEnterFloor0"] == true) {
					shakeTower.stopShake();
					
					gameProgress["firstEnterFloor0"] = false;
				} else if (gameProgress["switch024Down"] || gameProgress["switch025Down"] || gameProgress["switch026Down"]) {				
					removeKeyListener();
					effectAnimationLoop = true;
					effectArray[3][4] = tileSheetData.effect4Frame[0];
					effectArray[3][6] = tileSheetData.effect6Frame[0];
					TweenLite.delayedCall(1, waitComplete14);
					gameProgress["switch024Down"] = false;
					gameProgress["switch025Down"] = false;
					gameProgress["switch026Down"] = false;
				} else if (gameProgress["chatContentId411Over"]) {
					removeKeyListener();
					blackScreen = new Bitmap(tileSheetData.imageLibrary["blackScreen"]);
					blackScreen.alpha = 0;
					TweenLite.to(blackScreen, 2, { alpha:1, ease:Quint.easeOut, onComplete:waitComplete12} );
					Global.stage.addChild(blackScreen);
					
					gameProgress["chatContentId411Over"] = false;
				} else if (gameProgress["chatContentId414Over"]) {
					removeKeyListener();
					effectArray[3][5] = tileSheetData.effect2Frame[0];
					TweenLite.delayedCall(1, waitCompleteAutoChat);
					gameProgress["chatContentId414Over"] = false;
				} else if (gameProgress["chatContentId433Over"]) {
					gameAllOver = true;
					dispatchEvent(new Event(Game.GAME_OVER));				
					gameProgress["chatContentId433Over"] = false;
				}
			}
			
			

			
			
			//旁支剧情
			if (gameProgress["switch225Down"] == true) {
				removeKeyListener();
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 76));					
				gameProgress["switch225Down"] = false;
			} else if (gameProgress["switch316Down"] == true) {
				removeKeyListener();
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 106));
				gameProgress["switch316Down"] = false;
			} else if (gameProgress["switch21010Down"] == true) {
				removeKeyListener();
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 88));
				gameProgress["switch21010Down"] = false;
			} else if (gameProgress["switch4210Down"] == true) {
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 131));
				gameProgress["switch4210Down"] = false;
			} else if (gameProgress["checkDoor287"] == true && doorDic["287"] == DOOR_CLOSE) {
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 53));
				gameProgress["checkDoor287"] = null;
			} else if (gameProgress["checkDoor305"] == true && doorDic["305"] == DOOR_CLOSE) {
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 129));
				gameProgress["checkDoor305"] = null;
			}
			/*
			else if (gameProgress["switch9108Down"] == true) {
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 195));
				gameProgress["switch9108Down"] = false;
			} else if (gameProgress["switch1175Down"] == true) {
				dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto", 195));
				gameProgress["switch1175Down"] = false;
			}
			*/
		}
		
		private function waitCompleteAutoChat():void {
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
		}
		
		private function waitComplete1():void {
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
			gameProgress["floor0plot1"] = false;
			gameProgress["floor1plot1"] = true;//触发floor1的情节
			Global.stage.removeChild(blackScreen);
		}
		
		private function waitComplete2():void {
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "manual", 2));
			effectAnimationLoop = false;
			gameProgress["floor1plot1"] = false;
			gameProgress["floor2plot1"] = true;//触发floor2的情节
		}
		
		private function waitComplete3():void {
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
			gameProgress["floor2plot1"] = false;
			gameProgress["floor3plot1"] = true;//触发floor3的剧情
		}
		
		private function waitComplete4():void {
			effectAnimationLoop = false;
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));
			floorDataArray[ARRAY_ITEM][2][1][4] = 137;
			switchDic["214"] = [0, 0];
			gameProgress["floor6plot1"] = false;
			gameProgress["floor2plot2"] = true;//触发floor2的第二个剧情
		}
		
		private function waitComplete5():void {
			effectAnimationLoop = true;
			effectArray[1][5] = tileSheetData.effect6Frame[0];
			roleArray[1][5] = 9;
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));			
		}
		
		
		private function waitComplete6():void {
			effectAnimationLoop = false;
			addKeyListener();
			
			dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "6层的道路已通畅",0,1.2));
			floorDataArray[ARRAY_ITEM][6][1][5] = 0;
			removeTile(underItemLayerDatas[6], 5, 1, itemSheet);
			floorDataArray[ARRAY_ITEM][6][1][5] = 2;
			gameProgress["floor2plot2"] = false;
			gameProgress["floor9plot1"] = true;//触发floor9的故事情节
		}
		
		private function waitComplete7():void {
			effectAnimationLoop = false;
			addKeyListener();
			floorDataArray[ARRAY_ITEM][9][10][9] = 0;
			removeTile(underItemLayerDatas[9], 9, 10, itemSheet);
			gameProgress["floor2plot3"] = false;
			gameProgress["floor11plot1"] = true;//触发floor11的故事情节
		}
		
		private function waitComplete8():void {
			effectAnimationLoop = true;
			effectArray[1][5] = tileSheetData.effect6Frame[0];
			roleArray[1][5] = 9;
			effectArray[0][4] = tileSheetData.effect1Frame[0];
			roleArray[0][4] = 3;
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));			
		}
		
		private function waitComplete9():void {
			removeKeyListener();
			dispatchEvent(new FightEvent(FightEvent.FIGHT_START, 4, 5, false, "auto", "NPC"));
			
		}
		
		private function waitComplete10():void {
			removeKeyListener();
			roleArray[5][5] = 12;
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));		
		}
		
		private function waitComplete11():void {
			removeKeyListener();
			if(chat != null) {
				chat.removeKeyListener();
			}
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_OVER, "389"));
			chatContentData.npcStartContentIdArray[0] = 390;
			roleArray[4][5] = 0;
			roleArray[1][5] = 0;
			removeTile(roleLayerDatas[2], 5, 4, roleSheet);
			removeTile(roleLayerDatas[2], 5, 1, roleSheet);
			chatContentData.npcStartContentIdArray[4] = 394;
			TweenLite.to(whiteScreen, 1.5, { alpha:0, ease:Quint.easeOut, delay:2, onComplete:waitCompleteAutoChat} );//白屏停留时间后消失
			floorDataArray[ARRAY_ITEM][0][2][4] = 137;
			floorDataArray[ARRAY_ITEM][0][2][5] = 137;
			floorDataArray[ARRAY_ITEM][0][2][6] = 137;
			switchDic["024"] = [0, 0];
			switchDic["025"] = [0, 0];
			switchDic["026"] = [0, 0];
			chatContentData.npcStartContentIdArray[3] = 434;
			gameProgress["firstEnterFloor0"] = null;
		}
		
		private function waitComplete12():void {
			for (var i:int = 1; i < 10; i++ ) {
				floorDataArray[ARRAY_BACKGROUND][0][0][i] = 66 + i;
				changeTile(backgroundLayerDatas[0], 66 + i, i, 0, backgroundSheet);
			}
			chatContentData.npcStartContentIdArray[2] = 412;
			TweenLite.to(blackScreen, 2, { alpha:0, ease:Quint.easeOut, delay:5, onComplete:waitComplete13 } );
			dispatchEvent(new CustomEventSound(CustomEventSound.STOP_SOUND, AddId.SOUND_SHAKE_TOWER, false, 0, 0, 0,true,3,0));
		}
		
		private function waitComplete13():void {
			addKeyListener();
		}
		
		private function waitComplete14():void {
			roleArray[3][4] = 6;
			roleArray[3][6] = 9;
			dispatchEvent(new ChatEvent(ChatEvent.CHAT_START, "auto"));	
		}		

	}
	
}