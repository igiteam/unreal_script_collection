class EPA_ShieldLost extends EPA_BasePlaySingleAnim;

simulated function PlayAnimation()
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
    super.PlayAnimation();
    PawnOwner.Mesh.RootMotionMode = 3;
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
    //return;    
}

defaultproperties
{
    BlendInTime=0.3000000
    BlendOutTime=0.4000000
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnAction'
}