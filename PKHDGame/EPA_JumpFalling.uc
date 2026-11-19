class EPA_JumpFalling extends EPA_Jump;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super(EvilPawnAction).PawnActionStarted(bForced, PrevMove);
    PawnOwner.SetPhysics(2);
    PawnOwner.CustomGravityScaling = PawnOwner.CurrentJumpInfo.JumpFalling.CustomGravityScaling;
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(PawnOwner.CurrentJumpInfo.JumpFalling.AnimName, PawnOwner.CurrentJumpInfo.JumpFalling.AnimSpeed, PawnOwner.CurrentJumpInfo.JumpFalling.BlendInTime, PawnOwner.CurrentJumpInfo.JumpFalling.BlendOutTime, true, true);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    //return;    
}
