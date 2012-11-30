package pl.mooska.asql.commands
{
	import pl.mooska.asql.IAsqlBase;
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.events.SQLEvent;
	import pl.mooska.asql.hash.User;
	import pl.mooska.asql.packets.Packet;
	
	import flash.utils.ByteArray;	

	public class SelectBaseCommand implements ICommand
	{
		private var base:IAsqlBase;
		public static var baseSelected:Boolean = false;//for connection event purpose
		
		public function SelectBaseCommand ( currentBase:IAsqlBase )
		{
			base = currentBase;
		}
		public function handleResult( data:ByteArray ) :void
		{
			SQLDebugger.write("DBase ["+ User.BASE +"] was selected succesfully", 1);
			base.addCmd( new QueryCommand( base ) );
			
			if( !baseSelected )
			{
				baseSelected = true;
				base.handleEvent( new SQLEvent( SQLEvent.CONNECT ) );
			} 
			else 
			{
				base.handleEvent( new SQLEvent(SQLEvent.SQL_OK) );
			}
			
			
		}
		
		public function execute() :void
		{
			var data:ByteArray = new ByteArray();
			data.position = 3;//leaving space for the packet size
			
			//packet number
			data.writeByte( 0x00 );
			
			//command: use database
			data.writeByte( CommandCodes.SELECT_BASE );
			
			data.writeUTFBytes( User.BASE );
			base.sendPacket( new Packet( data ) );
		}
		
		public function finalize() :void
		{
		}
		
	}
}