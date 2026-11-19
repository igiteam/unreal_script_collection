class SeqAct_ToggleCinematicMode extends SequenceAction
    hidecategories(Object);

var() bool bDisableMovement;
var() bool bDisableTurning;
var() bool bHidePlayer;

defaultproperties
{
    bDisableMovement=true
    bDisableTurning=true
    bHidePlayer=true
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Toggle Cinematic Mode"
    ObjCategory="Toggle"
}