class EPA_JumpLand extends EPA_Jump;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    local int JumpIndex;

    JumpIndex = PawnOwner.PawnActionFlags;
    super(EvilPawnAction).PawnActionStarted(bForced, PrevMove);
    PawnOwner.CustomGravityScaling = PawnOwner.default.CustomGravityScaling;
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(PawnOwner.JumpInformationArchetypes[JumpIndex].JumpLand.AnimName, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpLand.AnimSpeed, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpLand.BlendInTime, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpLand.BlendOutTime);
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