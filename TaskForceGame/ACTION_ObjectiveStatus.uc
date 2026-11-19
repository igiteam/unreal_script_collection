class ACTION_ObjectiveStatus extends ScriptedAction;

var() int ID;
var() EObjectiveStatus NewStatus;

function bool InitActionFor(ScriptedController C)
{
	local SFRMPlayerController pc;

	if (ID != -1)
	{
		ForEach C.DynamicActors(class'SFRMPlayerController', pc)
		{
			pc.ObjectiveManager.SetObjectiveStatus(ID, NewStatus);
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
    Id=-1
    NewStatus=1
    ActionString="Set Objective Status"
}