private var elevatorSpeed : float;
private var elevatorHeight : float;
private var currentElevatorHeight : float;
private var maxElevatorHeight : float;
private var elevatorWaitTime : float;
private var currentTime : float;
private var movingUp : boolean;

function Start() {
	elevatorSpeed = 0.6f;
	elevatorHeight = transform.position.y;
	currentElevatorHeight = elevatorHeight;
	maxElevatorHeight = 10.75f;
	movingUp = true;
	elevatorWaitTime = 2.0f;
	currentTime = 0;
}

function Update() {
	if (currentTime > 0)
		currentTime -= Time.deltaTime;
	if (currentTime < 0)
		currentTime = 0;
	if (currentTime != 0)
		return;
		
	//Move elevator up
	if (movingUp) {
		transform.Translate(0, 0.05 * elevatorSpeed, 0);
		currentElevatorHeight = transform.position.y;
	}
	
	//Move elevator down
	else {
		transform.Translate(0, -0.05 * elevatorSpeed, 0);
		currentElevatorHeight = transform.position.y;	
	}
	
	//Ensures the elevator doesn't above or below the
	//lower and upper height limit
	if (currentElevatorHeight < elevatorHeight) {
		movingUp = !movingUp;
		currentTime = elevatorWaitTime;
		transform.position.y = elevatorHeight;
		currentElevatorHeight = elevatorHeight;
	}
	else if (currentElevatorHeight > maxElevatorHeight) {
		movingUp = !movingUp;
		currentTime = elevatorWaitTime;
		transform.position.y = maxElevatorHeight;
		currentElevatorHeight = maxElevatorHeight;
	}
}