package  com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	 
	public class TileSheetData 
	{
		public static const BACKGROUND_MAGMA:int = -2;
		public static const BACKGROUND_WATER:int = -1;
		public static const BACKGROUND_WALL:int = 0;
		public static const BACKGROUND_ROAD:int = 1;
		public static const BACKGROUND_UPSTAIR:int = 2;
		public static const BACKGROUND_DOWNSTAIR:int = 3;
		public static const BACKGROUND_GLASS:int = 4;
		
		public static const ROLE_VACANT:int = 0;
		public static const ROLE_MONSTER:int = 1;
		public static const ROLE_NPC:int = 2;

		public static const ITEM_DECORATION_ABOVE_NAME:int = -2;
		public static const ITEM_DECORATION_UNDER_NAME:int = -1;
		public static const ITEM_RED_DRUG:int = 0;
		public static const ITEM_GREEN_DRUG:int  = 1;
		public static const ITEM_BLUE_DRUG:int = 2;
		public static const ITEM_RED_KEY:int = 3;
		public static const ITEM_YELLOW_KEY:int = 4;
		public static const ITEM_BLUE_KEY:int = 5;
		public static const ITEM_BOX:int = 6;
		public static const ITEM_BOOK:int = 7;
		public static const ITEM_FRAGMENT:int = 8;
		public static const ITEM_FLOOR_SWITCH1:int = 9;
		public static const ITEM_FLOOR_SWITCH2:int = 10;
		public static const ITEM_FLOOR_SWITCH_TILE:int = 11;
		
		public static const ITEM_SWITCH_DOOR:int = 12;
		public static const ITEM_YELLOW_COL_DOOR:int = 13;
		public static const ITEM_BLUE_COL_DOOR:int = 14;
		public static const ITEM_RED_COL_DOOR:int = 15;
		public static const ITEM_YELLOW_ROW_DOOR:int = 16;
		public static const ITEM_BLUE_ROW_DOOR:int = 17;
		public static const ITEM_RED_ROW_DOOR:int = 18;
		
		public static const ITEM_EQUIP_SWORD_1:int = 19;
		public static const ITEM_EQUIP_SWORD_2:int = 20;
		public static const ITEM_EQUIP_SWORD_3:int = 21;
		public static const ITEM_EQUIP_SWORD_4:int = 22;
		public static const ITEM_EQUIP_SWORD_5:int = 23;
		public static const ITEM_EQUIP_ARMOUR_1:int = 24;
		public static const ITEM_EQUIP_ARMOUR_2:int = 25;
		public static const ITEM_EQUIP_ARMOUR_3:int = 26;
		public static const ITEM_EQUIP_ARMOUR_4:int = 27;
		public static const ITEM_EQUIP_ARMOUR_5:int = 28;
		
		public static const ITEM_NEWS_TREASUREMAP1:int = 29;
		

		
		public static const ITEM_EFFECT_1:int = 30;
		public static const ITEM_EFFECT_2:int = 31;
		public static const ITEM_EFFECT_3:int = 32;
		public static const ITEM_EFFECT_4:int = 33;
		public static const ITEM_EFFECT_5:int = 34;
		public static const ITEM_EFFECT_6:int = 35;
		public static const ITEM_EFFECT_7:int = 36;
		
		public static const ITEM_GEM_RED:int = 37;
		public static const ITEM_GEM_BLUE:int = 38;
		public static const ITEM_GEM_WHITE:int = 39;
		public static const ITEM_GEM_BLACK:int = 40;
		public static const ITEM_GEM_SPRITE1:int = 41;
		public static const ITEM_GEM_SPRITE2:int = 42;
		public static const ITEM_GEM_SPRITE3:int = 43;
		
		public static const ITEM_NEWS_STELE:int = 44;
		
		public static const ITEM_SWITCH_STICK:int = 45;
		
		public static const ITEM_SWITCH_PLOT:int = 46;
		
		public static const ITEM_NEWS_BOOKS1:int = 47;
		public static const ITEM_NEWS_BOOKS2:int = 48;
		
		public static const ITEM_NEWS_TREASUREMAP2:int = 49;
		public static const ITEM_NEWS_TREASUREMAP3:int = 50;
		public static const ITEM_NEWS_TREASUREMAP4:int = 51;
		public static const ITEM_NEWS_TREASUREMAP5:int = 52;
		public static const ITEM_NEWS_TREASUREMAP6:int = 53;
		public static const ITEM_NEWS_TREASUREMAP7:int = 54;
		public static const ITEM_NEWS_TREASUREMAP8:int = 55;
		public static const ITEM_NEWS_TREASUREMAP9:int = 56;
		public static const ITEM_NEWS_TREASUREMAP10:int = 57;
		
		public static const ITEM_DECORATION_ABOVE:int = 0;
		public static const ITEM_DECORATION_UNDER:int = 1;
		public static const ITEM_ITEM:int = 2;
		public static const ITEM_DOOR:int = 3;
		public static const ITEM_SWITCH:int = 4;
		public static const ITEM_NEWS:int = 5;
		public static const ITEM_EFFECT:int = 6;
		
		public static const ITEM_WALKABLE:int = 0;
		public static const ITEM_UNWALKABLE:int = 1;


		
		public var backgroundSheetData:Array;
		
		public var roleSheetData:Array;
		public var monsterSheetData:Array;
		public var npcSheetData:Array;
		
		public var itemSheetData:Array;
		public var itemSheetTypeData:Array;
		public var itemSheetWalkData:Array;
		
		
		public var waterFrame:Array = [];
		public var glassFrame:Array = [];
		public var magmaFrame:Array = [];
		
		
		
		public var switchDoorFrame:Array = [];
		public var floorSwitch1Frame:Array = [];
		public var floorSwitch2Frame:Array = [];
		public var floorSwitchTileFrame:Array = [];
		
		public var switchStickFrame:Array = [];
		public var plotSwitchFrame:Array = [];
		
		public var yellowColDoorFrame:Array = [];
		public var blueColDoorFrame:Array = [];
		public var redColDoorFrame:Array = [];
		public var yellowRowDoorFrame:Array = [];
		public var blueRowDoorFrame:Array = [];
		public var redRowDoorFrame:Array = [];
		
		public var effect1Frame:Array = [];
		public var effect2Frame:Array = [];
		public var effect3Frame:Array = [];
		public var effect4Frame:Array = [];
		public var effect5Frame:Array = [];
		public var effect6Frame:Array = [];
		public var effect7Frame:Array = [];

		public var colDoorCover:int;
		
		

		public var imageLibrary:Dictionary = new Dictionary;
		
		public static const ROLE_PLAYER:int = 0;
		public static const ROLE_NPC1:int = 1;
		public static const ROLE_NPC2:int = 2;
		public static const ROLE_NPC3:int = 3;
		public static const ROLE_NPC4:int = 4;

		public function TileSheetData() 
		{
			initBackgroundData();
			initRoleSheetData();
			initItemSheetData();
			initImageLibrary();
		}
		
		
		private function initImageLibrary():void
		{
			var roleChatImageBitmapDatas:Array = [];
			roleChatImageBitmapDatas[ROLE_PLAYER] = [new PlayerChatImage0(0, 0), new PlayerChatImage1(0, 0), new PlayerChatImage2(0, 0), new PlayerChatImage3(0, 0), new PlayerChatImage4(0, 0), new PlayerChatImage5(0, 0), new PlayerChatImage6(0, 0), new PlayerChatImage7(0, 0), new PlayerChatImage8(0, 0), new PlayerChatImage9(0, 0),
			 new PlayerChatImage10(0, 0), new PlayerChatImage11(0, 0), new PlayerChatImage12(0, 0), new PlayerChatImage13(0, 0), new PlayerChatImage14(0, 0), new PlayerChatImage15(0, 0)        ];
			
			roleChatImageBitmapDatas[ROLE_NPC1] = [new NPC1ChatImage0(0, 0), new NPC1ChatImage1(0, 0), new NPC1ChatImage2(0, 0), new NPC1ChatImage3(0, 0), new NPC1ChatImage4(0, 0), new NPC1ChatImage5(0, 0), new NPC1ChatImage6(0, 0)   ];
			
			roleChatImageBitmapDatas[ROLE_NPC2] = [new NPC2ChatImage0(0, 0), new NPC2ChatImage1(0, 0), new NPC2ChatImage2(0, 0), new NPC2ChatImage3(0, 0), new NPC2ChatImage4(0, 0), new NPC2ChatImage5(0, 0), new NPC2ChatImage6(0, 0), new NPC2ChatImage7(0, 0), new NPC2ChatImage8(0, 0),
			new NPC2ChatImage9(0, 0), new NPC2ChatImage10(0, 0), new NPC2ChatImage11(0, 0), new NPC2ChatImage12(0, 0), new NPC2ChatImage13(0, 0),new NPC2ChatImage14(0, 0), new NPC2ChatImage15(0, 0), new NPC2ChatImage16(0, 0), new NPC2ChatImage17(0, 0), new NPC2ChatImage18(0, 0), new NPC2ChatImage19(0, 0),
			new NPC2ChatImage20(0, 0), new NPC2ChatImage21(0, 0), new NPC2ChatImage22(0, 0), new NPC2ChatImage23(0, 0)];
			
			roleChatImageBitmapDatas[ROLE_NPC3] = [new NPC3ChatImage0(0, 0), new NPC3ChatImage1(0, 0), new NPC3ChatImage2(0, 0), new NPC3ChatImage3(0, 0), new NPC3ChatImage4(0, 0), new NPC3ChatImage5(0, 0), new NPC3ChatImage6(0, 0), new NPC3ChatImage7(0, 0), new NPC3ChatImage8(0, 0), new NPC3ChatImage9(0, 0), new NPC3ChatImage10(0, 0), new NPC3ChatImage11(0, 0)];
			
			roleChatImageBitmapDatas[ROLE_NPC4] = [new NPC4ChatImage0(0, 0), new NPC4ChatImage1(0, 0), new NPC4ChatImage2(0, 0), new NPC4ChatImage3(0, 0), new NPC4ChatImage4(0, 0), new NPC4ChatImage5(0, 0), new NPC4ChatImage6(0, 0), new NPC4ChatImage7(0, 0), new NPC4ChatImage8(0, 0)];
			imageLibrary["titleScreenBGJpg"] = new TitleScreenBGJpg(0, 0);
			imageLibrary["titleScreenExitPng"] = new TitleScreenExitPng(0, 0);
			imageLibrary["titleScreenHelpPng"] = new TitleScreenHelpPng(0, 0);
			imageLibrary["titleScreenSetPng"] = new TitleScreenSetPng(0, 0);
			imageLibrary["titleScreenBeginPng"] = new TitleScreenBeginPng(0, 0);
			imageLibrary["titleScreenConPng"] = new TitleScreenConPng(0, 0);
			imageLibrary["roleChatImageBitmapDatas"] = roleChatImageBitmapDatas;
			imageLibrary["chatBackground"] = new ChatBackground(0, 0);
			imageLibrary["playerImageNPng"] = new PlayerImageNPng(0, 0);
			imageLibrary["changePng"] = new ChangePng(0, 0);
			imageLibrary["fightComparePng"] = new FightComparePng(0, 0);
			imageLibrary["fightBackgroundPng"] = new FightBackgroundPng(0, 0);
			imageLibrary["fightFightPng"] = new FightFightPng(0, 0);
			imageLibrary["FWpointPng"] = new FWpointPng(0, 0);
			imageLibrary["fightLosePng"] = new FightLosePng(0, 0);
			imageLibrary ["fightWinPng"] = new FightWinPng(0, 0);
			imageLibrary["fightQuickBackgroundPng"] = new FightQuickBackgroundPng(0, 0);
			imageLibrary["fightStartPng"] = new FightStartPng(0, 0);
			imageLibrary["FWbarOutPng"] = new FWbarOutPng(0, 0);
			imageLibrary["FWbarPng"] = new FWbarPng(0 , 0);
			imageLibrary["FWcirclePng"] = new FWcirclePng(0, 0);
			imageLibrary["titleScreenConIMPng"] = new TitleScreenConIMPng(0, 0);
			imageLibrary["titleScreenExitIMPng"] = new TitleScreenExitIMPng(0, 0);
			imageLibrary["titleScreenBeginIMPng"] = new TitleScreenBeginIMPng(0, 0);
			
			imageLibrary["statusScreenBGJpg"] = new StatusScreenBGJpg(0, 0);
			
			imageLibrary["treasureMapBG"] = new TreasureMapBG(0, 0);
			imageLibrary["treasureMap1"] = new TreasureMap1(0, 0);
			imageLibrary["treasureMap2"] = new TreasureMap2(0, 0);
			imageLibrary["treasureMap3"] = new TreasureMap3(0, 0);
			imageLibrary["treasureMap4"] = new TreasureMap4(0, 0);
			imageLibrary["treasureMap5"] = new TreasureMap5(0, 0);
			imageLibrary["treasureMap6"] = new TreasureMap6(0, 0);
			imageLibrary["treasureMap7"] = new TreasureMap7(0, 0);
			imageLibrary["treasureMap8"] = new TreasureMap8(0, 0);
			imageLibrary["treasureMap9"] = new TreasureMap9(0, 0);
			imageLibrary["treasureMap10"] = new TreasureMap10(0, 0);
			
			imageLibrary["book1Png"] = new Book1Png(0, 0);

			
			imageLibrary["normalNewsPng"] = new NormalNewsPng(0, 0);
			imageLibrary["transmitPng"] = new TransmitPng(0, 0);
			imageLibrary["transmitPointPng"] = new TransmitPointPng(0, 0);
			imageLibrary["addPointPng"] = new AddPointPng(0, 0);
			imageLibrary["addPointPointPng"] = new AddPointPointPng(0, 0);
			
			imageLibrary["blackScreen"] = new BlackScreen(0, 0);
			imageLibrary["blackCoverPng"] = new BlackCoverPng(0 , 0);
			imageLibrary["gameOverJpg"] = new GameOverJpg(0, 0);
			imageLibrary["gameRestartPng"] = new GameRestartPng(0, 0);
			
			imageLibrary["whiteScreen"] = new WhiteScreen(0, 0);
			imageLibrary["basicFunctionPng"] = new BasicFunctionPng(0, 0);
			
			imageLibrary["gameAllOverPng"] = new GameAllOverPng(0, 0);
			imageLibrary["gameOverPng"] = new GameOverPng(0, 0);
			
			imageLibrary["titleScreenHelpTextPng"] = new TitleScreenHelpTextPng(0, 0);
			imageLibrary["titleScreenPointPng"] = new TitleScreenPointPng(0, 0);
			
			imageLibrary["monsterManualPng"] = new MonsterManualPng(0, 0);
			
			imageLibrary["instructionScreen"] = new InstructionScreen(0, 0);
			imageLibrary["basicWindowPng"] = new BasicWindowPng(0, 0);
			imageLibrary["loadPng"] = new LoadPng(0, 0);
			
			imageLibrary["load1Png"] = new Load1Png(0, 0);
			imageLibrary["load2Png"] = new Load2Png(0, 0);
			imageLibrary["load3Png"] = new Load3Png(0, 0);
			imageLibrary["load4Png"] = new Load4Png(0, 0);
			imageLibrary["load5Png"] = new Load5Png(0, 0);
			imageLibrary["load6Png"] = new Load6Png(0, 0);
			imageLibrary["load7Png"] = new Load7Png(0, 0);
			
			
		}

				
		//从XML文件中读取图片（TileSheet）信息
		private  function initBackgroundData():void {
			backgroundSheetData = new Array;
			var numberToPush:int = 99;
			var tileXML:XML = BackgroundSheetXML.XMLData;
			var numTiles:int = tileXML.tile.length();
			var tileNum:int;
			for (tileNum = 0; tileNum < numTiles; tileNum++) {
				if (String(tileXML.tile[tileNum].@type) == "road") {

					numberToPush = BACKGROUND_ROAD;
				
				} else if (String(tileXML.tile[tileNum].@type) == "upstair") {
					
					numberToPush = BACKGROUND_UPSTAIR;
					
				} else if (String(tileXML.tile[tileNum].@type) == "downstair") {
					
					numberToPush = BACKGROUND_DOWNSTAIR;
				} else if (String(tileXML.tile[tileNum].@type) == "wall") {

					numberToPush = BACKGROUND_WALL;
				} else if (String(tileXML.tile[tileNum].@type) == "water") {
					
					numberToPush = BACKGROUND_WATER;
					waterFrame.push(tileXML.tile[tileNum].@id);
				} else if (String(tileXML.tile[tileNum].@type) == "glass") {
					
					numberToPush = BACKGROUND_GLASS;
					glassFrame.push(tileXML.tile[tileNum].@id);
				} else if (String(tileXML.tile[tileNum].@type) == "magma") {
					
					numberToPush = BACKGROUND_MAGMA;
					magmaFrame.push(tileXML.tile[tileNum].@id);
				} 
				
				backgroundSheetData.push(numberToPush);
			}
		
			
		}
		
		private function initRoleSheetData():void {
			
			roleSheetData = [];
			monsterSheetData = [];
			npcSheetData = [];
			
			var tileXML:XML = RoleSheetXML.XMLData;
			var numTiles:int = tileXML.tile.length();
			var tileNum:int;
			var numberToPushType:int = 99;
			
			for (tileNum = 0; tileNum < numTiles; tileNum++) {
				if(String(tileXML.tile[tileNum].@type) == "monster") {
					numberToPushType = ROLE_MONSTER;
					monsterSheetData[tileNum] = [int(tileXML.tile[tileNum].@id), String(tileXML.tile[tileNum].@name), int(tileXML.tile[tileNum].@HP), int(tileXML.tile[tileNum].@CP), int(tileXML.tile[tileNum].@STR), int(tileXML.tile[tileNum].@DEF), int(tileXML.tile[tileNum].@FW)];								
				} 
				else if (String(tileXML.tile[tileNum].@type) == "NPC") {
					numberToPushType = ROLE_NPC;
					npcSheetData[tileNum] = [int(tileXML.tile[tileNum].@id), String(tileXML.tile[tileNum].@name), int(tileXML.tile[tileNum].@HP), int(tileXML.tile[tileNum].@CP), int(tileXML.tile[tileNum].@STR), int(tileXML.tile[tileNum].@DEF), int(tileXML.tile[tileNum].@FW)];
				}
				roleSheetData.push(numberToPushType);
				roleSheetData.push(numberToPushType);
				roleSheetData.push(numberToPushType);
			}
			
			//trace(monsterSheetData);
			//trace(npcSheetData);
			//trace(roleSheetData);

			
			
		}
		
		private function initItemSheetData():void {
			itemSheetData = [];
			itemSheetTypeData = [];
			var numberToPush:int = 99;
			var numberToPushType:int = 99;
			var tileXML:XML = ItemSheetXML.XMLData;
			var tileNum:int;
			var numTiles:int = tileXML.tile.length();
			for (tileNum = 0; tileNum < numTiles; tileNum++) {
				if (String(tileXML.tile[tileNum].@type) == "decoration_under") {

					numberToPush = ITEM_DECORATION_UNDER_NAME;
					numberToPushType = ITEM_DECORATION_UNDER;
				}
				else if (String(tileXML.tile[tileNum].@type) == "decoration_above") {
					
					numberToPush = ITEM_DECORATION_ABOVE_NAME;
					numberToPushType = ITEM_DECORATION_ABOVE;
					if (String(tileXML.tile[tileNum].@name) == "colDoorCover") {
						colDoorCover = tileXML.tile[tileNum].@id;
					}
				}
				else if (String(tileXML.tile[tileNum].@type) == "switch") {
					
					switch(String(tileXML.tile[tileNum].@name)) {
						case "floorSwitch1":
							numberToPush = ITEM_FLOOR_SWITCH1;
							floorSwitch1Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "floorSwitch2":
							numberToPush = ITEM_FLOOR_SWITCH2;
							floorSwitch2Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "floorSwitchTile":
							numberToPush = ITEM_FLOOR_SWITCH_TILE;
							floorSwitchTileFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "stickSwitch":
							numberToPush = ITEM_SWITCH_STICK;
							switchStickFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "plotSwitch":
							numberToPush = ITEM_SWITCH_PLOT;
							plotSwitchFrame.push(tileXML.tile[tileNum].@id);
							break;
					}
					numberToPushType = ITEM_SWITCH;
				}
				else if (String(tileXML.tile[tileNum].@type) == "door") {
					switch(String(tileXML.tile[tileNum].@name)) {
						case "switchDoor":
							numberToPush = ITEM_SWITCH_DOOR;
							switchDoorFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "yellowColDoor":
							numberToPush = ITEM_YELLOW_COL_DOOR;
							yellowColDoorFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "blueColDoor":
							numberToPush = ITEM_BLUE_COL_DOOR;
							blueColDoorFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "redColDoor":
							numberToPush = ITEM_RED_COL_DOOR;
							redColDoorFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "yellowRowDoor":
							numberToPush = ITEM_YELLOW_ROW_DOOR;
							yellowRowDoorFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "blueRowDoor":
							numberToPush = ITEM_BLUE_ROW_DOOR;
							blueRowDoorFrame.push(tileXML.tile[tileNum].@id);
							break;
						case "redRowDoor":
							numberToPush = ITEM_RED_ROW_DOOR;
							redRowDoorFrame.push(tileXML.tile[tileNum].@id);
							break;
							
					}
					numberToPushType = ITEM_DOOR;
				}
				else if (String(tileXML.tile[tileNum].@type) == "item") {
					
					switch(String(tileXML.tile[tileNum].@name)) {
						case "greenDrug":
							numberToPush = ITEM_GREEN_DRUG;
							break;
						case "redDrug":
							numberToPush = ITEM_RED_DRUG;
							break;
						case "blueDrug":
							numberToPush = ITEM_BLUE_DRUG;
							break;
						case "redKey":
							numberToPush = ITEM_RED_KEY;
							break;
						case "blueKey":
							numberToPush = ITEM_BLUE_KEY;
							break;
						case "yellowKey":
							numberToPush = ITEM_YELLOW_KEY;
							break;
						case "box":
							numberToPush = ITEM_BOX;
							break;
						case "book":
							numberToPush = ITEM_BOOK;
							break;
						case "fragment":
							numberToPush = ITEM_FRAGMENT;
							break;
						case "sword1":
							numberToPush = ITEM_EQUIP_SWORD_1;
							break;
						case "sword2":
							numberToPush = ITEM_EQUIP_SWORD_2;
							break;
						case "sword3":
							numberToPush = ITEM_EQUIP_SWORD_3;
							break;
						case "sword4":
							numberToPush = ITEM_EQUIP_SWORD_4;
							break;
						case "sword5":
							numberToPush = ITEM_EQUIP_SWORD_5;
							break;
						case "armour1":
							numberToPush = ITEM_EQUIP_ARMOUR_1;
							break;
						case "armour2":
							numberToPush = ITEM_EQUIP_ARMOUR_2;
							break;
						case "armour3":
							numberToPush = ITEM_EQUIP_ARMOUR_3;
							break;
						case "armour4":
							numberToPush = ITEM_EQUIP_ARMOUR_4;
							break;
						case "armour5":
							numberToPush = ITEM_EQUIP_ARMOUR_5;
							break;
						case "gemRed":
							numberToPush = ITEM_GEM_RED;
							break;
						case "gemBlue":
							numberToPush = ITEM_GEM_BLUE;
							break;
						case "gemWhite":
							numberToPush = ITEM_GEM_WHITE;
							break;
						case "gemBlack":
							numberToPush = ITEM_GEM_BLACK;
							break;
						case "spriteGem1":
							numberToPush = ITEM_GEM_SPRITE1;
							break;
						case "spriteGem2":
							numberToPush = ITEM_GEM_SPRITE2;
							break;
						case "spriteGem3":
							numberToPush = ITEM_GEM_SPRITE3;
							break;

					}
					numberToPushType = ITEM_ITEM;
			
				}
				
				else if (String(tileXML.tile[tileNum].@type) == "news") {
					switch(String(tileXML.tile[tileNum].@name)) {
						case "treasureMap1":
							numberToPush = ITEM_NEWS_TREASUREMAP1;
							break;
						case "stele":
							numberToPush = ITEM_NEWS_STELE;
							break;
						case "books1":
							numberToPush = ITEM_NEWS_BOOKS1;
							break;
						case "books2":
							numberToPush = ITEM_NEWS_BOOKS2;
							break;
						case "treasureMap2":
							numberToPush = ITEM_NEWS_TREASUREMAP2;
							break;
						case "treasureMap3":
							numberToPush = ITEM_NEWS_TREASUREMAP3;
							break;
						case "treasureMap4":
							numberToPush = ITEM_NEWS_TREASUREMAP4;
							break;
						case "treasureMap5":
							numberToPush = ITEM_NEWS_TREASUREMAP5;
							break;
						case "treasureMap6":
							numberToPush = ITEM_NEWS_TREASUREMAP6;
							break;
						case "treasureMap7":
							numberToPush = ITEM_NEWS_TREASUREMAP7;
							break;
						case "treasureMap8":
							numberToPush = ITEM_NEWS_TREASUREMAP8;
							break;
						case "treasureMap9":
							numberToPush = ITEM_NEWS_TREASUREMAP9;
							break;
						case "treasureMap10":
							numberToPush = ITEM_NEWS_TREASUREMAP10;
							break;
							
					}
					numberToPushType = ITEM_NEWS;
				}
				
				else if (String(tileXML.tile[tileNum].@type) == "effect") {
					switch(String(tileXML.tile[tileNum].@name)) {
						case "effect1":
							numberToPush = ITEM_EFFECT_1;
							effect1Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "effect2":
							numberToPush = ITEM_EFFECT_2;
							effect2Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "effect3":
							numberToPush = ITEM_EFFECT_3;
							effect3Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "effect4":
							numberToPush = ITEM_EFFECT_4;
							effect4Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "effect5":
							numberToPush = ITEM_EFFECT_5;
							effect5Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "effect6":
							numberToPush = ITEM_EFFECT_6;
							effect6Frame.push(tileXML.tile[tileNum].@id);
							break;
						case "effect7":
							numberToPush = ITEM_EFFECT_7;
							effect7Frame.push(tileXML.tile[tileNum].@id);
							break;
							
					}
					numberToPushType = ITEM_EFFECT;
				}
				
				itemSheetData.push(numberToPush);
				itemSheetTypeData.push(numberToPushType);


			}
			
			
			itemSheetWalkData = [];	
			var numberToPushWalk:int = 1000;
			for (tileNum = 0; tileNum < numTiles; tileNum++) {
				if (String(tileXML.tile[tileNum].@walk) == "walkable") {
					
					numberToPushWalk = ITEM_WALKABLE;
				}
				else if (String(tileXML.tile[tileNum].@walk) == "unwalkable") {
					numberToPushWalk = ITEM_UNWALKABLE;
				}
				itemSheetWalkData.push(numberToPushWalk);
			}
				
		}
		
		
	}

}