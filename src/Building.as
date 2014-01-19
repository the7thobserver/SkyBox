package
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	
	public class Building extends Mesh
	{
		public function Building() 
		{
			// use super constructor
			super(new CubeGeometry(50,100,50));
			material = new ColorMaterial(Math.random() * 0xFFFFFF);
			// offset height
			//y = -50;
		}
		
		
	}
}