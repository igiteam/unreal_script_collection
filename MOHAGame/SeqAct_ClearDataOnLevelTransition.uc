class SeqAct_ClearDataOnLevelTransition extends SequenceAction
    native
    hidecategories(Object);

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failure",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Clear Game Data On Level Transition"
    ObjCategory="Save/Load"
}