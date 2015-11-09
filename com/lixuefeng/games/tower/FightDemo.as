package  com.lixuefeng.games.tower
{
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign; 
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import com.lixuefeng.framework.*;
	import gs.*; 
	import gs.easing.*;



	
	public class FightDemo extends BasicScreen {
		
		public static const PLAYER_IMAGE:int = 0;
		public static const MONSTER_IMAGE:int = 1;
		private static const FW_PLAYER_CIRCLE_IMAGE:int = 2;
		private static const FW_MONSTER_CIRCLE_IMAGE:int = 3;
		private static const FIGHT_START_IMAGE:int = 4;
		private static const FIGHT_FIGHT_IMAGE:int = 5;
		private static const FIGHT_FWPOINT_IMAGE:int = 6;
		private static const FIGHT_WIN_IMAGE:int = 7;
		private static const FIGHT_LOSE_IMAGE:int = 8;
		
		private static const FIGHT_PAUSE:int = 9;
		
		
		
		public static const PLAYER_HP_TEXT:int = 0;
		public static const MONSTER_HP_TEXT:int = 1;
		public static const PLAYER_STR_TEXT:int = 2;
		public static const MONSTER_STR_TEXT:int = 3;
		public static const PLAYER_DEF_TEXT:int = 4;
		public static const MONSTER_DEF_TEXT:int = 5;
		private static const HURT_PLAYER_TEXT:int = 6;
		private static const HURT_MONSTER_TEXT:int = 7;

		
		private static const FIGHT_START_ANIMATION:int = 0;
		private static const FIGHT_PLAYER_TURN:int = 1;
		private static const FIGHT_MONSTER_TURN:int = 2;
		private static const FIGHT_PLAYER_ANIMATION:int = 3;
		private static const FIGHT_MONSTER_ANIMATION:int = 4;
		private static const FIGHT_END_ANIMATION:int = 5;
		private static const FIGHT_WAIT:int = 6;
		private static const FIGHT_COMPUTE:int = 7;
		private static const FIGHT_OVER:int = 8;

		private var monsterRow:int;
		private var monsterCol:int;
		
		private var player:Player;
		private var monster:Monster;
		
		private var roundtime:int = 0;
		private var firstHitTurn:int;
		
		private static const TURN_PLAYER:int = 1;
		private static const TURN_MONSTER:int = 2;
		
		private var player_HP:int;
		private var player_STR:int;
		private var player_DEF:int;
		private var playerCurrFW:int;
		
		private var monster_HP:int;
		private var monster_STR:int;
		private var monster_DEF:int;
		private var monster_FW:int;
		private var monsterCurrFW:int;
		
		private var hurtPlayer:int;
		private var hurtMonster:int;
		private var differentFW:int;
		
		private var fightRank:int = 0;
		
		
		public static const EVENT_WAIT_COMPLETE:String = "wait complete";
		private var barPlayer:Bar;
		private var barMonster:Bar;

		private var timerPeriod:Number;
		private var frameRate:Number;
		private var fightTimer:Timer;
		
		public var systemFunction:Function;
		public var currentSystemState:int;
		public var nextSystemState:int;
		public var lastSystemState:int;
		
		public var waitTime:int;
		public var waitCount:int = 0;
		
		private var keyboardArray:Array = new Array;
		
		private var monsterRandomHeight:int;
		

		private var vx:Number = 10;
		private var lastPlayerX:int = 175;
		private var lastMonsterX:int = 430;
		
		private var tileSheetData:TileSheetData;
		
		private var playerImageNPng:BitmapData;
		private var fightFightPng:BitmapData;
		private var fightStartPng:BitmapData;
		private var fightBackgroundPng:BitmapData;
		private var FWbarPng:BitmapData;
		private var FWbarOutPng:BitmapData;
		private var changePng:BitmapData;
		private var FWcirclePng:BitmapData;
		private var FWpointPng:BitmapData;
		private var fightWinPng:BitmapData;
		private var fightLosePng:BitmapData;
		
		private var shakePlayer:ShakeAnimation;
		private var shakeMonster:ShakeAnimation;
		
		public function FightDemo(player:Player, monster:Monster,monsterRow:int, monsterCol:int, tileSheetData:TileSheetData) 
		{
			this.player = player;
			this.monster = monster;
			this.monsterRow = monsterRow;
			this.monsterCol = monsterCol;
			this.tileSheetData = tileSheetData;
			
			initData();
			
			init();
		}
		
		private function init():void 
		{
			playerImageNPng = tileSheetData.imageLibrary["playerImageNPng"];
			fightFightPng = tileSheetData.imageLibrary["fightFightPng"];
			fightStartPng = tileSheetData.imageLibrary["fightStartPng"];
			fightBackgroundPng = tileSheetData.imageLibrary["fightBackgroundPng"];
			FWbarPng = tileSheetData.imageLibrary["FWbarPng"];
			FWbarOutPng = tileSheetData.imageLibrary["FWbarOutPng"];
			changePng = tileSheetData.imageLibrary["changePng"];
			FWcirclePng = tileSheetData.imageLibrary["FWcirclePng"];
			FWpointPng = tileSheetData.imageLibrary["FWpointPng"];
			fightWinPng = tileSheetData.imageLibrary["fightWinPng"];
			fightLosePng = tileSheetData.imageLibrary["fightLosePng"];
			
			setBackgroundBitmap(fightBackgroundPng);
			addImageBitmap(PLAYER_IMAGE, lastPlayerX, 127, playerImageNPng);
			addImageBitmap(MONSTER_IMAGE, lastMonsterX, 170, monster.view);
			imageBitmaps[MONSTER_IMAGE].scaleX *= 2;
			imageBitmaps[MONSTER_IMAGE].scaleY *= 2;
			
			addImageBitmap(FW_PLAYER_CIRCLE_IMAGE, 140, 100, FWcirclePng);
			addImageBitmap(FW_MONSTER_CIRCLE_IMAGE, 370, 100, FWcirclePng);
			
			
			var textFormat:TextFormat = new TextFormat("Franklin Gothic Demi", 25, null, true,null, null,null,null,TextFormatAlign.CENTER);
			createDisplayText(PLAYER_HP_TEXT, String(player.data.HP), 90, 210,313, textFormat);
			createDisplayText(MONSTER_HP_TEXT, String(monster.data.HP), 90, 413, 313, textFormat);
			createDisplayText(PLAYER_STR_TEXT, String(player.data.STR), 90, 210,350, textFormat);
			createDisplayText(MONSTER_STR_TEXT, String(monster.data.STR), 90, 413, 350, textFormat);	
			createDisplayText(PLAYER_DEF_TEXT, String(player.data.DEF), 90, 210,387, textFormat);
			createDisplayText(MONSTER_DEF_TEXT, String(monster.data.DEF), 90, 413, 387, textFormat);
			var textFormat2:TextFormat = new TextFormat("Gill Sans MT", 60,0xff000000, true,null, null,null,null,TextFormatAlign.CENTER);
			createDisplayText(HURT_MONSTER_TEXT, "", 90, 420, 156, textFormat2);
			createDisplayText(HURT_PLAYER_TEXT, "", 90, 184, 156, textFormat2);
			
			barPlayer = new Bar(FWbarPng, FWbarOutPng, changePng);
			barPlayer.x = 90;
			barPlayer.y = 80;
			addChild(barPlayer);
			
			barMonster = new Bar(FWbarPng, FWbarOutPng, changePng);
			barMonster.x = 560;
			barMonster.y = 80;
			addChild(barMonster);

			addImageBitmap(FIGHT_START_IMAGE, 240, 205, fightStartPng);
			addImageBitmap(FIGHT_FIGHT_IMAGE, 360, 200, fightFightPng);
			
			frameRate = 30;
			timerPeriod = 1000 / frameRate;
			fightTimer=new Timer(timerPeriod);
			fightTimer.addEventListener(TimerEvent.TIMER, fightListener);
			
			firstHitTurn = randRange(1, 2);
			
			TweenLite.delayedCall(0.5, fightStartDelay);
			shakePlayer = new ShakeAnimation(imageBitmaps[PLAYER_IMAGE], 4);
			shakeMonster = new ShakeAnimation(imageBitmaps[MONSTER_IMAGE], 4);
			monsterRandomHeight = barMonster.outSide.height * ( -1 + randRange(monster_FW - 20 , monster_FW + 10) / 100);
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Global.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		}
		
		private function initData():void {
			

			player_HP = player.data.HP;
			player_STR = player.data.STR;
			player_DEF = player.data.DEF;
			
			
			monster_HP = monster.data.HP;
			monster_STR = monster.data.STR;
			monster_DEF = monster.data.DEF;
			monster_FW = monster.data.FW;
			
			hurtPlayer = monster_STR - player_DEF;
			hurtMonster = player_STR - monster_DEF;
		}
		
		private function fightStartDelay():void {
			TweenLite.to(imageBitmaps[FIGHT_FIGHT_IMAGE], 0.7, { x:-40, alpha:0, ease:Back.easeIn});
			TweenLite.to(imageBitmaps[FIGHT_START_IMAGE], 0.7, { x:840, alpha:0, ease:Back.easeIn, onComplete:completed } );			
		}
		
		private function completed():void {
			addImageBitmap(FIGHT_FWPOINT_IMAGE, 400, 40, FWpointPng);
			if (firstHitTurn == FIGHT_MONSTER_TURN) {
				imageBitmaps[FIGHT_FWPOINT_IMAGE].x = 530;
				imageBitmaps[FIGHT_FWPOINT_IMAGE].y = 40;
			} else {
				imageBitmaps[FIGHT_FWPOINT_IMAGE].x = 90;
				imageBitmaps[FIGHT_FWPOINT_IMAGE].y = 40;

			}
			switchSystemState(FIGHT_START_ANIMATION);
			fightTimer.start();
		}
		

		
		private function fightListener(e:TimerEvent):void {
			
			systemFunction();
			if (keyboardArray[81] == true && monster.row > 4) {
				switchSystemState(FIGHT_PAUSE);
				dispatchEvent(new FightEvent(FightEvent.FIGHT_OVER, monsterRow, monsterCol, true));
			}
			
			
		}
		
		private function fightPause():void 
		{
			
		}
		
		public function switchSystemState(stateval:int):void {
			lastSystemState = currentSystemState;
			currentSystemState = stateval;
			
			trace("currentFightState=" + currentSystemState)
			switch(stateval) {

				case FIGHT_START_ANIMATION:
					systemFunction = fightStart;
					break;	
				
				case FIGHT_PLAYER_TURN:
					systemFunction = playerTurn;
					break;					
				case FIGHT_MONSTER_TURN:
					systemFunction = monsterTurn;
					break
				case FIGHT_PLAYER_ANIMATION:
					systemFunction = playerAnimation;
					break;
				case FIGHT_MONSTER_ANIMATION:
					systemFunction = monsterAnimation;
					break;
				
				case FIGHT_END_ANIMATION:
					systemFunction = fightEnd;
					break;
				case FIGHT_OVER:
					systemFunction = fightOver;
					break;
					
				case FIGHT_WAIT: 
					systemFunction = fightWait;
					break;
					
				case FIGHT_COMPUTE:
					systemFunction = fightCompute;
					break;
					
				case FIGHT_PAUSE:
					systemFunction = fightPause;
					break;
					
				
			}
				
		}
				
		private function fightStart():void {
			keyboardArray = [];
			if (firstHitTurn == FIGHT_MONSTER_TURN) {
				imageBitmaps[FIGHT_FWPOINT_IMAGE].x = 530;
				imageBitmaps[FIGHT_FWPOINT_IMAGE].y = 40;
			} else {
				imageBitmaps[FIGHT_FWPOINT_IMAGE].x = 90;
				imageBitmaps[FIGHT_FWPOINT_IMAGE].y = 40;

			}
			switchSystemState(firstHitTurn);

		}
		

		

		
		private function playerTurn():void {
			imageBitmaps[FIGHT_FWPOINT_IMAGE].x = 90;
			imageBitmaps[FIGHT_FWPOINT_IMAGE].y = 40;
			
			
			if (keyboardArray[32] == true) {
				//barPlayer.vLength = 3;
				barPlayer.aLength = 1;
				barPlayer.updata();
				barPlayer.render();
				if (barPlayer.checkTheEnd(30)) {
					barPlayer.stopUpdata();
					barPlayer.resetRender();
				}
			}
			
			if (keyboardArray[32] == false) {
				barPlayer.stopUpdata(); 
				//monsterRandomHeight = barMonster.outSide.height * ( -1 + randRange(monster_FW - 30 , monster_FW + 10) / 100);


				if (firstHitTurn == TURN_PLAYER) {
					switchSystemState(FIGHT_MONSTER_TURN);
				} else {
					switchSystemState(FIGHT_COMPUTE);
				}
			}

		}
		
		private function randRange(min:Number, max:Number):Number {

			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;

			return randomNum;

		}
		
		private function monsterTurn():void {
			imageBitmaps[FIGHT_FWPOINT_IMAGE].x = 530;
			imageBitmaps[FIGHT_FWPOINT_IMAGE].y = 40;
				
			barMonster.vLength = 10;
			barMonster.updata();
			barMonster.render();
			if (barMonster.checkTheEnd(monsterRandomHeight)) {
				barMonster.stopUpdata();
				
				if (firstHitTurn == TURN_MONSTER) {
					switchSystemState(FIGHT_PLAYER_TURN);
				} else {
					switchSystemState(FIGHT_COMPUTE);
				}
			}
			
		}
		
		private function playerAnimation():void 
		{
			
			if (hurtPlayer > 0)
			{		
								
			} else {
				hurtPlayer = 0;
			}
			
			
			player_HP -= hurtPlayer;
			if (player_HP <= 0) 
			{	
				player_HP = 1;

				trace("你死了");
			} else {
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, ("bodyHit" + String(randRange(1, 10))), false, 1, 0, 0.3));
			}
			
			
			shakePlayer.startShake();
				
			changeDisplayText(PLAYER_HP_TEXT, player_HP.toString());			
			changeDisplayText(HURT_PLAYER_TEXT, String( -hurtPlayer));
			if (player_HP == 0) {
				nextSystemState = FIGHT_END_ANIMATION;
				
			} else if (firstHitTurn == TURN_PLAYER) {
				
				nextSystemState = FIGHT_MONSTER_ANIMATION;
			} else if (firstHitTurn == TURN_MONSTER) {
				monsterRandomHeight = barMonster.outSide.height * ( -1 + randRange(monster_FW - 30 , monster_FW + 10) / 100);
				nextSystemState = FIGHT_MONSTER_TURN;
			}
			waitTime = 40;
			switchSystemState(FIGHT_WAIT);
			addEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener, false, 0, true);
			
		}
		
		private function monsterAnimation():void 
		{
			
			if (hurtMonster > 0) 
			{				
											
			} else {
				hurtMonster = 1;
			}
			
			monster_HP -= hurtMonster;
			if (monster_HP <= 0) {
				monster_HP = 0;
				trace("怪物死了");
			} else {
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, ("bodyHit" + String(randRange(1, 10))), false, 1, 0, 0.3));
			}
			
			
			shakeMonster.startShake();
			
			changeDisplayText(HURT_MONSTER_TEXT, String( -hurtMonster));
			changeDisplayText(MONSTER_HP_TEXT, monster_HP.toString());
			
			if (monster_HP == 0) {
				nextSystemState = FIGHT_END_ANIMATION;
				
			} else if (firstHitTurn == TURN_PLAYER) {
				
				nextSystemState = FIGHT_PLAYER_TURN;
			} else if (firstHitTurn == TURN_MONSTER) {
				
				nextSystemState = FIGHT_PLAYER_ANIMATION;
			}
			waitTime = 40;
			switchSystemState(FIGHT_WAIT);
			addEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener, false, 0, true);
		}


		
		private function fightCompute():void {
			
			imageBitmaps[FIGHT_FWPOINT_IMAGE].x = 1000;
			imageBitmaps[FIGHT_FWPOINT_IMAGE].y = 800;
			//Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			//Global.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			keyboardArray = [];

			playerCurrFW = barPlayer.changeSprite.height;
			monsterCurrFW = barMonster.changeSprite.height;
			differentFW = playerCurrFW - monsterCurrFW;
			
			hurtPlayer = (monster_STR - player_DEF) * (1 - differentFW / barPlayer.outSide.height * 0.5);
			hurtMonster = (player_STR - monster_DEF) * (1 + differentFW / barPlayer.outSide.height * 0.5);
			
			if (lastSystemState == FIGHT_PLAYER_TURN) {
				switchSystemState(FIGHT_MONSTER_ANIMATION);
			} else if (lastSystemState == FIGHT_MONSTER_TURN) {
				switchSystemState(FIGHT_PLAYER_ANIMATION);
			}
			
		}
			//trace(player_HP + "           " + monster_HP);				
