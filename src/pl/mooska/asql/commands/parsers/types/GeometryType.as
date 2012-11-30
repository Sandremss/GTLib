package pl.mooska.asql.commands.parsers.types
{
	import pl.mooska.asql.debugger.SQLDebugger;
	
	import flash.utils.ByteArray;	

	public class GeometryType implements IType
	{
		public function GeometryType ()
		{
		}
		public function convert(data:ByteArray):*
		{
			SQLDebugger.write("Geometry Type not implemented");
			return data;
		}
		
	}
}