package com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	
	 
	public class SwitchEvent extends Event
	{
		public var visitItemSheetData:int;
		public var visitItemSheetTypeData:int;
		public var switchType:String;
		public static const ON_SWITCH:String = "onSwitch";

		public function SwitchEvent(type:String,switchType:String, visitItemSheetData:int, visitItemSheetTypeData:int, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.visitItemSheetData = visitItemSheetData;
			this.visitItemSheetTypeData = visitItemSheetTypeData;
			this.switchType = switchType;
		}
		
		
		public override function clone():Event {
			return new SwitchEvent(type,switchType,visitItemSheetData,visitItemSheetTypeData, bubbles,cancelable)
		}
		
		
	}
	
}