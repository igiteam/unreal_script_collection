class EPA_JumpFalling extends EPA_Jump;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    local int JumpIndex;

    JumpIndex = PawnOwner.PawnActionFlags;
    super(EvilPawnAction).PawnActionStarted(bForced, PrevMove);
    PawnOwner.SetPhysics(2);
    PawnOwner.CustomGravityScaling = PawnOwner.JumpInformationArchetypes[JumpIndex].JumpFalling.CustomGravityScaling;
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(PawnOwner.JumpInformationArchetypes[JumpIndex].JumpFalling.AnimName, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpFalling.AnimSpeed, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpFalling.BlendInTime, PawnOwner.JumpInformationArchetypes[JumpIndex].JumpFalling.BlendOutTime, true, true);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    //return;    
}
