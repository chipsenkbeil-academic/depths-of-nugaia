function OnTriggerStay (other : Collider) {
	if (other.transform.parent == null && other.name.Contains("Nyx"))
		other.transform.parent = gameObject.transform;
}

function OnTriggerExit (other : Collider) {
	if (other.name.Contains("Nyx"))
		other.transform.parent = null;
}