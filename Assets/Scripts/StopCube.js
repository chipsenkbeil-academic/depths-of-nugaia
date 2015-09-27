#pragma strict
public var player : GameObject;

function OnTriggerEnter( collider : Collider ) {
	if( collider.name.Equals( "floating_cube" ) ) {
		var reciever : GrappleReciever = collider.GetComponent( "GrappleReciever" );
		var hook : GrapplingHook = player.GetComponent( "GrapplingHook" );
		if( reciever != null ) {
			if (hook != null && hook.hook_attached) {
				Debug.Log("test");
				hook.ResetHook();
			}
			reciever.enabled = false;
		}
	}
}