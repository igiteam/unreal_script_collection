class SeqEvent_PlayerActivity extends SequenceEvent
    native
    hidecategories(Object);

var() MOHAPlayerPawn.EPlayerActivity PlayerActivity;

defaultproperties
{
    MaxTriggerCount=0
    OutputLinks[0]=(Links=none,LinkDesc="Begin State",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="End State",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Player Activity"
    ObjCategory="Player"
}