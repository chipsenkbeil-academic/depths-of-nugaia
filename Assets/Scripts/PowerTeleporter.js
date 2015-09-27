public var teleporter : GameObject;
public var generators : GameObject[];
private var isActivated : boolean;
private var lightsTurnedOn : boolean;
private var generator1On : Generator;
private var generator2On : Generator;
private var generator3On : Generator;

function Start() {
	isActivated = false;
	lightsTurnedOn = false;
	generator1On = generators[0].GetComponentInChildren(Generator);
	generator2On = generators[1].GetComponentInChildren(Generator);	
	generator3On = generators[2].GetComponentInChildren(Generator);	
}

function Update() {
	if (generator1On.isActivated() && generator2On.isActivated() && generator3On.isActivated())
		isActivated = true;
	if (isActivated && !lightsTurnedOn)
		activateLights();
}

function OnTriggerEnter(other : Collider) {
	if (other.name.Contains("Nyx") && isActivated) {
		Application.LoadLevel("sewer_level3");
	}
}

function activateLights() {
	teleporter.transform.Find("light1").active = true;
    teleporter.transform.Find("light2").active = true;
	lightsTurnedOn = true;
}