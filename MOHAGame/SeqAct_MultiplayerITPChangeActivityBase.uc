class SeqAct_MultiplayerITPChangeActivityBase extends SequenceAction
    abstract
    native
    hidecategories(Object);

defaultproperties
{
    bLatentExecution=true
    InputLinks[0]=(LinkDesc="Activate",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjCategory="Multiplayer Animation"
}