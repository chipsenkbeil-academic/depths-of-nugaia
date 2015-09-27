using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum RopeType
{
	Null,
	Line,
	Prefab
}

public enum BuildAxis
{
	PosX,
	NegX,
	PosY,
	NegY,
	PosZ,
	NegZ
}

public enum LongAxis
{
	X,
	Y,
	Z
}

public enum ConstraintPlane
{
	None,
	X_Y,
	Y_Z,
	Z_X
}

public class Rope : MonoBehaviour 
{
	public RopeType type = RopeType.Prefab;
	public GameObject ropeEnd = null;
	public bool FreezeBeg = true;
	public bool FreezeEnd = true;
	public ConstraintPlane constraintPlane = ConstraintPlane.None;
	public float ropeRadius = 0.25f;
	public int MinMaxTwist = 30;
	public float jointMass = 0.1f;
	public GameObject prefab = null;
	public float altRotation = 90;
	public float scale = 1.0f;
	
	private Vector3 jointHeading = Vector3.zero;
	private GameObject jointParent = null;
	private List<GameObject> jointConnections = new List<GameObject>();
	
	// Length of the rope as a floar. The floor of this number is the number of links to draw
	private float length = 0.0f;
	private float maxLength = -1.0f;
	private int linkCount = 10;
	
	// the rope won't ever get this short
	public float minLength = .5f;
	
	private float linkLength = 0.0f;
	
	void OnDrawGizmos()
	{

		Gizmos.color = new Color(0.3f,0.7f,0.5f,0.5f);
		try{
			Gizmos.DrawLine(transform.position, ropeEnd.transform.position);
			foreach(GameObject jc in jointConnections)
				Gizmos.DrawWireSphere(jc.transform.position, ropeRadius);
		
			for(int i = 1; i < jointConnections.Count; i++)
				Gizmos.DrawLine(jointConnections[i-1].transform.position, jointConnections[i].transform.position);
		}catch{ }
	}
	
	void OnDrawGizmosSelected()
	{
		//if(!Application.isPlaying && ropeEnd != null)
			//MakeDemo();
	}
	
	/* This was used for a demo scene for the rope component.
	void MakeDemo()
	{
		DestroyDemoRope();
		jointGap = Vector3.Distance(transform.position, ropeEnd.transform.position)/linkCount;
		jointHeading = (transform.position - ropeEnd.transform.position).normalized;
		PlaceJointConnections();
		PlacePrefabs();
	}
	
	GameObject demo;
	void DestroyDemoRope()
	{
		demo = GameObject.Find("TempRope");
		
		if(demo != null)
		{
			for(int i = 0; i < demo.transform.childCount; i++)
			{
				DestroyImmediate(demo.transform.GetChild(i).gameObject);
			}
			
			DestroyImmediate(demo);
		}
		jointConnections.Clear();
	}
	*/
	
	
	/*
	 * Returns the length of the rope (not the number of links).
	 */
	public float getLength() {
		return length;
	}
		
	/*
	 * Sets the length of the rope as a float. 
	 * The number of links will be the floor of this value.
	 * Use this to adjust the rope dynamically.
	 */
	public void setLength( float len ) {
		//if( len > minLength )
			length = len;
		
		// Calculate the length of a link
		if (linkLength > 0.0f) {
			var linkDiff = Mathf.CeilToInt(length / linkLength) - linkCount;
		    linkCount = Mathf.CeilToInt(length / linkLength);
			
			//if( jointConnections.Count != 0 )
				//RedrawRope();
			//PlaceJointConnections ();
			//PlacePrefabs();
		}
		//Debug.Log( "linkCount: " + len + " : " + linkCount );
	}
	
	public float getMaxLength() {
		return maxLength;
	}
	
	public void setMaxLength(float len) {
		maxLength = len;
	}
	
	/*
	 * Returns the length of one segment of rope as determined by the distance between joints.
	 */
	public float SegmentLength() {
		return linkLength;
	}
	
