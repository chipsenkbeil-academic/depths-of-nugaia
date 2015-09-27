public var objectToBreak : GameObject;
private var fracture : SimpleFracture;

function Start () {
	fracture = objectToBreak.GetComponent("SimpleFracture");
}

function OnTriggerEnter(other : Collider) {
	if (other.name.Contains("Nyx"))
		BreakObject();
}

function BreakObject() {
	fracture.FractureAtPoint(objectToBreak.transform.position, Vector3.down * 100);
}