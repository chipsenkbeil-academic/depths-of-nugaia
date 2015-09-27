public var control : Texture;
public var xoffset : float = 0;
public var yoffset : float = 0;
public var size : float = 1;
private var width : float;
private var height : float;
private var display : boolean;

function Start() {
	width = Screen.width;
	height = Screen.height;
}

function OnTriggerEnter(other : Collider) {
	if (other.name.Contains("Nyx")) {
		display = true;
	}
}

function OnGUI() {
	if (display) {
		GUI.Label(new Rect(20 + xoffset, (height * 0.85) + yoffset, 
			150 * size, 150 * size), control);
	}
}

function OnTriggerExit(other : Collider) {
	if (other.name.Contains("Nyx")) {
		Destroy(this);
	}
}