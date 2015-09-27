#pragma strict

public var spawn : GameObject;
public static var currentSpawnPoint : GameObject;

function OnTriggerEnter() {
	currentSpawnPoint = spawn;
}