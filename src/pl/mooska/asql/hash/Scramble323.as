package pl.mooska.asql.hash {
	public class Scramble323 {
		function Scramble323(){
			
		}
		public function scramble(pass:String, salt:String) :String
		{
			return scramble_323(salt, pass, 1);
		}
		
		private function get_hash(password:String):Array
		{/* this ones ok */
			//var password_len:int = password.length;
			var result:Array = [];
			
			var nr:Number = 1345345333;
			var addnr:int = 7;
			var nr2:int = 0x12345671;
			
			var tmp:int;
			//var password_end : String = password.length + password_len;
			for(var i:int=0; i<password.length; i++){
				tmp = password.substr(i, 1).charCodeAt(0);
				//trace("tmp: "+tmp);
				//nr = Math.abs(nr);
				//trace("nr1 "+nr);
				//trace("nr+63: "+((nr)));
				nr ^= (((nr & 63)+addnr) * tmp + (nr<<8));
				//trace("nr "+nr);
				
				//nr = Math.abs(nr);
				nr2 += ((nr2 << 8) ^ nr);
				addnr += tmp;
			}
			//(((ulong) 1L << 31) -1L)
			
			result[0] = nr & ((1<< 31)-1);
			result[1] = nr2 & ((1<< 31)-1);;
			return result;
			
		}
		
		private function scramble_323(hash_seed : String, password:String, capabilities:Number) : *
		{
			var hsl:int = hash_seed.length;
			var out : Array = [];
			var hash_pass : Array = get_hash(password);
			var hash_mess : Array = get_hash(hash_seed);
			var max_value:Number, seed:int, seed2:int;
			var dRes:Number, dSeed:Number, dMax:Number;
			/*
		
			*/
			//trace("hashes: "+hash_pass+" "+hash_mess);
			if(capabilities < 1){
				max_value = 0x3fffffff;
				seed = (hash_pass[0] ^ hash_mess[0]) % max_value;
				//seed2 = (hash_pass[1] ^ hash_mess[1]) % max_value;
				seed2 = int(seed/2);
			} else {
				max_value = 0x3fffffff;
				seed = (hash_pass[0] ^ hash_mess[0]) % max_value;
				seed2 = (hash_pass[1] ^ hash_mess[1]) % max_value;
			}
			dMax = max_value;
			/*
			*/
			for(i=0; i<hsl;i++){
				seed = int((seed * 3 + seed2) % max_value);
				seed2 = int((seed + seed2 + 33) % max_value);
				dSeed = seed;
				dRes = dSeed/dMax;
				//trace("dRes: "+dRes)
				out.push(int(dRes * 31) + 64);
			}
			/*
			*/
			if(capabilities == 1){
				seed = (seed * 3 + seed2) % max_value;
				seed2 = (seed + seed2 + 33) % max_value;
				dSeed = seed;
				dRes = dSeed / dMax;
				var e:int = int(dRes * 31);
				for(var i:int =0; i<hsl ; i++){
					out[i]^= e;
				}
			}
			var s:String = '';
			for(i=0; i<out.length; i++){
				s += String.fromCharCode(out[i]);
			}
			return s;
			
		}
	}
}