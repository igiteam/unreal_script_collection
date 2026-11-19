class SeqAct_SaveGame extends SequenceAction
    native
    hidecategories(Object);

var() bool bCheckPointText;

defaultproperties
{
    bCheckPointText=true
    bLatentExecution=true
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failure",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks=none
    ObjClassVersion=3
    ObjName="Save Game"
    ObjCategory="Save/Load"
}