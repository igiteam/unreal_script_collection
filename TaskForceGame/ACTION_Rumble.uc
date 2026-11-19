class ACTION_Rumble extends ScriptedAction;

var() editinline RumbleDescription	RumbleDesc;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;

	if (RumbleDesc != none)
	{
		ForEach C.DynamicActors(class'PlayerController', pc)
		{
			pc.PlayRumble(RumbleDesc);
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
    ActionString="Play Rumble"
}