
// Require a character controller to be attached to the same game object
@script RequireComponent(CharacterController)

public var idleAnimation : AnimationClip;
public var walkAnimation : AnimationClip;
public var runAnimation : AnimationClip;
public var jumpPoseAnimation : AnimationClip;

public var walkMaxAnimationSpeed : float = 0.75;
public var trotMaxAnimationSpeed : float = 1.0;
public var runMaxAnimationSpeed : float = 1.0;
public var jumpAnimationSpeed : float = 1.15;
public var landAnimationSpeed : float = 1.0;

private var _animation : Animation;

enum CharacterState {
	Idle = 0,
	Walking = 1,
	Trotting = 2,
	Running = 3,
	Jumping = 4,
}

private var _characterState : CharacterState;
// The speed when walking
var walkSpeed = 6.0;
// after trotAfterSeconds of walking we trot with trotSpeed
var trotSpeed = 6.0;
// when pressing "Fire3" button (cmd) we start running
var runSpeed = 6.0;
// when true, friction is applied as normal
// whne false, the player moves as if on ice
var friction : boolean = true;

// speed when on the ice
var iceSpeed : float = 25f;
// set when the player initially enters the ice
var iceDir : Vector3;

var inAirControlAcceleration = 3.0;

// How high do we jump when pressing jump and letting go immediately
var jumpHeight = 0.5;

// The gravity for the character
var gravity = 20.0;
// The gravity in controlled descent mode
var speedSmoothing = 10.0;
var rotateSpeed = 500.0;
var trotAfterSeconds = 3.0;

var canJump = true;

private var jumpRepeatTime = 0.05;
private var jumpTimeout = 0.15;
private var groundedTimeout = 0.25;
private var pushPower : float = 2.0f;

// The camera doesnt start following the target immediately but waits for a split second to avoid too much waving around.
private var lockCameraTimer = 0.0;

// The current move direction in x-z
private var moveDirection = Vector3.zero;
// The current vertical speed
private var verticalSpeed = 0.0;
// The current x-z move speed
public var moveSpeed = 0.0;

// The last collision flags returned from controller.Move
private var collisionFlags : CollisionFlags; 

// Are we jumping? (Initiated with jump button and not grounded yet)
private var jumping = false;
private var jumpingReachedApex = false;

// Are we moving backwards (This locks the camera to not do a 180 degree spin)
private var movingBack = false;
// Is the user pressing any keys?
private var isMoving = false;
// When did the user start walking (Used for going into trot after a while)
private var walkTimeStart = 0.0;
// Last time the jump button was clicked down
private var lastJumpButtonTime = -10.0;
// Last time we performed a jump
private var lastJumpTime = -1.0;


// the height we jumped from (Used to determine for how long to apply extra jump power after jumping.)
private var lastJumpStartHeight = 0.0;


private var inAirVelocity = Vector3.zero;

private var lastGroundedTime = 0.0;


private var isControllable = true;

private var grapplingHook : GrapplingHook;
private var dying = false;

function Start() {
	grapplingHook = GameObject.Find("grapling_hook_option1").GetComponent(GrapplingHook);
}

function Awake ()
{
	moveDirection = transform.TransformDirection(Vector3.forward);
	
	_animation = GetComponent(Animation);
	if(!_animation)
		Debug.Log("The character you would like to control doesn't have animations. Moving her might look weird.");
	
	if(!idleAnimation) {
		_animation = null;
		Debug.Log("No idle animation found. Turning off animations.");
	}
	if(!walkAnimation) {
		_animation = null;
		Debug.Log("No walk animation found. Turning off animations.");
	}
	if(!runAnimation) {
		_animation = null;
		Debug.Log("No run animation found. Turning off animations.");
	}
	if(!jumpPoseAnimation && canJump) {
		_animation = null;
		Debug.Log("No jump animation found and the character has canJump enabled. Turning off animations.");
	}
	walkAnimation = runAnimation;
			
}

