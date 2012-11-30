package org.gametack.world {
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.WireframeCube;
	import away3d.primitives.WireframePlane;
	import away3d.primitives.WireframeSphere;
	import away3d.textures.BitmapTexture;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Object3D {
		//vars
		
		//constructor
		public function Object3D() {
			
		}
		
		//public
		public static function plane(width:Number, height:Number, segmentsWidth:uint = 1, segmentsHeight:uint = 1, material:BitmapData = null):Mesh {
			var texture:TextureMaterial;
			var plane:Mesh;
			
			if (material) {
				texture = new TextureMaterial(new BitmapTexture(material));
			}
			plane = new Mesh(new PlaneGeometry(width, height, segmentsWidth, segmentsHeight, true, false), texture);
			
			return plane;
		}
		public static function wirePlane(width:uint, height:uint, segmentsWidth:uint = 1, segmentsHeight:uint = 1):WireframePlane {
			return new WireframePlane(width, height, segmentsWidth, segmentsHeight, 0xFFFFFF, 1, "xz");
		}
		
		public static function sphere(radius:Number, segmentsWidth:uint, segmentsHeight:uint, material:BitmapData = null):Mesh {
			var texture:TextureMaterial;
			var sphere:Mesh;
			
			if (material) {
				texture = new TextureMaterial(new BitmapTexture(material));
			}
			
			sphere = new Mesh(new SphereGeometry(radius, segmentsWidth, segmentsHeight), texture);
			
			return sphere;
		}
		public static function wireSphere(radius:Number, segmentsWidth:uint, segmentsHeight:uint):WireframeSphere {
			return new WireframeSphere(radius, segmentsWidth, segmentsHeight);
		}
		
		public static function cube(width:Number, height:Number, depth:Number, segmentsWidth:uint = 1, segmentsHeight:uint = 1, segmentsDepth:uint = 1, material:BitmapData = null):Mesh {
			var texture:TextureMaterial;
			var cube:Mesh;
			
			if (material) {
				texture = new TextureMaterial(new BitmapTexture(material));
			}
			
			cube = new Mesh(new CubeGeometry(width, height, depth, segmentsWidth, segmentsHeight, segmentsDepth, false), texture);
			
			return cube;
		}
		public static function wireCube(width:Number, height:Number, depth:Number):WireframeCube {
			return new WireframeCube(width, height, depth);
		}
		
		public static function directionalLight(direction:Vector3D, color:uint = 0xFFFFFF, ambient:Number = 0.1, diffuse:Number = 0.5, specular:Number = 0.2):DirectionalLight {
			var light:DirectionalLight = new DirectionalLight();
			light.color = color;
			light.direction = direction;
			light.ambient = ambient;
			light.diffuse = diffuse;
			light.specular = specular;
			
			return light;
		}
		
		//private
	}
}