class SeqCond_HasSaveGame extends SequenceCondition
    native
    hidecategories(Object);

var() bool bDelayInput;

defaultproperties
{
    bDelayInput=true
    bLatentExecution=true
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Has Save Game"
}