package org.gametack.socket {
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	import org.gametack.BaseClass;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Client extends BaseClass {
		//vars
		public const LOG_SIGNAL:Signal = new Signal(uint, String);
		public var socketAddress:String = "";
		public var socketPort:uint = 0;
		
		private var _socket:Socket = new Socket();
		private var _connectHandler:Function = null;
		private var _closeHandler:Function = null;
		private var _IOErrorHandler:Function = null;
		private var _securityErrorHandler:Function = null;
		private var _socketDataHandler:Function = null;
		
		private var _timeout:Timer;
		private var _timeoutHandler:Function = null;
		
		//constructor
		public function Client() {
			
		}
		
		//public
		public function init(host:String, port:uint, timeout:uint, socketDataHandler:Function, timeoutHandler:Function = null, connectHandler:Function = null, closeHandler:Function = null, IOErrorHandler:Function = null, securityErrorHandler:Function = null):Boolean {
			try {
				_timeout = new Timer(timeout, 1);
				if (timeoutHandler != null) {
					_timeoutHandler = timeoutHandler;
					_timeout.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				}
				if (connectHandler != null) {
					_connectHandler = connectHandler;
					_socket.addEventListener(Event.CONNECT, onConnect);
				}
				if (closeHandler != null) {
					_closeHandler = closeHandler;
					_socket.addEventListener(Event.CLOSE, onClose);
				}
				if (IOErrorHandler != null) {
					_IOErrorHandler = IOErrorHandler;
					_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				}
				if (securityErrorHandler != null) {
					_securityErrorHandler = securityErrorHandler;
					_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				}
				if (socketDataHandler != null) {
					_socketDataHandler = socketDataHandler;
					_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				}
			}catch (error:Error) {
				LOG_SIGNAL.dispatch(0, "Socket - Client: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			_socket.timeout = timeout + 5000;
			
			try {
				_socket.connect(host, port);
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "Socket - Client: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "Socket - Client: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			socketAddress = host;
			socketPort = port;
			
			_timeout.start();
			
			return true;
		}
		
		public function close():Boolean {
			_timeout.reset();
			clean();
			
			if (_socket.connected) {
				try {
					_socket.close();
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Client: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			
			return true;
		}
		
		public function writeObject(data:Object):Boolean {
			if (_socket.connected) {
				try {
					_socket.writeObject(data);
					_socket.flush();
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Client: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				if (_timeout.running) {
					_timeout.reset();
					_timeout.start();
				}else {
					_timeout.start();
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		public function writeString(data:String):Boolean {
			if (_socket.connected) {
				try {
					_socket.writeUTFBytes(data);
					_socket.flush();
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Client: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				if (_timeout.running) {
					_timeout.reset();
					_timeout.start();
				}else {
					_timeout.start();
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		public function writeNumber(data:Number):Boolean {
			if (_socket.connected) {
				try {
					_socket.writeDouble(data);
					_socket.flush();
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Client: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				if (_timeout.running) {
					_timeout.reset();
					_timeout.start();
				}else {
					_timeout.start();
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		public function isConnected():Boolean {
			return _socket.connected;
		}
		
		//private
		private function clean():void {
			if (_timeoutHandler != null) {
				_timeout.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				_timeoutHandler = null;
			}
			if (_connectHandler != null) {
				_socket.removeEventListener(Event.CLOSE, onConnect);
				_connectHandler = null;
			}
			if (_closeHandler != null) {
				_socket.removeEventListener(Event.CLOSE, onClose);
				_closeHandler = null;
			}
			if (_IOErrorHandler != null) {
				_socket.removeEventListener(Event.CLOSE, onIOError);
				_IOErrorHandler = null;
			}
			if (_securityErrorHandler != null) {
				_socket.removeEventListener(Event.CLOSE, onSecurityError);
				_securityErrorHandler = null;
			}
			if (_socketDataHandler != null) {
				_socket.removeEventListener(Event.CLOSE, onSocketData);
				_socketDataHandler = null;
			}
		}
		
		private function onTimeout(e:TimerEvent):void {
			_timeout.reset();
			
			LOG_SIGNAL.dispatch(1, "Socket - Client: Read timeout");
			
			close();
			
			if (_timeoutHandler != null) {
				_timeoutHandler.call(null, e);
			}
		}
		private function onConnect(e:Event):void {
			_timeout.reset();
			
			LOG_SIGNAL.dispatch(4, "Socket - Client: Connected to " + _socket.remoteAddress + " on port " + _socket.remotePort);
			
			if (_connectHandler != null) {
				_connectHandler.call(null, e);
			}
		}
		private function onClose(e:Event):void {
			LOG_SIGNAL.dispatch(2, "Socket - Client: Server closed connection");
			
			if (_closeHandler != null) {
				_closeHandler.call(null, e);
			}
			
			close();
		}
		private function onIOError(e:IOErrorEvent):void {
			_timeout.reset();
			
			LOG_SIGNAL.dispatch(0, "Socket - Client: " + e.text + " (" + e.errorID + ")");
			
			if (_IOErrorHandler != null) {
				_IOErrorHandler.call(null, e);
			}
			
			close();
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			_timeout.reset();
			
			LOG_SIGNAL.dispatch(0, "Socket - Client: " + e.text + " (" + e.errorID + ")");
			
			if (_securityErrorHandler != null) {
				_securityErrorHandler.call(null, e);
			}
			
			close();
		}
		private function onSocketData(e:ProgressEvent):void {
			_timeout.reset();
			
			if (_socketDataHandler != null) {
				_socketDataHandler.call(null, e);
			}
		}
	}
}