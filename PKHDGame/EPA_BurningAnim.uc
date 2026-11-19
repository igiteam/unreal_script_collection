class EPA_BurningAnim extends EvilPawnAction;

protected function bool InternalCanDoPawnAction()
{
    return !PawnOwner.IsBurning() && int(PawnOwner.Physics) != int(10);
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte NewAction)
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    // End:0x14
    if(int(inAction) == 3)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool AimOffsetOverride(out Rotator DeltaRot)
{
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;
    local EvilAnimInfo AnimInfo;
    local float AnimLength;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0x2DB
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false);
        AnimLength = PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().GetAnimPlaybackLength();
        PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
        PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
        // End:0x28B
        if(int(PawnOwner.WorldInfo.NetMode) < int(NM_Client))
        {
            PawnOwner.Mesh.RootMotionMode = 3;
        }
        PawnOwner.SetTimer(AnimLength - RandRange(0.0000000, AnimLength * 0.3000000), false, 'DieInBurningAnim_T');        
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    PawnOwner.TakeDamage(PawnOwner.Health, none, vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), Class'EvilDmgType_Fire');
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnAction'
    bDisableAI=true
}