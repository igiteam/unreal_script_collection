class ACTION_WaitForRandomTime extends LatentScriptedAction;

var(Action) float MinTime;
var(Action) float MaxTime;

function bool InitActionFor(ScriptedController C)
{
	local float pauseTime;

	C.CurrentAction = self;
	
	pauseTime = Lerp(MinTime,MaxTime,frand());
	
	C.SetTimer(PauseTime, false);
	return true;
}

function bool CompleteWhenTimer()
{
	return true;
}

function string GetActionString()
{
	return ActionString@MinTime$".."$MaxTime;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="Wait for random time"
}