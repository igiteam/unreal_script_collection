class ACTION_ObjectiveRemove extends ScriptedAction;

var() int ID;

function bool InitActionFor(ScriptedController C)
{
	local SFRMPlayerController pc;

	if (ID != -1)
	{
		ForEach C.DynamicActors(class'SFRMPlayerController', pc)
		{
			pc.ObjectiveManager.RemoveObjective(ID);
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
    ActionString="Remove Objective"
}