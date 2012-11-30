package org.gametack.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class BitmapUtils {
		//vars
		
		//constructor
		public function BitmapUtils() {
			
		}
		
		//public
		public static function getBitmapData(source:Class):BitmapData {
			return Bitmap(new source()).bitmapData;
		}
		
		public static function splitBitmap(source:BitmapData, rows:uint, columns:uint, spacing:uint = 0):Vector.<BitmapData> {
			var bitmapVector:Vector.<BitmapData> = new Vector.<BitmapData>;
			
			return bitmapVector;
		}
		
		//private
	}
}