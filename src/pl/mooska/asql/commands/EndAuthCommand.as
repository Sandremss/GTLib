package pl.mooska.asql.commands
{
	import pl.mooska.asql.IAsqlBase;
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.events.SQLError;
	import pl.mooska.asql.packets.Packet;
	
	import flash.utils.ByteArray;	

	public class EndAuthCommand implements ICommand
	{
		private var base:IAsqlBase;  
		
		public function EndAuthCommand ( currentBase:IAsqlBase )
		{
			base = currentBase;
		}
		public function handleResult( data:ByteArray ) :void
		{
			var result:Packet = new Packet();
			result.write ( data );
			
			if( result.type == Packet.ERROR )
			{
				//dispatchEvent();
				//handleError();
				base.handleEvent( new SQLError( result.text ) );//, result.code, result.error
				return;
			}
			
			if( result.type == Packet.EOF )
			{
				//end of file marker, wich means, that server wants old type authorization, 
				//besides standard 4.1 one
				SQLDebugger.write( "Double authorization invoked, using old authorization algorithm" );			
				base.addCmd( new AuthCommand323( base ) );
				//base.invokeCmd();
			} 
			else 
			{
				SelectBaseCommand.baseSelected = false;//resetting base selection state
				base.addCmd( new SelectBaseCommand( base ) );
				//base.invokeCmd();
			}
			
			//base.handleEvent( new SQLEvent( SQLEvent.SQL_OK ) );
			base.invokeCmd();
		}
		
		public function execute():void
		{
		}
		
		public function finalize():void
		{
		}
	}
}