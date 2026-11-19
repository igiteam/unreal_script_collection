class ACTION_RemoveItemFromInv extends ScriptedAction;

var() Enums.EIcon  IconToRemove;

function bool InitActionFor(ScriptedController C)
{
	local ZombiePlayerPawn P;

	ForEach C.DynamicActors(class'ZombiePlayerPawn',P)
		break;

	SFRMPlayerController (P.Controller).MySAInteraction.RemoveItemFromInv(IconToRemove);
	return false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    IconToRemove=9
}