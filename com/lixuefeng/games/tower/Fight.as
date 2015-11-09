package  com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign; 
	import com.lixuefeng.framework.*;
	import flash.events.Event;
	
	public class Fight extends BasicScreen
	{
		private var player:Player;
		private var monster:Monster;
		private var monsterRow:int;
		private var monsterCol:int;
		private var tileSheetData:TileSheetData;
		public static const PLAYER_IMAGE:int = 0;
		public static const MONSTER_IMAGE:int = 1;
		private static const FIGHT_WIN_IMAGE:int = 2;
		private static const FIGHT_LOSE_IMAGE:int = 3;
		
	
		public static const PLAYER_HP_TEXT:int = 0;
		public static const MONSTER_HP_TEXT:int = 1;
		private static const HURT_PLAYER_TEXT:int = 2;
		private static const HURT_MONSTER_TEXT:int = 3;
		
		public var fightQuickBackgroundPng:BitmapData;
		
		private var fightTimer:Timer;		
		private var roundtime:int = 0;
		
		private var player_HP:int;
		private var player_STR:int;
		private var player_DEF:int;
		
		private var monster_HP:int;
		private var monster_STR:int;
		private var monster_DEF:int;
		
		private var hurtPlayer:int;
		private var hurtMonster:int;
		
		private var currTurn:int;
		
		private static const TURN_PLAYER:int = 0;
		private static const TURN_MONSTER:int = 1;
		
		private var shakePlayer:ShakeAnimation;
		private var shakeMonster:ShakeAnimation;
		
		private var fightOver:Boolean = false;
		
		public function Fight(player:Player, monster:Monster,monsterRow:int, monsterCol:int, tileSheetData:TileSheetData) 
		{
			
			this.player = player;
			this.monster = monster;
			this.monsterRow = monsterRow;
			this.monsterCol = monsterCol;
			this.tileSheetData = tileSheetData;
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			init();
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			if (e.keyCode == 81) {
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
				fightTimer.stop();
				fightTimer.removeEventListener(TimerEvent.TIMER, fightListener);
				dispatchEvent(new FightEvent(FightEvent.FIGHT_OVER, monsterRow, monsterCol, true));
			}
		}
		
		private function randRange(min:Number, max:Number):Number {

			var randomNum:Number = int(Math.random() * (max - min + 1)) + min;

			return randomNum;

		}
		
		private function init():void 
		{
			player_HP = player.data.HP;
			player_STR = player.data.STR;
			player_DEF = player.data.DEF;
			
			
			monster_HP = monster.data.HP;
			monster_STR = monster.data.STR;
			monster_DEF = monster.data.DEF;
			
			hurtPlayer = monster_STR - player_DEF;
			hurtMonster = player_STR - monster_DEF;
			
			
			
			fightQuickBackgroundPng = tileSheetData.imageLibrary["fightQuickBackgroundPng"];
			setBackgroundBitmap(fightQuickBackgroundPng);
			addImageBitmap(PLAYER_IMAGE, 85, 90, new PlayerImageNPng(0, 0));
			addImageBitmap(MONSTER_IMAGE, 310, 135, monster.view);
			var textFormat2:TextFormat = new TextFormat("Gill Sans MT", 60,0xff000000, true,null, null,null,null,TextFormatAlign.CENTER);
			createDisplayText(HURT_MONSTER_TEXT, "", 90, 293, 130, textFormat2);
			createDisplayText(HURT_PLAYER_TEXT, "", 90, 95, 120, textFormat2);
			
			imageBitmaps[MONSTER_IMAGE].scaleX *= 2;
			imageBitmaps[MONSTER_IMAGE].scaleY *= 2;
			var textFormat:TextFormat = new TextFormat("Gill Sans MT", 40,0xff000000, true,null, null,null,null,TextFormatAlign.CENTER);
			createDisplayText(PLAYER_HP_TEXT, String(player.data.HP), 90, 105,230, textFormat);
			createDisplayText(MONSTER_HP_TEXT, String(monster.data.HP), 90, 305, 230,textFormat);
			

			fightTimer = new Timer(1000 / 20);
			fightTimer.addEventListener(TimerEvent.TIMER, fightListener, false, 0);
			fightTimer.start();
			currTurn = TURN_PLAYER;
			
			shakePlayer = new ShakeAnimation(imageBitmaps[PLAYER_IMAGE], 4);
			shakeMonster = new ShakeAnimation(imageBitmaps[MONSTER_IMAGE], 4);
		}
		
		
		private function fightListener(e:TimerEvent):void 
		{
			roundtime++;
			if (roundtime == 4) {
				shakeMonster.stopShake();
				shakePlayer.stopShake();
			}
			if (roundtime == 6) {
				changeDisplayText(HURT_PLAYER_TEXT, "");
				changeDisplayText(HURT_MONSTER_TEXT, "");
			}
			
			if (roundtime == 13 && fightOver == true) {				
				fightTimer.stop();
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得  " + monster.data.CP + "  经验",0,1,false));
				fightTimer.removeEventListener(TimerEvent.TIMER, fightListener);				
				dispatchEvent(new FightEvent(FightEvent.FIGHT_OVER, monsterRow, monsterCol, false));
				if (player_HP == 0) {
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_FIGHT_LOSE, false, 1, 0, 0,true,0.5,0.2));
					dispatchEvent(new Event(Game.GAME_OVER));
				}
			}
			
			if (roundtime == 12 && fightOver == false)
			{ 
				
				if (currTurn == TURN_PLAYER) {
					if (hurtMonster <= 0) {
						hurtMonster = 0;
					}
					changeDisplayText(HURT_MONSTER_TEXT, String( -hurtMonster));
					if (hurtMonster > 0) 
					{
						
					} else {
						hurtMonster = 1;
					}
						
					shakeMonster.startShake();
					
					monster_HP -= hurtMonster;					
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, ("bodyHit" + String(randRange(1, 10))), false, 1, 0, 0.3));
					
					if (monster_HP <= 0) {
						monster_HP = 0;
						
						trace("怪物死了");
						//player.data.HP = player_HP;
						player.data.CP += monster.data.CP;
						fightOver = true;
						
						addImageBitmap(FIGHT_WIN_IMAGE, 190, 140, tileSheetData.imageLibrary["fightWinPng"]);
						
						
					}
						
					
					changeDisplayText(MONSTER_HP_TEXT, monster_HP.toString());

					
					currTurn = TURN_MONSTER;
					
				} else if (currTurn == TURN_MONSTER) {
					if (hurtPlayer <= 0) {
						hurtPlayer = 0;
					}
					changeDisplayText(HURT_PLAYER_TEXT, String( -hurtPlayer));
					if (hurtPlayer > 0)
					{
						
					} else {
						hurtPlayer = 0;
					}
						
						
					shakePlayer.startShake();
					
					player_HP -= hurtPlayer;
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, ("bodyHit" + String(randRange(1, 10))), false, 1, 0, 0.3));
					
					if (player_HP <= 0) 
					{	
						player_HP = 0;
						//fightOver = true;
						trace("你死了");
						
						addImageBitmap(FIGHT_LOSE_IMAGE, 190, 140, tileSheetData.imageLibrary["fightLosePng"]);
						
					
					}
						
					
					changeDisplayText(PLAYER_HP_TEXT, player_HP.toString());				


					currTurn = TURN_PLAYER;
					
				}
					
				roundtime = 0;
			}
			
		}
		
		
	}
	


}