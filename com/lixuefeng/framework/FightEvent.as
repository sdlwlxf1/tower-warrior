package com.lixuefeng.framework
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	
	 
	public class FightEvent extends Event
	{
		
		public static const FIGHT_START:String = "fight_start";
		public static const FIGHT_OVER:String = "fight_over";
		public var visitMonsterRow:int;
		public var visitMonsterCol:int;
		public var fightFlee:Boolean;
		public var fightType:String;
		public var targetType:String;

		public function FightEvent(type:String,visitMonsterRow:int,visitMonsterCol:int ,fightFlee:Boolean = false, fightType:String = "manual",targetType:String = "monster", bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.visitMonsterRow = visitMonsterRow;
			this.visitMonsterCol = visitMonsterCol;
			this.fightFlee = fightFlee;
			this.fightType = fightType;
			this.targetType = targetType;
		}
		
		
		public override function clone():Event {
			return new FightEvent(type,visitMonsterRow,visitMonsterCol,fightFlee,fightType,targetType, bubbles,cancelable)
		}
		
		
	}
	
}