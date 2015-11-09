package  com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author li xuefeng
	 */

	public class SimpleButtonEvent extends Event
	{
		
		public static const BUTTON_ID:String = "button id";
		public var id:int;

		public function SimpleButtonEvent(type:String,id:int, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles,cancelable);
			this.id = id;
		}
		
		
		public override function clone():Event {
			return new SimpleButtonEvent(type, id, bubbles, cancelable);
		}
		
		
	}
	
}

