public var floor : GameObject;
public var wallToDestroy1 : GameObject;
public var wallToDestroy2 : GameObject;
public var wallToDestroy3 : GameObject;
public var wallToDestroy4 : GameObject;
public var stairs : GameObject;
private var fracture : SimpleFracture;

function Start () {
	fracture = floor.GetComponent("SimpleFracture");
}

function OnTriggerEnter(other : Collider) {
	if (other.name.Contains("Nyx"))
		BreakFloor();
}

function BreakFloor() {
	fracture.FractureAtPoint(floor.transform.position, Vector3.down * 100);
	Destroy(wallToDestroy1);
	Destroy(wallToDestroy2);
	Destroy(wallToDestroy3);
	Destroy(wallToDestroy4);
	stairs.rigidbody.isKinematic = false;
	stairs.rigidbody.useGravity = true;
	Destroy(this);
}