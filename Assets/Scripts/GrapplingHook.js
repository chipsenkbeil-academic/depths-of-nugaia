#pragma strict

// how fast does the hook hurdle towards its target?
var hook_speed : float;
// how far away can you grapple to?
var hook_range : float;
// how fast is the rope shortened?
var pull_speed : float = 10;
// how fast is the rope lengthened?
var slacken_speed : float = 10;
// how fast is the rope reeled in when not attached to something?
var retract_speed : float = 100;
// search for a target with a cone of rays with this number of degrees from the middle
var target_degrees : float = 0;


// is it attached to the player or not
public var hook_fired : boolean = false;
// is it attached to some grapplable surface?
public var hook_attached : boolean = false;
// is it in the process of being fired (initial movement from player to destination)
public var hook_firing : boolean = false;
// using while the hook is firing
private var hook_dest : RaycastHit;
private var hook_from : Vector3;
private var hook_to : Vector3;
private var hook_curr_dist : float;
private var hook_total_dist : float;

// saves the local position and rotation of hook when attached to the player
private var hook_transform : Transform;
private var hook_parent : Transform;
var hook : GameObject;


// where should the player end of the rope be at any given moment
var player_anchor : Transform;
private var prev_player_position : Vector3;
// where should the hook end of the rope be at any moment
var hook_anchor : Transform;


// the game object containing the Rope script
var rope_object : GameObject;
// rope script
private var rope : Rope;


var playerCamera : Camera;
var player : GameObject;
//var target_sphere : Transform;
// holds information from the latest call to FindTarget
var target : RaycastHit;
// was a target aquired in the last call to FindTarget? (don't use target if this is false)
var targetFound : boolean;

// a gameobject with the default pull script attached
var default_pull_object : GameObject;
private var default_pull_script : GrappleReciever;
private var canGrapple : boolean;

// Determines the axis perpendicular to the player's plane of interaction
public enum ViewMode {
	side,
	top
}
public var viewMode : ViewMode = ViewMode.side;

function Start () {
    rope = rope_object.GetComponent( "Rope" );
    if( rope == null )
    	Debug.Log( "Could not find the Rope in " + rope_object.name );
    Debug.Log( transform.position );
    default_pull_script = default_pull_object.GetComponent( "GrappleReciever" );
    hook_transform = GameObject().transform;
    hook_transform.localPosition = transform.localPosition;
    hook_transform.localRotation = transform.localRotation;
    canGrapple = true;
}

function Update () {
}

// use of FixedUpdate() required for dealing with rigidbodies
function FixedUpdate() {
	if( !hook_fired )
	    FindTarget();

	var lrenderers = GameObject.FindObjectsOfTypeAll( typeof( LineRenderer ));
	// attached to the player?
    if( hook_fired ) {
        hook_curr_dist += Time.deltaTime * hook_speed;
        // attached to a surface?
        if( hook_attached ) {
	        // ensure they player can't move past the rope's length
	        prev_player_position = player_anchor.root.position;
	        if( Input.GetButtonDown( "HookReleaseBtn" ) ) {
	        	hook_attached = false;
	        	ResetHook();
	        }
	        
	        // regrapple to a new target
		    if ( Input.GetButtonDown( "HookMouseBtn" ) ) {
		    	FindTarget();
		    	if( targetFound ) {
		    		hook_attached = false;
		    		ResetHook();
			        hook_fired = true;
			       	hook_firing = true;
			       	
			        hook_dest = target;
			        hook_from = hook.transform.position;
			        hook_to = hook_dest.point;
			        hook_curr_dist = 0;
			        hook_total_dist = (hook_to - hook_from).magnitude;
			        //target_sphere.position = target.point; //direction;
			        hook_parent = hook.transform.parent;
			        hook.transform.parent = null;
			        rope.enabled = true;
					hook.transform.LookAt( player.transform.position );
					
					//var rope = GameObject.Find( "Rope" );
					//var lrenderers : Component[] = rope.GetComponentsInChildren(;
					Debug.Log( lrenderers.Length );
					for( var lr : LineRenderer in lrenderers ) {
						lr.enabled = true;
						//lr.gameObject.enabled = false;
					}
				}
			}
	        
            // The hook control button makes the rope become shorter
		    if ( Input.GetAxisRaw( "Vertical" ) > 0 ) {
		    	PullRope();
	        } else if ( Input.GetAxisRaw( "Vertical" ) < 0 ) {
	            SlackenRope();
	        }
		}
		// not on a surface or the player
	    else {
	    	// initial movement from player to dest
	    	if( hook_firing ) {
		    	// has the hook reached it's destination
				if( hook_curr_dist > hook_total_dist ) {
				    hook_attached = true;
				    hook_firing = false;
				    
				    hook.transform.parent = target.transform;
				    hook.transform.localPosition = target.transform.InverseTransformPoint( hook_to );
				    //hook.transform.position = hook_to;
				    prev_player_position = player_anchor.root.position;
				    //rope.setLength( (hook_anchor.position - player_anchor.position).magnitude );
                	rope.setMaxLength( (hook_anchor.position - player_anchor.position).magnitude );
				}
				// the hook's still traveling
				else {
				    hook.transform.position = Vector3.Lerp( hook_from, hook_to, hook_curr_dist/hook_total_dist );
				    Debug.DrawLine( player_anchor.position, hook_anchor.position, Color.green );
				}
			}
			// unattached
			else {
				//RetractRope();
			}
        }
    }
    // attached to the player
    else {
    	// only let the hook fire if there's a target
	    if( Input.GetButtonDown( "HookMouseBtn" ) && targetFound && canGrapple) {
	        hook_fired = true;
	       	hook_firing = true;
	       	
	        hook_dest = target;
	        hook_from = hook.transform.position;
	        hook_to = hook_dest.point;
	        hook_curr_dist = 0;
	        hook_total_dist = (hook_to - hook_from).magnitude;
	        //target_sphere.position = target.point; //direction;
	        hook_parent = hook.transform.parent;
	        hook.transform.parent = null;
	        rope.enabled = true;
			hook.transform.LookAt( player.transform.position );
			
			//var rope = GameObject.Find( "Rope" );
			//var lrenderers : Component[] = rope.GetComponentsInChildren(;
			Debug.Log( lrenderers.Length );
			for( var lr : LineRenderer in lrenderers ) {
				lr.enabled = true;
				//lr.gameObject.enabled = false;
			}
	    }
	}
}


