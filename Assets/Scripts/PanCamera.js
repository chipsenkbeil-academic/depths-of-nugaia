public var player : GameObject;
public var robot : GameObject;
public var dummyObjects : GameObject[];
public var offset : Vector3;
private static var hasPanned : boolean = false;
private var controller : ThirdPersonController;
private var ai : WaypointAI;
private var currObj : int;

function Start () {
	if (!hasPanned) {
		controller = player.GetComponent("ThirdPersonController");
		ai = robot.GetComponent("WaypointAI");
		controller.enabled = false;
		ai.enabled = false;
		currObj = 0;
	}
}

function Update () {
	if (!hasPanned) {
		var obj = dummyObjects[currObj];
		transform.position = Vector3.Lerp(transform.position, obj.transform.position + Vector3.up * 10, Time.deltaTime);
		if (currObj == dummyObjects.Length - 1) {
			hasPanned = true;
			controller.enabled = true;
			ai.enabled = true;
		}
		else if (Mathf.Abs(transform.position.y - obj.transform.position.y - 10) < 0.05) {
			++currObj;
		}
	}
	else {
		transform.position = player.transform.position + offset;
	}
}