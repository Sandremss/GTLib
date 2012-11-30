package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class NullType implements IType
	{
		public function NullType ()
		{
			
		}
		public function convert(data:ByteArray):*
		{
			return null;
		}
		
	}
}