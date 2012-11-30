package org.gametack.util {
	import com.hurlant.util.Base64;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class LZW {
		//vars
		
		//constructor
		public function LZW() {
			
		}
		
		//public
		public static function compress(string:String):String {
			var i:uint = 0;
			var chars:uint = 256;
			var xstr:String = "";
			var dict:Dictionary = new Dictionary();
			var result:String = "";
			var buffer:String = "";
			
			for (i = 0; i <= 255; i++) {
				dict[i] = i;
			}
			
			for (i = 0; i < string.length; i++) {
				xstr = (i == 0) ? String(string.charCodeAt(i)) : buffer + "-" + string.charCodeAt(i);
				
				if (dict[xstr] == undefined) {
					result += String.fromCharCode(dict[buffer]);
					dict[xstr] = chars;
					chars++;
					buffer = "";
				}
				
				buffer += (buffer == "") ? String(string.charCodeAt(i)) : "-" + string.charCodeAt(i);
			}
			
			return result + string.substr(string.length - 1, 1);
		}
		
		//TODO Improve decompress function - it's wasteful and slow
		public static function decompress(string:String):String {
			var i:uint;
			var chars:uint = 256;
			var dict:Dictionary = new Dictionary();
			var buffer:String = "";
			var result:String;
			var charCode:uint;
			var currentChar:String;
			
			for (i = 0; i <= 255; i++) {
				dict[i] = String.fromCharCode(i);
			}
			
			for (i = 0; i < string.length; i++) {
				charCode = string.charCodeAt(i);
				currentChar = dict[charCode];
				
				if (i == 0) {
					buffer = result = currentChar;
				}else {
					if (charCode <= 255) {
						result += currentChar;
						dict[chars] = buffer + currentChar;
					}else {
						result += (currentChar) ? currentChar : buffer + buffer.charAt(0);
						dict[chars] = buffer + currentChar.charAt(0);
					}
					
					chars++;
					buffer = currentChar;
				}
			}
			
			return result;
		}
		
		//private
	}
}