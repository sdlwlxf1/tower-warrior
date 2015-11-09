package  com.lixuefeng.framework
{
	import flash.utils.ByteArray;

	public class DeepCopyUtil
	{				
		public static function clone (source : Object) : *
		{
			var array : ByteArray = new ByteArray ();
			array.writeObject(source);
			array.position = 0;			
			return array.readObject();
		}
	}
}
