package com.lixuefeng.framework
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 动画工厂 
	 * @author S_eVent
	 * 
	 */
	public class AnimationFactory
	{
		
		/**
		 * 切图 
		 * @param source         切割源
		 * @param width                   切块宽度
		 * @param height         切块高度
		 * @param row                 欲切割行
		 * @param col                欲切割列
		 * @return                         
		 * 
		 */                
		public static function Cut( source:BitmapData, width:Number, height:Number, row:int, col:int ):BitmapData
		{
			var result:BitmapData = new BitmapData( width, height );
			result.copyPixels( source, 
				new Rectangle( col * width, row * height, width, height ), new Point( 0, 0 ) );
			return result;
		}
		
		
		/**
		 * 切图工厂，提供批量切图功能
		 * @param source	欲切图的图像源
		 * @param row		欲切图的行号
		 * @param length	横向切割块数
		 * @param width		切片宽
		 * @param height	切片高
		 * @return 			一个包含全部切片的BitmapData数组
		 * 
		 */		
		public static function imgListFactory( source:BitmapData, row:int, length:int, 
												 width:Number, height:Number ):Array{
			var result:Array = new Array();
			for( var i:int=0; i<length; i++ ){
				
				result[i] = Cut( source, width, height, row, i );
			}
			return result;
		}
	}
}