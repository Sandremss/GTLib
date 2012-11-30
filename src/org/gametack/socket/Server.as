package org.gametack.socket {
	import flash.errors.EOFError;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import org.gametack.BaseClass;
	import org.gametack.util.StringUtils;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Server extends BaseClass {
		//vars
		public const LOG_SIGNAL:Signal = new Signal(uint, String);
		
		public var clients:Vector.<Socket> = new Vector.<Socket>;
		
		private var _socket:ServerSocket = new ServerSocket();
		private var _connectHandler:Function = null;
		private var _clientCloseHandler:Function = null;
		private var _serverCloseHandler:Function = null;
		private var _IOErrorHandler:Function = null;
		private var _securityErrorHandler:Function = null;
		private var _socketDataHandler:Function = null;
		
		//constructor
		public function Server() {
			
		}
		
		//public
		public function init(port:uint, socketDataHandler:Function, connectHandler:Function = null, clientCloseHandler:Function = null, serverCloseHandler:Function = null, IOErrorHandler:Function = null, securityErrorHandler:Function = null):Boolean {
			try {
				_socket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
				_socket.addEventListener(Event.CLOSE, onServerClose);
			}catch (error:ArgumentError) {
				LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			try {
				_socket.bind(port);
				_socket.listen();
			}catch (error:RangeError) {
				LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:ArgumentError) {
				LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			_socketDataHandler = socketDataHandler;
			if (connectHandler != null) {
				_connectHandler = connectHandler;
			}
			if (clientCloseHandler != null) {
				_clientCloseHandler = clientCloseHandler;
			}
			if (serverCloseHandler != null) {
				_serverCloseHandler = serverCloseHandler;
			}
			if (IOErrorHandler != null) {
				_IOErrorHandler = IOErrorHandler;
			}
			if (securityErrorHandler != null) {
				_securityErrorHandler = securityErrorHandler;
			}
			
			return true;
		}
		
		public function close():Boolean {
			clean();
			
			if (_socket.bound && _socket.listening) {
				try {
					_socket.close();
				}catch (error:Error) {
					LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			
			return true;
		}
		
		public function writeObject(client:uint, data:Object):Boolean {
			if (isListening() && client <= clients.length - 1 && clients[client].connected) {
				try {
					clients[client].writeObject(data);
					clients[client].flush();
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		public function writeString(client:uint, data:String):Boolean {
			if (isListening() && client <= clients.length - 1 && clients[client].connected) {
				try {
					clients[client].writeUTFBytes(data);
					clients[client].flush();
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		public function writeNumber(client:uint, data:Number):Boolean {
			if (isListening() && client <= clients.length - 1 && clients[client].connected) {
				try {
					clients[client].writeDouble(data);
					clients[client].flush();
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		public function writeByte(client:uint, data:String):Boolean {
			var byteArray:ByteArray = new ByteArray();
			
			if (isListening() && client <= clients.length - 1 && clients[client].connected) {
				byteArray.writeUTFBytes(data);
				byteArray.position = 0;
				
				try {
					clients[client].writeByte(byteArray.readByte());
					clients[client].flush();
				}catch (error:EOFError) {
					LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
					return false;
				}catch (error:IOError) {
					LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
					return false;
				}
				
				return true;
			}else {
				return false;
			}
		}
		
		public function removeClient(client:uint):Boolean {
			if (client <= clients.length - 1) {
				if (clients[client].connected) {
					try {
						clients[client].close();
					}catch (error:IOError) {
						LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
						return false;
					}
				}
				
				clients[client].removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				clients[client].removeEventListener(Event.CLOSE, onClientClose);
				clients[client].removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				
				clients.splice(client, 1);
				return true;
			}else {
				return false;
			}
		}
		
		public function isListening():Boolean {
			return (_socket.bound && _socket.listening) ? true : false;
		}
		
		public function sendPolicy(client:uint):Boolean {
			var xmlString:String = "<?xml version=\"1.0\"?>"
				+ "<!DOCTYPE cross-domain-policy SYSTEM \"/xml/dtds/cross-domain-policy.dtd\">"
				+ "<cross-domain-policy>"
					+ "<site-control permitted-cross-domain-policies=\"master-only\"/>"
					+ "<allow-access-from domain=\"*\" to-ports=\"" + _socket.localPort + "\"/>"
				+ "</cross-domain-policy>\x00"
			
			return (writeString(client, "Content-Type: application/xml \r\n" + "Content-Length: " + xmlString.length + " \r\n" + xmlString) && removeClient(client)) ? true : false;
		}
		
		//private
		private function clean():void {
			_socket.removeEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
			_socket.removeEventListener(Event.CLOSE, onServerClose);
			
			while(clients.length > 0) {
				removeClient(0);
			}
			
			if (_connectHandler != null) {
				_connectHandler = null;
			}
			if (_clientCloseHandler != null) {
				_clientCloseHandler = null;
			}
			if (_serverCloseHandler != null) {
				_serverCloseHandler = null;
			}
			if (_IOErrorHandler != null) {
				_IOErrorHandler = null;
			}
			if (_securityErrorHandler != null) {
				_securityErrorHandler = null;
			}
			
			_socketDataHandler = null;
		}
		
		private function onConnect(e:ServerSocketConnectEvent):void {
			for (var i:uint = 0; i < clients.length; i++) {
				if (clients[i].remoteAddress == e.socket.remoteAddress) {
					removeClient(i);
					break;
				}
			}
			clients.push(e.socket);
			
			try {
				clients[clients.length - 1].addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				clients[clients.length - 1].addEventListener(Event.CLOSE, onClientClose);
				clients[clients.length - 1].addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}catch (error:ArgumentError) {
				LOG_SIGNAL.dispatch(0, "Socket - Server: " + error.message + " (" + error.name + ")");
				return;
			}
			
			if (_connectHandler != null) {
				_connectHandler.call(null, e);
			}
		}
		private function onClientClose(e:Event):void {
			LOG_SIGNAL.dispatch(4, "Socket - Server: " + e.target.remoteAddress + " terminated connection");
			
			for (var i:uint = 0; i < clients.length; i++) {
				if (clients[i].remoteAddress == e.target.remoteAddress) {
					removeClient(i);
					break;
				}
			}
			
			if (_clientCloseHandler != null) {
				_clientCloseHandler.call(null, e);
			}
		}
		private function onServerClose(e:Event):void {
			close();
			
			LOG_SIGNAL.dispatch(0, "Socket - Server: Host closed server");
			
			if (_serverCloseHandler != null) {
				_serverCloseHandler.call(null, e);
			}
		}
		private function onIOError(e:IOErrorEvent):void {
			LOG_SIGNAL.dispatch(0, "Socket - Server: " + e.text + " (" + e.errorID + ")");
			
			if (_IOErrorHandler != null) {
				_IOErrorHandler.call(null, e);
			}
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			LOG_SIGNAL.dispatch(0, "Socket - Server: " + e.text + " (" + e.errorID + ")");
			
			if (_IOErrorHandler != null) {
				_IOErrorHandler.call(null, e);
			}
		}
		private function onSocketData(e:ProgressEvent):void {
			_socketDataHandler.call(null, e);
		}
	}
}