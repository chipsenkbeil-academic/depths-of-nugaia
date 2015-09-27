@script RequireComponent(Rigidbody)
@script RequireComponent(MeshFilter)

public class Buoyancy extends MonoBehaviour {
	public var density : float = 0.2f;
	public var centerGravity : Vector3;
	public var bouncingOffset : float;
	
	private var centroid : Vector3;			// Centroid for the submerged volume
	private var polyLength : float;			// Approx square length of polyhedron
	private var I : Vector3;
	private var verts : Vector3[];
	private var tris : int[];
	private var triCount : int;
	private var vertCount : int;
	private var meshVolume : float;	
	private var layerMask : int = 1 << 4;	//Ignores water tags 
	
	private var drag : float;
	private var angularDrag : float;
	 
	function Start () {
		centerGravity = Vector3.zero;
		if (rigidbody == null)
			return;
		rigidbody.SetDensity(density);
		rigidbody.centerOfMass = centerGravity;
		
		polyLength = transform.localScale.magnitude * transform.localScale.magnitude;
		var mesh : Mesh = (GetComponent(MeshFilter)).mesh;
		verts = mesh.vertices;
		tris = mesh.triangles;
		triCount = tris.Length / 3;
		vertCount = verts.Length;
		meshVolume = ComputeVolume();
		
		I = rigidbody.mass / 12f * Vector3.one;
		
		drag = rigidbody.drag;
		angularDrag = rigidbody.angularDrag;
	}
	
	function Update(){
		SetCenterGravity(centerGravity);		//Possibly remove at some point
	}
	
	function FixedUpdate () {
		ComputeBuoyancy();
	}
	
	function SetCenterGravity(cg : Vector3){
		rigidbody.centerOfMass = cg;
	}
	
	//Buoyancy calculation
	
	// Returns the volume of a tetrahedron and updates the centroid accumulator.
	private function TetrahedronVolume(p : Vector3, v1 : Vector3, v2 : Vector3, v3: Vector3) : float {
		var a : Vector3 = v2 - v1;
		var b : Vector3 = v3 - v1;
		var c : Vector3 = p - v1;

		var volume : float = (1f / 6f) * Vector3.Dot(Vector3.Cross(b, a), c);
		centroid += 0.25f * volume * (v1 + v2 + v3 + p);
		return volume;
	}
	
	// Clips a partially submerged triangle and returns the volume of the resulting tetrahedrons and updates the centroid accumulator.
	// v's are vertices of a face and d's are depth of those vertices below the watersurface
	private function ClipTriangle(p : Vector3, v1 : Vector3, v2: Vector3, v3 : Vector3, 
		d1 : float, d2 : float, d3 : float) : float {
		
		var vc1 : Vector3 = v1 + (d1 / (d1 - d2)) * (v2 - v1);
		var vc2 : Vector3;
		var volume : float = 0;

		if (d1 < 0){
			if (d3 < 0){
				// Case B - a quadrilateral or two triangles.
				vc2 = v2 + (d2 / (d2 - d3)) * (v3 - v2);
				volume += TetrahedronVolume(p, vc1, vc2, v1);
				volume += TetrahedronVolume(p, vc2, v3, v1);
			} else {
				// Case A - a single triangle.
				vc2 = v1 + (d1 / (d1 - d3)) * (v3 - v1);
				volume += TetrahedronVolume(p, vc1, vc2, v1);
			}
		} else {
			if (d3 < 0) {
				// Case B
				vc2 = v1 + (d1 / (d1 - d3)) * (v3 - v1);
				volume += TetrahedronVolume(p, vc1, v2, v3);
				volume += TetrahedronVolume(p, vc1, v3, vc2);
			} else {
				// Case A
				vc2 = v2 + (d2 / (d2 - d3)) * (v3 - v2);
				volume += TetrahedronVolume(p, vc1, v2, vc2);
			}
		}

		return volume;
	}
	
