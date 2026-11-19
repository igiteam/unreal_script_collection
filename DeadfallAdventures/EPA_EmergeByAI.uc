class EPA_EmergeByAI extends EPA_Emerge;

function DoEmerge(optional float _SightSenseLength = 1000.0000000, optional float _HearSenseLength = 1000.0000000, optional bool bEnableMotionDelta = false, optional bool bEnableTakeDamage = false)
{
    // End:0x44
    if(bEnableTakeDamage)
    {
        PawnOwner.SetCollision(true, true);
    }
    // End:0x14C
    if((int(PawnOwner.WakeInformation.RecoverID) == int(0)) && bEnableMotionDelta || PawnOwner.WakeInformation.bEnabledMotionDelta)
    {
        PawnOwner.Mesh.RootMotionMode = 0;
        PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
    }
    // End:0x1EA
    if(PawnOwner.MyEvilAI != none)
    {
        PawnOwner.MyEvilAI.CustomSightRadius = _SightSenseLength;
        PawnOwner.MyEvilAI.CustomHearRadius = _HearSenseLength;
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    // End:0x96
    if(PawnOwner.MyEvilAI != none)
    {
        PawnOwner.MyEvilAI.CustomSightRadius = -1.0000000;
        PawnOwner.MyEvilAI.CustomHearRadius = -1.0000000;
    }
    super.PawnActionEnded(PrevMove, NextMove);
    //return;    
}

defaultproperties
{
    bCanBeWakenByAI=true
    DefaultAICommand=Class'EvilAICmd_EmergeByAI'
}