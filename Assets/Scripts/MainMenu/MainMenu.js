#pragma strict

/**
 * Generate the main menu GUI with the following buttons:
 * 1. New Game
 * 2. Load Game
 * 3. Options
 * 4. Quit
 */

var newgame_skin : GUISkin;
var quitgame_skin : GUISkin;

function OnGUI() {
	var scrWidth = Screen.width;
	var scrHeight = Screen.height;

    // The new game button
    GUI.skin = newgame_skin;
    if (GUI.Button(Rect(20, scrHeight / 1.75 + 0 * scrHeight / 10, scrWidth / 2, scrHeight / 10), "")) {
        Application.LoadLevel("sewer_level");
    }
    

    
    // The quit button: Exits the game
    GUI.skin = quitgame_skin;
    if (GUI.Button(Rect(20, scrHeight / 1.75 + 3 * scrHeight / 10, scrWidth / 2, scrHeight / 10), "")) {
        Application.Quit();
    }
}