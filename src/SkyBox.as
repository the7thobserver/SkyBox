// Tutorial this is based off of
// https://www.youtube.com/watch?v=VSiI4FYYuoc

// Cube rotation and stuff
// http://tv.adobe.com/watch/adc-presents/alternativa-3d-platform-engine-and-flash/
package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.system.System;
	
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	
	public class SkyBox extends Sprite
	{
		private var view:View3D;
		private var cube:Mesh;
		private var material:TextureMaterial;
		private var light:PointLight;
		
		private var lastX:int;
		private var lastY:int;
		private var isDragging:Boolean = false;

		private var button:Mesh;		
		
		[Embed(source="../dk.jpg")]
		private var dk:Class;
		
		public function SkyBox()
		{
			// Set up view
			setupView();
			// set up a light
			initLight();
			// texturing
			initMaterial();
			// set up the cube
			createCube();	
			// build "city"
			//buildCity();
			// set up the floor
			initFloor();
			// Start the update loop		
			addEventListener(Event.ENTER_FRAME, update);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			trace("done");
		}
		
		private function mouseDown (event:MouseEvent):void{
			trace("down");
			isDragging = true;
			lastX = event.stageX;
			lastY = event.stageY;
		}
		
		private function mouseUp (event:Event):void{
			trace("up");
			isDragging = false;
		}
		
		private function mouseMove (event:MouseEvent):void{
			if(!isDragging)
			{
				trace("Is not dragging");
				return;
			}
			
			var dx:int = lastX - event.stageX;
			var dy:int = lastY - event.stageY;
			
			lastX = event.stageX;
			lastY = event.stageY;
			
			trace(dx * Math.PI/180);
			
			// cube.rotationZ += dx * Math.PI/180;
			// cube.rotationY += dy * Math.PI/180;
			
			var matrix:Matrix3D = cube.transform;
			
			matrix.appendRotation(dx, new Vector3D(0,0,1));
			matrix.appendRotation(-dy, new Vector3D(1,0,0));
			
			cube.transform = matrix;
		}
		
		private function update(e:Event)
		{
			// rotate cube
			// cube.rotationY += 2;
			// Render the view
			view.render();
		}
		
		private function setupView()
		{
			view = new View3D();
			view.backgroundColor = 000000;
			// Position camera
			view.camera.position = new Vector3D(0,0,-700);
			view.camera.lookAt(new Vector3D());
			// Add view to stage
			addChild(view);
		}
		
		private function createCube()
		{
			var cubeGeo:CubeGeometry = new CubeGeometry();
			// all sides of the cube are the same texture face instead of cut up into 6 parts
			cubeGeo.tile6 = false;			
			cube = new Mesh(cubeGeo);
			cube.material = material;
			view.scene.addChild((cube));
		}
		
		private function initMaterial()
		{
			var materialBitmap:BitmapTexture = new BitmapTexture(Cast.bitmapData(dk));
			material = new TextureMaterial(materialBitmap);
			material.specular = 0;
			// get affected by the light
			
			material.lightPicker = new StaticLightPicker([ light ]);
		}
		
		private function initFloor()
		{
			// Make a new plane
			var floor:Mesh = new Mesh(new PlaneGeometry(2000, 2000));
			floor.y = -50;
			floor.material = new ColorMaterial(0x444444);
			view.scene.addChild(floor);
		}
		
		private function initLight()
		{
			light = new PointLight();
			light.position = new Vector3D(400,300,-200);
			light.color = 0xFFCCCC;
			light.ambient = 0.25;
			view.scene.addChild(light);
		}
		
		private function buildCity()
		{
			var citySize:int = 1800;
			var roadSize:int = 50;
			var buildingSize:int = 100;
			// loop x note 0 is at the center
			for(var cityX:int = -citySize/2; cityX < citySize/2; cityX += roadSize + buildingSize)
			{
				for(var cityY:int = -citySize/2; cityY < citySize /2; cityY += roadSize + buildingSize) 
				{
					// make building and position it accordingly
					var building:Building = new Building();
					building.x = cityX;
					building.y = cityY;
					view.scene.addChild(building);
				}
			}
		}
	}
}