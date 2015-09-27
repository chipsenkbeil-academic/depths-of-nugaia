#pragma strict

// Size and color of waypoint in the editor
public var gizmoColor : Color = Color.green;
public var gizmoSize = 3.0f;

// Enum with AI types
enum PathTrace {
    SingleStep = 0,       // Follow path once and ignore player
    MultiStep = 1,        // Follow path X times and ignore player
    InfiniteStep = 2,     // Follow path infinite times and ignore player
    ReverseStep = 3,      // Follow path infinite times reversing between forward and backward and ignore player
    StepUntilCounter = 4, // Follow path until encounter player and chase player
    StepAndRejoin = 5     // Follow path until encounter player and chase player until player escapes
}

// The AI of the enemy
public var ai : PathTrace = PathTrace.SingleStep;

// The number of steps for the ai
public var steps : int = 0;

// The player to track
public var player : GameObject;

// The movement speed used per update frame
public var movementSpeed : float = 0.1f;
public var speed : float = 15.0f;

// The radius acceptable to count a point as reached
public var acceptableRadius : float = 3.0f;

// Decides the radius to check for the player
public var attackRadius : float = 5.0f;

// The name of the game object containing the waypoint manager
public var waypointManagerName : String;

// MUST be altered to total number of waypoints to WAIT ON before starting
public var totalWaypointsLoading : int = 0;

// The waypoint manager
private var waypointManager : WaypointManager;

// The current target point
private var targetPoint : Vector3;
private var targetWaypoint : Waypoint;

// Flags for following the player
private var shouldFollowPlayer : boolean = false;
private var shouldIgnorePlayer : boolean = false;
private var attackRadiusVisual : boolean = true;

// Other flags
private var shouldGoBackwards : boolean = false;
private var canStartAI : boolean = false;
private var stepCount : int = 0;

// Draw the AI
function OnDrawGizmos () {
    Gizmos.color = gizmoColor;
    Gizmos.DrawSphere(transform.position, gizmoSize);
}

// Sets up the AI
function Start () {
    shouldIgnorePlayer = (ai < 4);
}

