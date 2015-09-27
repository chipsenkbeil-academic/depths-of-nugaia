#pragma strict

public var maxHealth : int = 100;
public var currentHealth : int = 100;

public var healthBarLength : float;

function Start () {
	healthBarLength = Screen.width / 10;
}

function Update () {
	//Debug.Log("Player : " + transform.position);
}

// Draws the health bar
function OnGUI() {
	GUI.Box(new Rect(10, Screen.height - 30, healthBarLength, 20), currentHealth + "/" + maxHealth);
}

function AdjustCurrentHealth(adjustment : int) {
	currentHealth += adjustment;
	if (currentHealth < 0)
		currentHealth = 0;
		
	if (currentHealth > maxHealth)
		currentHealth = maxHealth;
		
	if (maxHealth < 1)
		maxHealth = 1;
		
	if (currentHealth == 0) {}
		//Subtract lives/game over
}