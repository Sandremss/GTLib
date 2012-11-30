package pl.mooska.asql.query
{
	import flash.utils.ByteArray;	

	public interface IQueryObject
	{
		function get queryString () :String;
		function get binaryWildCard () :String;
		function get binaryData () :ByteArray
	}
}