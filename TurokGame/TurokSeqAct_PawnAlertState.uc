class TurokSeqAct_PawnAlertState extends SequenceAction
    hidecategories(Object);

var() float mBlendTime;
var() bool mAlerted;

defaultproperties
{
    mAlerted=true
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    ObjName="Force Human AI Alert State"
    ObjCategory="Turok AI"
}