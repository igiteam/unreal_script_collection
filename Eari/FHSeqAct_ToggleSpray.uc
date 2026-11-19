// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHSeqAct_ToggleSpray extends SequenceAction;

var() bool enableSpraying;

event Activated()
{
	local FHPlayerController pc;
	pc = FHPlayerController(GetWorldInfo().GetALocalPlayerController());
	FHNormalPlayer(pc.Pawn).sprayingEnabled = enableSpraying;
}


// Decompiled with UE Explorer.
defaultproperties
{
    enableSpraying=true
    ObjName="ToggleSpray"
    ObjCategory="Forever Hunted"
}