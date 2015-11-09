package com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	
	 
	public class ChatEvent extends Event
	{
		
		public static const CHAT_START:String = "chat_start";
		public static const CHAT_OVER:String = "chat_over";
		public var chatNum:int;
		public var chatFlee:Boolean;
		public var chatType:String;

		public function ChatEvent(type:String,chatType:String = null,chatNum:int = -1,chatFlee:Boolean = false, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.chatNum = chatNum;
			this.chatFlee = chatFlee;
			this.chatType = chatType;
		}
		
		
		public override function clone():Event {
			return new ChatEvent(type,chatType,chatNum,chatFlee, bubbles,cancelable)
		}
		
		
	}
	
}