/*
 * High level view of everything that happens when the rope is shortened.
 * Shortening happens based on the timeDelta between calls and pull_speed.
 */
private function PullRope() {
	// adjust the rope itself so that it renders correctly
	var length_diff = Time.deltaTime * pull_speed;
	rope.setLength( rope.getLength() - length_diff );
	rope.setMaxLength( rope.getLength() - length_diff );
	/*if( rope.getLength() < 1 ) {
		ResetHook();
	}*/
}

/*
 * Slackens the rope by adding more length to it.
 */
private function SlackenRope() {    
    var length_diff = Time.deltaTime * slacken_speed;

    // Exit early if trying to extend rope beyond range
    if (rope.getMaxLength() + length_diff > hook_range)
        return; 
    
    // Adjust the rope itself so that it renders correctly
	rope.setLength( rope.getLength() + length_diff );
	rope.setMaxLength( rope.getLength() + length_diff );
	
}


/*
 * Reel in the hook.
 */
private function RetractRope() {
	// adjust the rope itself so that it renders correctly
	var length_diff = Time.deltaTime * retract_speed;
	rope.setLength( rope.getLength() - length_diff );
	rope.setMaxLength( rope.getLength() - length_diff );
	if( rope.getLength() < 1 ) {
		ResetHook();
	}
}



/*
 * Puts the grappling hook back onto the player.
 */
public function ResetHook() {
	hook_fired = false;
	hook_firing = false;
	hook_attached = false;
	
	rope.enabled = false;
	
	var controller : ThirdPersonController = player.GetComponent("ThirdPersonController");
	controller.setVerticalSpeed(0.0f);
	
	//hook.rigidbody.isKinematic = true;
	if( hook_parent != null )
		hook.transform.parent = hook_parent;
	if( hook_transform != null ) {
		hook.transform.localPosition = hook_transform.localPosition;
		//hook.transform.localRotation = hook_transform.localRotation;
	}
	hook.transform.localScale = Vector3.one;
	
	//var rope = GameObject.Find( "Rope" );
	var lrenderers = GameObject.FindObjectsOfTypeAll( typeof( LineRenderer ));
	//var lrenderers : Component[] = rope.GetComponentsInChildren(;
	Debug.Log( lrenderers.Length );
	for( var lr : LineRenderer in lrenderers ) {
		lr.enabled = false;
		//lr.gameObject.enabled = false;
	}
}


/*
 * This updates the grappling hook's target based on aim_x and aim_y. 
 * The result should be that target is the RaycastHit containing information about
 * the target of a grappling hook fire. 
 * If target is null then no target could be aquired.
 */
