class EPA_EmergeByAI extends EPA_Emerge;

function DoEmerge(optional float _senseLength = 1000.0000000, optional bool bEnableMotionDelta = false, optional bool bEnableTakeDamage = false)
{
    // End:0x3B
    if(bEnableTakeDamage)
    {
        PawnOwner.SetCollision(true, true);
    }
    // End:0x143
    if((int(PawnOwner.WakeInformation.RecoverID) == int(0)) && bEnableMotionDelta || PawnOwner.WakeInformation.bEnabledMotionDelta)
    {
        PawnOwner.Mesh.RootMotionMode = 0;
        PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
    }
    // End:0x1A4
    if(PawnOwner.MyEvilAI != none)
    {
        PawnOwner.MyEvilAI.CustomSightRadius = _senseLength;
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    // End:0x5D
    if(PawnOwner.MyEvilAI != none)
    {
        PawnOwner.MyEvilAI.CustomSightRadius = -1.0000000;
    }
    super.PawnActionEnded(PrevMove, NextMove);
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAICmd_EmergeByAI'
}