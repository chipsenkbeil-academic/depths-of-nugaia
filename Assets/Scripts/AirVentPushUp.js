var ventEnabled : boolean = true;
var ventForce_Rigid = 8.0f;
var ventForce_Controller = 0.5f;

function OnTriggerStay(other : Collider)
{
	if( !ventEnabled )
		return;
		
	var controller : ThirdPersonController = other.GetComponent(ThirdPersonController);
	if (controller != null) {
		controller.AddVerticalForce(ventForce_Controller);
		return;
	}
		
	var rigidBody = other.rigidbody;
	if (rigidBody != null) 
		rigidBody.velocity = transform.TransformDirection(new Vector3(0, ventForce_Rigid, 0));
}