package com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	
	 
	public class NewsEvent extends Event
	{
		public var newsType:String;
		public var newsContent:String;
		public var visitItemId:int;
		public var lastTime:Number;
		public var removeKey:Boolean;

		
		public static const READ_NEWS:String = "readNews";
		public static const READ_NEWS_OVER:String = "readNewsOver";

		public function NewsEvent(type:String, newsType:String = null, newsContent:String = null, visitItemId:int = 0, lastTime:Number = 0.8, removeKey:Boolean = true, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.newsType = newsType;
			this.newsContent = newsContent;
			this.visitItemId = visitItemId;
			this.lastTime = lastTime;
			this.removeKey = removeKey;
		}
		
		
		public override function clone():Event {
			return new NewsEvent(type,newsType,newsContent,visitItemId,lastTime, removeKey, bubbles,cancelable)
		}
		
		
	}
	
}