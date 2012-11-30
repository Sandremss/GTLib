package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class YearType implements IType
	{
		public function YearType ()
		{
			
		}
		public function convert( data:ByteArray ) :*
		{
			return int ( data.readUTFBytes( data.length ) );
		}
		
	}
}