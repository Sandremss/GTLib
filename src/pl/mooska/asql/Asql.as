package pl.mooska.asql
{
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.query.IQueryObject;
	import pl.mooska.asql.query.QueryObject;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;	

	public class Asql extends EventDispatcher implements IAsql
	{
		private var asqlObject:IAsqlBase;
		
		/* constructor */
		public function Asql ( baseObject:IAsqlBase = null ) 
		{
			if( baseObject == null )
			{
				asqlObject = new Mysql( this  );
			};
		};
		
		public function connect ( 
			host:String, 
			user:String, 
			pass:String, 
			initialDBase:String, 
			port:uint = 3306 ) :void 
		{
			asqlObject.connect(host, user, pass, initialDBase, port);
		};
		public function disconnect () :void  
		{
			asqlObject.disconnect();
		};
		
		public function query ( queryString:String ) :void  
		{
			var query:IQueryObject = new QueryObject( queryString );
			asqlObject.query( query );
		};
		public function binaryQuery ( 
										queryString:String, 
										wildCard:String, 
										data:ByteArray ) :void
		{
			var query:IQueryObject = new QueryObject( queryString, wildCard, data );
			asqlObject.query( query );
		}
		public function get connected () :Boolean
		{
			return asqlObject.connected;
		}
		public function selectDBase ( baseName:String ) :void  
		{
			SQLDebugger.write("Dbase selecting not implemented");
		};
		
		internal function handleEvent ( evt:Event ) :void
		{
			dispatchEvent( evt );
		}
	}
}