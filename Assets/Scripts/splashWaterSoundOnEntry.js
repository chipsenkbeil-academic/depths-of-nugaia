var clip : AudioClip;
var source : GameObject;

function OnCollisionEnter (collision : Collision) {
	
}

function OnTriggerEnter(other : Collider) {
	AudioSource.PlayClipAtPoint(clip, transform.position);
}