package org.gametack.file {
	import flash.filesystem.File;
	import org.gametack.BaseClass;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class FileUtils extends BaseClass {
		//vars
		private static var _date:Date = new Date();
		
		//constructor
		public function FileUtils() {
			
		}
		
		//public
		
		/**
		 * Convers a string into a file object. The path is relative to the "company name" folder and does not require a seperator before the name.
		 * 
		 * @param file A string describing the path of the file object.
		 * @return A file object with the path specified.
		 */
		public static function fileStr(file:String):File {
			return Files.saveLocation.resolvePath(Files.saveParentFolder + Files.SEPARATOR + Files.saveGameFolder + Files.SEPARATOR + file);
		}
		/**
		 * Convers a file object into a string.
		 * 
		 * @param file A file object.
		 * @return A string with the path of the file object.
		 */
		public static function strFile(file:File):String {
			return file.nativePath;
		}
		
		/**
		 * Gets the current system time in a formatted string.
		 * 
		 * @return A formatted string with the system time.
		 */
		public static function getTimeStr():String {
			return _date.fullYear + " " + _date.month + " " + _date.date + " " + _date.hours + " " + _date.minutes + " " + _date.seconds;
		}
		/**
		 * Gets the current system time in a number. (as seconds from 0 A.D.)
		 * 
		 * @return A number with the system time.
		 */
		public static function getTimeNum():Number {
			return (_date.fullYear*12*30*34*60*60) + (_date.month*30*24*60*60) + (_date.date*24*60*60) + (_date.hours*60*60) + (_date.minutes * 60) + _date.seconds;
		}
		
		/**
		 * Convers a formatted time string (getTimeStr or strTime) into a number.
		 * 
		 * @param time A string describing the time.
		 * @return A number with the time. (as seconds from 0 A.D.)
		 */
		public static function numTime(time:String):Number {
			var temp:Array = time.split(" ");
			return (parseInt(temp[0])*12*30*24*60*60) + (parseInt(temp[1])*30*24*60*60) + (parseInt(temp[2])*24*60*60) + (parseInt(temp[3])*60*60) + (parseInt(temp[4])*60) + parseInt(temp[5]);
		}
		/**
		 * Convers a number (getTimeNum or numTime) into a formatted string.
		 * 
		 * @param time A number describing the time. (as seconds from 0 A.D.)
		 * @return A string with the time.
		 */
		public static function strTime(time:Number):String {
			var temp:Vector.<uint> = new Vector.<uint>;
			temp[0] = 0;
			temp[1] = 0;
			temp[2] = 0;
			temp[3] = 0;
			temp[4] = 0;
			
			while (time >= 31104000) {
				temp[0]++;
				time -= 31104000;
			}
			while (time >= 2592000) {
				temp[1]++;
				time -= 2592000;
			}
			while (time >= 86400) {
				temp[2]++;
				time -= 86400;
			}
			while (time >= 3600) {
				temp[3]++;
				time -= 3600;
			}
			while (time >= 60) {
				temp[4]++;
				time -= 60;
			}
			
			return temp[0] + " " + temp[1] + " " + temp[2] + " " + temp[3] + " " + temp[4] + " " + time;
		}
		
		//private
	}
}