#pragma strict

/**
 * Loads the options menu with the following options:
 * 1. Sound Adjustment Slider
 * 2. Resolution Mode Options
 * 3. Back to Main Menu
 */
function OnGUI() {

    // The sound adjustment slider
    /* TODO */
    
    // The resulution mode dropdown list
    /* TODO */
    
    // The back to main menu option
    if (GUI.Button(Rect(20, 60, 140, 20), "Back to Main Menu")) {
        Application.LoadLevel("MainMenu");
    }
}