package org.gametack.world {
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class BaseWorld extends Sprite {
		//vars
		public var lights:Array = new Array();
		
		private var _skybox:SkyBox;
		private var _skyboxTexture:BitmapCubeTexture;
		
		private var _view:View3D;
		
		//constructor
		public function BaseWorld() {
			
		}
		
		//public
		public function init():void {
			_view = new View3D();
			
			_view.contextMenu = null;
		}
		
		/**
		 * Creates a new skybox. You may re-run this function to change the current skybox.
		 * 
		 * @param texture A vector of BitmapData defining the skybox's image
		 * @param positions A vector of uints defining where each piece if the skybox is (in the texture parameter)
		 * positions are as follows:
			 * positive X
			 * negative X
			 * positive Y
			 * negative Y
			 * positive Z
			 * negative Z
		 */ 
		public function skybox(texture:Vector.<BitmapData>, positions:Vector.<uint>):void {
			if (_view.scene.contains(_skybox)) {
				_view.scene.addChild(_skybox);
			}
			
			_skyboxTexture = new BitmapCubeTexture(texture[positions[0]], texture[positions[1]], texture[positions[2]], texture[positions[3]], texture[positions[4]], texture[positions[5]]);
			
			_skybox = new SkyBox(_skyboxTexture);
			
			_view.scene.addChild(_skybox);
		}
		
		public function get skyboxTexture():BitmapCubeTexture {
			return _skyboxTexture;
		}
		
		public function get view():View3D {
			return _view;
		}
		public function get scene():Scene3D {
			return _view.scene;
		}
		public function get camera():Camera3D {
			return _view.camera;
		}
		
		//private
	}
}