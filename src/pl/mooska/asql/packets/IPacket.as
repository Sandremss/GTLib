package pl.mooska.asql.packets
{
	import flash.utils.ByteArray;	

	public interface IPacket
	{
		function write ( data:ByteArray ) :void
		function get data () :ByteArray;
	}
}