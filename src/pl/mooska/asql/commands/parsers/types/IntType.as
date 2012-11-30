package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class IntType implements IType
	{
		public function IntType () {}
		
		public function convert(data:ByteArray):*
		{
			return int(data.readUTFBytes(data.length));
		}
		
	}
}