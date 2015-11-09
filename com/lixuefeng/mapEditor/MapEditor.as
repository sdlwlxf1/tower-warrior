package  com.lixuefeng.mapEditor
{
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import fl.controls.TileList;
	import fl.controls.ScrollBarDirection;
	import fl.controls.ComboBox;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import fl.controls.Label;
	import flash.text.TextFieldAutoSize;
	import fl.controls.TextArea;
	
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class MapEditor extends Sprite
	{
		private var currSourceBD:BitmapData;
		private var cutImage:CutImage;
		private var sourceBDArray:Array;
		private static const SOURCE_BACKGROUND:uint = 0;
		private static const SOURCE_MONSTER:uint = 1;
		private static const SOURCE_ITEM:uint = 2;
		private var tileList:TileList;
		private var comboBox:ComboBox;
		private var drawBackground:TileList;
		private var drawMonster:TileList;
		private var drawItem:TileList;
		private var currDrawMap:TileList;
		private var sourceSelectedObj:Object;
		private var drawSelectedObj:Object;
		
		private var outPutTextArea:TextArea;
		
		private	var backgroundArray:Array;
		private	var monsterArray:Array;
		private	var itemArray:Array;
		
		public function MapEditor() 
		{


			setButton();
			
			initDrawMap();
			setTextArea();
			
			setSourceTileList(SOURCE_BACKGROUND);
			setComboBox();
			setOutPutScene();
						
			
		}
		
		private function setTextArea():void 
		{
			var textArea:TextArea = new TextArea();
			textArea.text = "请先从右边图库中选中一个图块，按住Ctrl再点左键可以删除添加上去的图块";
			textArea.wordWrap = true;
			textArea.x = 500;
			textArea.y = 20;
			textArea.setSize(90, 90);
			textArea.editable = false;
			addChild(textArea);
			

		}
		
		private function setOutPutScene():void 
		{
			
			outPutTextArea = new TextArea();
			//labelOutPut.wordWrap = true;
			outPutTextArea.x = 200;
			outPutTextArea.y = 40;
			outPutTextArea.editable = false;
			outPutTextArea.setSize(400, 400);
			//addChild(outPutTextArea);
		}
		
		private function initDrawMap():void 
		{
			drawBackground = new TileList;
			drawMonster = new TileList;
			drawItem = new TileList;
			
			setDrawMapStyle(drawBackground);
			setDrawMapStyle(drawMonster);
			setDrawMapStyle(drawItem);
			changeDrawMap(SOURCE_BACKGROUND);
		}
		
		private function setButton():void 
		{
			var addAllButton:Button = new Button;
			addAllButton.addEventListener(MouseEvent.CLICK, addAllButtonListener);
			addAllButton.x = 510;
			addAllButton.y = 140;
			addAllButton.setSize(70, 30);
			addAllButton.label = "全部应用";
			addChild(addAllButton);
			var clearAllButton:Button = new Button;
			clearAllButton.addEventListener(MouseEvent.CLICK, clearAllButtonListener);
			clearAllButton.x = 510;
			clearAllButton.y = 180;
			clearAllButton.setSize(70, 30);
			clearAllButton.label = "全部删除";
			addChild(clearAllButton);
			var outPutButton:Button = new Button;
			outPutButton.addEventListener(MouseEvent.CLICK, outPutButtonListener);
			outPutButton.x = 510;
			outPutButton.y = 220;
			outPutButton.setSize(70, 50);
			outPutButton.label = "输出数组";
			addChild(outPutButton);
		}
		
		private function setDrawMapStyle(tileList:TileList):void 
		{
			tileList.x = 50;
			tileList.y = 20;
			tileList.columnWidth = 40;
			tileList.rowHeight = 40;
			tileList.setSize(440, 440);
			tileList.setRendererStyle("imagePadding", 0);
			tileList.allowMultipleSelection = true;
			var i:uint;
						
			for (i = 0; i < 11 * 11; i++ )
			{
					//var tile:Bitmap = new Bitmap(new BitmapData(40, 40, true, 0x00000000));
					tileList.addItem( { source:null , ID:0, position:i} );
			}
		
			tileList.addEventListener(MouseEvent.MOUSE_DOWN, drawMouseDownItem, true);
			tileList.addEventListener(MouseEvent.MOUSE_UP, drawMouseUpItem, true);
			addChild(tileList);
		}
		
		
		
		private function drawMouseDownItem(e:MouseEvent):void {
			try {
				e.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, drawMouseMoveItem, true);
				if(e.ctrlKey != true) {
					var changeBitmap:Bitmap = new Bitmap(sourceSelectedObj.source.bitmapData);
					e.currentTarget.replaceItemAt( { source:changeBitmap, ID:sourceSelectedObj.ID, position: e.target.listData.index }, e.target.listData.index);
				} else {
					e.currentTarget.replaceItemAt( { source:null, ID:0, position: e.target.listData.index }, e.target.listData.index);
				}
			} catch (e:TypeError) {
				trace("请先在右边选择一个图块！");
			}
		}
		
		private function drawMouseMoveItem(e:MouseEvent):void {
			try {
				if(e.ctrlKey != true) {
					var changeBitmap:Bitmap = new Bitmap(sourceSelectedObj.source.bitmapData);
					e.currentTarget.replaceItemAt( { source:changeBitmap, ID:sourceSelectedObj.ID, position: e.target.listData.index }, e.target.listData.index);
				} else {
					e.currentTarget.replaceItemAt( { source:null, ID:0, position: e.target.listData.index }, e.target.listData.index);
				}
			} catch (e:TypeError) {
				trace("请先在右边选择一个图块！");
			}
		}
		
		private function drawMouseUpItem(e:MouseEvent):void {
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, drawMouseMoveItem, true);
		}
		

		private function changeDrawMap(imageName:uint):void {
			//drawBackground.enabled = false;
			//drawMonster.enabled = false;
			//drawItem.enabled = false;
			if (imageName == SOURCE_BACKGROUND) {
				//drawBackground.enabled = true;
				this.setChildIndex(drawBackground, 2);
				this.setChildIndex(drawMonster, 1);
				this.setChildIndex(drawItem, 0);
				currDrawMap = drawBackground;
			}else if (imageName == SOURCE_MONSTER) {
				//drawMonster.enabled = true;
				this.setChildIndex(drawBackground, 0);
				this.setChildIndex(drawMonster, 2);
				this.setChildIndex(drawItem, 1);
				currDrawMap = drawMonster;
			}else if (imageName == SOURCE_ITEM) {
				//drawItem.enabled = true;
				this.setChildIndex(drawBackground, 0);
				this.setChildIndex(drawMonster, 1);
				this.setChildIndex(drawItem, 2);
				currDrawMap = drawItem;
			}
			
		}
		
		private function setComboBox():void {
			comboBox = new ComboBox();
			comboBox.x = 600;
			comboBox.y = 20;
			comboBox.width = 120 + 15;
			comboBox.addItem( { label: "背景层", data:SOURCE_BACKGROUND } );
            comboBox.addItem( { label: "怪物层", data:SOURCE_MONSTER } );
            comboBox.addItem( { label: "物品层", data:SOURCE_ITEM } );
            comboBox.addEventListener(Event.CHANGE, cardSelected);
			addChild(comboBox);
		}
		
		private function cardSelected(e:Event):void {
			sourceSelectedObj = null;
			setSourceTileList(e.target.selectedItem.data);
			changeDrawMap(e.target.selectedItem.data);
        }
		
		private function setSourceTileList(imageName:uint):void 
		{
			if (tileList != null) {
				removeChild(tileList);
				tileList = null;
			}
			tileList = new TileList();
			tileList.columnCount = 3;
			tileList.columnWidth = 40;
			tileList.rowHeight = 40;
			tileList.direction = ScrollBarDirection.VERTICAL;
			tileList.x = 600;
			tileList.y = 60;
			
			
			if (imageName == SOURCE_BACKGROUND) {
				currSourceBD = new BackgroundPng(0, 0);
			}else if (imageName == SOURCE_MONSTER) {
				currSourceBD = new MonsterPng(0, 0);
			}else if (imageName == SOURCE_ITEM) {
				currSourceBD = new ItemPng(0, 0);
			} 
			
			tileList.setSize(120 + 15, 400);
			
			cutImage = new CutImage(currSourceBD, 40, 40);
			
			sourceBDArray = cutImage.bitmapDataArray;
			var length:uint = sourceBDArray.length;
			var count:uint;
			var sourceBitmap:Bitmap;
			
			for (count = 0; count < length; count ++ ) {
				sourceBitmap = new Bitmap(sourceBDArray[count]);
				tileList.addItem( { source:sourceBitmap , ID:count } );
			}
			
			tileList.addEventListener(Event.CHANGE, sourceClickedItem);
			

			
			addChild(tileList);
			
		}
		 
		private function sourceClickedItem(e:Event):void 
		{
			sourceSelectedObj = e.target.selectedItem;
		}
		
		private function addAllButtonListener(e:MouseEvent):void 
		{
			var i:uint;
			for (i = 0; i < 11 * 11; i++ )
			{
				var changeBitmap:Bitmap = new Bitmap(sourceSelectedObj.source.bitmapData);
				currDrawMap.replaceItemAt( { source:changeBitmap, ID:sourceSelectedObj.ID, position: i}, i);
			}
		}
		
		private function clearAllButtonListener(e:MouseEvent):void 
		{
			var i:uint;
			for (i = 0; i < 11 * 11; i++ )
			{
				currDrawMap.replaceItemAt( { source:null , ID:0, position:i}, i );
			}
		}
		
		private function outPutButtonListener(e:MouseEvent):void 
		{
			backgroundArray = new Array;
			monsterArray = new Array;
			itemArray = new Array;
			var i:uint;
			var j:uint;
			var array:Array;
			
			for (i = 0; i < 11; i++ ) {
				array = new Array;
				for (j = 0; j < 11; j++ ) {
					array[j] = drawBackground.getItemAt(j + i * 11).ID;
					
				}
				backgroundArray[i] = array;
			}
			
			
			for (i = 0; i < 11; i++ ) {
				array = new Array;
				for (j = 0; j < 11; j++ ) {
					array[j] = drawMonster.getItemAt(j + i * 11).ID;
				}
				
				monsterArray[i] = array;
			}
			
			for (i = 0; i < 11; i++ ) {
				array = new Array;
				for (j = 0; j < 11; j++ ) {
					array[j] = drawItem.getItemAt(j + i * 11).ID;
				}
				
				itemArray[i] = array;
			}
			

			outPut();
			
			outPutTextArea.text = "backgroundArray = \n [";
			for (i = 0; i < 10; i++ ) {
				outPutTextArea.appendText("\n[" + backgroundArray[i].toString() + "]," );
			}
			outPutTextArea.appendText("\n[" + backgroundArray[10].toString() + "]\n]\n" );
			
			outPutTextArea.appendText("monsterArray = \n [");
			for (i = 0; i < 10; i++ ) {
				outPutTextArea.appendText("\n[" + monsterArray[i].toString() + "]," );
			}
			outPutTextArea.appendText("\n[" + monsterArray[10].toString() + "]\n]\n" );
			
			outPutTextArea.appendText("itemArray = \n [");
			for (i = 0; i < 10; i++ ) {
				outPutTextArea.appendText("\n[" + itemArray[i].toString() + "]," );
			}
			outPutTextArea.appendText("\n[" + itemArray[10].toString() + "]\n]\n" );
			
			stage.addEventListener(MouseEvent.CLICK, removeListener);

			addChild(outPutTextArea);
			
		}
		
		private function removeListener(e:MouseEvent):void
		{
			if (stage.mouseX < outPutTextArea.x || stage.mouseX > outPutTextArea.width + outPutTextArea.x || stage.mouseY < outPutTextArea.y || stage.mouseY > outPutTextArea.height + outPutTextArea.y)
			{
				removeChild(outPutTextArea);
				stage.removeEventListener(MouseEvent.CLICK, removeListener);
			}
		}
		
		private function outPut():void 
		{
			var i:uint;
			trace("backgroundArray = ");
			trace("[");
			for (i = 0; i < 10; i++ ) {
				trace("[" + backgroundArray[i].toString() + "],");
			}
			trace("[" + backgroundArray[10].toString() + "]");
			trace("]");
			trace();
			trace("monsterArray = ");
			trace("[");
			for (i = 0; i < 10; i++ ) {
				trace("[" + monsterArray[i].toString() + "],");
			}
			trace("[" + monsterArray[10].toString() + "]");
			trace("]");
			trace();
			trace("itemArray = ");
			trace("[");
			for (i = 0; i < 10; i++ ) {
			trace("[" + itemArray[i].toString() + "],");
			}
			trace("[" + itemArray[10].toString() + "]");
			trace("]");
		}
		

	}
	


}