	void Start()
	{
		//linkLength = Vector3.Distance(transform.position, ropeEnd.transform.position)/linkCount	
		linkLength = 0.02f; //Vector3.Distance(transform.position, ropeEnd.transform.position)/linkCount;
		jointHeading = (transform.position - ropeEnd.transform.position).normalized;
		
		try{ gameObject.AddComponent<Rigidbody>(); gameObject.rigidbody.isKinematic = FreezeBeg; } catch { }
		try{ ropeEnd.AddComponent<Rigidbody>(); ropeEnd.rigidbody.isKinematic = FreezeEnd; } catch { }
		
		switch(constraintPlane)
		{
			case ConstraintPlane.X_Y:
				ropeEnd.rigidbody.constraints = RigidbodyConstraints.FreezePositionZ;
				rigidbody.constraints = RigidbodyConstraints.FreezePositionZ;	
				break;
			case ConstraintPlane.Y_Z:
				ropeEnd.rigidbody.constraints = RigidbodyConstraints.FreezePositionX;
				rigidbody.constraints = RigidbodyConstraints.FreezePositionX;
				break;
			case ConstraintPlane.Z_X:
				ropeEnd.rigidbody.constraints = RigidbodyConstraints.FreezePositionY;
				rigidbody.constraints = RigidbodyConstraints.FreezePositionY;	
				break;
			default:
				break;
		}
		
		setLength( 0.6f );
		
		PlaceJointConnections();
		PlacePrefabs();
	}
	
	void LateUpdate()
	{
		setLength( Vector3.Distance( transform.position, ropeEnd.transform.position )  );
		// Redraw the rope if the number of links has changed
		//RedrawRope();
		try{ 
			ConfigurableJoint cj = jointConnections[jointConnections.Count - 1].GetComponent<ConfigurableJoint>();
			cj.transform.position = transform.position;
			//cj.transform.localPosition = Vector3.zero;
			cj.rigidbody.constraints = RigidbodyConstraints.FreezePosition; 
		} catch{} 
		/*
		try{ 
			ConfigurableJoint cj = jointConnections[jointConnections.Count - 2].GetComponent<ConfigurableJoint>();
			cj.transform.position = Vector3.Lerp(jointConnections[jointConnections.Count - 3].transform.position, 
						jointConnections[jointConnections.Count - 1].transform.position, 0.5f);
			//cj.transform.localPosition = Vector3.zero;
			Debug.Log( transform.position );
			cj.rigidbody.constraints = RigidbodyConstraints.FreezePosition; 
		} catch{} 
		*/
	}
	
	
	
	void DestroyRope()
	{
		foreach(GameObject go in jointConnections)
			DestroyImmediate(go);
		
		DestroyImmediate(jointParent);
		
		jointConnections.Clear();
	}
	
	
	void RedrawRope() {
		if(prefab != null)
		{						
			if( linkCount >= jointConnections.Count ) {
				int i = linkCount;
				GameObject tJC = new GameObject("Connection_"+i.ToString());
				//tJC.transform.position = ropeEnd.transform.position + (jointHeading * linkLength * i);
				//tJC.transform.LookAt(transform.position);
				
				if( jointParent == null ) {
					tJC.transform.parent = GameObject.Find( "Rope" ).transform;
				}
				else {
					tJC.transform.parent = jointParent.transform;
				}
				tJC.AddComponent<Rigidbody>();
				//tJC.rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;
				tJC.rigidbody.angularDrag = 0;
				
				
				ConfigurableJoint tCJ = tJC.AddComponent<ConfigurableJoint>();
				tCJ.configuredInWorldSpace = true;
				try{
					tCJ.connectedBody = jointConnections[i-2].rigidbody; 
					jointConnections[i-1].GetComponent<ConfigurableJoint>().connectedBody = rigidbody;
					jointConnections.Insert( i-1, tJC );
				}
				catch{ 
					tCJ.connectedBody = ropeEnd.rigidbody;
				}
				
				//tCJ.swingAxis = new Vector3(1,1,1);
				tCJ.xMotion = ConfigurableJointMotion.Locked;
				tCJ.yMotion = ConfigurableJointMotion.Locked;
				tCJ.zMotion = ConfigurableJointMotion.Locked;
				
		
				tCJ.angularXMotion = ConfigurableJointMotion.Locked;
				tCJ.angularYMotion = ConfigurableJointMotion.Locked;
				tCJ.angularZMotion = ConfigurableJointMotion.Locked;
				
				JointDrive jd = new JointDrive() { mode = JointDriveMode.Position };
				tCJ.xDrive = jd;
				tCJ.yDrive = jd;
				tCJ.zDrive = jd; 
				
				
				Debug.Log( "insertion" );
				
				
				//NewJoint( i );
				//AddPrefab( i );
			}
				
			//Debug.Log( "jointConnections: " + jointConnections.Count );
			for(int i = 0; i < linkCount; i++)
			{

				//jointConnections[i].transform.LookAt( ropeEnd.transform.position );
				try{
					jointConnections[i].transform.position = Vector3.Lerp( ropeEnd.transform.position, transform.position, (float)i/(float)50.0f );
					jointConnections[i].transform.LookAt( jointConnections[i-1].transform.position );
				}
				catch {
				}
				//tPrefab.transform.position = jointConnections[i].transform.position + (jointHeading/2 * jointGap);
				//tPrefab.transform.parent = jointConnections[i].transform;
				//tPrefab.transform.parent.LookAt(transform.position);
				//tPrefab.transform.Rotate(0,0, altRotation * i);
				//tPrefab.transform.Rotate (new Vector3(0, 1, 0), 90.0f);
				//tPrefab.transform.localScale *= scale;
				
				//var renderer = (Renderer) tPrefab.GetComponentInChildren (typeof(Renderer));
				//linkLength = renderer.bounds.size.z;
				//var mesh = (Mesh) tPrefab.GetComponentInChildren (typeof(Mesh));
			}
			if( jointConnections.Count > 0 )
				jointConnections[0].transform.LookAt( transform.position );
		}
	}
	
