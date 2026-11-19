class EPA_DeathAnimWithoutMotors extends EPA_DeathAnimBase;

simulated function OnDeathAnimBodyRest()
{
    DeathAnimBlendToMotors();
    super.OnDeathAnimBodyRest();
    //return;    
}

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
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
    super(EPA_BasePlaySingleAnim).PawnActionStarted(bForced, PrevAction);
    PawnOwner.Mesh.RootMotionDelta.Translation = vect(0.0000000, 0.0000000, 0.0000000);
    PawnOwner.ZeroMovementVariables();
    // End:0x2B9
    if(!PawnOwner.IsRidingRailCar())
    {
        PawnOwner.Mesh.RootMotionMode = 3;
        PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
        PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
    }
    PawnOwner.PlayNoGoreDyingEffects();
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.bTearOff = true;
    //return;    
}

simulated function DeathAnimBlendToMotors()
{
    local Actor PawnBase;
    local Vector HitLoc, HitNormal;

    PawnBase = PawnOwner.Base;
    // End:0xBA
    if(PawnBase == none)
    {
        PawnBase = PawnOwner.Trace(HitLoc, HitNormal, PawnOwner.Location + vect(0.0000000, 0.0000000, -128.0000000), PawnOwner.Location);
    }
    // End:0x1C7
    if((PawnBase != none) && PawnBase.bStatic)
    {
        SetSpringForBone(PawnOwner.HipsBoneName, true);
        SetSpringForBone(PawnOwner.RightHandBoneName, true);
        SetSpringForBone(PawnOwner.LeftHandBoneName, true);
        SetSpringForBone(PawnOwner.LeftFootBoneName, true);
        SetSpringForBone(PawnOwner.RightFootBoneName, true);
        super.DeathAnimBlendToMotors();        
    }
    else
    {
        super.DeathAnimBlendToMotors();
        DeathAnimRagDoll();
    }
    //return;    
}

defaultproperties
{
    BlendInTime=0.0000000
}