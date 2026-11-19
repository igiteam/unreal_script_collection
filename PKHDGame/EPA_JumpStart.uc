class EPA_JumpStart extends EPA_Jump;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super(EvilPawnAction).PawnActionStarted(bForced, PrevMove);
    PawnOwner.AccumulatedMotionDelta = vect(0.0000000, 0.0000000, 0.0000000);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(PawnOwner.CurrentJumpInfo.JumpStart.AnimName, PawnOwner.CurrentJumpInfo.JumpStart.AnimSpeed, PawnOwner.CurrentJumpInfo.JumpStart.BlendInTime, PawnOwner.CurrentJumpInfo.JumpStart.BlendOutTime, false, true, 0.0000000);
    PawnOwner.CustomGravityScaling = PawnOwner.CurrentJumpInfo.JumpStart.CustomGravityScaling;
    // End:0x293
    if(PawnOwner.bInheritJumpVelocityFromMotionDelta)
    {
        PawnOwner.Mesh.RootMotionMode = 3;
        PawnOwner.Mesh.bRootMotionExtractedNotify = true;        
    }
    else
    {
        PawnOwner.Mesh.RootMotionMode = 1;
    }
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    PawnOwner.JumpDeltaMultiplier = 1.0000000;
    // End:0x7C
    if(PawnOwner.bInheritJumpVelocityFromMotionDelta)
    {
        PawnOwner.Mesh.bRootMotionExtractedNotify = false;
    }
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnActionIgnoreLockDown'
}