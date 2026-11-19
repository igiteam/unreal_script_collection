class ACTION_SetHealthWatch extends ScriptedAction;

var() name WatchTag;
var() string WatchName;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;
	local pawn p;

	log("SetHealthWatch0: ");

	if ((WatchTag != 'None') && (WatchTag != ''))
	{
		ForEach C.AllActors(class'Pawn',P,WatchTag)
		{
			break;
		}
	}

	log("SetHealthWatch1: " $ P );

	ForEach C.DynamicActors(class'PlayerController', pc)
	{
		if (BasicHud(pc.myHud) != none)
		{
			log("SetHealthWatch2: " $ P);
			BasicHUD(pc.myHud).SetHealthWatch(p, WatchName);
		}
	}
	return false;	
}

function string GetActionString()
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="Set Health Watch"
}