package pl.mooska.asql.hash 
{
	import pl.mooska.asql.debugger.*;
	import pl.mooska.asql.hash.SHA1;	

	public class Pass{
		public static function hash(salt:String, pass:String) :String 
		{
			SQLDebugger.write("Used salt: "+salt);
			SQLDebugger.write("Used pass: "+pass);
			
			var s:String = SHA1.calculate(pass);
			var s1:String = SHA1.calculate(salt+hex2str(SHA1.calculate(hex2str(s))));
			var fn:String = bin2hex(XOR(convert(s1), convert(s)));
			
			
			return fn;
		}
		private static function XOR(first:String, sec:String) :String
		{
			var binString:String = '';
			for(var i:uint =0; i<first.length; i++){
				if(first.substr(i, 1) != sec.substr(i, 1)){
					binString +="1";
				} else {
					binString +="0";
				}
			}
			return binString;
		}
		private static function hex2str(str:String) :String
		{
			var temp:String = '';
			for(var i:uint = 0; i<40; i+=2){
				temp+=String.fromCharCode(Number("0x"+str.substr(i, 2)));
			}
			return temp;
		}
		private static function convert(str:String) :String{
			var whole:String = '';
			for(var i:uint = 0; i<40; i+=2){
				var w:String = (str.substr(i, 2));
				var binary:String = Number("0x"+w).toString(2);
				//trace(String.fromCharCode(Number("0x"+w)));
				if(binary.length<8){
					binary = "00000000".substr((binary.length-8))+binary;
				}
				whole +=binary;
			}
			return whole;
		}
		private static function bin2hex(str:String) :String
		{
			var s:String = '';
			for(var i:uint = 0; i<str.length; i+=8){
				var t:String = (parseInt(str.substr(i, 8), 2).toString(16));
				if(t.length == 1){
					t = "0"+t;
				}
				s+=t;
			}
			return s;
		}
	}
}