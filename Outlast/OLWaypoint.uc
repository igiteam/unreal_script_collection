
class OLWaypoint extends NavigationPoint
	placeable
	native(AI);

var() float WaitTime;

var() name AnimToPlay;
var() bool bLoopAnimation;

var() bool bTurnToRotation;

var() bool bAlignAnimToWaypoint;

native function WaypointReachedEvent(Actor InInstigator);
native function AnimStartedEvent(Actor InInstigator);

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.Flag1'
	End Object

	WaitTime=0.0f

	SupportedEvents.Add(class'OLSeqEvent_AIWaypointAction')
}
