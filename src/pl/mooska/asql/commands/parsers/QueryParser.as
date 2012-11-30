package pl.mooska.asql.commands.parsers
{
	import pl.mooska.asql.commands.parsers.types.IType;
	import pl.mooska.asql.debugger.SQLDebugger;
	import pl.mooska.asql.events.SQLError;
	import pl.mooska.asql.events.SQLEvent;
	import pl.mooska.asql.packets.Packet;
	import pl.mooska.asql.utils.TypesUtil;

	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;	

	public class QueryParser extends EventDispatcher implements IParser
	{
		private var rawData : ByteArray;
		private var currentTypes : Array;
		private var currentFieldsNames : Array;//array of column names
		private var currentFields : Array;
		private var currentParsers : Array;
		private var currentData : Array;
		private var lEndian : String = Endian.LITTLE_ENDIAN;

		/* constructor */
		public function QueryParser()
		{
			rawData = new ByteArray();//initing the arrays
		}

		public function parse( data : ByteArray ) : void
		{
			rawData.writeBytes(data);

			var columnHeader : Packet;
			
			if( !hasEndPacket(rawData) ) {
				data.position = 0;
				columnHeader = new Packet();
				columnHeader.write(data);
								
				if( columnHeader.type == Packet.ERROR ) {
					dispatchEvent(new SQLError(columnHeader.text));
					resetArrays();
				} 
				else if ( columnHeader.type == Packet.OK ) {
					dispatchEvent(new SQLEvent(SQLEvent.SQL_OK));
				}
				return;
			}
			rawData.position = 0;
			
			//initing/reseting arrays
			currentFields = [];
			currentParsers = [];
			currentFieldsNames = [];
			currentData = [];
			
			columnHeader = new Packet();//reading first packet
			columnHeader.write(rawData);

			
			if( columnHeader.type == Packet.ERROR ) {
				dispatchEvent(new SQLError(columnHeader.text));
				resetArrays();
				return;
			} 
			else if( columnHeader.type == Packet.OK ) {
				dispatchEvent(new SQLEvent(SQLEvent.SQL_OK));
				resetArrays();
				return;
			}
			
			var packetSize : uint = columnHeader.length;//reading length of the current packet
			//var packetNumber:int = columnHeader.number;
			var fieldsCounter : uint = columnHeader.data.readUnsignedByte();//how many field there will be
			SQLDebugger.write("There will be: " + fieldsCounter + " columns in current query ", 1);
			
			if(packetSize > 1) {
				//sometimes present, how many records there will be
				SQLDebugger.write("Number of records in the query result: " + columnHeader.data.readByte());
			}
			
			for( var i : uint = 0;i < fieldsCounter; i++ ) {
				var fieldType : int = readField(rawData);//reads column properties, collects into arrays, returns field code (byte/int)
				var type : IType = TypesUtil.getParserFromCode(fieldType);//returns needed parser
				currentParsers.push(type);
			}
			var eofPacket : Packet = new Packet();
			eofPacket.write(rawData);
			readData(rawData);
		}

		/**
		 * 
		 * 
		 * helpers
		 * 
		 */
		private function hasEndPacket( data : ByteArray ) : Boolean
		{
			//var lastPosition:uint = data.position;
			var eof : uint = data[data.length - 5];
			
			SQLDebugger.write("looking for eof byte: " + eof.toString(16) + " length " + data.length);
			SQLDebugger.write("has end packet ? " + (eof == 254) + " " + (data[data.length - 9]) + ( data[data.length - 8] == 0 ));
			
			//need to correct his
			if(eof == 254 && data[data.length - 9] == 5 && data[data.length - 8] == 0 && data[data.length - 7] == 0 ) {
				data.position = 0;
				
				return true;
			}
			
			return false;
		}

		private function readUTFFrom( data : ByteArray ) : String 
		{
			//standard readUTF reads string of the short length, mysql
			//uses one or more bytes for the length of the string;
			return data.readUTFBytes(data.readByte());
		}

		/**
		 * 
		 * 
		 * end of helpers
		 * 
		 * 
		 */
		private function readField( data : ByteArray ) : int 
		{
			
			SQLDebugger.write("Start of the column");
			
			var field : Packet = new Packet();
			field.write(data);
			var d : ByteArray = field.data;
			
			//SQLDebugger.write("current packet length: "+field.length+"----");
			SQLDebugger.write("catalogue:                " + readUTFFrom(d));//for version 4.1 and upper its "def"
			SQLDebugger.write("dbase name (schema):      " + readUTFFrom(d));
			SQLDebugger.write("table:                    " + readUTFFrom(d));
			SQLDebugger.write("orginal table identifier: " + readUTFFrom(d));
			
			var fieldName : String = readUTFFrom(d);
			SQLDebugger.write("Column name:              " + fieldName);
			SQLDebugger.write("original column name:     " + readUTFFrom(d));
			SQLDebugger.write("----- fixed length part : " + d.readByte() + "  ----");
			
			d.endian = Endian.LITTLE_ENDIAN;
			
			SQLDebugger.write("charset:       " + d.readUnsignedShort());
			SQLDebugger.write("field length:  " + d.readUnsignedInt());
			
			var fieldType : uint = d.readUnsignedByte();
			var fieldTypeName : String = TypesUtil.getTypeFromCode(fieldType);
			
			currentFieldsNames.push(fieldName);//collecting fields name
			currentFields.push(fieldTypeName);//collecting fields types
			SQLDebugger.write("Field type:    " + fieldTypeName);//+" "+b+" "+data.position);
			
			/*
			 * 
			 * 
			 * in here theres unresolved packet
			 * due to this error flags are counted badly
			 * 
			 * TODO find what kind of byte it is
			 * 
			 * its present with some types of fields, ie for string its 0x11
			 * 
			 */
			SQLDebugger.write("Options (currently bad) : " + TypesUtil.getFlagsFromCode(d.readShort()));
			SQLDebugger.write("decimals (number of fields after point): " + d.readByte());//if type is decimal or numeric, number of fields after point
				
			/*
			if(counter != 0){
			data.position+=2;
				
			trace("Options: "+getFlagsFromCode(data.readShort()));
			trace("decimals: "+data.readByte());//if type is decimal or numeric, number of fields after point
			//trace("default: " + data.readByte());//doeasnt occure for standard queries
			} else {
			data.position++;
				
			trace("Options: "+getFlagsFromCode(data.readShort()));
			trace("decimals: "+data.readByte());//if type is decimal or numeric, number of fields after point
			trace("default: " + data.readByte());//doeasnt occure for standard queries
			}
			 */
			return fieldType;
		}

		private function readData( data : ByteArray ) : void
		{
			//data.position = 0;
			var tim : Number = getTimer();
			//SQLDebugger.write("\tparsing started ... data: "+data.length+" bytes");
			var packet : Packet;
			var eofMarker : String = Packet.EOF;
			
			while( packet = new Packet() ) {
				packet.write(data);
				
				if( packet.type == eofMarker ) {
					break;
				}
				var row : Object = readRow(packet.data);
				currentData.push(row);
			}
			SQLDebugger.write("Parsing of " + data.length + " bytes [" + currentData.length + " rows] took: " + (getTimer() - tim) + " ms ", 4);
			
			var eofPacket : Packet = packet;
			//var oefMarker : uint = eofPacket.data.readUnsignedByte();
			
			//TODO uncomment and improve SQLDebugger code
			/*SQLDebugger.write("Server warnings: \n" + eofPacket.data.readUTFBytes(eofPacket.data.readByte()));
			SQLDebugger.write("Server status code " + eofPacket.data.readShort().toString(16));*/
			
			var e : SQLEvent = new SQLEvent(SQLEvent.SQL_DATA, currentData);
			dispatchEvent(e);
			
			resetArrays();
		}

		private function readRow( data : ByteArray ) : Object
		{
			var result : Object = new Object;
			
			//SQLDebugger.write("Reading row - data: "+data.length);
			var length : uint = currentFieldsNames.length;
			//trace("how many fields? " + length);
			for(var i : uint = 0;i < length; i++) {
				var l : uint = data.readUnsignedByte();
				//if(l == 0)
				//{//if fields are empty
				//continue;
				//}
				//if length (first byte) is equal to 252, it means, that length is coded in next 2 bytes
				//again if first byte is 253 this mean, length is coded in next 3 bytes
				data.endian = lEndian;
				if(l == 252) {
					l = data.readUnsignedShort();
					//SQLDebugger.write("Length is coded in 2 bytes");
				} 
				else if( l == 253 ) {
					//need to be converted into maskin
					l = (data.readUnsignedInt() << 8 ) >> 8;
					data.position--;
					//SQLDebugger.write("Length is coded in 3 bytes");
				}
				//data.endian = Endian.LITTLE_ENDIAN
				var item : Object;
				var value : ByteArray = new ByteArray();
				

				if(l == 0xfb) { 
					//null field (int 251)
					item = null;
					value = null;
				} 
				else if ( l != 0 )//length is 0 (no data) 
				{
					data.readBytes(value, 0, l);
				}
				
				//SQLDebugger.write("Reading row: parsing using - "+currentParsers[i]+" current field name: "+currentFieldsNames[i]+" value : "+value);
				if(value) {
					result[currentFieldsNames[i]] = currentParsers[i].convert(value);//parsing values from string to as types (Number, int etc)
				} else {
					result[currentFieldsNames[i]] = value;
				}
			}
			
			return result;
		}

		private function resetArrays() : void
		{
			rawData = new ByteArray;
			currentTypes = [];
			currentFieldsNames = [];//array of column names
			currentParsers = [];
			currentData = [];
		}
	}
}