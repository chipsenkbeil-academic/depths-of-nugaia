public var player : Transform;
public var respawnPoint : GameObject;
public var isEnabled : boolean;
private var hook : GrapplingHook;
private var controller : ThirdPersonController;
private var dying : boolean;
private var deathTime : float;

function Start() {
	isEnabled = true;
	dying = false;
	hook = player.GetComponentInChildren(GrapplingHook);
	controller = player.GetComponent("ThirdPersonController");
	deathTime = 2.2;
}

function OnTriggerEnter(other : Collider) {
	if (other.name.Contains("Nyx") && isEnabled && !dying) {
		dying = true;
		controller.KillPlayer(dying);
		KillPlayer();
	}
}

function KillPlayer() {
	hook.ResetHook();
	yield WaitForSeconds(deathTime);
	Respawn();
	dying = false;
	controller.KillPlayer(dying);
}

function Respawn() {
	if (Application.loadedLevelName.Equals("sewer_level2")) {
		Application.LoadLevel("sewer_level2");
	}
	
	if (Application.loadedLevelName.Equals("sewer_level3"))
		respawnPoint = SetSpawn.currentSpawnPoint;
		
	if (respawnPoint != null) {
		player.position = respawnPoint.transform.position + Vector3.up * 0.5;
	}
	
	controller.moveSpeed = 0f;
	controller.friction = true;
}

function isDying() {
	return dying;
}