class SeqCond_IsMedalAwarded extends SequenceCondition
    hidecategories(Object);

var() MOHAIncludeClass.EMedalTypeSP Medal;

function Activated()
{
    local PlayerController iterCont, playerCont;
    local MOHAPlayerReplicationInfo mPRI;

    // End:0x24
    foreach GetWorldInfo().LocalPlayerControllers(iterCont)
    {
        playerCont = iterCont;        
    }    
    mPRI = MOHAPlayerReplicationInfo(playerCont.PlayerReplicationInfo);
    // End:0xB5
    if(mPRI != none)
    {
        OutputLinks[0].bHasImpulse = mPRI.SPStatsMedal[int(Medal)].bHasMedal;
        OutputLinks[1].bHasImpulse = !mPRI.SPStatsMedal[int(Medal)].bHasMedal;
        return;
    }
    OutputLinks[1].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="True",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="False",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjClassVersion=2
    ObjName="Is Medal Awarded"
}