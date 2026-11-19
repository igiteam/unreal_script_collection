class Waypoint extends Actor
	placeable;

var(Waypoint) float Radius;

var(Waypoint) int Number;

var (Waypoint) bool bUse3DPosition;

var (Waypoint)	bool	bCompleteOnTrigger;
var				bool	bHasBeenTriggered;


function bool CheckRadius(Pawn myPawn)
{
	local vector diff;
//	diff = myPawn.Location-Location;
	diff = myPawn.Location-Location;
	
	//
//	myPawn.ClientMessage("Waypoint dist: " $ VSize(diff));
	//
	if ( bCompleteOnTrigger )
	{
		return bHasBeenTriggered;
	}
	else
	{
		return (VSize(diff)<Radius);
	}
}

function Trigger ( Actor Other, Pawn EventInstigator )
{
	if ( bCompleteOnTrigger )
	{
		bHasBeenTriggered = true;
	}
}

function OnHit(Pawn myPawn)
{
//	myPawn.ClientMessage("Waypoint hit");
	TriggerEvent(Event, self, myPawn);
}

// Decompiled with UE Explorer.
defaultproperties
{
    Radius=80.0000000
    bHidden=true
}