// Attempts to get the 
function Update () {
    // Check to make sure we have a waypoint manager (temporary fix)
    if (!CheckHasManager()) return;
    
    // Check if the AI can start
    if (!CheckCanStart()) return;
	
    // Have the manager, so attempt to move
    if (waypointManager) {
        // Check if near the player or is already following the player
        if (!shouldIgnorePlayer && ((shouldFollowPlayer && (ai == PathTrace.StepUntilCounter)) || GetDistance(player.transform.position) <= attackRadius)) {
            targetPoint = player.transform.position;
            shouldFollowPlayer = true;
        } else if (targetWaypoint != null && !IsAtPoint(targetPoint, acceptableRadius)) {
            targetPoint = targetWaypoint.GetPosition();
        } else { // Get a new point
            if (!shouldGoBackwards) {
                if (waypointManager.HasNextWaypoint()) {
                    targetWaypoint = waypointManager.GetNextWaypoint();
                    targetPoint = targetWaypoint.GetPosition();
                } else {
                    // AI should be done if single step
                    if (ai == PathTrace.SingleStep) {            
                        targetWaypoint = null;
                        targetPoint = transform.position;
                        
                    // AI should be done if multi step has reached final step
                    } else if (ai == PathTrace.MultiStep && stepCount >= steps) {
                        targetWaypoint = null;
                        targetPoint = transform.position;
                        
                    // Check other conditions
                    } else {
                        var newPointID : int;
                    
                        // Multi-step, so start at lowest ID
                        if (ai == PathTrace.MultiStep) {
                            stepCount++;
                            newPointID = waypointManager.GetLowestWaypointID(0);
                            waypointManager.SetCurrentWaypointID(newPointID);
                            targetWaypoint = waypointManager.GetWaypointByID(newPointID);
                            targetPoint = targetWaypoint.GetPosition();
                        
                        // Infinite, so start at lowest ID
                        } else if (ai == PathTrace.InfiniteStep) {
                            newPointID = waypointManager.GetLowestWaypointID(0);
                            waypointManager.SetCurrentWaypointID(newPointID);
                            targetWaypoint = waypointManager.GetWaypointByID(newPointID);
                            targetPoint = targetWaypoint.GetPosition();
                         
                        // Reverse-infinite, so start at previous ID
                        } else if (ai == PathTrace.ReverseStep) {
                            targetWaypoint = waypointManager.GetPrevWaypoint();
                            targetPoint = targetWaypoint.GetPosition();
                            shouldGoBackwards = true;
                        
                        // Start at lowest ID
                        } else if (ai == PathTrace.StepUntilCounter) {
                            newPointID = waypointManager.GetLowestWaypointID(0);
                            waypointManager.SetCurrentWaypointID(newPointID);
                            targetWaypoint = waypointManager.GetWaypointByID(newPointID);
                            targetPoint = targetWaypoint.GetPosition();
                        
                        // Start at lowest ID
                        } else if (ai == PathTrace.StepAndRejoin) {
                            newPointID = waypointManager.GetLowestWaypointID(0);
                            waypointManager.SetCurrentWaypointID(newPointID);
                            targetWaypoint = waypointManager.GetWaypointByID(newPointID);
                            targetPoint = targetWaypoint.GetPosition();
                        }
                    }
                }
            } else {
                if (waypointManager.HasPrevWaypoint()) {
                    targetWaypoint = waypointManager.GetPrevWaypoint();
                    targetPoint = targetWaypoint.GetPosition();
                } else {
                    if (ai == PathTrace.ReverseStep) {
                        targetWaypoint = waypointManager.GetNextWaypoint();
                        targetPoint = targetWaypoint.GetPosition();
                        shouldGoBackwards = false;
                    } else {
                        targetWaypoint = null;
                        targetPoint = transform.position;
                    }
                }
            }
        }
        
        // Perform movement
        transform.position += GetMovementVector(targetPoint, movementSpeed) * Time.deltaTime * speed;
    }
}

// Gets the vector to add to move the AI toward the point provided (directly)
private function GetMovementVector(v : Vector3, s : float) : Vector3 {
    var distance : float = GetDistance(v);
    if (distance == 0.0f) return Vector3(0, 0, 0);
    var direction : Vector3 = Vector3((v.x - transform.position.x) / distance,
                                  (v.y - transform.position.y) / distance,
                                  (v.z - transform.position.z) / distance);
    direction *= s;
    return direction;
}

// Determines if the AI is within the range allowed for the specified point
private function IsAtPoint(v : Vector3, r : float) : boolean {
    return (GetDistance(v) <= r);
}

// Checks and grabs the waypoint manager
private function CheckHasManager() : boolean {
    // Attempt to get the manager, since don't have it
    if (waypointManager == null) {
        var gObject = GameObject.Find(waypointManagerName);
        if (gObject != null) {
            waypointManager = gObject.GetComponent("WaypointManager");
            return (waypointManager != null);
        } else {
            return false;
        }
    }
    
    // Already exists, so return true
    return true;
}

// Checks if can start the AI
private function CheckCanStart() : boolean {
    if (canStartAI) {
        return true;
    } else {
        canStartAI = (waypointManager.GetTotalWaypoints() >= totalWaypointsLoading);
        return canStartAI;
    }
}

// Calculates the straight-line distance from this enemy to a vector
private function GetDistance(v : Vector3) : float {
	var x = v.x - transform.position.x;
	var y = v.y - transform.position.y;
	var z = v.z - transform.position.z;
    return Mathf.Sqrt((x * x) + (y * y) + (z * z));
}

public function setWayPointManager(manager : WaypointManager) {
	waypointManager = manager;
}

public function setAI(newAI : PathTrace) {
	ai = newAI;
}