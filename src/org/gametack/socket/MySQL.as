package org.gametack.socket {
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.IllegalOperationError;
	import flash.events.SQLErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.gametack.BaseClass;
	import org.gametack.file.Files;
	import org.gametack.file.FileUtils;
	import org.gametack.util.StringUtils;
	import org.osflash.signals.Signal;
	import pl.mooska.asql.Asql;
	import pl.mooska.asql.events.SQLError;
	import pl.mooska.asql.events.SQLEvent;
	
	/**
	 * ...
	 * @author Alexander
	 * 
	 * TODO Two weeks and much cussing later, and external connections still don't work like they're supposed to. I'll fix it later.
	 */
	
	public class MySQL extends BaseClass {
		//vars
		public const LOG_SIGNAL:Signal = new Signal(uint, String);
		public const EVENT_SIGNAL:Signal = new Signal(String, Boolean, Array);
		
		private var _external:Boolean;
		private var _database:String;
		
		private var _timeoutHandler:Function = null;
		
		private var _externalSQL:Asql = new Asql();
		
		private var _internalSQL:SQLConnection = new SQLConnection();
		private var _internalStatement:SQLStatement = new SQLStatement();
		
		private var _timer:Timer;
		private var _timoutHandler:Function = null;
		
		private var _id:String = "";
		
		private var _files:Files = new Files();
		
		//constructor
		public function MySQL() {
			
		}
		
		//public
		public function init(usingExternal:Boolean, defaultDB:String, timeout:uint = 3000, dbHost:String = null, dbUser:String = null, dbPass:String = null, dbPort:uint = 3306, timeoutHandler:Function = null):Boolean {
			_external = usingExternal;
			_database = defaultDB;
			
			if (_external) {
				try {
					_externalSQL.addEventListener(SQLEvent.SQL_DATA, onExternalData);
					_externalSQL.addEventListener(SQLEvent.SQL_OK, onExternalData);
					_externalSQL.addEventListener(SQLEvent.CONNECT, onExternalConnect);
					_externalSQL.addEventListener(SQLError.SQL_ERROR, onExternalError);
				}catch (error:ArgumentError) {
					LOG_SIGNAL.dispatch(0, "Socket - MySQL: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				if (timeoutHandler != null) {
					_timeoutHandler = timeoutHandler;
				}
				
				_timer = new Timer(timeout, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				_timer.start();
				
				_externalSQL.connect(dbHost, dbUser, dbPass, defaultDB, dbPort);
			}else {
				_internalSQL.addEventListener(flash.events.SQLEvent.OPEN, onInternalConnect);
				_internalSQL.addEventListener(SQLErrorEvent.ERROR, onInternalError);
				_internalStatement.addEventListener(SQLErrorEvent.ERROR, onInternalError);
				_internalStatement.addEventListener(flash.events.SQLEvent.RESULT, onInternalData);
				
				_internalStatement.sqlConnection = _internalSQL;
				
				try {
					_internalSQL.openAsync(FileUtils.fileStr(Files.serverSaveFolder + Files.SEPARATOR + defaultDB));
				}catch (error:IllegalOperationError) {
					LOG_SIGNAL.dispatch(0, "Socket - MySQL: " + error.message + " (" + error.name + ")");
					return false;
				}catch (error:ArgumentError) {
					LOG_SIGNAL.dispatch(0, "Socket - MySQL: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			
			return true;
		}
		
		public function close():Boolean {
			clean();
			
			if (_timer.running) {
				_timer.reset();
			}
			
			if (_externalSQL.connected) {
				_externalSQL.disconnect();
			}else if (_internalSQL.connected) {
				_internalSQL.close();
			}
			
			return true;
		}
		
		public function isConnected():Boolean {
			return (_externalSQL.connected || _internalSQL.connected) ? true : false;
		}
		
		public function san(input:String):String {
			return input.replace(/(['\\"])/g, "\\$1");
		}
		
		public function query(input:String, id:String = ""):Boolean {
			_id = id;
			
			if (_externalSQL.connected) {
				_timer.start();
				_externalSQL.query(input);
				
				return true;
			}else if (_internalSQL.connected) {
				_internalStatement.text = input;
				
				try {
					_internalStatement.execute();
				}catch (error:IllegalOperationError) {
					LOG_SIGNAL.dispatch(0, "Socket - MySQL: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		//private
		private function clean():void {
			if (_external) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				_externalSQL.removeEventListener(SQLEvent.CONNECT, onExternalConnect);
				_externalSQL.removeEventListener(pl.mooska.asql.events.SQLError.SQL_ERROR, onExternalError);
				_externalSQL.removeEventListener(SQLEvent.SQL_OK, onExternalData);
				_externalSQL.removeEventListener(SQLEvent.SQL_DATA, onExternalData);
				
				if (_timeoutHandler != null) {
					_timeoutHandler = null;
				}
			}else {
				_internalSQL.addEventListener(flash.events.SQLEvent.OPEN, onInternalConnect);
				_internalSQL.addEventListener(SQLErrorEvent.ERROR, onInternalError);
				_internalStatement.addEventListener(SQLErrorEvent.ERROR, onInternalError);
				_internalStatement.addEventListener(flash.events.SQLEvent.RESULT, onInternalData);
			}
		}
		
		private function onExternalConnect(e:SQLEvent):void {
			_timer.reset();
			
			trace("connect");
			
			EVENT_SIGNAL.dispatch(_id, true, null);
		}
		private function onExternalError(e:SQLError):void {
			_timer.reset();
			
			if (StringUtils.find(e.text, "Bad handshake") > -1) {
				close();
				init(false, _database + ".db", _timer.delay);
			}else if (StringUtils.find(e.text, "Access denied") > -1) {
				close();
				init(false, _database + ".db", _timer.delay);
			}
			
			EVENT_SIGNAL.dispatch(_id, false, [e.text]);
		}
		private function onExternalData(e:SQLEvent):void {
			var data:Array = e.data;
			
			_timer.reset();
			
			if (!data) {
				data = new Array("data");
			}
			
			EVENT_SIGNAL.dispatch(_id, true, data);
		}
		private function onTimeout(e:TimerEvent):void {
			_timer.reset();
			
			close();
			init(false, _database + ".db", _timer.delay);
			
			if (_timeoutHandler != null) {
				_timeoutHandler.call(null, e);
			}
		}
		
		private function onInternalConnect(e:flash.events.SQLEvent):void {
			EVENT_SIGNAL.dispatch(_id, true, null);
		}
		private function onInternalError(e:SQLErrorEvent):void {
			EVENT_SIGNAL.dispatch(_id, false, [e.errorID, e.error]);
		}
		private function onInternalData(e:flash.events.SQLEvent):void {
			var data:Array = _internalStatement.getResult().data;
			if (!data || data.length == 0) {
				data = new Array("data");
			}
			
			if (!_internalSQL.autoCompact) {
				try {
					_internalSQL.compact();
				}catch (error:IllegalOperationError) {
					LOG_SIGNAL.dispatch(1, "Socket - MySQL: " + error.message + " (" + error.name + ")");
				}
			}
			
			EVENT_SIGNAL.dispatch(_id, true, data);
		}
	}
}