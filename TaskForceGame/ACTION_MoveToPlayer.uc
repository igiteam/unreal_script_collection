class ACTION_MoveToPlayer extends LatentScriptedAction;

var() float	Distance;

function bool InitActionFor(ScriptedController C)
{
	if ( C.CheckIfNearPlayer(Distance) )
		return false;
	C.CurrentAction = self;
	C.SetTimer(0.1,true);
	return true;
}

function bool MoveToGoal()
{
	return true;
}

function bool WaitForPlayer()
{
	return true;	
}

function float GetDistance()
{
	return Distance;
}

function Actor GetMoveTargetFor(ScriptedController C)
{
	return C.GetMyPlayer();
}


// Decompiled with UE Explorer.
defaultproperties
{
    Distance=300.0000000
    ActionString="Move to player"
    bValidForTrigger=false
}