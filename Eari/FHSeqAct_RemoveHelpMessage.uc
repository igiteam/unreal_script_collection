// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHSeqAct_RemoveHelpMessage extends SequenceAction;

/** Message to be removed from the active list, if found */
var() string messageToRemove;

event Activated()
	{
	local FHPlayerController pc;
	pc = FHPlayerController(GetWorldInfo().GetALocalPlayerController());
	pc.RemoveGameMesage (messageToRemove);
	}


// Decompiled with UE Explorer.
defaultproperties
{
    ObjName="Remove Help Message"
    ObjCategory="Forever Hunted"
}