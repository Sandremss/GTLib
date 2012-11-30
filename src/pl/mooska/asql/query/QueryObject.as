package pl.mooska.asql.query
{
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.query.IQueryObject;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;	

	public class QueryObject implements IQueryObject
	{
		private var _queryString :String;
		private var _binaryWildCard :String;
		private var _binaryData :ByteArray;
		
		public function get queryString () :String
		{
			return _queryString;
		}
		
		public function get binaryWildCard () :String
		{
			return _binaryWildCard;
		}
		
		public function get binaryData () :ByteArray
		{
			 return _binaryData;	
		}
		
		public function QueryObject ( 
										queryString:String, 
										binaryWildCard:String = '', 
										binaryData:ByteArray = null )
		{
			_queryString = queryString;
			_binaryWildCard = binaryWildCard;
			_binaryData = binaryData;
			//trace("data.received " + binaryData.toString());
			if ( binaryData != null )
			{
				var p:RegExp = new RegExp(binaryWildCard, "");
				_queryString = _queryString.replace(p, convertBytes( binaryData ) );
			}
		}
		
		private function convertBytes(data:ByteArray) :String
		{
		//converts byte array to its string form
		SQLDebugger.write("Started converting ByteArray to query ...", 1);
		var t:int = getTimer();
			var s:String = '';
			
			for(var i:uint =0; i<data.length; i++)
			{
				var b:String = data[i].toString(16);
				b = (b != null ? b : "");
				var bb:String = (b.length == 1 ) ? "0"+b : b;
				s += bb;
			}
		SQLDebugger.write("Ended converting after: "+(getTimer() - t) +" ms, data received: " + s.length+ " bytes", 1);
			return "0x"+s;
			
		}
	}
}