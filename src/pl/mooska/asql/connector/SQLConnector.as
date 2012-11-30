package pl.mooska.asql.connector
{
	import pl.mooska.asql.packets.IPacket;
	
	import flash.net.Socket;	

	public class SQLConnector extends Socket
	{
		public function SQLConnector ()
		{
			
		}
		public function sendPacket ( packet:IPacket ) :void
		{
			writeBytes( packet.data );
			flush();
		}
	}
}