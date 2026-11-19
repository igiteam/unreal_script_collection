class SeqAct_ModifyCover extends SequenceAction
    hidecategories(Object);

var() array<int> Slots;
var() CoverLink.ECoverType ManualCoverType;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Enable Slots",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disable Slots",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Auto Adjust",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[3]=(LinkDesc="Manual Adjust",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Modify Cover"
    ObjCategory="Cover"
}