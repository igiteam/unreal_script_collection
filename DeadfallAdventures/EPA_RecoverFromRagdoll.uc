class EPA_RecoverFromRagdoll extends EPA_BasePlaySingleAnim;

struct RecoverAnimInfo
{
    var() name RecoverAnimName;
    var() int YawModAngle;

    structdefaultproperties
    {
        RecoverAnimName="None"
        YawModAngle=0
    }
};

var bool bGetUpFromBack;
var() bool bInvertUpDownBoneAxis;
var() bool bIgnorePawnsOnRecover;
var() name UpDownBoneName;
var() Object.EAxis UpDownAxis;
var() Object.EAxis OrientationAxis;
var() name OrientationBoneName;
var() int GetUpFromBackYawOffset;
var RecoverAnimInfo GetUpFront[EHitDirectionType];
var RecoverAnimInfo GetUpBack[EHitDirectionType];
var RecoverAnimInfo CurrentAnim;

function bool CanOverrideAction(byte inAction)
{
    return (int(inAction) != 3) && int(inAction) != 31;
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte NewAction)
{
    return (int(NewAction) == 3) || int(NewAction) == 31;
    //return ReturnValue;    
}

simulated function Actor TraceNoPawns(Pawn TraceOwner, Vector End, Vector Start, out Vector HitLocation)
{
    local Actor HitActor;
    local Vector HitLoc, HitNorm;

    // End:0x97
    foreach TraceOwner.TraceActors(Class'Engine.Actor', HitActor, HitLoc, HitNorm, End, Start, vect(0.0000000, 0.0000000, 0.0000000))
    {
        // End:0x96
        if(Pawn(HitActor) != none)
        {
            HitLocation = HitLoc;            
            return HitActor;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local Vector HitLocation, HitNormal, TraceStart, TraceEnd, Extent, HeightVec;

    local Actor HitActor;

    super(EvilPawnAction).PawnActionStarted(bForced, PrevAction);
    PawnOwner.RestorePreRagdollCollisionComponent();
    PawnOwner.Mesh.SetNotifyRigidBodyCollision(false);
    PawnOwner.SetPhysics(2);
    CurrentAnim = GetUpFront[PawnOwner.PawnActionFlags];
    SetupRotationAndAnimation();
    PawnOwner.Mesh.PhysicsWeight = 1.0000000;
    Extent = vect(0.0000000, 0.0000000, 0.0000000);
    HeightVec = vect(0.0000000, 0.0000000, 1.0000000) * PawnOwner.CylinderComponent.CollisionHeight;
    TraceStart = PawnOwner.Location + (HeightVec * 1.1000000);
    TraceEnd = PawnOwner.Location - (HeightVec * 3.0000000);
    // End:0x21F
    if(bIgnorePawnsOnRecover)
    {
        HitActor = TraceNoPawns(PawnOwner, TraceEnd, TraceStart, HitLocation);        
    }
    else
    {
        HitActor = PawnOwner.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, Extent);
    }
    // End:0x3C0
    if(HitActor != none)
    {
        HitLocation += (HeightVec - (vect(0.0000000, 0.0000000, 1.0000000) * Extent.Z));
        Extent = (vect(1.0000000, 1.0000000, 0.0000000) * PawnOwner.CylinderComponent.CollisionRadius) + HeightVec;
        // End:0x39C
        if(PawnOwner.FindSpot(Extent, HitLocation))
        {
            // End:0x399
            if(PawnOwner.Location != HitLocation)
            {
                PawnOwner.SetLocation(HitLocation);
            }            
        }
        else
        {
            PawnOwner.SetLocation(HitLocation);
        }        
    }
    PawnOwner.bPlayingFeignDeathRecovery = true;
    PawnOwner.FeignDeathRecoveryStartTime = PawnOwner.WorldInfo.TimeSeconds;
    // End:0x4FF
    if((PawnOwner.PawnActionFlags != 0) && int(PawnOwner.Role) == int(ROLE_Authority))
    {
        PawnOwner.MyEvilAI.SetFocalPoint(PawnOwner.MyEvilAI.Enemy.Location);
    }
    //return;    
}

function SetupRotationAndAnimation()
{
    local Rotator NewRotation;
    local int OrientationBodyIndex, UpDownBodyIndex;
    local Matrix BodyTM;

    bGetUpFromBack = false;
    CurrentAnim = GetUpFront[PawnOwner.PawnActionFlags];
    OrientationBodyIndex = PawnOwner.Mesh.PhysicsAsset.FindBodyIndex(OrientationBoneName);
    // End:0x33C
    if(OrientationBodyIndex != -1)
    {
        BodyTM = PawnOwner.Mesh.PhysicsAssetInstance.Bodies[OrientationBodyIndex].GetUnrealWorldTM();
        NewRotation.Yaw = Rotator(MatrixGetAxis(BodyTM, OrientationAxis)).Yaw;
        UpDownBodyIndex = PawnOwner.Mesh.PhysicsAsset.FindBodyIndex(UpDownBoneName);
        // End:0x2B3
        if(UpDownBodyIndex != -1)
        {
            BodyTM = PawnOwner.Mesh.PhysicsAssetInstance.Bodies[UpDownBodyIndex].GetUnrealWorldTM();
            bGetUpFromBack = MatrixGetAxis(BodyTM, UpDownAxis).Z > 0.0000000;
            // End:0x2B3
            if(bInvertUpDownBoneAxis)
            {
                bGetUpFromBack = !bGetUpFromBack;
            }
        }
        // End:0x304
        if(bGetUpFromBack)
        {
            NewRotation.Yaw += GetUpFromBackYawOffset;
            NewRotation = Normalize(NewRotation);
        }
        PawnOwner.SetRotation(NewRotation);
        CurrentAnim = GetGetUpAnim();        
    }
    else
    {
        NewRotation.Yaw = PawnOwner.Rotation.Yaw;
        PawnOwner.SetRotation(NewRotation);
    }
    AnimName = CurrentAnim.RecoverAnimName;
    // End:0x440
    if((PawnOwner.PawnActionFlags != 0) && PawnOwner.AST_GetAnimCount(79) > 0)
    {
        PawnOwner.RequestFastSpinUp(,, true, true);
    }
    PawnOwner.FullBodyAnimSlot.bEarlyAnimEndNotify = false;
    PlayAnimation();
    PawnOwner.Mesh.RootMotionMode = 2;
    PawnOwner.Mesh.RootMotionRotationMode = 1;
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneRotationOption(2, 2, 2);
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(1, 1, 1);
    //return;    
}

simulated event StartFeignDeathRecoveryAnim()
{
    PawnOwner.RestorePreRagdollCollisionComponent();
    PawnOwner.Mesh.MinDistFactorForKinematicUpdate = PawnOwner.default.Mesh.MinDistFactorForKinematicUpdate;
    PawnOwner.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
    PawnOwner.Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, PawnOwner.Mesh);
    PawnOwner.SetPawnRBChannels(false);
    PawnOwner.Mesh.bUpdateKinematicBonesFromAnimation = true;
    PawnOwner.CylinderComponent.SetActorCollision(true, true);
    PawnOwner.Mesh.SetActorCollision(true, false);
    PawnOwner.Mesh.SetTickGroup(0);
    PawnOwner.SetTickGroup(0);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.Mesh.RootMotionRotationMode = PawnOwner.default.Mesh.RootMotionRotationMode;
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneRotationOption(1, 1, 1);
    PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.MinDistFactorForKinematicUpdate = PawnOwner.default.Mesh.MinDistFactorForKinematicUpdate;
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    PawnOwner.FullBodyAnimSlot.bEarlyAnimEndNotify = PawnOwner.FullBodyAnimSlot.default.bEarlyAnimEndNotify;
    // End:0x3C9
    if(int(PawnOwner.Role) == int(ROLE_Authority))
    {
        // End:0x3C9
        if((AIOwner.MoveAction == none) || AIOwner.MoveAction.bInterruptable)
        {
            AIOwner.AbortCommand(AIOwner.CommandList);
            AIOwner.bAllowCombatTransitions = true;
            AIOwner.ReactionManager.UnSuppressAllReactions();
            AIOwner.BeginCombatCommand(AIOwner.GetDefaultCommand(), "PA_RecoverFromRagdoll");
        }
    }
    PawnOwner.SetCollision(true, true);
    PawnOwner.SpawnCompleted(0);
    //return;    
}