	/*
	 * Puts the rope link prefab at each joint.
	 * Joints should already be placed.
	 * This determines how the rope will be rendered.
	 */
	void PlacePrefabs()
	{
		if(prefab != null)
		{		
			for(int i = 0; i < jointConnections.Count; i++)
			{
				AddPrefab( i );
			}
		}
	}
	
	// i is the position in the jointConnections list
	GameObject AddPrefab( int i ) {
		GameObject tPrefab = (GameObject)Instantiate((Object)prefab);
		
		tPrefab.transform.position = jointConnections[i].transform.position;// + (jointHeading/2 * jointGap);
		tPrefab.transform.parent = jointConnections[i].transform;
		tPrefab.transform.parent.LookAt(transform.position);
		tPrefab.transform.localRotation = Quaternion.identity;
		//tPrefab.transform.Rotate(0,0, altRotation * i);
		//tPrefab.transform.Rotate (new Vector3(0, 1, 0), 90.0f);
		//tPrefab.transform.localScale *= scale;
		
		if( i > 0 ) {
			RopeDrawer drawScript = (RopeDrawer) tPrefab.GetComponent( "RopeDrawer" );
			drawScript.source = jointConnections[i-1].transform;
		}
		
		//var mesh = (Mesh) tPrefab.GetComponentInChildren (typeof(Mesh));
		return tPrefab;
	}
					
	
	/*
	 * Build the rope structure. 
	 * This determines how the rope will interact with the world.
	 */
	void PlaceJointConnections()
	{	
		if(Application.isPlaying)
			jointParent = new GameObject("Rope");
		
		jointParent.transform.position = ropeEnd.transform.position;
		jointParent.transform.LookAt( Vector3.right ); //transform.position);
		
		for(int i = 0; i <= linkCount; i++)
		{
			NewJoint( i );
		}
		//try{ jointConnections[0].rigidbody.constraints = RigidbodyConstraints.FreezePosition; } catch{} 
		/*
		try{ 
			ConfigurableJoint cj = jointConnections[jointConnections.Count - 1].GetComponent<ConfigurableJoint>();
			cj.transform.position = transform.position;
			cj.transform.localPosition = Vector3.zero;
			Debug.Log( transform.position );
			cj.rigidbody.constraints = RigidbodyConstraints.FreezePosition; 
		} catch{} 
		try{ 
			ConfigurableJoint cj = jointConnections[jointConnections.Count - 2].GetComponent<ConfigurableJoint>();
			cj.transform.position = Vector3.zero;
			cj.transform.localPosition = Vector3.zero;
			Debug.Log( transform.position );
			cj.rigidbody.constraints = RigidbodyConstraints.FreezePosition; 
		} catch{} 
		*/
	}
	
