class EPA_BasePlaySingleASTAnim extends EPA_BasePlaySingleAnim;

var EvilTypesNative.EAnimationSetType CurrentAST;
var SkeletalMeshComponent.ERootMotionMode RootMotionMode;
var int PawnActionFlags;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    // End:0xD2
    if(int(PawnOwner.WorldInfo.NetMode) < int(NM_Client))
    {
        PawnOwner.Mesh.RootMotionMode = RootMotionMode;
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = 1;
    //return;    
}

simulated function PlayAnimation()
{
    local EvilTypesNative.EAnimationSetType AST;
    local EvilAnimInfo AnimInfo;
    local int Index;

    // End:0x4C
    if(PawnOwner.PawnActionFlags != 0)
    {
        PawnActionFlags = PawnOwner.PawnActionFlags;
    }
    Class'EvilPawn'.static.UnpackAnimInfo(PawnActionFlags, AST, Index);
    CurrentAST = AST;
    // End:0xEC
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        SetActionParamsFromAniminfo(AnimInfo);        
    }
    else
    {
        PawnOwner.EndPawnAction();
    }
    super.PlayAnimation();
    //return;    
}

defaultproperties
{
    RootMotionMode=ERootMotionMode.RMM_Accel
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnAction'
    bLockPawnRotation=true
    bDisableMovement=true
}