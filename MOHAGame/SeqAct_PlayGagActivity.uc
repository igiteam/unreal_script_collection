class SeqAct_PlayGagActivity extends SequenceAction
    native
    hidecategories(Object);

var() name GagActivityName;
var() name GagActivityPose;
var bool bIsConverted;
var() bool bLastActivity;
var private MOHAGagNode.EGagStatus GagActivityStatus;

function SetActivityStatus(MOHAGagNode.EGagStatus newStatus)
{
    GagActivityStatus = newStatus;
    //return;    
}

defaultproperties
{
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    OutputLinks[0]=(Links=none,LinkDesc="Anim Done",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Interrupt",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Play Gag Activity"
    ObjCategory="IGC Gags"
}