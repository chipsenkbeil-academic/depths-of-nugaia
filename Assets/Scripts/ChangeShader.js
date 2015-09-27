public var shaderRegular : Shader;
public var shaderOutline : Shader;
private var flag: float;

function Start() {
	if(gameObject.name.Equals("oil_drum")) {
				if(gameObject.transform.Find("pCylinder2") != null) 
            		gameObject.transform.Find("pCylinder2").renderer.material.shader = shaderRegular;
            } else {
            	renderer.material.shader = shaderRegular;
            }
	flag = 0;
}

function Update() {
	if( flag == 1 ) {
            if(gameObject.name.Equals("oil_drum")) {
            	if(gameObject.transform.Find("pCylinder2") != null) 
            		gameObject.transform.Find("pCylinder2").renderer.material.shader = shaderOutline;
            } else {
            	renderer.material.shader = shaderOutline;
            }
            }
        else {
            
            if(gameObject.name.Equals("oil_drum")) {
            	if(gameObject.transform.Find("pCylinder2") != null) 
            		gameObject.transform.Find("pCylinder2").renderer.material.shader = shaderRegular;
            } else {
            	renderer.material.shader = shaderRegular;
            }
            }
}

function OnMouseOver () {
        flag = 1;
}

function OnMouseExit () {
        flag = 0;
}