class TurokSeqAct_BlendColorCube extends SeqAct_Latent
    native
    hidecategories(Object);

var() byte mSlot;
var() float mBlendValue;
var() float mBlendTime;
var float mCurBlendTime;
var float mBlendStart;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Blend Color Cube"
    ObjCategory="Turok Rendering"
}