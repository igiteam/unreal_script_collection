class UTSeqCond_DoTutorial extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local bool bTutorialOK;
    local WorldInfo WI;

    WI = GetWorldInfo();
    bTutorialOK = false;
    // End:0x146
    if(((WI != none) && WI.GRI != none) && UTGameReplicationInfo(WI.GRI) != none)
    {
        bTutorialOK = UTGameReplicationInfo(WI.GRI).bStoryMode;
        // End:0x146
        if((WI.Game.NumPlayers + WI.Game.NumTravellingPlayers) > 1)
        {
            bTutorialOK = false;
        }
    }
    OutputLinks[((bTutorialOK) ? 0 : 1)].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Play Tutorial",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Abort Tutorial",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    ObjName="Do Tutorial"
}