/*
		addImageBitmap(FIGHT_LOSE_IMAGE, 287, 188, fightLosePng);
			} else  if (monster_HP <= 0) {
				addImageBitmap(FIGHT_WIN_IMAGE, 287, 188, fightWinPng);
		*/
		private function fightWait():void {
			waitCount++;
			if (waitCount == 5) {
				shakeMonster.stopShake();
				shakePlayer.stopShake();
				
			} else if (waitCount == 15) {
				changeDisplayText(HURT_PLAYER_TEXT, "");
				changeDisplayText(HURT_MONSTER_TEXT, "");
			}
			
			if (waitCount > waitTime) {
				waitCount = 0;
				dispatchEvent(new Event(EVENT_WAIT_COMPLETE));
			}
		}
		//dispatchEvent(new FightEvent(FightEvent.FIGHT_OVER, monster.row));fightTimer.stop();
		public function waitCompleteListener(e:Event):void {
			switch(lastSystemState) {
				
				case FIGHT_PLAYER_ANIMATION:
					barPlayer.resetRender();				
					break;
				case FIGHT_MONSTER_ANIMATION:
					barMonster.resetRender();					
					break;
				case FIGHT_OVER:
					break;
			}
			
			removeEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener);
			switchSystemState(nextSystemState);
		}
		
		private function fightOver():void {
			fightTimer.stop();
			fightTimer.removeEventListener(TimerEvent.TIMER, fightListener);
			if (player_HP <= 0) {
				dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_FIGHT_LOSE, false, 1, 0, 0,true,3,0.4));
				dispatchEvent(new Event(Game.GAME_OVER));
				dispatchEvent(new FightEvent(FightEvent.FIGHT_OVER, monsterRow, monsterCol, true));
			} else if (monster_HP <= 0) {
				dispatchEvent(new NewsEvent(NewsEvent.READ_NEWS,"auto", "获得  " + monster.data.CP + "  经验",0,1,false));
				dispatchEvent(new FightEvent(FightEvent.FIGHT_OVER, monsterRow,monsterCol, false));
				//player.data.HP = player_HP;
				monster.data.HP = monster_HP;
				player.data.CP += monster.data.CP;
			}
		}
		
		private function fightEnd():void {
			waitTime = 20;
			switchSystemState(FIGHT_WAIT);
			nextSystemState = FIGHT_OVER;
			addEventListener(EVENT_WAIT_COMPLETE, waitCompleteListener, false, 0, true);
			
			if (player_HP <= 0) {				
				addImageBitmap(FIGHT_LOSE_IMAGE, 287, 188, fightLosePng);
			} else  if (monster_HP <= 0) {
				addImageBitmap(FIGHT_WIN_IMAGE, 287, 188, fightWinPng);
			}
		}
		
		
		
		
		private function keyDownListener(e:KeyboardEvent):void
		{
			keyboardArray[e.keyCode] = true;
		}

		private function keyUpListener(e:KeyboardEvent):void
		{
			keyboardArray[e.keyCode] = false;
		}

	}
	
}
