package com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	
	 
	public class FloorEvent extends Event
	{
		
		public static const UPDATA_FLOOR:String = "updataFloor";
		public var floorId:int;
		public var upOrDown:String;

		public function FloorEvent(type:String,floorId:int,upOrDown:String = null, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles,cancelable);
			this.floorId = floorId;
			this.upOrDown = upOrDown;
		}
		
		
		public override function clone():Event {
			return new FloorEvent(type,floorId,upOrDown, bubbles,cancelable)
		}
		
		
	}
	
}