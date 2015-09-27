private var heldBlock : Rigidbody;
private var holdingBlock : boolean;
private var offset : float;
private var findTarget : PlayerAttack;
private var hook : GrapplingHook;
private var pickUpTimer : float;
private var pickUpCooldown : float;
private var throwForce : float;
private var y : float;

function Start () {
	findTarget = GetComponent("PlayerAttack");
	hook = GetComponentInChildren(GrapplingHook);
	holdingBlock = false;
	offset = 1.0f;
	pickUpTimer = 0;
	pickUpCooldown = 0.2f;
}

function Update () {
	if (hook.hook_attached && holdingBlock)
		dropBlock();
	// Uses a short timer so that the player can't pick up
	// and drop objects too quickly
	if (pickUpTimer > 0)
		pickUpTimer -= Time.deltaTime;
	
	if (pickUpTimer < 0)
		pickUpTimer = 0;
		
	if(Input.GetKeyUp(KeyCode.E) && !Input.GetKeyUp(KeyCode.F)) {
		if (pickUpTimer > 0)
			return;
		pickUpTimer = pickUpCooldown;
		
		if (holdingBlock) 
			dropBlock();
		else {
			heldBlock = findTarget.getTarget();
			if (heldBlock == null)
				return;
			pickUpBlock();
		}
	}
}

// Removes the block as a child of the player
function dropBlock() {
	heldBlock.transform.parent = null;
	heldBlock.isKinematic = false;
	heldBlock = null;
	holdingBlock = false;
}

// Attaches the block to the player by making it a child
// of the player.
function pickUpBlock() {
	heldBlock.velocity = Vector3.zero;
	heldBlock.transform.parent = this.transform;
	heldBlock.isKinematic = true;
	heldBlock.transform.localPosition = Vector3(0, 0.6, offset);
	holdingBlock = true;
}

function isHoldingBlock() : boolean {
	return holdingBlock;
}
