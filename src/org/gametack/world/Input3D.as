package org.gametack.world {
	import flash.geom.Point;
	import org.gametack.input.Keyboard;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Input3D {
		//vars
		public var oldCameraPoint:Point;
		
		public var upSpeed:Number = 1;
		public var downSpeed:Number = 1;
		public var leftSpeed:Number = 1;
		public var rightSpeed:Number = 1;
		
		private var _world:BaseWorld;
		
		private var _upKeys:Vector.<uint> = new Vector.<uint>;
		private var _downKeys:Vector.<uint> = new Vector.<uint>;
		private var _leftKeys:Vector.<uint> = new Vector.<uint>;
		private var _rightKeys:Vector.<uint> = new Vector.<uint>;
		private var _longestKeys:uint = 0;
		
		private var _newRotation:Number;
		
		//constructor
		public function Input3D() {
			
		}
		
		//public
		public function init(world:BaseWorld, strafing:Boolean = true):void {
			_world = world;
			
			if (!_world.view) {
				_world.init();
			}
		}
		
		public function get upKeys():Vector.<uint> {
			return _upKeys;
		}
		public function set upKeys(keys:Vector.<uint>):void {
			if (keys.length > _longestKeys) {
				_longestKeys = keys.length;
			}
			
			_upKeys = keys;
		}
		
		public function get downKeys():Vector.<uint> {
			return _downKeys;
		}
		public function set downKeys(keys:Vector.<uint>):void {
			if (keys.length > _longestKeys) {
				_longestKeys = keys.length;
			}
			
			_downKeys = keys;
		}
		
		public function get leftKeys():Vector.<uint> {
			return _leftKeys;
		}
		public function set leftKeys(keys:Vector.<uint>):void {
			if (keys.length > _longestKeys) {
				_longestKeys = keys.length;
			}
			
			_leftKeys = keys;
		}
		
		public function get rightKeys():Vector.<uint> {
			return _rightKeys;
		}
		public function set rightKeys(keys:Vector.<uint>):void {
			if (keys.length > _longestKeys) {
				_longestKeys = keys.length;
			}
			
			_rightKeys = keys;
		}
		
		public function checkKeys():void {
			var i:uint;
			
			for (i = 0; i < _longestKeys; i++) {
				if (i < _upKeys.length && Keyboard.keyIsDown(_upKeys[i])) {
					onUpPressed();
				}else if (i < _downKeys.length && Keyboard.keyIsDown(_downKeys[i])) {
					onDownPressed();
				}
				if (i < _leftKeys.length && Keyboard.keyIsDown(_leftKeys[i])) {
					onLeftPressed();
				}else if (i < _rightKeys.length && Keyboard.keyIsDown(_rightKeys[i])) {
					onRightPressed();
				}
			}
		}
		
		public function rotateCamera(newX:Number, newY:Number):void {
			if (!oldCameraPoint) {
				oldCameraPoint = new Point(newX, newY);
			}else {
				_world.camera.rotationX += (newY - oldCameraPoint.y) / 2.5;
				_world.camera.rotationY += (newX - oldCameraPoint.x) / 2.5;
				
				if (_world.camera.rotationX > 90) {
					_world.camera.rotationX = 90;
				}else if (_world.camera.rotationX < -90) {
					_world.camera.rotationX = -90;
				}
				
				oldCameraPoint.x = newX;
				oldCameraPoint.y = newY;
			}
		}
		
		//private
		private function onUpPressed():void {
			_world.camera.x += Math.sin(Math.PI / 180 * _world.camera.rotationY + Math.PI) * (upSpeed * -1);
			_world.camera.z += Math.cos(Math.PI / 180 * _world.camera.rotationY + Math.PI) * (upSpeed * -1);
		}
		
		private function onDownPressed():void {
			_world.camera.x -= Math.sin(Math.PI / 180 * _world.camera.rotationY + Math.PI) * (downSpeed * -1);
			_world.camera.z -= Math.cos(Math.PI / 180 * _world.camera.rotationY + Math.PI) * (downSpeed * -1);
		}
		
		private function onLeftPressed():void {
			_newRotation = recalibrate(_world.camera.rotationY);
			
			if (_newRotation < 90 || _newRotation > 270) {
				_world.camera.x -= (Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10) / 10) * leftSpeed;
			}else {
				_world.camera.x += (Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10) / 10) * leftSpeed;
			}
			
			if (_newRotation < 180) {
				_world.camera.z += ((10 - Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10)) / 10) * leftSpeed;
			}else {
				_world.camera.z -= ((10 - Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10)) / 10) * leftSpeed;
			}
		}
		
		private function onRightPressed():void {
			_newRotation = recalibrate(_world.camera.rotationY);
			
			if (_newRotation < 90 || _newRotation > 270) {
				_world.camera.x += (Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10) / 10) * rightSpeed;
			}else {
				_world.camera.x -= (Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10) / 10) * rightSpeed;
			}
			
			if (_newRotation < 180) {
				_world.camera.z -= ((10 - Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10)) / 10) * rightSpeed;
			}else {
				_world.camera.z += ((10 - Math.abs(Math.cos(Math.PI / 180 * _newRotation + Math.PI) * -10)) / 10) * rightSpeed;
			}
		}
		
		private function recalibrate(rotation:Number):Number {
			while (rotation >= 360) {
				rotation -= 360;
			}
			while (rotation < 0) {
				rotation += 360;
			}
			
			return rotation;
		}
	}
}