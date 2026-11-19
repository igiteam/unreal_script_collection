class UIAction_LoadOptions extends UIAction
    native
    hidecategories(Object);

var MOHAPlayerController Player;
var() bool SuppressShowMessageScreen;
var() int ForcedUserInput;

defaultproperties
{
    bLatentExecution=true
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failure",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Load Options"
    ObjCategory="Profile Manager"
}