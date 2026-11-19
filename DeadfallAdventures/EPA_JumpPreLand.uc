class EPA_JumpPreLand extends EPA_Jump;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    local int JumpIndex;

    super(EvilPawnAction).PawnActionStarted(bForced, PrevMove);
    JumpIndex = PawnOwner.PawnActionFlags;
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(PawnOwner.JumpInformationArchetypes[JumpIndex].JumpPreLand.AnimName, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpPreLand.AnimSpeed, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpPreLand.BlendInTime, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpPreLand.BlendOutTime, true);
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