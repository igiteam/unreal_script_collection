class EPA_Emerge extends EvilPawnAction;

var bool bCanTakeDamage;

function bool CanOverrideActionWith(byte NewAction)
{
    return (int(NewAction) == 14) || bCanTakeDamage && int(NewAction) == 1;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return true;
    //return ReturnValue;    
}

static function int EncodeEmergeInfo(int AnimIndex, EvilTypes.ERecoverTypeFromAnimation RecoverType, EvilTypes.EEmergeAnimType AnimType, EvilTypes.ELayFirstFrameAnimation LayFirstFrame)
{
    local int ret;

    ret = AnimIndex & 255;
    ret = ret | ((int(RecoverType) & int(255)) << 8);
    ret = ret | ((int(AnimType) & int(255)) << 16);
    ret = ret | ((int(LayFirstFrame) & int(255)) << 24);
    return ret;
    //return ReturnValue;    
}

static function DecodeEmergeInfo(int EmergeInfo, out int AnimIndex, out EvilTypes.ERecoverTypeFromAnimation RecoverType, out EvilTypes.EEmergeAnimType AnimType, out EvilTypes.ELayFirstFrameAnimation LayFirstFrame)
{
    AnimIndex = EmergeInfo & 255;
    RecoverType = byte((EmergeInfo & 65280) >> 8);
    AnimType = byte((EmergeInfo & 16711680) >> 16);
    LayFirstFrame = byte((EmergeInfo & -16777216) >> 24);
    //return;    
}

function DoEmerge(optional float _senseLength = 1000.0000000, optional bool bEnableMotionDelta = false, optional bool bInEnableTakeDamage = false)
{
    local EvilAIReactCond_EmergeEnemyCloseAndVisible EECACondition;

    PawnOwner.MyEvilAI.ReactionManager.SuppressAllReactions();
    // End:0x135
    if(int(PawnOwner.WakeInformation.RecoverID) == int(2))
    {
        EECACondition = new (PawnOwner.MyEvilAI) Class'EvilAIReactCond_EmergeEnemyCloseAndVisible';
        EECACondition.DistanceThreshold = _senseLength;
        EECACondition.bKnockedDown = false;
        EECACondition.Initialize();
    }
    // End:0x23D
    if((int(PawnOwner.WakeInformation.RecoverID) == int(0)) && bEnableMotionDelta || PawnOwner.WakeInformation.bEnabledMotionDelta)
    {
        PawnOwner.Mesh.RootMotionMode = 0;
        PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
    }
    // End:0x27A
    if(bInEnableTakeDamage)
    {
        bCanTakeDamage = bInEnableTakeDamage;
        PawnOwner.SetCollision(true, true);
    }
    //return;    
}

function PawnActionStarted(bool bForced, byte PrevMove)
{
    local int AnimIndex;
    local EvilAnimInfo _AnimInfo;
    local EvilTypes.ERecoverTypeFromAnimation RecoverType;
    local EvilTypes.EEmergeAnimType AnimType;
    local EvilTypes.ELayFirstFrameAnimation LayFirstFrame;

    super.PawnActionStarted(bForced, PrevMove);
    PawnOwner.bCollideWorld = false;
    PawnOwner.SetCollision(false, false);
    PawnOwner.CylinderComponent.SetActorCollision(false, false);
    PawnOwner.bIgnoreSetMovementPhysics = true;
    Class'EPA_Emerge'.static.DecodeEmergeInfo(PawnOwner.PawnActionFlags, AnimIndex, RecoverType, AnimType, LayFirstFrame);
    // End:0x17A
    if(int(AnimType) == int(0))
    {
        _AnimInfo = PawnOwner.WakeAnims[int(LayFirstFrame)].AnimNames[AnimIndex];        
    }
    else
    {
        // End:0x1C3
        if(int(AnimType) == int(1))
        {
            _AnimInfo = PawnOwner.SpawnAnims[AnimIndex];            
        }
        else
        {
            // End:0x209
            if(int(AnimType) == int(2))
            {
                _AnimInfo = PawnOwner.LayAnims[AnimIndex];
            }
        }
    }
    // End:0x369
    if(int(RecoverType) == int(0))
    {
        PawnOwner.FullBodyAnimSlot.PlayCustomAnim(_AnimInfo.AnimName, 1.0000000, _AnimInfo.BlendInTime, _AnimInfo.BlendOutTime, false, true);
        PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
        PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption();
        PawnOwner.Mesh.RootMotionMode = 2;        
    }
    else
    {
        // End:0x446
        if(int(RecoverType) == int(2))
        {
            PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
            PawnOwner.FullBodyAnimSlot.PlayCustomAnim(_AnimInfo.AnimName, 1.0000000, _AnimInfo.BlendInTime, _AnimInfo.BlendOutTime, true, true);            
        }
        else
        {
            // End:0x520
            if(int(RecoverType) == int(1))
            {
                PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
                PawnOwner.FullBodyAnimSlot.PlayCustomAnim(_AnimInfo.AnimName, 1.0000000, _AnimInfo.BlendInTime, _AnimInfo.BlendOutTime, true, true);
            }
        }
    }
    PawnOwner.WakeInformation.RecoverID = RecoverType;
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    PawnOwner.SetCollision(PawnOwner.default.bCollideActors, PawnOwner.default.bBlockActors);
    PawnOwner.CylinderComponent.SetActorCollision(true, true);
    PawnOwner.bCollideWorld = true;
    PawnOwner.bIgnoreSetMovementPhysics = false;
    // End:0x222
    if(int(PawnOwner.Role) == int(ROLE_Authority))
    {
        // End:0x1D9
        if(int(PawnOwner.WakeInformation.RecoverID) == int(0))
        {
            PawnOwner.SpawnCompleted(0);
        }
        PawnOwner.MyEvilAI.ReactionManager.UnSuppressAllReactions();
    }
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAiCmd_Emerge'
    bDisableCollision=true
    bDisablePhysics=true
}