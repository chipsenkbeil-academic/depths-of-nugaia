#pragma strict

//Add this script to any object that you want to be destroyable.

public var maxHealth : int = 3;
public var currentHealth : int = 3;

function Start () {

}

function Update () {

}

function AdjustCurrentHealth(adjustment : int) {
	currentHealth += adjustment;
	if (currentHealth < 0)
		currentHealth = 0;
		
	if (currentHealth > maxHealth)
		currentHealth = maxHealth;
		
	if (maxHealth < 1)
		maxHealth = 1;
		
	if (currentHealth == 0)
		Destroy(gameObject);
}