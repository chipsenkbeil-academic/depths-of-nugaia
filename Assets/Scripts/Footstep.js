
var audioVolume = 5.0;
var footstepNoise : AudioClip;

function playSound(){
    audio.volume = audioVolume;
    audio.clip = footstepNoise;
    audio.Play();

    // Code to show GUI animation
    //otherscript = GameObject.Find("dripGUI").GetComponent("guiAnim");
    //otherscript.dripPlaying = true;
}

@script RequireComponent(AudioSource)