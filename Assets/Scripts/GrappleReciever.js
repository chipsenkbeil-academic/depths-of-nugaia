#pragma strict

public enum Movable {
	player,
	object
}

var moves : Movable = Movable.player;


/*
 * This should be called when the grappling hook's rope is shortened.
 * It applies all forces necessary when a rope attached to this object
 * is pulled. In this case, a force will be applied to the player so he
 * moves toward whatever this script is attached.
 * 
 * @param player The player object
 */
public function PullRope( player : GameObject, hit : RaycastHit, player_anchor : Transform, hook_anchor : Transform, movementVector : Vector3, rope : Rope, viewMode : ViewMode ) : Vector3 {
	var baseVec : Vector3;
	var y : float;
	switch( moves ) {
		case Movable.player:
			//var thirdPersController : ThirdPersonController = player.GetComponent( "ThirdPersonController" );
	        if( Vector3.Distance( player_anchor.position + movementVector, hook_anchor.position ) >= rope.getMaxLength() ) {
	            // from where the rope is attached to where the player would be 
	            baseVec = (player_anchor.position + movementVector) - hook_anchor.position;
		        movementVector = movementVector - ( baseVec - rope.getMaxLength()*baseVec.normalized ); 

		        
		        if( player != null ) {
			       	var controller : ThirdPersonController = player.GetComponent( "ThirdPersonController" );
			        controller.setVerticalSpeed( 0.0f );
			    }
			    
			    switch( viewMode ) {
			    	case ViewMode.side:
			            movementVector.z = 0.0f;
			    		break;
			    	case ViewMode.top:
			    		movementVector.y = 0.0f;
			    		break;
			    }
	        } 
			break;
		case Movable.object:
			// if the anchors are farther apart than they should be
	        if( Vector3.Distance( player_anchor.position , hook_anchor.position ) >= rope.getMaxLength() ) {
	            // from where the rope is attached to where the player would be 
	            baseVec = player_anchor.position - hook_anchor.position;
	            // first try to move the player only in the x direction to within the rope's radius
	            Debug.Log("Adding force: " + (baseVec - rope.getMaxLength()*baseVec.normalized));
	            
	            var myMovement = (baseVec - rope.getMaxLength()*baseVec.normalized);
			    switch( viewMode ) {
			    	case ViewMode.side:
			            myMovement.z = 0.0f;
			    		break;
			    	case ViewMode.top:
			    		myMovement.y = 0.0f;
			    		break;
			    }
			    
			    // don't move the block away from the player with the grappling rope
			    if( ((rigidbody.position + myMovement) - player_anchor.position).magnitude > (rigidbody.position - player_anchor.position).magnitude ) {
			    	myMovement = Vector3.zero;
			    	return;
			    }
			    
			    // don't move to close to anything, including the player
			    //var sweepHit : RaycastHit;
			    //var ishit = rigidbody.SweepTest( myMovement.normalized, sweepHit, myMovement.magnitude );
	            //if( !ishit || (ishit && !sweepHit.collider.CompareTag( "Player" )) )
	            	rigidbody.MovePosition( rigidbody.position + myMovement );
	            
			}
			break;
	}
		
	return movementVector;
}