	// Computes the submerged volume and center of buoyancy of a polyhedron 
	// with the water surface defined as a value on world y axis (was plane).
	private function SubmergedVolume() : float {
		// Transform the plane into the polyhedron frame.(We do 
		// opposite and transfrom each vertex into world space for simplicity)
		// Compute the vertex heights relative to the surface.
		var depth : float = -1e-6;
		var ds : float[] = new float[vertCount];
		
		// Compute the depth of each vertex.
		var numSubmerged : int = 0;
		var sampleVert : int = 0;
		var i : int = 0;
		for (i = 0; i < vertCount; ++i) {
			ds[i] = transform.TransformPoint(verts[i]).y - WaterPlane.getInstance().transform.position.y - bouncingOffset;
			if (ds[i] < depth) {
				++numSubmerged;
				sampleVert = i;
			}
		}
		
		// Return early if no vertices are submerged
		if (numSubmerged == 0) {
			centroid = Vector3.zero;
			return 0;
		}
		
		// Find a point on the water surface. Project a submerged point to
		// get improved accuracy. This point serves as the point of origin for
		// computing all the tetrahedron volumes. Since this point is on the
		// surface, all of the surface faces get zero volume tetrahedrons. This
		// way the surface polygon does not need to be considered.
		var p : Vector3 = verts[sampleVert];
		p.y = WaterPlane.getInstance().transform.position.y;
		
		// Initialize volume and centroid accumulators.
		var volume : float = 0;
		centroid = Vector3.zero;
		
		// Compute the contribution of each triangle.
		for (i = 0; i < triCount; ++i) {
			var i1 : int = tris[i * 3];
			var i2 : int = tris[i * 3 + 1];
			var i3 : int = tris[i * 3 + 2];
			
			var v1 : Vector3 = verts[i1];
			var d1 : float = ds[i1];
			
			var v2 : Vector3 = verts[i2];
			var d2 : float = ds[i2];
			
			var v3 : Vector3 = verts[i3];
			var d3 : float = ds[i3];
			
			if (d1 * d2 < 0) {
				// v1-v2 crosses the plane
				volume += ClipTriangle(p, v1, v2, v3, d1, d2, d3);
			} else if (d1 * d3 < 0) {
				// v1-v3 crosses the plane
				volume += ClipTriangle(p, v3, v1, v2, d3, d1, d2);
			} else if (d2 * d3 < 0) {
				// v2-v3 crosses the plane
				volume += ClipTriangle(p, v2, v3, v1, d2, d3, d1);
			} else if (d1 < 0 || d2 < 0 || d3 < 0){
				// fully submerged
				volume += TetrahedronVolume(p, v1, v2, v3);
			}
			
		}
		return volume;
	}
	
	//Compute volume of attached mesh
	private function ComputeVolume() : float {
		var volume : float = 0;
		var zero : Vector3 = Vector3.zero;
		centroid = Vector3.zero;

		// Compute the contribution of each triangle.
		for (var i : int = 0; i < triCount; ++i) {
			volume += TetrahedronVolume(zero, transform.TransformPoint(verts[tris[i*3]]), 
			transform.TransformPoint(verts[tris[i*3+1]]), transform.TransformPoint(verts[tris[i*3+2]]));
		}
	
		return volume;
	}
	
	function ComputeBuoyancy() {
		centroid = Vector3.zero;
		var gravity : float = Physics.gravity.magnitude;//FIX...
		
		var volume : float = SubmergedVolume() * meshVolume;
		if (volume > 0) {
			var buoyancyForce : Vector3 = (WaterPlane.getInstance().waterDensity * volume * gravity) * Vector3.up;
			
			//add this at the center of bouyancy for free buoyancy torque
			var amountInWater : float = Mathf.Clamp01(volume / meshVolume); 					//use this to change drag & angularDrag
			var submergedMass : float = rigidbody.mass * amountInWater;
			var rc : Vector3 = centroid + rigidbody.centerOfMass;
			var vc : Vector3 = rigidbody.GetPointVelocity(transform.TransformPoint(centroid));	//velocity at center of buoyancy
			var dragForce : Vector3 = (submergedMass * WaterPlane.getInstance().waterDrag) * (GetWaterCurrent() - vc);
			
			var totalForce : Vector3 = buoyancyForce + dragForce;
			rigidbody.AddForceAtPosition(totalForce, transform.TransformPoint(rc));	
			rigidbody.drag = Mathf.Lerp(drag, WaterPlane.getInstance().waterDrag, amountInWater);
			rigidbody.angularDrag = Mathf.Lerp(angularDrag, WaterPlane.getInstance().waterAngularDrag, amountInWater);
		}
	}
	
	function GetWaterCurrent() : Vector3 {
		if(!WaterPlane.getInstance().currents)
			return Vector3.zero;
			
		var origin : Vector3 = transform.TransformPoint(centroid);
		origin.y = WaterPlane.getInstance().transform.position.y + 1;
		var ray : Ray = new Ray(origin, -Vector3.up);
		
		var hit : RaycastHit;
    	if (!Physics.Raycast (ray, hit, 2, layerMask))
        	return Vector3.zero;
			
		var uv : Vector3 = hit.textureCoord;		
		var currentDir : Vector3 = Vector3.zero;
		var dir : Color = WaterPlane.getInstance().currents.GetPixelBilinear(uv.x, uv.y);
		var angle : float = dir.grayscale * 360;
		
		currentDir.x = Mathf.Cos(angle*Mathf.Deg2Rad);
		currentDir.z = Mathf.Sin(angle*Mathf.Deg2Rad);
			
		currentDir = currentDir.normalized;
		return currentDir * dir.a * WaterPlane.getInstance().currentStrength;
	}

}