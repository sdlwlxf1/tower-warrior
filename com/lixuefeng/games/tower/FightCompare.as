package  com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	import com.lixuefeng.framework.BasicScreen;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.lixuefeng.framework.FightEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign; 
	
	public class FightCompare extends BasicScreen
	{
		private var player:Player;
		private var monster:Monster;
		private var monsterRow:int;
		private var monsterCol:int;
		public static const PLAYER_IMAGE:int = 0;
		public static const MONSTER_IMAGE:int = 1;
		public static const PLAYER_HP_TEXT:int = 0;
		public static const MONSTER_HP_TEXT:int = 1;
		public static const PLAYER_STR_TEXT:int = 2;
		public static const MONSTER_STR_TEXT:int = 3;
		public static const PLAYER_DEF_TEXT:int = 4;
		public static const MONSTER_DEF_TEXT:int = 5;
		public static const MONSTER_FW_TEXT:int = 6;
		public static const FIGHT_RESULT:int = 7;
		
		private var player_HP:int;
		private var player_STR:int;
		private var player_DEF:int;
		
		private var monster_HP:int;
		private var monster_STR:int;
		private var monster_DEF:int;
		private var monster_FW:int;
		
		private var hurtPlayer:int;
		private var hurtMonster:int;
		
		private var tileSheetData:TileSheetData;
		
		private var fightComparePng:BitmapData;
		
		
		public function FightCompare(player:Player, monster:Monster ,monsterRow:int, monsterCol:int,tileSheetData:TileSheetData) 
		{
			this.player = player;
			this.monster = monster;
			this.monsterRow = monsterRow;
			this.monsterCol = monsterCol;
			this.tileSheetData = tileSheetData;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			init();
			
		}
		
		private function init():void 
		{
			fightComparePng = tileSheetData.imageLibrary["fightComparePng"];
			
			player_HP = player.data.HP;
			player_STR = player.data.STR;
			player_DEF = player.data.DEF;
			
			
			monster_HP = monster.data.HP;
			monster_STR = monster.data.STR;
			monster_DEF = monster.data.DEF;
			monster_FW = monster.data.FW;
			
			hurtPlayer = monster_STR - player_DEF;
			hurtMonster = player_STR - monster_DEF;
			
			
			
			setBackgroundBitmap(fightComparePng);
			addImageBitmap(PLAYER_IMAGE, 70, 60, player.viewArray[0][0].clone());
			addImageBitmap(MONSTER_IMAGE, 195, 60, monster.view);
			var textFormat:TextFormat = new TextFormat("Gill Sans MT", 20,0xff000000, true,null, null,null,null,TextFormatAlign.CENTER);
			createDisplayText(PLAYER_HP_TEXT, String(player.data.HP), 90, 45,115, textFormat);
			createDisplayText(MONSTER_HP_TEXT, String(monster.data.HP), 90, 170, 115, textFormat);
			createDisplayText(PLAYER_STR_TEXT, String(player.data.STR), 90, 45,157, textFormat);
			createDisplayText(MONSTER_STR_TEXT, String(monster.data.STR), 90, 170, 157, textFormat);
			createDisplayText(PLAYER_DEF_TEXT, String(player.data.DEF), 90, 45,203, textFormat);
			createDisplayText(MONSTER_DEF_TEXT, String(monster.data.DEF), 90,170, 203, textFormat);
			createDisplayText(MONSTER_FW_TEXT, String(monster.data.FW), 90, 170, 243,textFormat);
			
			var textFormat2:TextFormat = new TextFormat("黑体", 20,0xff000000, true,null, null,null,null,TextFormatAlign.CENTER);
			createDisplayText(FIGHT_RESULT, " ", 300, 0, 290, textFormat2 );
			


			fightCompute();
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			if (e.keyCode == 67) {
				dispatchEvent(new FightEvent(FightEvent.FIGHT_OVER, monsterRow, monsterCol, true));
			}
		}
		
		private function fightCompute():void 
		{
			var hurtMonster:int = player_STR - monster_DEF;
			var hurtPlayer:int = monster_STR - player_DEF;
			
			if (hurtPlayer <= 0) {
				hurtPlayer = 0;
			}
			if (hurtMonster <= 0) {
				hurtMonster = 0;
			}
			var playerCount:int = player_HP / hurtPlayer;
			var monsterCount:int = monster_HP / hurtMonster;
			var different:int = playerCount - monsterCount;
			
			if (hurtMonster <= 0)
			{
				changeDisplayText(FIGHT_RESULT, "你的实力不如对方");
			}
			else
			{
				if (hurtPlayer <= 0)
				{
					changeDisplayText(FIGHT_RESULT, "你的实力胜过对方");
				}
				else
				{
					if (different > 1) {
						changeDisplayText(FIGHT_RESULT, "你的实力胜过对方");
					} else if(different < 1) {
						changeDisplayText(FIGHT_RESULT, "你的实力不如对方");
					} else {
						changeDisplayText(FIGHT_RESULT, "实力相当");
					}
				}
			}
		}
		
	}

}