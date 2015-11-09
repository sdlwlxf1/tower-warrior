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
	import flash.utils.Timer;
	import com.lixuefeng.framework.FightEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign; 
	import flash.text.Font;
	
	public class Chat extends BasicScreen
	{
		
		
		public static const CHAT_ID:int = 0;
		public static const CHAT_SPEAKER:int = 1;
		public static const CHAT_CONTENT:int = 2;
		public static const CHAT_NEXT:int = 3;
		public static const CHAT_OVER:int = 4;
		public static const CHAT_IMAGE_ID:int = 5;
		
		
		
		public static const CHAT_SPEAKER_IMAGE = 0;
		public static const CHAT_CONTENT_TEXT = 0;
		
		private var player:Player;
		private var npc:NPC;
		private var chatContentData:ChatContentData;
		private var tileSheetData:TileSheetData;
		private var roleChatImageBitmapDatas:Array;
		private var chatBackground:BitmapData;
		
		private var speakerId:int;
		private var currContentId:int;
		private var currSpeakerId:int;
		private var currRoleImageId:int;		
		private var currRoleImage:BitmapData;
		private var currContent:Array;
		
		private var setContentId:int;
		
		private var type:String;
		
		
		public function Chat(type:String, chatContentData:ChatContentData, tileSheetData:TileSheetData, npc:NPC = null, setContentId:int = -1) 
		{
			this.type = type;
			this.npc = npc;
			this.chatContentData = chatContentData;
			this.tileSheetData = tileSheetData;
			this.setContentId = setContentId;		
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);
			init();
		}
		
		private function init():void
		{
			//从图片库中取出图片数据
			roleChatImageBitmapDatas = tileSheetData.imageLibrary["roleChatImageBitmapDatas"];
			chatBackground = tileSheetData.imageLibrary["chatBackground"];
			
			
			if(type == "manual") {
			
				switch(npc.data.name) {
					case "术士":
						speakerId = ChatContentData.SPEAKER_NPC1;					
						break;
					case "精灵":
						speakerId = ChatContentData.SPEAKER_NPC2;
						break;
					case "公主":
						speakerId = ChatContentData.SPEAKER_NPC3;
						break;
					case "魔女":
						speakerId = ChatContentData.SPEAKER_NPC4;
						break;
				}
				currContentId = chatContentData.npcStartContentIdArray[speakerId];
			
			} else if (type == "auto") {
				speakerId == ChatContentData.SPEAKER_PLAYER;
				currContentId = chatContentData.npcStartContentIdArray[speakerId];
			}
			if (setContentId != -1) {
				currContentId = setContentId;
			}
			currContent = chatContentData.chatContentArray[currContentId];
			currSpeakerId = currContent[CHAT_SPEAKER];
			if (currSpeakerId == ChatContentData.SPEAKER_OTHER) {
				currRoleImage = null;
			} else {
				
				currRoleImageId = currContent[CHAT_IMAGE_ID];
				currRoleImage = roleChatImageBitmapDatas[currSpeakerId][currRoleImageId];
			}
			
			
			setBackgroundBitmap(chatBackground);

			var textFormat:TextFormat = new TextFormat("微软雅黑", 17,0xff000000, true,null, null,null,null,TextFormatAlign.LEFT);
			createDisplayText(CHAT_CONTENT_TEXT, "", 180, 100, 25, textFormat);
			
			
			displayTexts[CHAT_CONTENT_TEXT].defaultTextFormat = textFormat;			
			displayTexts[CHAT_CONTENT_TEXT].wordWrap = true;
			addImageBitmap(CHAT_SPEAKER_IMAGE, -130, -160 ,  currRoleImage);
			changeDisplayText(CHAT_CONTENT_TEXT, currContent[CHAT_CONTENT]);
			displayTexts[CHAT_CONTENT_TEXT].y = (backgroundBitmap.height - displayTexts[CHAT_CONTENT_TEXT].textHeight) * 0.5 - 10;
		}
		
		public function removeKeyListener():void {
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		}
		
		private function keyDownListener(e:KeyboardEvent):void 
		{
			if (e.keyCode == 32) {
				
				if (currContent[CHAT_OVER] == 1) {
					if(setContentId == -1) {
						chatContentData.npcStartContentIdArray[speakerId] = currContent[CHAT_NEXT];
					}
					Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
					dispatchEvent(new ChatEvent(ChatEvent.CHAT_OVER, String(currContent[CHAT_ID])));
				} else {
					dispatchEvent(new CustomEventSound(CustomEventSound.PLAY_SOUND, AddId.SOUND_CHAT_CHANGE, false, 1, 0,0.3));
				}
				
				chatContentData.currContentId = currContent[CHAT_NEXT];
				currContentId = chatContentData.currContentId;
				currContent = chatContentData.chatContentArray[currContentId];
				currSpeakerId = currContent[CHAT_SPEAKER];
				if (currSpeakerId == ChatContentData.SPEAKER_OTHER) {
					currRoleImage = null;
				} else {
					currRoleImageId = currContent[CHAT_IMAGE_ID];
					currRoleImage = roleChatImageBitmapDatas[currSpeakerId][currRoleImageId];
				}
				
				changeDisplayText(CHAT_CONTENT_TEXT, currContent[CHAT_CONTENT]);
				displayTexts[CHAT_CONTENT_TEXT].y = (backgroundBitmap.height - displayTexts[CHAT_CONTENT_TEXT].textHeight) * 0.5 - 10;
				
				imageBitmaps[CHAT_SPEAKER_IMAGE].bitmapData = currRoleImage;
				
				
				
				
			}
			
			
		}
		
		
	}

}