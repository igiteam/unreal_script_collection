class ACTION_StopRumble extends ScriptedAction;


function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;

	ForEach C.DynamicActors(class'PlayerController', pc)
	{
		pc.StopAllRumble();
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
    ActionString="Stop Rumble"
}