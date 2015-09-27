public var sceneToLoad : String; 
public var seconds : float;
public var blackFade : GUITexture;

function OnTriggerEnter (other : Collider) {
	if (!other.name.Contains("Nyx")) 
		return;
		
	//Fade.use.Alpha(blackFade, 0, 1.0, seconds);
	yield WaitForSeconds(seconds);
	Application.LoadLevel (sceneToLoad); 
}