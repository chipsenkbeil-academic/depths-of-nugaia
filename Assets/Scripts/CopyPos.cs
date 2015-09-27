using UnityEngine;
using System.Collections;

[AddComponentMenu("Utilities/CopyPos")]
public class CopyPos : MonoBehaviour 
{
	public Transform target;
	public Vector3 offset;
	private Transform t;

	// Use this for initialization
	void Start () 
	{
		t = transform;
	}
	
	// Update is called once per frame
	void Update () 
	{
		t.position = target.position + offset;
	}
}
