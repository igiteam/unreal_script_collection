class PPA_FullBodyHitReaction extends EPA_FullBodyHitReaction;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    // End:0xEA
    if((PKPawn(PawnOwner) != none) && !PKPawn(PawnOwner).ProjectileSM.HiddenGame)
    {
        PKPawn(PawnOwner).bHitWhenThrow = true;
        PawnOwner.OnStartThrow();
        PKPawn(PawnOwner).OnDetachProjectile();
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.DISABLEHITPLAYRAGDOLL();
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.RecomputeNextHitTime();
    PawnOwner.Mesh.RootMotionMode = 1;
    PawnOwner.NotifyEndFullBodyHit();
    //return;    
}

simulated function PlayAnimation()
{
    local EvilTypesNative.EAnimationSetType AST;
    local EvilAnimInfo AnimInfo;
    local int Index;

    Class'EvilGame.EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    CurrentAST = AST;
    // End:0xB5
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        SetActionParamsFromAniminfo(AnimInfo);        
    }
    super.PlayAnimation();
    //return;    
}
