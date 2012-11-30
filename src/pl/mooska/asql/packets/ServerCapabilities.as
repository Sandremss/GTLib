package pl.mooska.asql.packets
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;	

	public class ServerCapabilities
	{
		
		public static var PROTOCOL:uint;
		public static var VERSION:String;
		public static var THREAD_ID:int;
		public static var FIRST_SCRAMBLE:String;
		public static var CAN_DO_AUTHENTICATION:Boolean;
		public static var SPEAKS_41_PROTOCOL:Boolean;
		public static var KNOWS_ABOUT_TRANSACTION:Boolean;
		public static var IGNORE_SIGPIPIES:Boolean;
		public static var SWITCH_TO_SSL:Boolean;
		public static var INTERACTIVE_CLIENT:Boolean;
		public static var SPEAKS_42_PROTOCOL_NEW:Boolean;
		public static var IGNORE_SPACES:Boolean;
		/*
		* var firstOctet = [ "can do authentication:",
							 "speaks 4.1 protocol",
							 "knows about transaction",
							 "Ignore sigpipes",
							 "Switch to SSL after handshake",
							 "Interactive Client",
							 " Speaks 4.1 protocol (new flag)",
							 "Ignore Spaces before '('"]
		 */
		 public static var LOAD_DATA_LOCAL:Boolean;
		 public static var ODBC_CLIENT:Boolean;
		 public static var CAN_USE_COMPRESSION:Boolean;
		 public static var DONT_ALLOW_DATABASE_TABLE_COLUMN:Boolean;
		 public static var CONNECT_WITH_DATABASE:Boolean;
		 public static var LONG_COLUMN_FLAG:Boolean;
		 public static var FOUND_ROWS:Boolean;
		 public static var LONG_PASSWORD:Boolean;
		/*
		* var secOctet = [														   
						 "Can Use LOAD DATA LOCAL",
						 "ODBC Client",
						 "Can use compression protocol",
						 "Dont Allow database.table.column",
						 "Connect With Database",
						 "Long Column Flags",
						 "Found Rows",
						 "Long Password"
		 ]
		 */
		public static var CHARSET:int;
		public static var NO_BACKSLASH_ESCAPES:Boolean;
		public static var DATABASE_DROPPED:Boolean;
		public static var LAST_ROW_SEBD:Boolean;
		public static var CURSOR_EXIST:Boolean;
		public static var NO_INDEX_USED:Boolean;
		public static var BAD_INDEX_USED:Boolean;
		public static var MULTI_QUERY:Boolean;
		public static var MORE_RESULT:Boolean;
		public static var AUTO_COMMIT:Boolean;
		public static var IN_TRANSACTION:Boolean;
		
		/*
		* var secServerStatus = [
								"Last row sebd",
								"Cursor exists",
								"No index used",
								"Bad index used",
								"Multi query - more resultsets",
								"More results",
								"AUTO_COMMIT",
								"In transaction"
								]
		//
		*/
		public static var SECOND_SCRAMBLE:String;
		
		public function ServerCapabilities () 
		{
			
		}
		
		private static function convertBytesToOptions(n:Number, array:Array) :Array
		{
			var s:String = n.toString(2);
			if(s.length<8)
			{
				s = ("00000000").substr(0, 8-s.length)+s;
			}
			
			var tempArray:Array = [];
			for(var i:uint = 0 ;i<array.length; i++)
			{
				tempArray.push(Boolean(s.substr(i, 1)));
			}
			
			return tempArray;
			
		}
		private static function convertBytesToStatus(n:Number, array:Array) :Array
		{
			var s:String = n.toString(2);
			if(s.length<8)
			{
				s = ("00000000").substr(0, 8-s.length)+s;
			}
			
			var tempArray:Array = [];
			
			for(var i:uint = 0 ; i<array.length; i++)
			{
				tempArray.push(Boolean(s.substr(i, 1)));
			}
			
			return tempArray;
		}
		public static function readCapabilities( n:ByteArray ) :void{
			n.position = 0;
			PROTOCOL = n[4];
			
			n.position = 5;
			
			VERSION = '';
			var vrs:String = '';
			while(vrs = n.readUTFBytes(1)){
				VERSION += vrs;
			}
			n.endian = Endian.LITTLE_ENDIAN;
			THREAD_ID = n.readInt();
			n.endian = Endian.BIG_ENDIAN;
			
			//getting first scrumble
			FIRST_SCRAMBLE = n.readUTFBytes(8);
			var firstOctet:Array = [   "can do authentication:",
								 "speaks 4.1 protocol",
								 "knows about transaction",
								 "Ignore sigpipes",
								 "Switch to SSL after handshake",
								 "Interactive Client",
								 " Speaks 4.1 protocol (new flag)",
								 "Ignore Spaces before '('"
			 ];

			 var secOctet:Array = [														   
							 "Can Use LOAD DATA LOCAL",
							 "ODBC Client",
							 "Can use compression protocol",
							 "Dont Allow database.table.column",
							 "Connect With Database",
							 "Long Column Flags",
							 "Found Rows",
							 "Long Password"
			 ];
			 
			 var options:int = n.readUnsignedByte();
			 var options2:int = n.readUnsignedByte();
			 
			var firstOctetArray:Array = convertBytesToOptions(options2, firstOctet);
			
			CAN_DO_AUTHENTICATION = firstOctetArray[0];
			SPEAKS_41_PROTOCOL = firstOctetArray[1];
			KNOWS_ABOUT_TRANSACTION = firstOctetArray[2];
			IGNORE_SIGPIPIES = firstOctetArray[3];
			SWITCH_TO_SSL = firstOctetArray[4];
			INTERACTIVE_CLIENT = firstOctetArray[5];
			SPEAKS_42_PROTOCOL_NEW = firstOctetArray[6];
			IGNORE_SPACES = firstOctetArray[7];
			
			var secOctetArray:Array = convertBytesToOptions(options, secOctet);
			
			 LOAD_DATA_LOCAL = secOctetArray[0];
			 ODBC_CLIENT  = secOctetArray[1];
			 CAN_USE_COMPRESSION = secOctetArray[2];
			 DONT_ALLOW_DATABASE_TABLE_COLUMN = secOctetArray[3];
			 CONNECT_WITH_DATABASE = secOctetArray[4];
			 LONG_COLUMN_FLAG = secOctetArray[5];
			 FOUND_ROWS = secOctetArray[6];
			 LONG_PASSWORD = secOctetArray[7];
			 
			CHARSET = n.readUnsignedByte();

			var serverStatus:Array = ["No backslash escapes: Not set",
								"database dropped: Not set"];

			var secServerStatus:Array = [
								"Last row sebd",
								"Cursor exists",
								"No index used",
								"Bad index used",
								"Multi query - more resultsets",
								"More results",
								"AUTO_COMMIT",
								"In transaction"
			];
			var status_1:int = n.readUnsignedByte();
			var status_2:int = n.readUnsignedByte();
			
			var firstStatusArray:Array = convertBytesToStatus(status_1, serverStatus);
			
			NO_BACKSLASH_ESCAPES = firstStatusArray[0]; 
			DATABASE_DROPPED = firstStatusArray[1];
			
			var secondStatusArray:Array = convertBytesToStatus(status_2, secServerStatus);
			
			LAST_ROW_SEBD = secondStatusArray[0];
			CURSOR_EXIST = secondStatusArray[1];
			NO_INDEX_USED = secondStatusArray[2];
			BAD_INDEX_USED = secondStatusArray[3];
			MULTI_QUERY = secondStatusArray[4];
			MORE_RESULT = secondStatusArray[5];
			AUTO_COMMIT = secondStatusArray[6];
			IN_TRANSACTION = secondStatusArray[7];
			
			//till b[45] unused
			n.position += 14;
			SECOND_SCRAMBLE = n.readUTFBytes(13);
			/*
			trace("---------------authorization info----------------");
			trace("current salt:"+FIRST_SCRAMBLE+SECOND_SCRAMBLE+":endofscrumble");
			trace("-----------------------------------------------")
			*/
		}
	}
}