class ACTION_StopCameraEffects extends ScriptedAction;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;

	ForEach C.DynamicActors(class'PlayerController', pc)
	{
		pc.RemoveCameraEffects();
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
    ActionString="Remove all cam effects"
}