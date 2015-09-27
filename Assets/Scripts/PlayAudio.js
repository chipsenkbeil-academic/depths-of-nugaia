var audioVolume = 3.0;
var collisionSoundEffect : AudioClip;

function playSound() {
    audio.volume = audioVolume;
    audio.clip = collisionSoundEffect;
    audio.Play();
}