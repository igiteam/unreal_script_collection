class ACTION_ShootActor extends ScriptedAction;

var(Action) name 	ActorTag;
var(Action) int 	NumShots;

function bool InitActionFor(ScriptedController C)
{
	local actor	curActor;

	if ( ActorTag != '' )
	{
		ForEach C.AllActors(class'Actor',curActor,ActorTag)
			break;
	}

	if(curActor != None){
		C.ScriptedFocus = curActor;
		C.NumShots = NumShots;
		C.bShootTarget = true;
	}

	return false;	
}

	

// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="shoot actor"
    bValidForTrigger=false
}