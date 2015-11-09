package com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	
	 
	public class DoorEvent extends Event
	{
		public var visitItemSheetData:int;
		
		public static const OPEN_DOOR:String = "openDoor";

		public function DoorEvent(type:String,visitItemSheetData:int, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.visitItemSheetData = visitItemSheetData;
		}
		
		
		public override function clone():Event {
			return new DoorEvent(type,visitItemSheetData, bubbles,cancelable)
		}
		
		
	}
	
}