package pl.mooska.asql.commands
{
	import pl.mooska.asql.IAsqlBase;
	import pl.mooska.asql.packets.Packet;
	
	import flash.utils.ByteArray;	

	public class DisconnectCommand implements ICommand
	{
		private var base:IAsqlBase;
		
		public function DisconnectCommand ( currentBase:IAsqlBase )
		{
			base = currentBase;	
		}
		public function handleResult(data:ByteArray):void
		{
		}
		
		public function execute() :void
		{
			var data:ByteArray = new ByteArray();
			
			data.position = 3;
			
			//packet number
			data.writeByte( 0x00 );
			
			//command type
			data.writeByte( CommandCodes.QUIT );
			
			base.sendPacket( new Packet( data ) );
		}
		
		public function finalize() :void
		{
		}
	}
}