package  com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class ChatContentData 
	{

		
		public var chatContentArray:Array;
		public var npcStartContentIdArray:Array;
		public var nextContentId:int;
		public var currContentId:int;
		
		public static const SPEAKER_PLAYER:int = 0;
		public static const SPEAKER_NPC1:int = 1;
		public static const SPEAKER_NPC2:int = 2;
		public static const SPEAKER_NPC3:int = 3;
		public static const SPEAKER_NPC4:int = 4;
		public static const SPEAKER_OTHER:int = 99;
		
		public function ChatContentData() 
		{
			init();
		}
		
		private function init():void 
		{
			chatContentArray = [];
			npcStartContentIdArray = [];
			var numberToPush:int = 99;
			var chatXML:XML = ChatContentXML.XMLData;
			var nums:int = chatXML.chat.length();
			var num:int;
			var speakerId:int;
			for (num = 0; num < nums; num++) {
				switch(String(chatXML.chat[num].@speaker)) {
					case "主角":
						speakerId = SPEAKER_PLAYER;
						break;
					case "术士":
						speakerId = SPEAKER_NPC1;
						break;
					case "精灵":
						speakerId = SPEAKER_NPC2;
						break;
					case "公主":
						speakerId = SPEAKER_NPC3;
						break;
					case "魔女":
						speakerId = SPEAKER_NPC4;
						break;
					case "旁白":
						speakerId = SPEAKER_OTHER;
						break;
						
				}
				chatContentArray[num] = [int(chatXML.chat[num].@id), speakerId, String(chatXML.chat[num].@content), int(chatXML.chat[num].@next), int(chatXML.chat[num].@over) , int(chatXML.chat[num].@imageId)];	
			}
			
		}
		
	}

}