protected simulated function RecoverAnimInfo GetGetUpAnim()
{
    // End:0x39
    if(bGetUpFromBack)
    {
        return GetUpBack[PawnOwner.PawnActionFlags];        
    }
    else
    {
        return GetUpFront[PawnOwner.PawnActionFlags];
    }
    //return ReturnValue;    
}

function bool PlayedRecoverAnimation(name playedAnimName)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x95 [Loop If]
    if(I < 5)
    {
        // End:0x87
        if((GetUpFront[I].RecoverAnimName == playedAnimName) || GetUpBack[I].RecoverAnimName == playedAnimName)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return false;
    //return ReturnValue;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x4B
    if(PlayedRecoverAnimation(SeqNode.AnimSeqName))
    {
        PawnOwner.EndPawnAction();
    }
    //return;    
}

function FireSpinUpFromRecover()
{
    //return;    
}

defaultproperties
{
    bIgnorePawnsOnRecover=true
    UpDownBoneName="Hips"
    UpDownAxis=EAxis.AXIS_Y
    OrientationAxis=EAxis.AXIS_X
    OrientationBoneName="Spine"
    GetUpFromBackYawOffset=32768
    GetUpFront[0]=(RecoverAnimName="Getup_front",YawModAngle=0)
    GetUpFront[1]=(RecoverAnimName="Getup_Front_RunFwd",YawModAngle=0)
    GetUpFront[2]=(RecoverAnimName="Getup_Front_RunBwd",YawModAngle=0)
    GetUpFront[3]=(RecoverAnimName="Getup_Front_RunLeft",YawModAngle=0)
    GetUpFront[4]=(RecoverAnimName="Getup_Front_RunRight",YawModAngle=0)
    GetUpBack[0]=(RecoverAnimName="Getup_back",YawModAngle=0)
    GetUpBack[1]=(RecoverAnimName="Getup_Back_RunBwd",YawModAngle=0)
    GetUpBack[2]=(RecoverAnimName="Getup_Back_RunFwd",YawModAngle=0)
    GetUpBack[3]=(RecoverAnimName="Getup_Back_RunRight",YawModAngle=0)
    GetUpBack[4]=(RecoverAnimName="Getup_Back_RunLeft",YawModAngle=0)
    BlendInTime=0.1000000
    BlendOutTime=0.3000000
    bLockPawnRotation=true
    bDisableMovement=true
    bDisableAI=true
}