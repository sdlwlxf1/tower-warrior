package  com.lixuefeng.games.tower
{
	/**
	 * ...
	 * @author li xuefeng
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.lixuefeng.framework.AnimationFactory;
	import com.lixuefeng.framework.AnimationList;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	public class NPC 
	{
		public var data:NPCData;
		private var npcData:Array;
		private var tileSheetData:TileSheetData;
		
		public var row:int;
		public var view:BitmapData;
		
		public static const NPC_ID:int = 0;
		public static const NPC_NAME:int = 1;
		public static const NPC_HP:int = 2;
		public static const NPC_CP:int = 3;
		public static const NPC_STR:int = 4;
		public static const NPC_DEF:int = 5;
		public static const NPC_FW:int = 6;
		
		//这里的row代表的是角色图片中第几行图片
		public function NPC(row:int, tileSheetData:TileSheetData) 
		{
			this.row = row;
			this.tileSheetData = tileSheetData;
			initData(row);
			initView(row);
		}
		
		private function initData(row:int):void
		{
			data = new NPCData;
			npcData = [];
			npcData = tileSheetData.npcSheetData[row];
			data.name = npcData[NPC_NAME];
			data.HP = npcData[NPC_HP];
			data.CP = npcData[NPC_CP];
			data.STR = npcData[NPC_STR];
			data.DEF = npcData[NPC_DEF];
			data.FW = npcData[NPC_FW];
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