public var box : GameObject;

function OnTriggerEnter (hit : Collider) {
	if (hit.name.Equals("Player"))
		collapse();
}

private function collapse () {
	var body = box.rigidbody;
	
	//Makes the body moveable
	if (body.isKinematic)
		body.isKinematic = false;
	if (!body.useGravity)
		body.useGravity = true;
		
	//Removes the script
	Destroy(this);
}