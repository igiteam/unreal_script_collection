class EPA_PlayerReload extends EvilPawnAction;

function bool CanChainAction(byte NextAction)
{
    return true;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte NewAction)
{
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local name Anim;
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;
    local EvilAnimInfo AnimInfo;
    local EvilWeap_Base Weap;
    local float WeaponReloadRateModifier;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    Weap = EvilWeap_Base(PawnOwner.Weapon);
    WeaponReloadRateModifier = 1.0000000;
    // End:0x302
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo) && Weap != none)
    {
        Anim = AnimInfo.AnimName;
        // End:0x201
        if(Weap.IsTimerActive('ReloadTimer', Weap))
        {
            WeaponReloadRateModifier = PawnOwner.Mesh.GetAnimLength(Anim) / (Weap.GetTimerRate('ReloadTimer', Weap) - Weap.GetTimerCount('ReloadTimer', Weap));
        }
        PawnOwner.TopHalfAnimSlot.PlayCustomAnim(Anim, ((AnimInfo.AnimSpeed * SpeedModifier) * PawnOwner.PawnActionAnimRateModifier) * WeaponReloadRateModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false, true, Weap.ReloadResumeTime);        
    }
    else
    {
        PawnOwner.EndPawnAction();
    }
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.TopHalfAnimSlot.StopCustomAnim(0.2000000);
    PawnOwner.TopHalfAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    //return;    
}
