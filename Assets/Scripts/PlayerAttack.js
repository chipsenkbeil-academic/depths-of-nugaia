public var target : Rigidbody;
private var pickUp : PickUpBlock;
private var hook : GrapplingHook;
private var layerMask  = -1;
public var attackTimer : float;
public var attackRange : float;
public var cooldown : float;
public var attackDamage : int;

function Start () {
	attackTimer = 0;
	attackRange = 2;
	cooldown = 0.75f;		//0.75 second cooldown
	attackDamage = 1;
	pickUp = GetComponent("PickUpBlock");
	hook = GetComponentInChildren(GrapplingHook);	
}

function Update () {
	//Uses a timer so the player can't attack too quickly
	if (attackTimer > 0)
		attackTimer -= Time.deltaTime;
	
	if (attackTimer < 0)
		attackTimer = 0;
	
	if (!pickUp.isHoldingBlock() && !hook.hook_attached)
		target = findTarget();
	
	//Highlights the current target
	/*if (target != null) {
		if (target.renderer != null) {
			var highlight : HighlightTarget;
			highlight = target.renderer.GetComponent("HighlightTarget");
			if(highlight == null) 
				highlight = target.renderer.gameObject.AddComponent("HighlightTarget");
			highlight.Highlight();
		}
	}*/
	
	if(Input.GetKeyUp(KeyCode.F) && !Input.GetKeyUp(KeyCode.E)) {
		if (pickUp.isHoldingBlock())
			return;
		if(attackTimer == 0) { 
			PlayerAttack();
			attackTimer = cooldown;
		}
	}
}

function PlayerAttack() {
	// Throw in attack animation here possibly
	//animation.CrossFade("AttackAnimation");
	
	// If there is no target, return
	if (target == null)
		return;
	
	var health : EnemyHealth = target.GetComponent(EnemyHealth);
	
	// Checks if the target has the health script
	if (health == null)
		return;
	health.AdjustCurrentHealth(attackDamage * -1);
}

//Does 3 ray casts at different heights in the following order:
//High, middle, low. Will return the first one found.
function findTarget() : Rigidbody {
	var hit : RaycastHit;
	var origin = transform.position;
	
	//High
	origin.y += 0.5f;
	var ray = transform.forward;
	if (Physics.Raycast(origin, ray, hit, attackRange, layerMask))
		return hit.rigidbody;
		
	//Medium
	origin.y -= 0.5f;
	if (Physics.Raycast(origin, ray, hit, attackRange, layerMask))
		return hit.rigidbody;
		
	//Low
	origin.y -= 0.5f;
	if (Physics.Raycast(origin, ray, hit, attackRange, layerMask))
		return hit.rigidbody;	
	
	//No target found
	return null;
}

//Used by the PickUpBlock.js file so that both files
//are guaranteed to use the same target
public function getTarget() : Rigidbody {
	return target;
}