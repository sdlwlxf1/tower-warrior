package  com.lixuefeng.games.tower
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.lixuefeng.framework.AnimationFactory;
	import com.lixuefeng.framework.AnimationList;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	/**
	 * ...
	 * @author li xuefeng
	 */
	public class Monster
	{

		public var data:RoleData;
		private var monsterData:Array;
		private var npcData:Array;
		private var tileSheetData:TileSheetData;
		
		public var row:int;
		public var view:BitmapData;
		
		public static const MONSTER_ID:int = 0;
		public static const MONSTER_NAME:int = 1;
		public static const MONSTER_HP:int = 2;
		public static const MONSTER_CP:int = 3;
		public static const MONSTER_STR:int = 4;
		public static const MONSTER_DEF:int = 5;
		public static const MONSTER_FW:int = 6;
		
		//这里的row代表的是怪物图片中第几行图片
		public function Monster(row:int, tileSheetData:TileSheetData) 
		{
			this.row = row;
			this.tileSheetData = tileSheetData;
			initData(row);
			initView(row);
		}
		
		private function initData(row:int):void
		{
			if (row < 5) {
				data = new NPCData;
				npcData = [];
				npcData = tileSheetData.npcSheetData[row];
				data.id = npcData[NPC.NPC_ID];
				data.name = npcData[NPC.NPC_NAME];
				data.HP = npcData[NPC.NPC_HP];
				data.CP = npcData[NPC.NPC_CP];
				data.STR = npcData[NPC.NPC_STR];
				data.DEF = npcData[NPC.NPC_DEF];
				data.FW = npcData[NPC.NPC_FW];
			} else {			
				data = new MonsterData;
				monsterData = new Array;
				monsterData = tileSheetData.monsterSheetData[row];
				data.id = monsterData[MONSTER_ID];
				data.name = monsterData[MONSTER_NAME];
				data.HP = monsterData[MONSTER_HP];
				data.CP = monsterData[MONSTER_CP];
				data.STR = monsterData[MONSTER_STR];
				data.DEF = monsterData[MONSTER_DEF];
				data.FW = monsterData[MONSTER_FW];
			}
		}
		
		private function initView(row:int):void 
		{
			view = new BitmapData(40, 40, true, 0x00000000);
			var sourceBitmapData:BitmapData = new RolePng(0, 0);
			var blitPoint:Point = new Point();
			var tileBlitRectangle:Rectangle = new Rectangle(0, 0, 40, 40);
			tileBlitRectangle.y = row * 40;
			
			blitPoint.x = 0;
			blitPoint.y = 0;
			view.copyPixels(sourceBitmapData, tileBlitRectangle, blitPoint);
			
			sourceBitmapData.dispose();
		}
		
		
		
	}

}