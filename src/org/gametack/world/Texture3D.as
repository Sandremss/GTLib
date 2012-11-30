package org.gametack.world {
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Texture3D {
		//vars
		
		//constructor
		public function Texture3D() {
			
		}
		
		//public
		public static function reflect(mesh:Mesh, skyboxTexture:BitmapCubeTexture, alpha:Number = 1):Mesh {
			var material:ColorMaterial = new ColorMaterial();
			
			if (!skyboxTexture) {
				return mesh;
			}
			
			if (alpha < 0) {
				alpha = 0;
			}else if (alpha > 1) {
				if (alpha <= 100) {
					alpha = alpha / 100;
				}else {
					alpha = 1;
				}
			}
			
			material.addMethod(new EnvMapMethod(skyboxTexture, alpha));
			
			mesh.material = material;
			
			return mesh;
		}
		
		public static function addMaterial(mesh:Mesh, material:BitmapData):Mesh {
			return mesh;
		}
		
		public static function addLightMap(mesh:Mesh, material:BitmapData):Mesh {
			return mesh;
		}
		
		public static function addBumpMap(mesh:Mesh, material:BitmapData):Mesh {
			TextureMaterial(mesh.material).normalMap = new BitmapTexture(material);
			
			return mesh;
		}
		
		public static function addLight(mesh:Mesh, lights:Array):Mesh {
			mesh.material.lightPicker = new StaticLightPicker(lights);
			
			return mesh;
		}
		
		//private
	}
}