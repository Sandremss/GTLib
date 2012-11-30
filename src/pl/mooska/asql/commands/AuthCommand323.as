package pl.mooska.asql.commands
{
	import pl.mooska.asql.IAsqlBase;
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.hash.Scramble323;
	import pl.mooska.asql.hash.User;
	import pl.mooska.asql.packets.IPacket;
	import pl.mooska.asql.packets.Packet;
	import pl.mooska.asql.packets.ServerCapabilities;
	
	import flash.utils.ByteArray;	

	public class AuthCommand323 implements ICommand
	{
		private var base:IAsqlBase;
		public function AuthCommand323 ( currentBase:IAsqlBase )
		{
			base = currentBase;
		}
		public function handleResult(data:ByteArray):void
		{
		}
		
		public function execute():void
		{
			var data:ByteArray = new ByteArray();
			
			data.position = 3;//leavin a space for packet length
			
			//packet number
			data.writeByte( 0x03 );

			if ( User.PASS != "" )
			{
				//writing old hash type (3.23)
				var scramble:Scramble323 = new Scramble323();
				var old_hash:String = scramble.scramble( User.PASS, ServerCapabilities.FIRST_SCRAMBLE );
				
				SQLDebugger.write( "Old authorization: hash:"+old_hash+" pass: "+ User.PASS+" scramble: " + ServerCapabilities.FIRST_SCRAMBLE );
				
				data.writeUTFBytes( old_hash );
			} else 
			{
				data.writeByte( 0x00 );
			}
			
			//end command
			data.writeByte(0x00);
			
			//setting end of authorization
			//base.handleEvent( new SQLEvent( SQLEvent.SQL_OK ) );
			base.addCmd (new EndAuthCommand( base ));//EndAuthorization will handle the result
			 
			var packet:IPacket = new Packet( data );
			base.sendPacket( packet );
		}
		
		public function finalize():void
		{
		}
		
	}
}