class EPA_JumpPreLand extends EPA_Jump;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super(EvilPawnAction).PawnActionStarted(bForced, PrevMove);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(PawnOwner.CurrentJumpInfo.JumpPreLand.AnimName, PawnOwner.CurrentJumpInfo.JumpPreLand.AnimSpeed, PawnOwner.CurrentJumpInfo.JumpPreLand.BlendInTime, PawnOwner.CurrentJumpInfo.JumpPreLand.BlendOutTime, true);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
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