function UpdateSmoothedMovementDirection ()
{
	var cameraTransform = Camera.main.transform;
	var grounded = IsGrounded();
	
	var dir = Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
  	// calculate the desired velocity:
  	var vel = transform.TransformDirection(dir) * runSpeed;
	
	// <BERENGER>
	// Forward vector relative to the camera along the x-z plane	
	//var forward = Vector3.forward;
	var forward;
	if( grapplingHook.viewMode == ViewMode.side ) {
	forward = Vector3.right;
	}
	else {
	forward = Vector3.forward;
	}
	// </BERENGER>
	
	forward.y = 0;
	forward = forward.normalized;

	// Right vector relative to the camera
	// Always orthogonal to the forward vector
	var right = Vector3(forward.z, 0, -forward.x);

	// <BERENGER>
	var v;
	var h;
	if( grapplingHook.viewMode == ViewMode.side ) {
		v = Input.GetAxisRaw("Horizontal");
		h = 0f;
	}
	else {
		v = Input.GetAxisRaw("Vertical");
		h = Input.GetAxisRaw("Horizontal");
	}
	// </BERENGER>

	// Are we moving backwards or looking backwards
	if (v < -0.2)
		movingBack = true;
	else
		movingBack = false;
	
	var wasMoving = isMoving;
	// <BERENGER>
	isMoving = Mathf.Abs (v) > 0.1;
	// </BERENGER>
		
	// Target direction relative to the camera
	var targetDirection = h * right + v * forward;
	
	//print( targetDirection );
	// Grounded controls
	if (grounded)
	{
		// Lock camera for short period when transitioning moving & standing still
		lockCameraTimer += Time.deltaTime;
		if (isMoving != wasMoving)
			lockCameraTimer = 0.0;

		// We store speed and direction seperately,
		// so that when the character stands still we still have a valid forward direction
		// moveDirection is always normalized, and we only update it if there is user input.
		if (targetDirection != Vector3.zero)
		{
	// <BERENGER>
			moveDirection = targetDirection.normalized;
	// </BERENGER stuff removed>
		}
		
		// Smooth the speed based on the current target direction
		var curSmooth = speedSmoothing * Time.deltaTime;
		
		// Choose target speed
		//* We want to support analog input but make sure you cant walk faster diagonally than just forward or sideways
		var targetSpeed = Mathf.Min(targetDirection.magnitude, 1.0);
	
		_characterState = CharacterState.Idle;
		
		// Pick speed modifier

		targetSpeed *= runSpeed;
		_characterState = CharacterState.Running;
		
		moveSpeed = Mathf.Lerp(moveSpeed, targetSpeed, curSmooth);
		
		// Reset walk time start when we slow down
		if (moveSpeed < walkSpeed * 0.3)
			walkTimeStart = Time.time;
	}
	// In air controls
	else
	{
		if( friction ) {
			// Lock camera while in air
			if (jumping)
				lockCameraTimer = 0.0;
	
			if (isMoving) {
				inAirVelocity += 2 * targetDirection.normalized * Time.deltaTime * inAirControlAcceleration;
			}
		}
	}
	

		
}


function ApplyJumping ()
{
	// Prevent jumping too fast after each other
	if (lastJumpTime + jumpRepeatTime > Time.time)
		return;

	if (IsGrounded()) {
		// Jump
		// - Only when pressing the button down
		// - With a timeout so you can press the button slightly before landing		
		if (canJump && Time.time < lastJumpButtonTime + jumpTimeout) {
			verticalSpeed = CalculateJumpVerticalSpeed (jumpHeight);
			SendMessage("DidJump", SendMessageOptions.DontRequireReceiver);
		}
	}
}


function ApplyGravity ()
{
	if (isControllable)	// don't move player at all if not controllable.
	{
		// Apply gravity
		var jumpButton = Input.GetButton("Jump");
		
		
		// When we reach the apex of the jump we send out a message
		if (jumping && !jumpingReachedApex && verticalSpeed <= 0.0)
		{
			jumpingReachedApex = true;
			SendMessage("DidJumpReachApex", SendMessageOptions.DontRequireReceiver);
		}
	
		if (IsGrounded ())
			verticalSpeed = 0.0;
		else
			verticalSpeed -= gravity * Time.deltaTime;
	}
}

function ApplyGrapple (movementVector : Vector3) : Vector3 {
    return grapplingHook.Event_PlayerMovement(movementVector);
}

/* Most of the parameters are for calculating the movmement vector when swinging in a circle.
 */
