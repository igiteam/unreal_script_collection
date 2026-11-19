// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHSeqAct_PlayerAnimation extends SequenceAction;

/** Name of node you want to play. */
var() name animationName;
/** How long the animation takes. Needed to reset animation to the beginning after it's done playing. */
var() float animationLength;

event Activated()
{
	local FHPlayerController pc;
	pc = FHPlayerController(GetWorldInfo().GetALocalPlayerController());
	FHNormalPlayer(pc.Pawn).playAnimation(animationName, animationLength);
}


// Decompiled with UE Explorer.
defaultproperties
{
    ObjName="Player Animation"
    ObjCategory="Forever Hunted"
}