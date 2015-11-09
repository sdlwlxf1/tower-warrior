package com.lixuefeng.framework
{
	import flash.events.*;
	
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class CustomEventSound extends Event
	{
		
		public static const PLAY_SOUND:String = "playsound";
		public static const STOP_SOUND:String = "stopsound";
		
		public var name:String;
		public var loops:int;
		public var offset:Number;
		public var volume:Number;
		public var isSoundTrack:Boolean;
		
		public var fade:Boolean;
		public var lastTime:Number;
		public var lastVolumn:Number;

		public function CustomEventSound(type:String,name:String,isSoundTrack:Boolean=false,loops:int=0,offset:Number=0,volume:Number=1,fade:Boolean = false,lastTime:Number = 0, lastVolumn:Number = 0, bubbles:Boolean=false,cancelable:Boolean=false)
		{
			
			
			super(type, bubbles, cancelable);
			this.name = name;
			this.loops = loops;
			this.offset = offset;
			this.volume = volume;
			this.isSoundTrack = isSoundTrack;
			
			this.lastTime = lastTime;
			this.fade = fade;
			this.lastVolumn = lastVolumn;
			
		}
		
		
		public override function clone():Event {
			return new CustomEventSound(type, name,isSoundTrack,loops,offset,volume,fade,lastTime,lastVolumn,bubbles,cancelable)
		}
		
		public override function toString():String {
			return formatToString(type, "type", "bubbles", "cancelable", "eventPhase",name,isSoundTrack,loops,offset,volume);
		}
	}
	
}