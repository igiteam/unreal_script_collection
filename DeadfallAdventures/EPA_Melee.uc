class EPA_Melee extends EvilPawnAction;

var bool bShouldLoop;
var const bool bShouldSetFocus;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilAnimInfo AnimInfo;
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0xAB
    if(!PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
    }
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, bShouldLoop);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    // End:0x260
    if(int(PawnOwner.WorldInfo.NetMode) < int(NM_Client))
    {
        PawnOwner.Mesh.RootMotionMode = 3;
    }
    // End:0x2BB
    if((AIOwner != none) && bShouldSetFocus)
    {
        AIOwner.Focus = AIOwner.Enemy;
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    //return;    
}

defaultproperties
{
    bShouldSetFocus=true
}