function FindTarget() {
    // calculate the direction the player is aiming on a (0, 0) to (1, 1) rectangle
    var x : float = Input.mousePosition.x / Screen.width;
    var y : float = Input.mousePosition.y / Screen.height;
    
    var ray : Ray;
    var playerPlane : Plane;
    var raydist : float;
    var direction : Vector3;
    
    // first, calculate the base direction
    ray = playerCamera.ViewportPointToRay( Vector3(x, y, 0) );
    switch( viewMode ) {
    	case ViewMode.side:
		    playerPlane = Plane( playerCamera.transform.forward , player_anchor.position );
    		break;
    	case ViewMode.top:
		    playerPlane = Plane( Vector3( 0f, -1.0f, 0f ), player_anchor.position );
    		break;
    }
    playerPlane.Raycast( ray, raydist );
    // a point, not direction vector beginning at 0
    direction = playerCamera.ViewportToWorldPoint( Vector3(x, y, raydist) );
    direction = playerCamera.ViewportToWorldPoint( Vector3( x, y, raydist - playerPlane.GetDistanceToPoint( direction ) ) );
    switch( viewMode ) {
    	case ViewMode.side:
		    direction.z = player_anchor.position.z;
    		break;
    	case ViewMode.top:
		    direction.y = player_anchor.position.y;
    		break;
    }
    Vector3.Normalize(direction);
    
    // used for calculation only
    var hi = new GameObject();
    var trans : Transform = hi.transform;
    
    // try to find a target by casting multiple rays starting from the middle and radiating to target_degrees
    var baseAngle : int = 0;
    for( baseAngle = 0; baseAngle <= target_degrees; baseAngle += 2 ) {
    	var angle : float = baseAngle;
    	for( var i : int = 0; i < 2; i++ ) {
    		trans.position = direction; 
		    switch( viewMode ) {
		    	case ViewMode.side:
		    		trans.RotateAround( player_anchor.position, Vector3( 0, 0, 1 ), angle );
		    		break;
		    	case ViewMode.top:
		    		//Debug.Log( "top" );
		    		trans.RotateAround( player_anchor.position, Vector3( 0, -1, 0 ), angle );
		    		break;
		    }
		    //Debug.Log( "angle: " + angle + "    direction: " + direction + "     transpos: " + trans.position );
    		direction = trans.position;
    	
		    var hit : RaycastHit;
		    var playerMask : int = 1 << 9;
		    playerMask = ~playerMask;
		    // find a target within grappling range
		    targetFound = Physics.Raycast( player_anchor.position, Vector3.Normalize(direction - player_anchor.position), hit, hook_range, playerMask );
		    switch( viewMode ) {
		    	case ViewMode.side:
		    		hit.point.z = player_anchor.position.z;
		    		break;
		    	case ViewMode.top:
		    		hit.point.y = player_anchor.position.y;
		    		break;
		    }
		    
		    Debug.DrawLine( player_anchor.position, direction, Color.red );
		    Debug.DrawRay( player_anchor.position, hook_range * Vector3.Normalize(direction - player_anchor.position), Color.blue );
		    
			if( targetFound && hit.collider.GetComponent( "GrappleReciever" ) == null )
				targetFound = false;
		    if( targetFound ) {
		    	target = hit;
		    	break;
		    }
		    angle *= -1;
		}
		//if( targetFound )
		//	break;
    }
    GameObject.Destroy( hi );

    
    // just for debugging, possibly put target indicator information here
    //target_sphere.position = hit.point;
    
}



/**
 * Executed when the player moves.
 *
 * movementVector: The movement vector of the player BEFORE being applied.
 */
public function Event_PlayerMovement(movementVector : Vector3) : Vector3 {

    if (hook_attached && rope.getMaxLength() != -1.0f) {
    
        // Add force if player is attempting to swing
/*        if ( Input.GetButton( "Horizontal" ) ) {
            var dir = Input.GetAxisRaw( "Horizontal" );
            var swingForce : Vector3 = Vector3(0, 0, 0);
            if (dir > 0) {
                swingForce = Vector3(-0.3f, 0.0f, 0.0f);
            } else if (dir < 0) {
                swingForce = Vector3(0.3f, 0.0f, 0.0f);
            }
            movementVector += swingForce;
        }
*/    

		//Debug.Log( "adjusting movment" );
		var reciever : GrappleReciever = target.collider.GetComponent( "GrappleReciever" );
		if( reciever == null ) {
			//reciever = default_pull_script;
			ResetHook();
			return;
		}
		movementVector = reciever.PullRope( player, target, player_anchor, hook_anchor, movementVector, rope, viewMode );
		
    }
    return movementVector;
}

public function canGrappleObjects(grappable : boolean) {
	canGrapple = grappable;
}