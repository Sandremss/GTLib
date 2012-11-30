package pl.mooska.asql.packets
{
	import pl.mooska.asql.debugger.SQLDebugger;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;	

	public class Packet implements IPacket 
	{
		private var _data:ByteArray;
		
		public var length:uint = 0;
		public var number:uint = 0;
		public var type:String = "";
		public var text:String = "";
		public var code:uint = 0;//text and code goes for error type only
		public var affectedRows:uint = 0;
		
		public function get data () :ByteArray
		{
			return _data;
		}
		
		public static var ERROR:String = "error";
		public static var OK:String = "ok";
		public static var RAW_DATA:String = "raw_data";
		public static var DATA:String = "data";
		public static var EOF:String = "eof";
		
		//private static var packetCounter:uint = 0;
		private const lEndian:String = Endian.LITTLE_ENDIAN;
		private const bEndian:String = Endian.BIG_ENDIAN;
		private const abs:Function = Math.abs;
		
		public function Packet ( currentData:ByteArray = null )//constructor goes for sendin packet
		{
			_data = new ByteArray();
			if( currentData != null )
			{
				_data.writeBytes( currentData );
				writePacketSize( _data.length - 4 );//4 bytes is a packet size and a packet number, the rest goes as packet size
				_data.position = 0;
			}
		}
		
		public function write( currentData:ByteArray ):void //for result packets
		{
			/**
			 * 
			 * 
			 * 
			 * This code is one great mess, it checks many conditions for correct packet
			 * it should check this as a whole
			 * 
			 * 
			 */
			//trace("\t----writing to packet, position: " + currentData.position+" length: "+currentData.length)
			/*
			var s = ''
			var b:Boolean = false;
			var counter:uint = 0;
			for(var k = 0; i<10; i++)
			{
				s+= "data: ";
				for(var i = 0; i <10; i++)
				{
					try 
					{
						s+= " "+currentData.readUnsignedByte();
						counter ++;
					} 
					catch ( er:EOFError )
					{
						break
						b = true;
						//
					}
				}
				if ( b ) break
			}
			*/
			/*
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			trace ( "data in a a packet: "+currentData.readUnsignedByte() );
			*/
			//trace( s );
			//trace ( currentData.position -= ( counter ) )
			
			
			
			
			currentData.endian = lEndian;
			var i:int = currentData.readUnsignedInt();//reading length int (its 3 bytes long, in here we are reading 4bytes)

			
			length = uint(0x00ffffff & i);//cutting last byte
			
			currentData.position --;//moving pointer back one byte
			
			number = currentData.readUnsignedByte();//reading packet number
			
			var firstPosition:uint = currentData.position;//remembering position of the starting data byte
			var field_count:uint;

			
			
			//remembers whole packet
			if (  length <= currentData.length - currentData.position )//if packet length seems to be ok, remembers the data
			{
				_data.writeBytes(currentData, currentData.position, length);//setting data
			} 
			else //if length was bigger then loaded data, then were omitting the data
			{
				//_data.writeBytes(currentData, currentData.position, currentData.length - currentData.position);//setting data
			}
			
			_data.position = 0;
			
			//reading first byte (field_count)
			field_count = currentData.readUnsignedByte();
			
			if( field_count == 0xfe )
			{
				//checks if the packet has eof byte
				type = EOF;
			} 
			else if( field_count == 0  && ( length == (currentData.length - 4 ) ) ) //second condition checks if this is one whole packet
			{
				//looking for ok code
				type = OK;
			} 
			else if( field_count == 0xff && ( length == (currentData.length - 4 ) ) )
			{
				//looking for the error code (ff)
				type = ERROR;
				_data.endian = lEndian;
				code = currentData.readUnsignedShort();
				var byte:uint = currentData.readUnsignedByte();
				
				if( code < 1000 && code > 1300 )
				{
					SQLDebugger.write("Unknown error code in ResultPacket::init");
				}
				if( byte == 0x23 )
				{
					//var sqlState:String = currentData.readUTFBytes(5);
					//SQLDebugger.write("There was an [MYSQL protocol v4.1] mid byte, sql state, in the error message: "+sqlState)
				}
				
				text = currentData.readUTFBytes(currentData.length - currentData.position);
			}
			
			_data.endian = bEndian;
			currentData.endian = bEndian;
			
			currentData.position = firstPosition + length;//moving pointer to the end of the packet
		}
		
		private function writePacketSize(r:int, offset:int = 0) :void 
		{
			//this writes packet size (header)
			/*
			* packet size is written in the revert order (littleEndian)
			* 
			*/
			
			_data.endian = Endian.LITTLE_ENDIAN;
			_data.position = offset;
			_data.writeShort(r);
			_data.position = offset+1;
			_data.writeShort(r>>8);
			_data.endian =  Endian.BIG_ENDIAN;
		}
		/*
		private function readLengthCodedBinary () :uint
		{
			var byte:uint = _data.readUnsignedByte();
			if ( byte < 250 ) 
			{
				return byte;
			} 
			else if ( byte == 251 )
			{
				return null;
			}
			return null;
		}*/
	}
}