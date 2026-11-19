class AirplaneSplineMover extends SplineMover
								native
								placeable;

var() float RollTurnFactor;
var() float RollStrafeFactor;

native function bool MoveOnSpline(float DeltaTime);

