package com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	
	 
	public class PickEvent extends Event
	{
		public var itemType:uint;
		public static const PICK:String = "pick";

		public function PickEvent(type:String,itemType:uint, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.itemType = itemType;
		}
		
		
		public override function clone():Event {
			return new PickEvent(type, itemType, bubbles, cancelable);
		}
		
		
	}
	
}