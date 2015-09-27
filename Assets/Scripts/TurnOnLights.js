#pragma strict
public var light1 : Light;
public var light2 : Light;

function OnTriggerEnter(other : Collider) {
	if (other.name.Contains("Nyx"))
		TurnOnLights();
}

function TurnOnLights() {
	if (light1 != null)
		light1.enabled = true;
	if (light2 != null)
		light2.enabled = true;
}
