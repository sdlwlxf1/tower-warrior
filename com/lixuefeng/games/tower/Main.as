package com.lixuefeng.games.tower
{
	import flash.display.Sprite;
	import com.lixuefeng.games.tower.Global;
	import com.lixuefeng.framework.*;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.display.Stage;
	import gs.*;
	import gs.easing.*;
	import flash.media.*;
	import flash.media.SoundMixer;
	import flash.events.Event;
	import com.lixuefeng.utils.MonitorKit;
	
	//import unit4399.events.SaveEvent;
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class Main extends GameFrameWork
	{
		
		private var tileSheetData:TileSheetData;
		
		//广告KEY
		private static var _4399_function_ad_id:String = "92d6cef76cd06829e088932fe9fd819b";
		
		//积分KEY
		public static var _4399_function_score_id:String = "d8c8d4731a33a0a581edc746e73eadc7200";
		
		//存档KEY
		public static var _4399_function_archives_id:String = '3885799f65acec467d97b4923caebaae';
		
		//游戏推荐
		public static var _4399_function_gameList_id:String = '944c23f5e64a80647f8d0f3435f5c7a8';
		
		public function Main()
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		
		}
		
		private function init(e:Event = null):void
		{
			if (e != null)
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}
			
			stage.stageFocusRect = false;
			Global.stage = stage;
			
			
			
			frameRate = 30;
			startTimer(true);
			switchSystemState(FrameWorkStates.STATE_SYSTEM_LOGO);
		}
		
		override public function initData():void
		{
			tileSheetData = new TileSheetData();
		}
		
		override public function initGame():void
		{
			game = new Tower(tileSheetData);
			game.x = 160;
			game.y = 20;
			game.alpha = 0;
			
			(game as Tower).setMainHold(this);
			game.initGame();
			
			//add score board to the screen as the seconf layer
			statusScreen = new StatusScreen();
			var screenTextFormat:TextFormat = new TextFormat("_sans", "16", "0xffffff", "false");
			var textFormat:TextFormat = new TextFormat("Gill Sans MT", 20, 0xff000000, true, null, null, null, null, TextFormatAlign.CENTER);
			var textFormat1:TextFormat = new TextFormat("Gill Sans MT", 25, 0xff000000, true, null, null, null, null, TextFormatAlign.CENTER);
			
			var tileBitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
			
			statusScreen.setBackgroundBitmap(tileSheetData.imageLibrary["statusScreenBGJpg"]);
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_CURRFLOOR, new StatusScreenElement(662, 17, "", textFormat, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_HP, new StatusScreenElement(700, 220, "", textFormat, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_STR, new StatusScreenElement(700, 254, "", textFormat, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_DEF, new StatusScreenElement(700, 288, "", textFormat, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_CP, new StatusScreenElement(700, 320, "", textFormat, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_KEY_YELLOW, new StatusScreenElement(50, 290, "", textFormat1, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_KEY_BLUE, new StatusScreenElement(50, 350, "", textFormat1, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_TEXT_KEY_RED, new StatusScreenElement(50, 410, "", textFormat1, null));
			statusScreen.createElement(AddId.SCREEN_STATUS_IMAGE_SWORD, new StatusScreenElement(48, 77, null, null, tileBitmapData));
			statusScreen.createElement(AddId.SCREEN_STATUS_IMAGE_ARMOUR, new StatusScreenElement(48, 187, null, null, tileBitmapData));
			/*
			   //screen text initializations
			   screenTextFormat = new TextFormat("_sans", "16", "0xffffff", "false");
			   screenTextFormat.align = flash.text.TextFormatAlign.CENTER;
			   screenButtonFormat = new TextFormat("_sans", "12", "0x000000", "false");
			 */
			
			titleScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_TITLE);
			titleScreen.setBackgroundBitmap(tileSheetData.imageLibrary["titleScreenBGJpg"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_START, 117, 180, tileSheetData.imageLibrary["titleScreenBeginPng"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_CON, 117, 230, tileSheetData.imageLibrary["titleScreenConPng"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_SET, 117, 280, tileSheetData.imageLibrary["titleScreenSetPng"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_HELP, 117, 330, tileSheetData.imageLibrary["titleScreenHelpPng"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_EXIT, 117, 380, tileSheetData.imageLibrary["titleScreenExitPng"]);
			
			titleScreen.addImageBitmap(AddId.SCREEN_TITLE_IMAGE_POINT, 77, titleScreen.simpleButtons[AddId.SCREEN_TITLE_BUTTON_START].y + 14, tileSheetData.imageLibrary["titleScreenPointPng"]);
			
			titleScreen.addImageBitmap(AddId.SCREEN_TITLE_IMAGE_START, 300, 80, tileSheetData.imageLibrary["titleScreenBeginIMPng"]);
			titleScreen.addImageBitmap(AddId.SCREEN_TITLE_IMAGE_CON, 350, 100, tileSheetData.imageLibrary["titleScreenConIMPng"]);
			titleScreen.addImageBitmap(AddId.SCREEN_TITLE_IMAGE_SET, 300, 80, tileSheetData.imageLibrary["titleScreenBeginIMPng"]);
			titleScreen.addImageBitmap(AddId.SCREEN_TITLE_IMAGE_HELP, 370, 100, tileSheetData.imageLibrary["titleScreenHelpTextPng"]);
			titleScreen.addImageBitmap(AddId.SCREEN_TITLE_IMAGE_EXIT, 330, 135, tileSheetData.imageLibrary["titleScreenExitIMPng"]);
			
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_LOAD1, 500, 100, tileSheetData.imageLibrary["load1Png"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_LOAD2, 500, 100 + tileSheetData.imageLibrary["load2Png"].height * 1, tileSheetData.imageLibrary["load2Png"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_LOAD3, 500, 100 + tileSheetData.imageLibrary["load2Png"].height * 2, tileSheetData.imageLibrary["load3Png"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_LOAD4, 500, 100 + tileSheetData.imageLibrary["load2Png"].height * 3, tileSheetData.imageLibrary["load4Png"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_LOAD5, 500, 100 + tileSheetData.imageLibrary["load2Png"].height * 4, tileSheetData.imageLibrary["load5Png"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_LOAD6, 500, 100 + tileSheetData.imageLibrary["load2Png"].height * 5, tileSheetData.imageLibrary["load6Png"]);
			titleScreen.createButton(AddId.SCREEN_TITLE_BUTTON_LOAD7, 500, 100 + tileSheetData.imageLibrary["load2Png"].height * 6, tileSheetData.imageLibrary["load7Png"]);
			
			titleScreen.imageBitmaps[AddId.SCREEN_TITLE_IMAGE_CON].alpha = 0;
			titleScreen.imageBitmaps[AddId.SCREEN_TITLE_IMAGE_SET].alpha = 0;
			titleScreen.imageBitmaps[AddId.SCREEN_TITLE_IMAGE_HELP].alpha = 0;
			titleScreen.imageBitmaps[AddId.SCREEN_TITLE_IMAGE_EXIT].alpha = 0;
			
			var i:int;
			for (i = 5; i < titleScreen.simpleButtons.length; i++)
			{
				titleScreen.simpleButtons[i].mouseEnabled = false;
				titleScreen.simpleButtons[i].alpha = false;
			}
			
			titleScreen.imageBitmapsSeenId = 0;
			/*
			   instructionsScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_INSTRUCTIONS,640,500,false,0x0000dd);
			   instructionsScreen.createOkButton("Start", new Point(250, 250), 100, 20,screenButtonFormat, 0x000000, 0xff0000,2);
			   instructionsScreen.createDisplayText("Find the treasure.\nDestroy the tanks!\nArrows and Space",250,new Point(180,150),screenTextFormat);
			
			 */
			
			gameOverScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_GAME_OVER);
			gameOverScreen.setBackgroundBitmap(tileSheetData.imageLibrary["gameOverJpg"]);
			gameOverScreen.createButton(AddId.SCREEN_GAMEOVER_BUTTON_RESTART, 300, 280, tileSheetData.imageLibrary["gameRestartPng"]);
			gameOverScreen.addImageBitmap(AddId.SCREEN_GAMEOVER_IMAGE_GAMEOVER, 320, 200, tileSheetData.imageLibrary["gameOverPng"]);
			gameOverScreen.addImageBitmap(AddId.SCREEN_GAMEOVER_IMAGE_GAMEALLOVER, 348, 180, tileSheetData.imageLibrary["gameAllOverPng"]);
			/*
			
			   levelInScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LEVEL_IN, 640, 500, true, 0xaaff0000);
			   levelInText = "Level ";
			   levelInScreen.createDisplayText(levelInText,100,new Point(250,150),screenTextFormat);
			 */
			
			//set initial game state
			
			//sounds
			/*
			   soundManager.addSound(SOUND_ENEMY_FIRE,new SoundEnemyFire);
			   soundManager.addSound(SOUND_EXPLODE, new SoundExplode);
			   soundManager.addSound(SOUND_PLAYER_EXPLODE,new SoundPlayerExplode);
			   soundManager.addSound(SOUND_PLAYER_FIRE,new SoundPlayerFire);
			
			   soundManager.addSound(SOUND_PICK_UP,new SoundPickUp);
			   soundManager.addSound(SOUND_GOAL,new SoundGoal);
			   soundManager.addSound(SOUND_HIT, new SoundHit);
			 */
			soundManager.addSound(AddId.SOUND_MUSIC, new SoundMusic);
			soundManager.addSound(AddId.SOUND_PLAYER_MOVE1, new SoundPlayerMove1);
			soundManager.addSound(AddId.SOUND_PLAYER_MOVE2, new SoundPlayerMove2);
			soundManager.addSound(AddId.SOUND_MENU_OPEN, new SoundMenuOpen);
			soundManager.addSound(AddId.SOUND_MENU_CLOSE, new SoundMenuClose);
			soundManager.addSound(AddId.SOUND_CHAT_CHANGE, new SoundChatChange);
			
			soundManager.addSound(AddId.SOUND_BODY_HIT1, new SoundBodyHit1);
			soundManager.addSound(AddId.SOUND_BODY_HIT2, new SoundBodyHit2);
			soundManager.addSound(AddId.SOUND_BODY_HIT3, new SoundBodyHit3);
			soundManager.addSound(AddId.SOUND_BODY_HIT4, new SoundBodyHit4);
			soundManager.addSound(AddId.SOUND_BODY_HIT5, new SoundBodyHit5);
			soundManager.addSound(AddId.SOUND_BODY_HIT6, new SoundBodyHit6);
			soundManager.addSound(AddId.SOUND_BODY_HIT7, new SoundBodyHit7);
			soundManager.addSound(AddId.SOUND_BODY_HIT8, new SoundBodyHit8);
			soundManager.addSound(AddId.SOUND_BODY_HIT9, new SoundBodyHit9);
			soundManager.addSound(AddId.SOUND_BODY_HIT10, new SoundBodyHit10);
			
			soundManager.addSound(AddId.SOUND_DOOR_OPEN, new SoundDoorOpen);
			soundManager.addSound(AddId.SOUND_ADD_STONE, new SoundAddStone);
			
			soundManager.addSound(AddId.SOUND_SHAKE_TOWER, new SoundShakeTower);
			soundManager.addSound(AddId.SOUND_FIGHT_LOSE, new SoundFightLose);
			soundManager.addSound(AddId.SOUND_PICK_KEY, new SoundPickKey);
			soundManager.addSound(AddId.SOUND_PICK_GEM1, new SoundPickGem1);
			soundManager.addSound(AddId.SOUND_PICK_GEM2, new SoundPickGem2);
			soundManager.addSound(AddId.SOUND_PICK_GEM3, new SoundPickGem3);
			soundManager.addSound(AddId.SOUND_PICK_DRUG, new SoundPickDrug);
		
		/*
		   soundManager.addSound(SOUND_HIT_WALL,new SoundHitWall);
		   soundManager.addSound(SOUND_LIFE, new SoundLife);
		 */
		
			//create timer and run it one time
			
			var monitor:MonitorKit = new MonitorKit(MonitorKit.MKMODE_T);
			addChild(monitor);
		
		}
		
		override public function systemLogo():void
		{
			logoScreen = new BasicScreen(FrameWorkStates.STATE_SYSTEM_LOGO);
			logoScreen.addImageBitmap(0, 190, 130, new LOGO(0, 0));
			logoScreen.addImageBitmap(1, 290, 210, new LOGO1(0, 0));
			super.systemLogo();
		}
		
		override public function systemTitle():void
		{
			
			soundManager.playSound(AddId.SOUND_MUSIC, false, 999, 0, 0);
			TweenLite.to(soundManager.soundChannels[AddId.SOUND_MUSIC], 6, {volume: 3, onUpdate: updateChannel, onUpdateParams: [AddId.SOUND_MUSIC]});
			super.systemTitle();
		}
		
		override public function systemNewGame():void
		{
			TweenLite.to(soundManager.soundChannels[AddId.SOUND_MUSIC], 3, {volume: 0, onUpdate: updateChannel, onUpdateParams: [AddId.SOUND_MUSIC], onComplete: completeChannel, onCompleteParams: [AddId.SOUND_MUSIC]});
			super.systemNewGame();
		}
		
		private function updateChannel(soundId:String):void
		{
			var soundTransform:SoundTransform = new SoundTransform(soundManager.soundChannels[soundId].soundTransform.volume, 0);
			soundManager.soundChannels[soundId].soundTransform = soundTransform;
		}
		
		private function completeChannel(soundId:String):void
		{
			soundManager.stopSound(soundId);
		}
	
	}

}