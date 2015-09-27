var speed = 0.2;
var crawling = false;

function Start()
{
    // init text here, more space to work than in the Inspector (but you could do that instead)
    var tc = GetComponent(GUIText);
    var creds = "Depths of NuGaia\n \n";
    creds += "\n \n \n";
    creds += "Programmers:\n";
    creds += "Chip Senkbeil\n";
    creds += "Michael Cogswell\n";
    creds += "Brian Bowden\n";
    creds += "Collin Chew\n";
    creds += "David Merryman\n";
    creds += "\n \n";
    creds += "Artists:\n";
    creds += "Ryan Musselman\n";
    creds += "Ani Mittra\n";
    creds += "Gwen Sewell\n";
    creds += "Steven Ramberg\n";
    creds += "David Costa\n";
    creds += "\n \n";
    creds += "Producers: \n";
    creds += "Yong Cao\n";
    creds += "Dane Webster\n";
    creds += "Vinny Argentina\n";
    creds += "\n \n \n";
    creds += "\n \n \n";
    creds += "Thanks for playing!";
    tc.text= creds;
}

function Update ()
{
    if (!crawling)
        return;
    transform.Translate(Vector3.up * Time.deltaTime * speed);
    Debug.Log(gameObject.transform.position.y);
    if (gameObject.transform.position.y > 3.8)
    {
        crawling = false;
		LoadNewLevel();
    }
    if(Input.GetMouseButtonDown(0))
    {
   	 LoadNewLevel();
   	 }

}

function LoadNewLevel() {
	yield WaitForSeconds(3);
    Application.LoadLevel(0);
}