function ApplyFriction ( player_anchor : Transform, hook_anchor : Transform, movementVector : Vector3 ) {
	if( !friction ) {
		moveSpeed = iceSpeed;
		var rope = player_anchor.GetComponentInChildren( typeof( Rope ) );
		if( !(grapplingHook.hook_attached && Vector3.Distance( player_anchor.position, hook_anchor.position ) > rope.getLength()) ) {
			moveDirection = iceDir;
		}
		else {
			// move tangent to the circle (configured with the hook_anchor at (0, 0))
			var x = (player_anchor.position - hook_anchor.parent.position).x;
			var y = (player_anchor.position - hook_anchor.parent.position).z;
			// radius
			var r = (player_anchor.position - hook_anchor.parent.position).magnitude;
			// prevent div by 0
			if( y == 0f )
				x += .001;
			// slope of the tangent at x
			var m = -1 * x / y;
			// have y, m, x, need b
			var b = y - m*x;
			// I want a point on this line that is in front - that is,
			// forward in the direction of the player's motion - of the player.
			// I have the line, so I just need an x value to determine the point.
			// I'll choose the x value so it's at the center of the circle or at a
			// right or left extreme.
			// The x value can be completely determined based on the quadrant of the player's position
			// and whether it should be clockwise or counterclockwise.
			// Here, I assume counterclockwise.
			var x2 : float;
			if( x < 0 ) {
				// q3
				if( y < 0 ) {
					x2 = 0;
				}
				// q2
				else {
					x2 = -r;
				}
			}
			else {
				// q4
				if( y < 0 ) {
					x2 = r;
				}
				// q1
				else {
					x2 = 0;
				}
			}
			// y at x2
			var y2 = m*(x2) + b;
			var player1 = Vector2( x, y );
			var player2 = Vector2( x2, y2 );
			// use this for clockwise rotation
			var pdiff = player1 - player2;
			var clockwise = Vector3( pdiff.x, 0, pdiff.y ).normalized;
			
			// the direction is based on the angle between the clockwise vector
			// if the angle is greater than 90 degrees than it's counterclockwise, so negate the clockwise vector
			if( Vector3.Angle( clockwise, moveDirection.normalized ) > 90 )
				iceDir = -1 * clockwise;
			else
				iceDir = clockwise;
			moveDirection = iceDir;
		}
	}
}

function CalculateJumpVerticalSpeed (targetJumpHeight : float)
{
	// From the jump height and gravity we deduce the upwards speed 
	// for the character to reach at the apex.
	return Mathf.Sqrt(2 * targetJumpHeight * gravity);
}

function DidJump ()
{
	jumping = true;
	jumpingReachedApex = false;
	lastJumpTime = Time.time;
	lastJumpStartHeight = transform.position.y;
	lastJumpButtonTime = -10;
	
	_characterState = CharacterState.Jumping;
}

function Update() {
	if (!dying)
		grapplingHook.canGrappleObjects(true);

	if (!isControllable && !dying)
	{
		// kill all inputs if not controllable.
		Input.ResetInputAxes();
	}

	if (Input.GetButtonDown ("Jump"))
	{
		lastJumpButtonTime = Time.time;
	}

	UpdateSmoothedMovementDirection();
	
	// Apply gravity
	// - extra power jump modifies gravity
	// - controlledDescent mode modifies gravity
	ApplyGravity ();

	// Apply jumping logic
	if( !dying )
		ApplyJumping ();
	
	var controller : CharacterController = GetComponent(CharacterController);
	var movement : Vector3;
	
	if (dying) {
		grapplingHook.canGrappleObjects(false);
		animation.CrossFade("die");
		movement = Vector3 (0, verticalSpeed, 0);
		ApplyFriction ( grapplingHook.player_anchor, grapplingHook.hook_anchor, movement );
		collisionFlags = controller.Move(movement);
		return;
	}
	
	// precalculate for friction
	movement = moveDirection * moveSpeed + Vector3 (0, verticalSpeed, 0) + inAirVelocity;
	ApplyFriction ( grapplingHook.player_anchor, grapplingHook.hook_anchor, movement  );
	
	// Calculate actual motion
	movement = moveDirection * moveSpeed + Vector3 (0, verticalSpeed, 0) + inAirVelocity;
	movement *= Time.deltaTime;
	movement = ApplyGrapple(movement);
	
	// Move the controller
	collisionFlags = controller.Move(movement);
	
	// ANIMATION sector
	if(_animation) {
		if(_characterState == CharacterState.Jumping) 
		{
			if(!jumpingReachedApex) {
				_animation[jumpPoseAnimation.name].speed = jumpAnimationSpeed;
				_animation[jumpPoseAnimation.name].wrapMode = WrapMode.ClampForever;
				_animation.CrossFade(jumpPoseAnimation.name);
			} else {
				_animation[jumpPoseAnimation.name].speed = -landAnimationSpeed;
				_animation[jumpPoseAnimation.name].wrapMode = WrapMode.ClampForever;
				_animation.CrossFade(jumpPoseAnimation.name);				
			}
		} 
		else 
		{
			if(controller.velocity.sqrMagnitude < 0.1) {
				_animation.CrossFade(idleAnimation.name);
			}
			else 
			{
				if(_characterState == CharacterState.Running) {
					_animation[runAnimation.name].speed = Mathf.Clamp(controller.velocity.magnitude, 0.0, runMaxAnimationSpeed);
					_animation.CrossFade(runAnimation.name);	
				}
				else if(_characterState == CharacterState.Trotting) {
					_animation[walkAnimation.name].speed = Mathf.Clamp(controller.velocity.magnitude, 0.0, trotMaxAnimationSpeed);
					_animation.CrossFade(walkAnimation.name);	
				}
				else if(_characterState == CharacterState.Walking) {
					_animation[walkAnimation.name].speed = Mathf.Clamp(controller.velocity.magnitude, 0.0, walkMaxAnimationSpeed);
					_animation.CrossFade(walkAnimation.name);	
				}
				
			}
		}
	}
	// ANIMATION sector
	
	// <BERENGER>
	transform.rotation = Quaternion.LookRotation(moveDirection);
	
	// Set rotation to the move direction
	/*if (IsGrounded())
	{
		
		transform.rotation = Quaternion.LookRotation(moveDirection);
			
	}	
	else
	{
		var xzMove = movement;
		xzMove.y = 0;
		if (xzMove.sqrMagnitude > 0.001)
		{
			transform.rotation = Quaternion.LookRotation(xzMove);
		}
	}	
	*/
	// </BERENGER>
	
	// We are in jump mode but just became grounded
	if (IsGrounded())
	{
		lastGroundedTime = Time.time;
		inAirVelocity = Vector3.zero;
		if (jumping)
		{
			jumping = false;
			SendMessage("DidLand", SendMessageOptions.DontRequireReceiver);
		}
	}
}

