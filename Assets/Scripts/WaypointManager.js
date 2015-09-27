#pragma strict

private var wArray : Array;
private var currentWaypoint : int;

// Setup array and waypoint system
function Start () {
    wArray = new Array();
    currentWaypoint = -1;
}

// Adds a waypoint
function AddWaypoint(w : Waypoint) {
    wArray.push(w);
}

// Remove a waypoint by id
function DeleteWaypointByID(id : int) {
    for (var w : Waypoint in wArray) {
        if (w.GetID() == id) {
            wArray.remove(w);
            break;
        }
    }
}

// return the lowest waypoint ID in the list
function GetLowestWaypointID(lowestAllowed : int) : int {
    var lowestID : int = 999999999; // Maximum supported ID
    for (var w : Waypoint in wArray) {
        if (w.GetID() < lowestID && w.GetID() >= lowestAllowed) lowestID = w.GetID();
    }
    return lowestID;
}

// Return the highest waypoint ID in the list
function GetHighestWaypointID(highestAllowed : int) : int {
    var highestID : int = 0; // Smallest supported ID
    for (var w : Waypoint in wArray) {
        if (w.GetID() > highestID && w.GetID() <= highestAllowed) highestID = w.GetID();
    }
    return highestID;
}

// Return the current waypoint ID
function GetCurrentWaypointID() : int {
    return currentWaypoint;
}

// sets the current waypoint ID
function SetCurrentWaypointID(id : int) {
    currentWaypoint = id;
}

// Return the total number of waypoints
function GetTotalWaypoints() : int {
    return wArray.length;
}

// Return whether or not a waypoint with that id exists
function HasWaypointWithID(id : int) : boolean  {
    for (var w : Waypoint in wArray) {
        if (w.GetID() == id) return true;
    }
    
    return false;
}

// Retrieve a waypoint by id
function GetWaypointByID(id : int) : Waypoint {
    for (var w : Waypoint in wArray) {
        if (w.GetID() == id) return w;
    }
    
    // No waypoint
    Debug.LogWarning("No waypoint found with id: " + id);
    return null;
}

// Returns whether or not the manager has another waypoint in the id list
function HasNextWaypoint() : boolean {
    return (HasWaypointWithID(currentWaypoint + 1));
}

// Returns the next waypoint in the list
function GetNextWaypoint() : Waypoint {
    ++currentWaypoint;
    if (HasWaypointWithID(currentWaypoint)) {
        return GetWaypointByID(currentWaypoint);
    } else {
        --currentWaypoint; // Reset the position
        return null;
    }
}

// Returns whether or not the manager has a previous waypoint in the id list
function HasPrevWaypoint() : boolean {
    return (HasWaypointWithID(currentWaypoint - 1));
}

// Returns the previous waypoint in the list
function GetPrevWaypoint() : Waypoint {
    --currentWaypoint;
    if (HasWaypointWithID(currentWaypoint)) {
        return GetWaypointByID(currentWaypoint);
    } else {
        ++currentWaypoint; // Reset the position
        return null;
    }
}

// Finds and returns the waypoint closest to
// the provided waypoint
function FindWaypointClosestTo(baseW : Waypoint) {
    var foundPoint : Waypoint = null;
    for (var w : Waypoint in wArray) {
        if (foundPoint) { // Compare distances
            if (baseW.GetStraightDistance(w) < baseW.GetStraightDistance(foundPoint)) {
                foundPoint = w; // Update since was closer
            }
        } else { // Null, so auto-assign
            foundPoint = w;
        }
    }
    
    // Return the found point
    return foundPoint;
}









