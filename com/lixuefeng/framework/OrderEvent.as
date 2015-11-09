package  com.lixuefeng.framework
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	import flash.events.Event;
	public class OrderEvent extends Event
	{
		
		public static const ORDER_START:String = "order_start";
		public static const ORDER_OVER:String = "order_over";
		
		public var orderType:String;
		public var orderId:int;

		public function OrderEvent(type:String,orderType:String = null,orderId:int = 0, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.orderType = orderType;
			this.orderId = orderId;
		}
		
		
		public override function clone():Event {
			return new OrderEvent(type,orderType,orderId, bubbles,cancelable)
		}
		
	}

}