	void NewJoint( int i ) {
		GameObject tJC;
		ConfigurableJoint tCJ;
		SoftJointLimit sjl;
		JointDrive jd;
		//CapsuleCollider cc;
		
		tJC = new GameObject("Connection_"+i.ToString());
		tJC.transform.position = ropeEnd.transform.position + (jointHeading * linkLength * i);
		tJC.transform.LookAt(transform.position);
		
		Debug.Log( i );
		if( jointParent == null ) {
			tJC.transform.parent = GameObject.Find( "Rope" ).transform;
		}
		else {
			tJC.transform.parent = jointParent.transform;
		}
		tJC.AddComponent<Rigidbody>();
		//tJC.rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;
		tJC.rigidbody.angularDrag = 0;
		
		switch(constraintPlane)
		{
			case ConstraintPlane.X_Y:
				tJC.rigidbody.constraints = RigidbodyConstraints.FreezePositionZ;
				break;
			case ConstraintPlane.Y_Z:
				tJC.rigidbody.constraints = RigidbodyConstraints.FreezePositionX;
				break;
			case ConstraintPlane.Z_X:
				tJC.rigidbody.constraints = RigidbodyConstraints.FreezePositionY;
				break;
			default:
				break;
		}
		
		/* Uncomment this to add capsule colliders to the links. 
		if(i<linkCount)
		{
			cc = tJC.AddComponent<CapsuleCollider>();
			cc.center = new Vector3(0,0,jointGap/2);
			cc.height = jointGap * 1.33f;
			cc.direction = 2;
			cc.radius = ropeRadius;
		}*/
		
		tCJ = tJC.AddComponent<ConfigurableJoint>();
		tCJ.configuredInWorldSpace = true;
		try{tCJ.connectedBody = jointConnections[i-1].rigidbody; }catch{ tCJ.connectedBody = ropeEnd.rigidbody; }
		
		//tCJ.swingAxis = new Vector3(1,1,1);
		tCJ.xMotion = ConfigurableJointMotion.Locked;
		tCJ.yMotion = ConfigurableJointMotion.Locked;
		tCJ.zMotion = ConfigurableJointMotion.Locked;
		

		tCJ.angularXMotion = ConfigurableJointMotion.Locked;
		tCJ.angularYMotion = ConfigurableJointMotion.Locked;
		tCJ.angularZMotion = ConfigurableJointMotion.Locked;
		/*
		tCJ.angularXMotion = ConfigurableJointMotion.Limited;
		tCJ.highAngularXLimit = new SoftJointLimit(){ limit = 360.0f };
		tCJ.lowAngularXLimit = new SoftJointLimit(){ limit = 0.0f };
		tCJ.angularYMotion = ConfigurableJointMotion.Limited;
		tCJ.angularYLimit = new SoftJointLimit(){ limit = 360.0f };
		tCJ.angularZMotion = ConfigurableJointMotion.Limited;
		tCJ.angularZLimit = new SoftJointLimit(){ limit = 360 }; //MinMaxTwist };
		*/
		
	
		
		jd = new JointDrive() { mode = JointDriveMode.Position };
		tCJ.xDrive = jd;
		tCJ.yDrive = jd;
		tCJ.zDrive = jd; 
		
		
		
		if(i == linkCount)
		{
			// first, update the old end
			/*
			if( i > 1 ) {
				ConfigurableJoint oldcj = (ConfigurableJoint) jointConnections[i-1].GetComponent( "ConfigurableJoint" );
				oldcj.angularXMotion = ConfigurableJointMotion.Locked;
				oldcj.angularYMotion = ConfigurableJointMotion.Locked;
				oldcj.angularZMotion = ConfigurableJointMotion.Locked;
				
				oldcj.connectedBody = jointConnections[i-2].rigidbody;
			}
			*/
			
			tCJ = tJC.AddComponent<ConfigurableJoint>();
				
			tCJ.connectedBody = rigidbody;
			tCJ.xMotion = ConfigurableJointMotion.Locked;
			tCJ.yMotion = ConfigurableJointMotion.Locked;
			tCJ.zMotion = ConfigurableJointMotion.Locked;
			
			tCJ.angularZMotion = ConfigurableJointMotion.Limited;
			sjl = new SoftJointLimit(){ limit = MinMaxTwist };
			tCJ.angularZLimit = sjl;
			
			jd = new JointDrive() { mode = JointDriveMode.Position };
			tCJ.xDrive = jd;
			tCJ.yDrive = jd;
			tCJ.zDrive = jd; 
			
			tCJ.projectionMode = JointProjectionMode.PositionOnly;
			tCJ.projectionDistance = 0.1f;	
		}
		
		
		
		/*
		tCJ.projectionMode = JointProjectionMode.PositionAndRotation;
		tCJ.projectionDistance = 0.1f;
		tCJ.projectionAngle = .1f;
		tCJ.targetRotation = Quaternion.LookRotation( Vector3.up);
		tCJ.angularXDrive = new JointDrive() { mode = JointDriveMode.Position };
		tCJ.angularYZDrive = new JointDrive() { mode = JointDriveMode.Position };
		*/
		jointConnections.Add( tJC );
	}
}
