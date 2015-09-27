#pragma strict

// Size and color of waypoint in the editor
public var gizmoColor : Color = Color.blue;
public var gizmoSize = 3.0f;

// Unique ID for waypoint so can be followed in a set order
public var id : int = 0;

// Waypoint manager MUST be set in editor
public var waypointGameObjectName : String;
private var waypointGameObject : GameObject;
private var waypointManager : WaypointManager;
private var hasBeenAdded : boolean;

// Set flag to add
function Start() {
    hasBeenAdded = false;
}

// Add waypoint to editor (avoids null issue)
function Update() {
    if (hasBeenAdded) return;

    waypointGameObject = GameObject.Find(waypointGameObjectName);
    
    if (waypointGameObject == null) {
        //Debug.LogError("Waypoint " + id + " not provided a manager!");
        return;
    } else {
Debug.Log("Adding point " + id);
        waypointManager = waypointGameObject.GetComponent("WaypointManager");
        waypointManager.AddWaypoint(this);
        hasBeenAdded = true;
    }
}

// Draw the waypoint
function OnDrawGizmos () {
    Gizmos.color = gizmoColor;
    Gizmos.DrawSphere(transform.position, gizmoSize);
}

// Returns the id of the waypoint
function GetID() : int {
    return id;
}

// returns x position
function GetX() : float {
    return transform.position.x;
}

// Returns y position
function GetY() : float {
    return transform.position.y;
}

// Returns z position
function GetZ() : float {
    return transform.position.z;
}

// Returns the position of the waypoint
function GetPosition() : Vector3 {
    return transform.position;
}

// Calculates the straight-line distance from this waypoint to another
// [ (x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2 ] ^ (1/2)
function GetStraightDistance(w : Waypoint) : float {
    return Mathf.Sqrt(Mathf.Pow(w.GetX() - GetX(), 2) + 
                      Mathf.Pow(w.GetZ() - GetZ(), 2) + 
                      Mathf.Pow(w.GetZ() - GetZ(), 2));
}

// Calculates the straight-line distance from this waypoint to a vector
function GetStraightDistanceFromVector(v : Vector3) : float {
    return Mathf.Sqrt(Mathf.Pow(v.x - GetX(), 2) + 
                      Mathf.Pow(v.y - GetZ(), 2) + 
                      Mathf.Pow(v.z - GetZ(), 2));
}