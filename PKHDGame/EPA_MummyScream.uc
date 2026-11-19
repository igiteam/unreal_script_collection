class EPA_MummyScream extends EPA_BasePlaySingleAnim;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilTypesNative.EAnimationSetType AST;
    local EvilAnimInfo AnimInfo;
    local int Index;

    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0xA2
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        SetActionParamsFromAniminfo(AnimInfo);        
    }
    super.PawnActionStarted(bForced, PrevAction);
    // End:0x158
    if(int(PawnOwner.Role) == int(ROLE_Authority))
    {
        PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
        PawnOwner.Mesh.RootMotionMode = 3;
    }
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnActionIgnoreLockDown'
    bDisableMovement=true
}