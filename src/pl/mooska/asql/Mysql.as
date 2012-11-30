package pl.mooska.asql
{
	import pl.mooska.asql.commands.AuthCommand;
	import pl.mooska.asql.commands.DisconnectCommand;
	import pl.mooska.asql.commands.ICommand;
	import pl.mooska.asql.commands.QueryCommand;
	import pl.mooska.asql.commands.SelectBaseCommand;
	import pl.mooska.asql.connector.SQLConnector;
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.hash.User;
	import pl.mooska.asql.packets.IPacket;
	import pl.mooska.asql.query.IQueryObject;
	import pl.mooska.asql.query.IQueryReceiver;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;	

	internal class Mysql implements IAsqlBase
	{
		private var connector:SQLConnector;
		private var currentCommand:ICommand;
		private var main:Asql;
		
		/* constructor */
		public function Mysql ( currentMain:Asql ) 
		{
			main = currentMain;
			connector = new SQLConnector();
		}
		
		public function query( queryObject:IQueryObject ):void
		{
			var queryCommand:IQueryReceiver = new QueryCommand( this );
			queryCommand.queryObject = queryObject;
			
			addCmd( queryCommand as ICommand );
			invokeCmd();
		}
		
		public function disconnect():void
		{
			invokeCmd( new DisconnectCommand( this ) );
		}
		
		public function connect(host:String, 
								user:String, 
								pass:String, 
								initialDBase:String, 
								port:uint=3306):void
		{
			currentCommand = new AuthCommand( this );
			
			User.LOGIN = user;
			User.PASS = pass;
			User.BASE = initialDBase;
			User.HOST = host;
			
			connector.addEventListener( ProgressEvent.SOCKET_DATA, handleResult );
			connector.addEventListener( IOErrorEvent.IO_ERROR, handleError );
			connector.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleError );
			connector.addEventListener( Event.CLOSE, handleEvent );
			connector.connect( host, port );
		}
		
		public function selectDBase(baseName:String):void
		{
			User.BASE = baseName;
			invokeCmd( new SelectBaseCommand ( this ) );
		}
		
		private function handleError ( evt:Event ) :void {}
		
		private function handleResult ( evt:Event ) :void
		{
			var n:ByteArray = new ByteArray();
			connector.readBytes(n);
			currentCommand.handleResult ( n );
		}
		
		public function sendPacket ( packet:IPacket ) :void
		{
			connector.sendPacket( packet );
		}
		public function handleEvent ( evt:Event ) :void
		{
			main.handleEvent( evt );	
		}
		public function addCmd ( command:ICommand ) :void
		{
			SQLDebugger.write( "Creating command: " + command);
			//delete currentCommand;
			currentCommand = null;
			currentCommand = command;
		}
		public function invokeCmd ( command:ICommand = null ) :void
		{
			if ( command != null )
			{
				addCmd ( command );
			}
			currentCommand.execute();
		}
		public function get connected () :Boolean
		{
			return connector.connected;
		}
		
	}
}