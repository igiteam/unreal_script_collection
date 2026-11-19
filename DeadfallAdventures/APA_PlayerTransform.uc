class APA_PlayerTransform extends EvilPawnAction;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local name Anim;
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;
    local EvilAnimInfo AnimInfo;
    local AdvPlayerControllerMP PC;

    PC = AdvPlayerControllerMP(PawnOwner.Controller);
    // End:0xA2
    if(PC != none)
    {
        PC.IgnoreMoveInput(true);
        PC.bGodMode = true;
        PC.bForceNetUpdate = true;
    }
    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilGame.EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0x29A
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo) && PawnOwner.FullBodyAnimSlot != none)
    {
        Anim = AnimInfo.AnimName;
        // End:0x297
        if(PawnOwner.FullBodyAnimSlot.PlayCustomAnim(Anim, (AnimInfo.AnimSpeed * SpeedModifier) * PawnOwner.PawnActionAnimRateModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false) == 0.0000000)
        {
            PawnOwner.EndPawnAction();
        }        
    }
    else
    {
        PawnOwner.EndPawnAction();
    }
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    local AdvPlayerControllerMP PC;

    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.StopCustomAnim(0.2000000);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    PC = AdvPlayerControllerMP(PawnOwner.Controller);
    // End:0x1EE
    if(PC != none)
    {
        PC.TransformInMummy(true);
        PC.IgnoreMoveInput(false);
        PC.bGodMode = false;
        PC.bForceNetUpdate = true;
    }
    //return;    
}
