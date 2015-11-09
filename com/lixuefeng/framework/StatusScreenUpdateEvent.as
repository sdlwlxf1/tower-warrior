package com.lixuefeng.framework
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class StatusScreenUpdateEvent extends Event
	{
		
		public static const UPDATE:String = "update statusScreen";
		public var element:String;
		public var text:String;
		public var image:BitmapData;

		public function StatusScreenUpdateEvent(type:String,element:String, text:String = null,image:BitmapData = null, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles,cancelable);
			this.element = element;
			if(text != null) {
				this.text = text;
			}
			
			if (image != null) {
				this.image = image;
			}
		}
		
		
		public override function clone():Event {
			return new StatusScreenUpdateEvent(type,element,text, image, bubbles,cancelable)
		}
		
		
	}
	
}