function OnControllerColliderHit (hit : ControllerColliderHit )
{
	if (dying)
		return;
	var body : Rigidbody = hit.collider.attachedRigidbody;
    // Checks if the body being pushed is a RigidBody
    if (body == null || body.isKinematic)
        return;
        
    // Ensures that objects don't get pushed below the ground
    if (hit.moveDirection.y < -0.3) 
        return;
    
    // Calculate push direction from move direction, 
    // we only push objects to the sides never up and down
    var pushDir : Vector3 = Vector3 (hit.moveDirection.x, 0, hit.moveDirection.z);

    // If you know how fast your character is trying to move,
    // then you can also multiply the push velocity by that.
    
    // Apply the push
	body.velocity = pushDir * pushPower;

    // if the player wasn't pushed then reset friction
    Debug.Log( hit.collider.name );
    if( hit.moveLength  < 0.1 || hit.collider.name.Contains( "oil_drum" ) ) {
    	Debug.Log( "motionless" );
    	friction = true;
    	moveSpeed = 0;
    }
}

function AddVerticalForce (force : float) {
	verticalSpeed += force;
}

function setVerticalSpeed(speed : float) {
	verticalSpeed = speed;
}

function GetSpeed () {
	return moveSpeed;
}

function IsJumping () {
	return jumping;
}

function IsGrounded () {
	return (collisionFlags & CollisionFlags.CollidedBelow) != 0;
}

function GetDirection () {
	return moveDirection;
}

function IsMovingBackwards () {
	return movingBack;
}

function GetLockCameraTimer () 
{
	return lockCameraTimer;
}

function IsMoving ()  : boolean
{
	// <BERENGER>
	return /*Mathf.Abs(Input.GetAxisRaw("Vertical")) +*/ Mathf.Abs(Input.GetAxisRaw("Horizontal")) > 0.5;
	// </BERENGER>
}

function OnTriggerEnter(other: Collider){
	if( other.material.name.Contains( "Ice" ) )
		// only change direction if friction is enabled to begin with
		if( friction ) {
			Debug.Log("hi");

			iceDir = moveDirection;
			friction = false;
		}
}

function OnTriggerStay(other: Collider){
	if( other.material.name.Contains( "Ice" ) )
		if( friction && moveSpeed > 0.1) {
			iceDir = moveDirection;
			friction = false;
		} 
}

function OnTriggerExit(other: Collider){
	if( other.material.name.Contains( "Ice" ) )
		friction = true;
}

function HasJumpReachedApex ()
{
	return jumpingReachedApex;
}

function IsGroundedWithTimeout ()
{
	return lastGroundedTime + groundedTimeout > Time.time;
}

function Reset ()
{
	gameObject.tag = "Player";
}

function KillPlayer(isDying : boolean) {
	dying = isDying;
}

