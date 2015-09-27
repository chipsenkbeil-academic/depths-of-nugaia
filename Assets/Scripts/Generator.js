public var Generator : GameObject;
public var textureUpdated : Texture;
private var activated : boolean;
private var changed : boolean;

function Start () {
	activated = false;
	changed = false;
}

function OnTriggerEnter() {
	activated = true;
}

function Update() {
	if(activated && !changed) {
    	Generator.renderer.material.mainTexture = textureUpdated;
        Generator.transform.Find("gen_torus").renderer.material.mainTexture = textureUpdated;
        Generator.transform.Find("gen_bulbs").Find("group5").Find("pSphere1").renderer.material.mainTexture = textureUpdated;
        Generator.transform.Find("gen_bulbs").Find("group6").Find("pSphere1 1").renderer.material.mainTexture = textureUpdated;
        Generator.transform.Find("gen_bulbs").Find("group7").Find("pSphere1 2").renderer.material.mainTexture = textureUpdated;
        Generator.transform.Find("gen_bulbs").Find("group8").Find("pSphere1 3").renderer.material.mainTexture = textureUpdated;
        Generator.transform.Find("light1").active = true;
        Generator.transform.Find("light2").active = true;
        Generator.transform.Find("light3").active = true;
        Generator.transform.Find("light4").active = true;
        changed = true;
   	}
}

function isActivated() {
	return activated;
}