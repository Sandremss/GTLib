package pl.mooska.asql
{
	import flash.utils.ByteArray;	

	public interface IAsql
	{
		function connect ( host:String, user:String, pass:String, initialDBase:String, port:uint = 3306 ) :void;
		function disconnect () :void;
		function query ( queryString:String ) :void;
		function binaryQuery ( queryString:String, wildCards:String, data:ByteArray ) :void;
		function selectDBase ( baseName:String ) :void;
		function get connected () :Boolean;
	}
}