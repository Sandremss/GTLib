package pl.mooska.asql.commands
{
	import pl.mooska.asql.IAsqlBase;
	import pl.mooska.asql.commands.parsers.IParser;
	import pl.mooska.asql.commands.parsers.QueryParser;
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.events.SQLError;
	import pl.mooska.asql.events.SQLEvent;
	import pl.mooska.asql.packets.Packet;
	import pl.mooska.asql.query.IQueryObject;
	import pl.mooska.asql.query.IQueryReceiver;
	
	import flash.events.Event;
	import flash.utils.ByteArray;	

	public class QueryCommand implements ICommand, IQueryReceiver
	{
		private var parser:IParser;
		private var base:IAsqlBase;
		private var query:IQueryObject;
		
		public function set queryObject ( qObject:IQueryObject ) :void
		{
			query = qObject;
		}
		
		/* constructor */
		public function QueryCommand ( currentBase:IAsqlBase )
		{
			base = currentBase;
			parser = new QueryParser();
		}
		
		public function handleResult( data:ByteArray ):void
		{
			parser.addEventListener(SQLEvent.SQL_DATA, handleEvent);
			parser.addEventListener(SQLEvent.SQL_OK, handleEvent);
			parser.addEventListener(SQLError.SQL_ERROR, handleEvent);
			
			parser.parse( data );
		}
		
		public function execute():void
		{
			if ( query == null )
			{
				SQLDebugger("Query object in " + this + " must be specified before invoking a query");
				return;
			}
			
			var data:ByteArray = new ByteArray();
			
			data.position = 3;
			
			//packet number
			data.writeByte( 0x00 );
			
			//command type
			data.writeByte( CommandCodes.QUERY );
			
			
			//temporary, just to check the option
			data.writeUTFBytes( query.queryString );

			
			

			
			//trace("quering: "+ query.queryString);
			
			base.sendPacket( new Packet( data ) );
		}
		
		public function finalize():void
		{
		}
		
		private function handleEvent ( evt : Event ) :void
		{
			base.handleEvent( evt );
		}
	}
}