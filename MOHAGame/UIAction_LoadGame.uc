class UIAction_LoadGame extends UIAction
    native
    hidecategories(Object);

var() bool bCheckpointData;
var() bool bGameData;
var() bool bStatsData;

defaultproperties
{
    bCheckpointData=true
    bGameData=true
    bStatsData=true
    bLatentExecution=true
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failure",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=2
    ObjName="Load Game"
    ObjCategory="Profile Manager"
}