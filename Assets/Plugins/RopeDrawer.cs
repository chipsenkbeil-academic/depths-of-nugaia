using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class RopeDrawer : MonoBehaviour {

	public Transform source;
	public GameObject prefab = null;
	
	private LineRenderer lrender = null;
	private int linkCount;
	private int prevLinkCount;
	//private List<GameObject> links = new List<GameObject>();
	
	
	void OnDrawGizmos()
	{
		Gizmos.color = new Color(0.3f,0.7f,0.5f,0.5f);
		try{
			Gizmos.DrawWireSphere(transform.position, 0.03f);
			Gizmos.DrawWireSphere(source.position, 0.03f);
		}catch{ }
	}

	
	// Use this for initialization
	void Start () {
		// just to calculate linkLength
		GameObject tPrefab = (GameObject)Instantiate((Object)prefab);
		//prefab = gameObject.AddComponent<LineRenderer>();
		lrender = tPrefab.GetComponent<LineRenderer>();
		lrender.SetVertexCount(2);
		//Destroy( tPrefab );
	}
	
	// Update is called once per frame
	void LateUpdate () {
		if( lrender == null || source == null )
			return; 
			
		lrender.SetPosition( 0, source.position );
		lrender.SetPosition( 1, transform.position );
		//Debug.Log( "set position " );
		
		/*
		linkCount = 1; //(int) (Vector3.Distance( source.position, transform.position )/linkLength);
		
		Debug.Log( "updating" );
			
		Quaternion rotation = Quaternion.identity;
		// draw all the prefabs from source to here
		for(int i = 0; i < linkCount; i++)
		{
			links[i].transform.position = source.position; //Vector3.Lerp( source.position, transform.position, (float)i/(float)linkCount );
			if( i == 0 ) {
				links[i].transform.LookAt( transform.position );
				rotation = links[i].transform.rotation;
			}
			else {
				links[i].transform.rotation = rotation;
			}
		}
		*/
		
		prevLinkCount = linkCount;
	}
}
