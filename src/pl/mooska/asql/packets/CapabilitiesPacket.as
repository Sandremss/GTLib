package pl.mooska.asql.packets
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;	

	public class CapabilitiesPacket extends ByteArray
	{
		//private var _data:ByteArray;
		
		public function CapabilitiesPacket ( d:ByteArray )
		{
			 writeBytes(d);
			 position = 4;
			
			 endian = Endian.LITTLE_ENDIAN;
			 writeShort( ClientCapabilities.CAPABILITIES );
			 
			 //extended capabilities
			 writeShort( ClientCapabilities.EXT_CAPABILITIES );
			 
			 //max packet size
			 writeInt( 1073741824 );//16777216
			 
			 //charset
			 writeByte( 0x08 );
			 
			 //filler, 23 bytes		 
			 writeInt(0);
			 writeInt(0);
			 writeInt(0);
			 writeInt(0);
			 writeInt(0);
			 writeShort(0);
			 writeByte(0x00);
			 endian = Endian.BIG_ENDIAN;
		}
	}
}