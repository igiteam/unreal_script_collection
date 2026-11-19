class EPA_JumpLand extends EPA_Jump;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super(EvilPawnAction).PawnActionStarted(bForced, PrevMove);
    PawnOwner.CustomGravityScaling = PawnOwner.default.CustomGravityScaling;
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(PawnOwner.CurrentJumpInfo.JumpLand.AnimName, PawnOwner.CurrentJumpInfo.JumpLand.AnimSpeed, PawnOwner.CurrentJumpInfo.JumpLand.BlendInTime, PawnOwner.CurrentJumpInfo.JumpLand.BlendOutTime);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnActionIgnoreLockDown'
}