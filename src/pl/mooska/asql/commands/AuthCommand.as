package pl.mooska.asql.commands
{
	import pl.mooska.asql.IAsqlBase;
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.events.SQLError;
	import pl.mooska.asql.hash.Pass;
	import pl.mooska.asql.hash.User;
	import pl.mooska.asql.packets.CapabilitiesPacket;
	import pl.mooska.asql.packets.ClientCapabilities;
	import pl.mooska.asql.packets.Packet;
	import pl.mooska.asql.packets.ServerCapabilities;
	
	import flash.utils.ByteArray;	

	public class AuthCommand implements ICommand
	{
		private var base:IAsqlBase;  
		
		public function AuthCommand ( currentBase:IAsqlBase )
		{
			base = currentBase;
		}
		public function handleResult( n:ByteArray ):void
		{

			ServerCapabilities.readCapabilities( n );
			
			/**
			 * 
			 * Checking client capabilities, and compares them to the server capabilities
			 * 
			 **/
			 if( ServerCapabilities.PROTOCOL < ClientCapabilities.PROTOCOL_VERSION )
			 {
			 	base.handleEvent( new SQLError("Imcompatilibile protocol, founded: " 
			 	+ ServerCapabilities.PROTOCOL 
			 	+ " where " + ClientCapabilities.PROTOCOL_VERSION 
			 	+ " required ") );
			 }
			 
			 
			 
			 
			var data:ByteArray = new ByteArray();
			
			 data.position = 3;//leave the packet size space
			 
			 //packet number
			 data.writeByte( 0x01 );
			 
			 //client capabilities (decorator)
			 data = new CapabilitiesPacket( data );//this need to be improved
			 
			 //write login
			 data.writeUTFBytes( User.LOGIN );
			 
			 // ending pass
			 data.writeByte( 0x00 );
			 data.writeByte( 0x14 );
			 
			 
			 SQLDebugger.write("Used salt (scramble) "+ ServerCapabilities.FIRST_SCRAMBLE+" "+ServerCapabilities.SECOND_SCRAMBLE);
			 
			 var tempHash:String;
			 if ( User.PASS != "" )
			 {
				 //writing Hash
				 tempHash = Pass.hash(ServerCapabilities.FIRST_SCRAMBLE+ServerCapabilities.SECOND_SCRAMBLE, User.PASS);

				 /*
				 * TODO change to some byte operation, this one solution aint good 
				 * 
				 */
				 for(var i:uint =0; i<=39; i+=2)
				 {
					 data.writeByte(parseInt(tempHash.substr(i, 2), 16));
				 }
			 } 
			 else //if user has no pass, not tested
			 {
			 	//writing Hash
				tempHash = "";
				data.writeByte(0x00);
			 }
			
			SQLDebugger.write("Connecting to: " + User.HOST + " as " + User.LOGIN + " pass: " + User.PASS, 1);
			//base.handleEvent ( new SQLEvent(SQLEvent.SQL_OK) );
			base.addCmd ( new EndAuthCommand( base ) );//endAuthorization will handle the result
			 
			//Packet is a decorator, adds packet size at the header
			base.sendPacket( new Packet( data ) );
		}
		
		public function execute():void
		{
		}
		
		public function finalize():void
		{
		}
		
	}
}