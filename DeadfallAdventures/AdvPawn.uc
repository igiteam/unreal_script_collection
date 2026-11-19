class AdvPawn extends EvilPawn
    abstract
    native(Pawn)
    config(Pawn)
    hidecategories(Navigation);

enum EHeadTrackPriority
{
    EHTP_Default,                   // 0
    EHTP_AIFocus,                   // 1
    EHTP_MAX                        // 2
};

struct native HeadTrackStruct
{
    var Actor HeadLookAtActor;
    var name HeadLookAtBoneName;
    var AdvPawn.EHeadTrackPriority HeadTrackPriority;

    structdefaultproperties
    {
        HeadLookAtActor=none
        HeadLookAtBoneName="None"
        HeadTrackPriority=EHeadTrackPriority.EHTP_Default
    }
};

var AdvAIController MyAdvAI;
var array< class<EvilWeap_Base> > HandsClasses;
var SeqAct_EquipHands EquipHandsAction;
var AdvWalkableObstacleVolume CurrentWalkableObstacle;
var() bool bShouldHeadTrackAIFocus;
var bool bIsOnTurret;
var bool bCanDoFinisher;
var bool bPlayPuffParticle;
var bool bVisibleThroughWalls;
var protected transient bool bWasHeadTracking;
var() bool bFaceFXHeadTrackInvertLookAtAxis;
var() bool bFaceFXHeadTrackEyesHack;
var transient bool bRealignHeadWithTorso;
var bool bShouldPlayFullBodyHit;
var() config bool bCheckAnimDef;
var() config bool bCheckAnimDefEmptyAST;
var() protected bool bCanBeFinished;
var bool bAdjustingVelocity;
var transient bool bFastSpinUpHasAdditiveAnim;
var export editinline ParticleSystemComponent PuffEffectPCS;
var float EvadeGrenadeRadius;
var int MaxEnemyCount;
var export editinline SkeletalMeshComponent WallseeMesh;
var repnotify HeadTrackStruct ReplicatedHeadTrackInfo;
var HeadTrackStruct CurrentHeadTrackInfo;
var() config Vector2D HeadTrackUpdateIntervalRange;
var transient float NextHeadTrackUpdateTime;
var() name FaceFXHeadTrackBaseBone;
var() Object.EAxis FaceFXHeadTrackLookAtAxis;
var() Vector2D FaceFXHeadTrackWeightScale;
var() Vector2D FaceFXHeadTrackWeightBias;
var transient float FaceFXHeadTrackInfluenceInterpSpeed;
var transient float FaceFXHeadTrackDesiredInfluences[4];
var transient float FaceFXHeadTrackCurrentInfluences[4];
var transient float FaceFXHeadTrackInfluenceLimits[4];
var array<bool> RequiredAST;
var EvilPawn FinisherCandidate;
var Vector AdjustVelocityDir;
var float AdjustVelocitySpeed;
var() float SlowDownDistance;
var() float FastSpinUpDistances[ESpinUpSide];
var() AnimTree AIGroupAnimTreeTemplate;
var array<MaterialInterface> MaterialsToOverride;
var export editinline AudioComponent SizzleSoundComponent;
var() config float GrenadeDropChance;
var() transient float MummyBoltLifeTime;
var transient float lastPistolEquipOrPutDownSnd;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        FinisherCandidate, ReplicatedHeadTrackInfo, 
        bCanBeFinished;

    // Pos:0x011
    if(bNetDirty
        bVisibleThroughWalls;

    // Pos:0x01B
    if((!bNetOwner || bDemoRecording) && int(Role) == int(ROLE_Authority)
        bFastSpinUpHasAdditiveAnim;
}

// Export UAdvPawn::execUpdateAutomaticHeadTracking(FFrame&, void* const)
protected native final simulated function UpdateAutomaticHeadTracking();

// Export UAdvPawn::execSetHeadTrackActor(FFrame&, void* const)
reliable server native final function bool SetHeadTrackActor(Actor ActorToTrack, optional name LookAtBoneName, optional bool bOverride, optional AdvPawn.EHeadTrackPriority HeadTrackPriority);

// Export UAdvPawn::execSetHeadTrackActorLocal(FFrame&, void* const)
native final simulated function bool SetHeadTrackActorLocal(Actor ActorToTrack, optional name LookAtBoneName, optional bool bOverride, optional AdvPawn.EHeadTrackPriority HeadTrackPriority);

// Export UAdvPawn::execHeadTrackActorUpdated(FFrame&, void* const)
native final simulated function HeadTrackActorUpdated();

final simulated function DisableHeadTrackLocal()
{
    SetHeadTrackActorLocal(none);
    //return;    
}

// Export UAdvPawn::execShouldHeadTrackFocusPoint(FFrame&, void* const)
native simulated function bool ShouldHeadTrackFocusPoint();

// Export UAdvPawn::execGetEyeLookTargetLocation(FFrame&, void* const)
native simulated function Vector GetEyeLookTargetLocation();

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x80
        case 'ReplicatedHeadTrackInfo':
            // End:0x7D
            if(int(ReplicatedHeadTrackInfo.HeadTrackPriority) <= int(CurrentHeadTrackInfo.HeadTrackPriority))
            {
                CurrentHeadTrackInfo = ReplicatedHeadTrackInfo;
                HeadTrackActorUpdated();
            }
            // End:0x99
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            // End:0x99
            break;
            break;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local EvilTypesNative.EAnimationSetType AST;
    local AnimDefInfo ADF;
    local EvilAnimInfo EAI;
    local int Index;

    // End:0x3F
    if(SizzleSoundComponent != none)
    {
        SizzleSoundComponent.__OnAudioFinished__Delegate = SizzleAudioFinished;
    }
    super.PostBeginPlay();
    // End:0x18E
    if(bCheckAnimDef)
    {
        AST = 0;
        J0x62:

        // End:0x18E [Loop If]
        if(int(AST) < int(208))
        {
            // End:0x147
            if(AnimDefArchetype.GetAnimDefInfo(AST, ADF) && ADF.Animations.Length > 0)
            {
                // End:0x143
                foreach ADF.Animations(EAI, Index)
                {
                    // End:0x142
                    if(Mesh.FindAnimSequence(EAI.AnimName) == none)
                    {
                    }                    
                }                                
            }
            else
            {
                // End:0x16E
                if(bCheckAnimDefEmptyAST || RequiredAST[int(AST)])
                {
                }
            }
            AST = byte(int(AST) + int(1));
            // [Loop Continue]
            goto J0x62;
        }
    }
    // End:0x232
    if(bPlayPuffParticle)
    {
        PuffEffectPCS = new (self) Class'Engine.ParticleSystemComponent';
        PuffEffectPCS.SetTemplate(ParticleSystem'adv_ps_env_arctic.Effects.ps_ParaZUst');
        Mesh.AttachComponent(PuffEffectPCS, name("b_MF_Face_Lip_Top_Mid"));
        SetTimer(3.0000000, true, 'PlayPuffParticleEffect', self);
    }
    //return;    
}

simulated function OverrideMeshMaterials()
{
    local int Index;

    // End:0xE1
    if(MaterialsToOverride.Length > 0)
    {
        Index = 0;
        J0x1B:

        // End:0xE1 [Loop If]
        if(Index < MaterialsToOverride.Length)
        {
            // End:0xD3
            if((MaterialsToOverride[Index] != none) && !IsMaterialChildOf(Mesh.GetMaterial(Index), MaterialsToOverride[Index]))
            {
                Mesh.SetMaterial(Index, MaterialsToOverride[Index]);
            }
            Index++;
            // [Loop Continue]
            goto J0x1B;
        }
    }
    //return;    
}

simulated function class<EvilWeap_Base> GetHandsClassFor(AdvTypes.EHandsType HandsType)
{
    // End:0x30
    if(HandsClasses.Length > int(HandsType))
    {
        return HandsClasses[int(HandsType)];
    }
    return none;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    SizzleSoundComponent.__OnAudioFinished__Delegate = None;
    // End:0xA0
    if(bPlayPuffParticle && PuffEffectPCS != none)
    {
        PuffEffectPCS.DeactivateSystem();
        Mesh.DetachComponent(PuffEffectPCS);
        PuffEffectPCS = none;
    }
    super.Destroyed();
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local AdvPlayerController PC;
    local bool bDiedResult;

    // End:0xA9
    if(AdvGameSP(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none)
    {
        PC = AdvPlayerController(Killer);
        // End:0xA9
        if(PC != none)
        {
            // End:0xA9
            if(ClassIsChildOf(DamageType, Class'AdvDmgType_Dynamite'))
            {
                PC.IncrementGlobalIntStat(151);
            }
        }
    }
    bDiedResult = super.Died(Killer, DamageType, HitLocation);
    // End:0x23B
    if(((AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none) && AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).bDirectorSpawningFinished) && EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).AIDirectorInstance.GetInfluenceActorCount() == 1)
    {
        AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PrepareClientAIWallView(true);        
    }
    else
    {
        // End:0x3EF
        if(((AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none) && AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).bDirectorSpawningFinished) && EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).AIDirectorInstance.GetInfluenceActorCount() == 0)
        {
            AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PrepareClientAIWallView(false);
            AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).bDirectorSpawningFinished = false;
        }
    }
    SizzleSoundComponent.__OnAudioFinished__Delegate = None;
    // End:0x48F
    if(bPlayPuffParticle && PuffEffectPCS != none)
    {
        PuffEffectPCS.DeactivateSystem();
        Mesh.DetachComponent(PuffEffectPCS);
        PuffEffectPCS = none;
    }
    return bDiedResult;
    //return ReturnValue;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);
    MyAdvAI = AdvAIController(C);
    //return;    
}

function UnPossessed()
{
    super.UnPossessed();
    MyAdvAI = none;
    //return;    
}

event BaseChange()
{
    // End:0xB3
    if(((Base != none) && Pawn(Base) != none) && ClassIsChildOf(Base.Class, Class'EvilGame.EvilCreature') || ClassIsChildOf(Base.Class, Class'EvilGame.EvilAI_Creature'))
    {
        Pawn(Base).CrushedBy(self);        
    }
    else
    {
        super.BaseChange();
    }
    //return;    
}

function OnAdvJump(SeqAct_Jump Action)
{
    OnJump(Action);
    //return;    
}

function int GetRun2CoverStartAnimPackedIndex()
{
    local int Index;

    switch(CoverType)
    {
        // End:0x42
        case 2:
            Index = PackRandomAnimInfo(((bWantsToBeMirrored) ? 93 : 94));
            // End:0x86
            break;
        // End:0x71
        case 1:
            Index = PackRandomAnimInfo(((bWantsToBeMirrored) ? 99 : 100));
            // End:0x86
            break;
        // End:0xFFFF
        default:
            Index = -1;
            // End:0x86
            break;
            break;
    }
    return Index;
    //return ReturnValue;    
}

function int GetCoverFromLightStrafeForwardAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(175);        
    }
    else
    {
        packedindex = PackAnimInfo(175, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightStrafeForwardFastAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(188);        
    }
    else
    {
        packedindex = PackAnimInfo(188, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightJumpLeftAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(119);        
    }
    else
    {
        packedindex = PackAnimInfo(119, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightJumpRightAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(120);        
    }
    else
    {
        packedindex = PackAnimInfo(120, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightStartAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(109);        
    }
    else
    {
        packedindex = PackAnimInfo(109, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightLoopAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(110);        
    }
    else
    {
        packedindex = PackAnimInfo(110, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightHitAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(112);        
    }
    else
    {
        packedindex = PackAnimInfo(112, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightStrafeLeftAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(115);        
    }
    else
    {
        packedindex = PackAnimInfo(115, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightStrafeRightAnimPackedIndex(optional int Index = -1)
{
    local int packedindex;

    // End:0x31
    if(Index < 0)
    {
        packedindex = PackRandomAnimInfo(116);        
    }
    else
    {
        packedindex = PackAnimInfo(116, Index);
    }
    return packedindex;
    //return ReturnValue;    
}

function int GetCoverFromLightStrafeTransition(EvilTypesNative.EStrafeDirection OldStrafeDirection, EvilTypesNative.EStrafeDirection NewStrafeDirection)
{
    switch(OldStrafeDirection)
    {
        // End:0x3C
        case 2:
            // End:0x39
            if(int(NewStrafeDirection) == int(3))
            {
                return PackRandomAnimInfo(117);
            }
            // End:0x68
            break;
        // End:0x65
        case 3:
            // End:0x62
            if(int(NewStrafeDirection) == int(2))
            {
                return PackRandomAnimInfo(118);
            }
            // End:0x68
            break;
        // End:0xFFFF
        default:
            break;
    }
    return -1;
    //return ReturnValue;    
}

function int GetCoverFromLightStopAnimPackedIndex()
{
    return PackRandomAnimInfo(113);
    //return ReturnValue;    
}

function int GetRun2CoverLoopAnimPackedIndex()
{
    local int Index;

    switch(CoverType)
    {
        // End:0x42
        case 2:
            Index = PackRandomAnimInfo(((bWantsToBeMirrored) ? 95 : 96));
            // End:0x86
            break;
        // End:0x71
        case 1:
            Index = PackRandomAnimInfo(((bWantsToBeMirrored) ? 101 : 102));
            // End:0x86
            break;
        // End:0xFFFF
        default:
            Index = -1;
            // End:0x86
            break;
            break;
    }
    return Index;
    //return ReturnValue;    
}

function int GetRun2CoverStopAnimPackedIndex()
{
    local int Index;

    switch(CoverType)
    {
        // End:0x42
        case 2:
            Index = PackRandomAnimInfo(((bWantsToBeMirrored) ? 97 : 98));
            // End:0x86
            break;
        // End:0x71
        case 1:
            Index = PackRandomAnimInfo(((bWantsToBeMirrored) ? 103 : 104));
            // End:0x86
            break;
        // End:0xFFFF
        default:
            Index = -1;
            // End:0x86
            break;
            break;
    }
    return Index;
    //return ReturnValue;    
}

function PlayPuffParticleEffect()
{
    // End:0x2D
    if(IsAliveAndWell())
    {
        PuffEffectPCS.ActivateSystem(true);
    }
    //return;    
}

function bool CanDoFinisher()
{
    return bCanDoFinisher;
    //return ReturnValue;    
}

event bool SpecialMoveThruEdge(Pylon.ENavMeshEdgeType EdgeType, int Dir, Vector MoveStart, Vector MoveDest, optional Actor RelActor, optional int RelItem, optional NavigationHandle NavHandle)
{
    // End:0x40
    if(int(EdgeType) == int(2))
    {
        return SpecialMoveTo_CoverSlip(Dir, MoveStart, MoveDest);        
    }
    else
    {
        // End:0x7A
        if(int(EdgeType) == int(1))
        {
            return SpecialMoveTo_Mantle(Dir, MoveStart, MoveDest);
        }
    }
    return super.SpecialMoveThruEdge(EdgeType, Dir, MoveStart, MoveDest, RelActor, RelItem, NavHandle);
    //return ReturnValue;    
}

function bool SpecialMoveTo_CoverSlip(int Dir, Vector MoveStart, Vector MoveDest)
{
    local bool bResult;
    local AdvAIController_Cover CoverAI;

    CoverAI = AdvAIController_Cover(Controller);
    // End:0x2D
    if(CoverAI == none)
    {
        return false;
    }
    Class'AdvAICmd_Move_CoverSlip'.static.Coverslip(Dir, CoverAI, MoveStart, MoveDest);
    // End:0xC0
    if(CoverAI.CommandList.ChildStatus != 'Success')
    {
        bResult = false;        
    }
    else
    {
        bResult = true;
    }
    return bResult;
    //return ReturnValue;    
}

// Export UAdvPawn::execUpdateMeshBoneControllersNative(FFrame&, void* const)
native simulated function UpdateMeshBoneControllersNative(float DeltaTime);

function UpdateMeshBoneControllers(float DeltaTime)
{
    super.UpdateMeshBoneControllers(DeltaTime);
    UpdateMeshBoneControllersNative(DeltaTime);
    //return;    
}

simulated event UpdateFaceFXHeadTracking(Rotator Delta, float DeltaTime)
{
    local Vector2D Look;
    local int I, J, InfluenceIndex;
    local string RegName;

    Look.X = FaceFXHeadTrackWeightBias.X + ((FaceFXHeadTrackWeightScale.X * float(Delta.Yaw)) / 16384.0000000);
    Look.Y = FaceFXHeadTrackWeightBias.Y + ((FaceFXHeadTrackWeightScale.Y * float(Delta.Pitch)) / 16384.0000000);
    // End:0x16D
    if(DeltaTime == 0.0000000)
    {
        I = 0;
        J0x11A:

        // End:0x16A [Loop If]
        if(I < 4)
        {
            FaceFXHeadTrackCurrentInfluences[I] = 0.0000000;
            FaceFXHeadTrackDesiredInfluences[I] = 0.0000000;
            ++I;
            // [Loop Continue]
            goto J0x11A;
        }        
    }
    else
    {
        // End:0x204
        if((Abs(Look.X) > 1.0000000) || Abs(Look.Y) > 1.0000000)
        {
            I = 0;
            J0x1CA:

            // End:0x201 [Loop If]
            if(I < 4)
            {
                FaceFXHeadTrackDesiredInfluences[I] = 0.0000000;
                ++I;
                // [Loop Continue]
                goto J0x1CA;
            }            
        }
        else
        {
            // End:0x38C
            if(NextHeadTrackUpdateTime <= WorldInfo.TimeSeconds)
            {
                FaceFXHeadTrackDesiredInfluences[0] = Abs(FClamp(Look.X, FaceFXHeadTrackInfluenceLimits[0], 0.0000000));
                FaceFXHeadTrackDesiredInfluences[1] = FClamp(Look.X, 0.0000000, FaceFXHeadTrackInfluenceLimits[1]);
                FaceFXHeadTrackDesiredInfluences[2] = FClamp(Look.Y, 0.0000000, FaceFXHeadTrackInfluenceLimits[2]);
                FaceFXHeadTrackDesiredInfluences[3] = Abs(FClamp(Look.Y, FaceFXHeadTrackInfluenceLimits[3], 0.0000000));
                NextHeadTrackUpdateTime = WorldInfo.TimeSeconds + RandRange(HeadTrackUpdateIntervalRange.X, HeadTrackUpdateIntervalRange.Y);
            }
        }
        I = 0;
        J0x397:

        // End:0x40B [Loop If]
        if(I < 4)
        {
            FaceFXHeadTrackCurrentInfluences[I] = FInterpTo(FaceFXHeadTrackCurrentInfluences[I], FaceFXHeadTrackDesiredInfluences[I], DeltaTime, FaceFXHeadTrackInfluenceInterpSpeed);
            ++I;
            // [Loop Continue]
            goto J0x397;
        }
    }
    I = 0;
    J0x416:

    // End:0x5D8 [Loop If]
    if(I < 4)
    {
        J = 0;
        J0x431:

        // End:0x5CA [Loop If]
        if(J < 2)
        {
            RegName = ((J == 0) ? "eyes_" : "look_");
            switch(I)
            {
                // End:0x49F
                case 0:                    
                    RegName $= "left";
                    // End:0x509
                    break;
                // End:0x4C2
                case 1:                    
                    RegName $= "right";
                    // End:0x509
                    break;
                // End:0x4E3
                case 2:                    
                    RegName $= "up";
                    // End:0x509
                    break;
                // End:0x506
                case 3:                    
                    RegName $= "down";
                    // End:0x509
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            InfluenceIndex = (((bFaceFXHeadTrackEyesHack && J == 0) && I < 2) ? 1 - I : I);
            Mesh.SetFaceFXRegister(RegName, ((J == 0) ? FaceFXHeadTrackDesiredInfluences[InfluenceIndex] : FaceFXHeadTrackCurrentInfluences[InfluenceIndex]), 0);
            ++J;
            // [Loop Continue]
            goto J0x431;
        }
        ++I;
        // [Loop Continue]
        goto J0x416;
    }
    //return;    
}

protected function EvilTypesNative.EAnimationSetType GetDefaultAnimIndex(class<EvilDmgType_Base> DamageType, Vector HitLoc, EvilTypes.EHitDirectionType HitDir)
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 1;
    switch(HitDir)
    {
        // End:0x44
        case 1:
            AST = ((IsRunning()) ? 11 : 7);
            // End:0xD3
            break;
        // End:0x69
        case 2:
            AST = ((IsRunning()) ? 12 : 8);
            // End:0xD3
            break;
        // End:0x8E
        case 3:
            AST = ((IsRunning()) ? 13 : 9);
            // End:0xD3
            break;
        // End:0xB3
        case 4:
            AST = ((IsRunning()) ? 14 : 10);
            // End:0xD3
            break;
        // End:0xFFFF
        default:
            AST = ((IsRunning()) ? 2 : 1);
            break;
    }
    // End:0x182
    if((AST_GetAnimCount(AST)) < 1)
    {
        // End:0x176
        if((((int(AST) == int(11)) || int(AST) == int(12)) || int(AST) == int(13)) || int(AST) == int(14))
        {
            AST = 2;
            // End:0x173
            if((AST_GetAnimCount(AST)) < 1)
            {
                AST = 1;
            }            
        }
        else
        {
            AST = 1;
        }
    }
    return AST;
    //return ReturnValue;    
}

function bool CanPlayShotGunDeathAnim()
{
    return true;
    //return ReturnValue;    
}

function EvilTypesNative.EAnimationSetType OverrideGetDeathAnimIndex(EvilTypesNative.EAnimationSetType InAST, class<EvilDmgType_Base> DamageType, Vector HitLoc)
{
    return InAST;
    //return ReturnValue;    
}

function int GetDeathAnimIndex(class<EvilDmgType_Base> DamageType, Vector HitLoc)
{
    local EvilTypes.EHitDirectionType HitDirectionID;
    local EvilTypesNative.EAnimationSetType AST, DefaultAST;
    local bool bKnockBack, bShotgunAnim;
    local float Distance;

    Distance = VSize(CurrentHitInformation.EventInstigator.Pawn.Location - Location);
    bKnockBack = Distance < float(300);
    HitDirectionID = GetHitDirection();
    AST = 1;
    // End:0x1A1
    if(IsInCover())
    {
        switch(CoverType)
        {
            // End:0x19E
            case 2:
                // End:0x135
                if(bIsMirrored)
                {
                    switch(CoverAction)
                    {
                        // End:0xE4
                        case 3:
                        // End:0xF8
                        case 1:
                            AST = 190;
                            // End:0x132
                            break;
                        // End:0x10C
                        case 5:
                            AST = 1;
                            // End:0x132
                            break;
                        // End:0x120
                        case 0:
                            AST = 191;
                            // End:0x132
                            break;
                        // End:0xFFFF
                        default:
                            AST = 1;
                            // End:0x132
                            break;
                            break;
                    }                    
                }
                else
                {
                    switch(CoverAction)
                    {
                        // End:0x14D
                        case 4:
                        // End:0x161
                        case 2:
                            AST = 180;
                            // End:0x19B
                            break;
                        // End:0x175
                        case 5:
                            AST = 1;
                            // End:0x19B
                            break;
                        // End:0x189
                        case 0:
                            AST = 193;
                            // End:0x19B
                            break;
                        // End:0xFFFF
                        default:
                            AST = 1;
                            // End:0x19B
                            break;
                            break;
                    }
                }
                // End:0x1A1
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x403
        if((int(AST) == int(1)) || (AST_GetAnimCount(AST)) < 1)
        {
            // End:0x228
            if(((CanPlayShotGunDeathAnim()) && DamageType == Class'AdvDmgType_Browning') && Distance < float(500))
            {
                bShotgunAnim = true;
                bDeathAnimationWithoutMotors = true;                
            }
            else
            {
                bShotgunAnim = false;
            }
            AST = GetDefaultAnimIndex(DamageType, HitLoc, HitDirectionID);
            DefaultAST = AST;
            // End:0x2EC
            if(bShotgunAnim)
            {
                switch(HitDirectionID)
                {
                    // End:0x2AA
                    case 1:
                        AST = 182;
                        // End:0x2E9
                        break;
                    // End:0x2BE
                    case 2:
                        AST = 183;
                        // End:0x2E9
                        break;
                    // End:0x2D2
                    case 3:
                        AST = 184;
                        // End:0x2E9
                        break;
                    // End:0x2E6
                    case 4:
                        AST = 185;
                        // End:0x2E9
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }                
            }
            else
            {
                // End:0x38B
                if(bKnockBack)
                {
                    switch(HitDirectionID)
                    {
                        // End:0x320
                        case 1:
                            AST = 3;
                            // End:0x35F
                            break;
                        // End:0x334
                        case 2:
                            AST = 4;
                            // End:0x35F
                            break;
                        // End:0x348
                        case 3:
                            AST = 5;
                            // End:0x35F
                            break;
                        // End:0x35C
                        case 4:
                            AST = 6;
                            // End:0x35F
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                    // End:0x38B
                    if((AST_GetAnimCount(AST)) < 1)
                    {
                        AST = DefaultAST;
                    }
                }
            }
            AST = OverrideGetDeathAnimIndex(AST, DamageType, HitLoc);
            // End:0x403
            if((int(AST) != int(DefaultAST)) && (AST_GetAnimCount(AST)) < 1)
            {
                AST = DefaultAST;
            }
        }
        return PackRandomAnimInfo(AST);
        //return ReturnValue;        
    }
}

function int GetDeathInRailCarAnimIndex(class<EvilDmgType_Base> DamageType, Vector HitLoc)
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x1C
    if(bIsMirrored)
    {
        AST = 198;        
    }
    else
    {
        AST = 197;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function ResetAdjustMoveVelocity()
{
    bAdjustingVelocity = false;
    //return;    
}

function SetAdjustMoveVelocity(Vector Dir, float Time, float Speed)
{
    bAdjustingVelocity = true;
    AdjustVelocityDir = Dir;
    AdjustVelocitySpeed = Speed;
    SetTimer(Time, false, 'ResetAdjustMoveVelocity');
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x9F
    if(IsAliveAndWell())
    {
        // End:0x70
        if(!Mesh.bDisableFaceFX && (WorldInfo.TimeSeconds - LastRenderTime) < 1.0000000)
        {
            UpdateAutomaticHeadTracking();
        }
        // End:0x9F
        if(bAdjustingVelocity)
        {
            MoveSmooth((AdjustVelocityDir * AdjustVelocitySpeed) * DeltaTime);
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

function EvilTypesNative.EAnimationSetType TryGetHitAnimIndexPerBallisticType(EvilTypes.EHitDirectionType HitDirectionID, EvilTypes.EBodyParts BP, class<EvilDmgType_Base> EvilDamageType)
{
    local EvilTypes.EImpactTypeBallistic bt;

    // End:0x3D
    if((EvilDamageType == none) || int(EvilDamageType.default.ImpactTypeBallisticID) == int(0))
    {
        return 0;
    }
    // End:0x54
    if(int(HitDirectionID) != int(1))
    {
        return 0;
    }
    bt = EvilDamageType.default.ImpactTypeBallisticID;
    switch(BP)
    {
        // End:0xE5
        case 0:
            switch(bt)
            {
                // End:0xAF
                case 1:
                    return 129;
                // End:0xB7
                case 2:
                    return 135;
                // End:0xBF
                case 3:
                    return 141;
                // End:0xC7
                case 4:
                    return 147;
                // End:0xCF
                case 5:
                    return 153;
                // End:0xD7
                case 6:
                    return 159;
                // End:0xDF
                case 7:
                    return 165;
                // End:0xFFFF
                default:
                    // End:0x296
                    break;
                    break;
            }
        // End:0x13B
        case 1:
            switch(bt)
            {
                // End:0x105
                case 1:
                    return 130;
                // End:0x10D
                case 2:
                    return 136;
                // End:0x115
                case 3:
                    return 142;
                // End:0x11D
                case 4:
                    return 148;
                // End:0x125
                case 5:
                    return 154;
                // End:0x12D
                case 6:
                    return 160;
                // End:0x135
                case 7:
                    return 166;
                // End:0xFFFF
                default:
                    // End:0x296
                    break;
                    break;
            }
        // End:0x191
        case 2:
            switch(bt)
            {
                // End:0x15B
                case 1:
                    return 131;
                // End:0x163
                case 2:
                    return 137;
                // End:0x16B
                case 3:
                    return 143;
                // End:0x173
                case 4:
                    return 149;
                // End:0x17B
                case 5:
                    return 155;
                // End:0x183
                case 6:
                    return 161;
                // End:0x18B
                case 7:
                    return 167;
                // End:0xFFFF
                default:
                    // End:0x296
                    break;
                    break;
            }
        // End:0x1E7
        case 3:
            switch(bt)
            {
                // End:0x1B1
                case 1:
                    return 132;
                // End:0x1B9
                case 2:
                    return 138;
                // End:0x1C1
                case 3:
                    return 144;
                // End:0x1C9
                case 4:
                    return 150;
                // End:0x1D1
                case 5:
                    return 156;
                // End:0x1D9
                case 6:
                    return 162;
                // End:0x1E1
                case 7:
                    return 168;
                // End:0xFFFF
                default:
                    // End:0x296
                    break;
                    break;
            }
        // End:0x23D
        case 4:
            switch(bt)
            {
                // End:0x207
                case 1:
                    return 133;
                // End:0x20F
                case 2:
                    return 139;
                // End:0x217
                case 3:
                    return 145;
                // End:0x21F
                case 4:
                    return 151;
                // End:0x227
                case 5:
                    return 157;
                // End:0x22F
                case 6:
                    return 163;
                // End:0x237
                case 7:
                    return 169;
                // End:0xFFFF
                default:
                    // End:0x296
                    break;
                    break;
            }
        // End:0x293
        case 5:
            switch(bt)
            {
                // End:0x25D
                case 1:
                    return 134;
                // End:0x265
                case 2:
                    return 140;
                // End:0x26D
                case 3:
                    return 146;
                // End:0x275
                case 4:
                    return 152;
                // End:0x27D
                case 5:
                    return 158;
                // End:0x285
                case 6:
                    return 164;
                // End:0x28D
                case 7:
                    return 170;
                // End:0xFFFF
                default:
                    // End:0x296
                    break;
                    break;
            }
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local string FaceFXRegString;

    super.PostInitAnimTree(SkelComp);
    // End:0x1F7
    if((SkelComp == Mesh) && !SkelComp.bDisableFaceFX)
    {
        SkelComp.DeclareFaceFXRegister("eyes_left");
        SkelComp.DeclareFaceFXRegister("eyes_right");
        SkelComp.DeclareFaceFXRegister("eyes_up");
        SkelComp.DeclareFaceFXRegister("eyes_down");
        SkelComp.DeclareFaceFXRegister("look_left");
        SkelComp.DeclareFaceFXRegister("look_right");
        SkelComp.DeclareFaceFXRegister("look_up");
        SkelComp.DeclareFaceFXRegister("look_down");
        // End:0x1F3
        foreach SkelComp.FaceFXSpeechRegisterList(FaceFXRegString)
        {
            SkelComp.DeclareFaceFXRegister(FaceFXRegString);            
        }                
    }
    else
    {
        // End:0x25F
        if((CurrentWeaponAttachment != none) && SkelComp == CurrentWeaponAttachment.Mesh)
        {
            CurrentWeaponAttachment.PostInitAnimTree(SkelComp);            
        }
        else
        {
            // End:0x2C4
            if((CurrentWeaponLeftAttachment != none) && SkelComp == CurrentWeaponLeftAttachment.Mesh)
            {
                CurrentWeaponLeftAttachment.PostInitAnimTree(SkelComp);
            }
        }
    }
    //return;    
}

simulated event CacheAnimNodes()
{
    super.CacheAnimNodes();
    UpdateMovementTransitionDistances();
    //return;    
}

simulated function ClearAnimNodes()
{
    super.ClearAnimNodes();
    //return;    
}

simulated event AnimSetListUpdated()
{
    super(Pawn).AnimSetListUpdated();
    UpdateMovementTransitionDistances();
    //return;    
}

simulated function UpdateMovementTransitionDistances()
{
    local Vector Trans;
    local Quat Rot;
    local name SeqName;
    local EvilTypesNative.EAnimationSetType AST;
    local int Side, Index;
    local AnimDefInfo ADI;
    local float Dist;

    // End:0x11
    if(MoveModeNode == none)
    {
        return;
    }
    // End:0x57
    if(AnimNodeSequence(MoveModeNode.Children[4].Anim) == none)
    {        
    }
    else
    {
        SeqName = AnimNodeSequence(MoveModeNode.Children[4].Anim).AnimSeqName;
        // End:0xCC
        if(SeqName == 'None')
        {
            return;
        }
        // End:0xF8
        if(!GetTotalRootMotionForSequence(SeqName, Trans, Rot))
        {
            return;
        }
        // End:0x124
        if(!IsZero(Trans))
        {
            SlowDownDistance = VSize(Trans) + float(10);
        }
    }
    // End:0x136
    if(AnimDefArchetype == none)
    {        
    }
    else
    {
        Side = 0;
        J0x141:

        // End:0x3A0 [Loop If]
        if(Side < 6)
        {
            switch(Side)
            {
                // End:0x199
                case 3:
                    // End:0x18A
                    if((AST_GetAnimCount(78)) > 0)
                    {
                        AST = 78;                        
                    }
                    else
                    {
                        AST = 76;
                    }
                    // End:0x20C
                    break;
                // End:0x1CE
                case 2:
                    // End:0x1BF
                    if((AST_GetAnimCount(77)) > 0)
                    {
                        AST = 77;                        
                    }
                    else
                    {
                        AST = 76;
                    }
                    // End:0x20C
                    break;
                // End:0x1E2
                case 4:
                    AST = 75;
                    // End:0x20C
                    break;
                // End:0x1F6
                case 5:
                    AST = 74;
                    // End:0x20C
                    break;
                // End:0x1FA
                case 1:
                // End:0xFFFF
                default:
                    AST = 73;
                    // End:0x20C
                    break;
                    break;
            }
            // End:0x25E
            if(!AnimDefArchetype.GetAnimDefInfo(AST, ADI))
            {
                FastSpinUpDistances[Side] = 0.0000000;                
            }
            else
            {
                Index = 0;
                J0x269:

                // End:0x392 [Loop If]
                if(Index < ADI.Animations.Length)
                {
                    SeqName = ADI.Animations[Index].AnimName;
                    Dist = 0.0000000;
                    // End:0x300
                    if(SeqName == 'None')
                    {                        
                    }
                    else
                    {
                        // End:0x346
                        if(GetTotalRootMotionForSequence(SeqName, Trans, Rot))
                        {
                            Dist = VSize(Trans) + float(10);                            
                        }
                    }
                    // End:0x384
                    if(FastSpinUpDistances[Side] < Dist)
                    {
                        FastSpinUpDistances[Side] = Dist;
                    }
                    ++Index;
                    // [Loop Continue]
                    goto J0x269;
                }
            }
            ++Side;
            // [Loop Continue]
            goto J0x141;
        }
    }
    //return;    
}

simulated function OnIKStatusUpdate(optional bool bZoomIn)
{
    local AdvSkelControl_HandIK LeftIKNode, RightIKNode;

    LeftIKNode = AdvSkelControl_HandIK(LeftHandIK);
    // End:0xB3
    if(LeftIKNode != none)
    {
        LeftIKNode.bEnableRecoil = (CurrentWeaponLeftAttachment != none) && !ClassIsChildOf(CurrentWeaponLeftAttachment.WeaponClass, Class'AdvInventoryItem_Base');
        LeftIKNode.OnIKStatusUpdate(self, bZoomIn);
    }
    RightIKNode = AdvSkelControl_HandIK(RightHandIK);
    // End:0x108
    if(RightIKNode != none)
    {
        RightIKNode.OnIKStatusUpdate(self, bZoomIn);
    }
    //return;    
}

simulated event StartDriving(Vehicle V)
{
    super(UTPawn).StartDriving(V);
    // End:0xBA
    if(V.IsA('AdvTurret_Base'))
    {
        SetSprint(false);
        EvilPlayerController(Controller).StopCameraAnim(true);
        ChangeMoveMode(0);
        EvilPlayerController(Controller).IgnoreMoveInput(true);
        QuickHideCurrentWeapon();
        QuickHideCurrentWeapon(,,, true);
    }
    //return;    
}

simulated event StopDriving(Vehicle V)
{
    super(UTPawn).StopDriving(V);
    // End:0xD7
    if(Mesh != none)
    {
        // End:0xA0
        if(Mesh.AnimTreeTemplate != default.Mesh.AnimTreeTemplate)
        {
            Mesh.SetAnimTreeTemplate(default.Mesh.AnimTreeTemplate);
        }
        Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * BaseTranslationOffset);
    }
    // End:0x1CB
    if(bIsOnTurret)
    {
        StopManningTurret();
        EndQuickHideCurrentWeapon();
        EndQuickHideCurrentWeapon(,,, true);
        // End:0x18C
        if(((V != none) && int(Role) == int(ROLE_Authority)) && EvilRailCar_Base(V.Base) != none)
        {
            SetBase(V.Base);
            SetPhysics(WalkingPhysics);
        }
        SetCollisionSize(default.CylinderComponent.CollisionRadius, default.CylinderComponent.CollisionHeight);
    }
    //return;    
}

simulated event NotifyWeapQuickHideDone(EvilWeap_Base Weap)
{
    super.NotifyWeapQuickHideDone(Weap);
    // End:0xCA
    if(((AdvTurret_Base(DrivenVehicle) != none) && ((Weapon == none) || Weapon.IsA('EvilWeap_MeleeHands')) || Weapon.IsInState('QuickHide')) && (WeaponLeft == none) || WeaponLeft.IsInState('QuickHide'))
    {
        StartManningTurret();
    }
    //return;    
}

final simulated function StartManningTurret()
{
    local PlayerController PC;

    bIsOnTurret = true;
    bCanDoTurnInPlaceAnim = false;
    PC = EvilPlayerController(((Controller != none) ? Controller : ((DrivenVehicle != none) ? DrivenVehicle.Controller : none)));
    // End:0xA4
    if(PC != none)
    {
        PC.IgnoreMoveInput(false);
    }
    OnIKStatusUpdate();
    //return;    
}

final simulated function StopManningTurret()
{
    bCanDoTurnInPlaceAnim = default.bCanDoTurnInPlaceAnim;
    bIsOnTurret = false;
    OnIKStatusUpdate();
    //return;    
}

function StartFinisherAttack()
{
    ServerDoPawnAction(60, true, EvilPawn(MyEvilAI.Enemy), -1);
    //return;    
}

simulated function OnFinisherAnimBlendToMotors()
{
    // End:0x48
    if(int(PawnAction) == 61)
    {
        APA_FinisherVictim(PawnActions[int(PawnAction)]).OnFinisherAnimBlendToMotors();
        return;
    }
    super.OnFinisherAnimBlendToMotors();
    //return;    
}

simulated function OnDeathAnimBodyRest()
{
    // End:0x48
    if(int(PawnAction) == 61)
    {
        APA_FinisherVictim(PawnActions[int(PawnAction)]).OnDeathAnimBodyRest();
        return;
    }
    super.OnDeathAnimBodyRest();
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x18A
    if(((((Health > 0) && Controller != none) && AdvAIController(Controller) != none) && AdvPlayerControllerMP(EventInstigator) != none) && EventInstigator.Pawn != none)
    {
        // End:0x149
        if(AdvAIController(Controller).AssistingPlayers.Find(AdvPlayerControllerMP(EventInstigator)) == )
        {            
            AdvAIController(Controller).AssistingPlayers.AddItem(AdvPlayerControllerMP(EventInstigator));            
        }
        // End:0x174
        if(IsTimerActive('ResetAssistingList'))
        {
            ClearTimer('ResetAssistingList');
        }
        SetTimer(5.0000000, false, 'ResetAssistingList');        
    }
    else
    {
        // End:0x1C4
        if(Health <= 0)
        {
            // End:0x1C4
            if(IsTimerActive('ResetAssistingList'))
            {
                ClearTimer('ResetAssistingList');
            }
        }
    }
    //return;    
}

function ResetAssistingList()
{
    // End:0x7B
    if((Controller != none) && AdvAIController(Controller) != none)
    {
        AdvAIController(Controller).AssistingPlayers.Remove(0, AdvAIController(Controller).AssistingPlayers.Length);        
    }
    //return;    
}

function SetCanBeFinished(bool B)
{
    bCanBeFinished = B;
    //return;    
}

function bool GetCanBeFinished(EvilPawn Attacker)
{
    return (((((((self != Attacker) && IsAliveAndWell()) && !bPlayedDeath) && !IsInState('KnockedDown')) && !IsDoingPawnAction(61)) && MyEvilAI != none) && !MyEvilAI.IsFriendlyPawn(Attacker)) && bCanBeFinished;
    //return ReturnValue;    
}

function OnDoPawnAction(SeqAct_DoPawnAction Action)
{
    local EvilPawn TargetPawn;
    local int Flags;

    switch(Action.PawnActionToDo)
    {
        // End:0x1BC
        case 0:
            // End:0x1B9
            if(int(WorldInfo.NetMode) < int(NM_Client))
            {
                // End:0x121
                if(((PawnActions.Length > 60) && APA_Finisher(PawnActions[60]) != none) && APA_Finisher(PawnActions[60]).TargetPawn != none)
                {
                    TargetPawn = APA_Finisher(PawnActions[60]).TargetPawn;
                    Flags = APA_Finisher(PawnActions[60]).FinisherIndex;                    
                }
                else
                {
                    Action.PublishLinkedVariableValues();
                    TargetPawn = EvilPawn(Action.InteractionPawn);
                    Flags = Action.Flags;
                }
                ServerDoPawnAction(60, true, TargetPawn, Flags);
            }
            // End:0x24B
            break;
        // End:0x235
        case 1:
            // End:0x232
            if(int(WorldInfo.NetMode) < int(NM_Client))
            {
                Flags = Action.Flags;
                ServerDoPawnAction(19, true, TargetPawn, Flags);
            }
            // End:0x24B
            break;
        // End:0xFFFF
        default:
            super.OnDoPawnAction(Action);
            break;
    }
    //return;    
}

function EvilTypes.ESpinUpQueryResult CanFastSpinUp(int YawDelta, float DistanceSq)
{
    local EvilTypes.ESpinUpSide Side;

    // End:0x3C
    if((bIsWalking || int(CurrentMoveMode) != int(0)) || int(SupremeMoveMode) < int(2))
    {
        return 3;
    }
    Side = GetSpinUpDirection(YawDelta);
    // End:0x7E
    if(FastSpinUpDistances[int(Side)] == 0.0000000)
    {
        return 1;        
    }
    else
    {
        return ((FastSpinUpDistances[int(Side)] <= Sqrt(DistanceSq)) ? 0 : 2);
    }
    //return ReturnValue;    
}

function RequestFastSpinUp(optional int InYawDelta, optional bool InWithoutRotating, optional bool InWithoutBlendFromMovingToIdle)
{
    bFastSpinUp = true;
    PackedFastSpinUpAnimInfo = GetPackedSpinUpAnimInfoByYaw(InYawDelta);
    bFastSpinUpHasAdditiveAnim = int(UnpackASTFromAnimInfo(PackedFastSpinUpAnimInfo)) == int(73);
    //return;    
}

function RequestDefaultMovementMode()
{
    super.RequestDefaultMovementMode();
    //return;    
}

function int GetHitAnimIndex(class<EvilDmgType_Base> EvilDamageType, optional bool bKickHit = false)
{
    // End:0x3A
    if((int(CurrentMoveMode) == int(2)) && (AST_GetAnimCount(187)) > 0)
    {
        return PackRandomAnimInfo(187);
    }
    return super.GetHitAnimIndex(EvilDamageType, bKickHit);
    //return ReturnValue;    
}

function ThrowWeaponOnDeath()
{
    local Vector TossVel;

    // End:0x5D
    if(!IsRidingRailCar())
    {
        TossVel = VRand() * (GetCollisionRadius());
        // End:0x53
        if(FRand() <= GrenadeDropChance)
        {
            DropGrenadePickup(Location, TossVel);
        }
        super(Pawn).ThrowWeaponOnDeath();
    }
    //return;    
}

function bool CanBeDamagedBy(Controller EventInstigator, class<DamageType> DamageType)
{
    // End:0x6D
    if(ClassIsChildOf(WorldInfo.GetGameClass(), Class'AdvGameSurvivalBase'))
    {
        return !(MyEvilAI != none) && MyEvilAI.IsFriendly(EventInstigator);        
    }
    else
    {
        // End:0x161
        if(ClassIsChildOf(WorldInfo.GetGameClass(), Class'AdvGameTeamDeathmatchBase') && !AdvGameMP_Base(WorldInfo.Game).bTeamDamage)
        {
            return (EventInstigator.PlayerReplicationInfo.Team != Controller.PlayerReplicationInfo.Team) || Controller == EventInstigator;
        }
    }
    return super.CanBeDamagedBy(EventInstigator, DamageType);
    //return ReturnValue;    
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    super(Pawn).OnTeleport(Action);
    // End:0x5D
    if(TurnInPlaceNode != none)
    {
        TurnInPlaceNode.LastPawnYaw = Rotation.Yaw;
    }
    // End:0x13C
    if(AdvAIController(self.Controller) != none)
    {
        AdvAIController(self.Controller).SetFocalPoint(self.Location + Normal(Vector(self.Rotation)), false);
        AdvAIController(self.Controller).SetDesiredRotation(self.Rotation, false, false, 0.0000000);
    }
    //return;    
}

protected simulated function BlendMatineeAndGameAnims(bool bGameToMatinee, optional bool bZeroRootAtom)
{
    local bool bBlend;
    local AdvAnim_SkeletonSnapshot SnapshotNode;
    local SkeletonSnapshot Snapshot;
    local AnimNodeBlendByProperty BlendNode;

    bBlend = (Mesh != none) && Mesh.Animations != none;
    // End:0x87
    if(bBlend)
    {
        Snapshot = Class'AdvAnim_SkeletonSnapshot'.static.TakeSnapshotCopy(Mesh, bZeroRootAtom);
    }
    Mesh.SetAnimTreeTemplate(((bGameToMatinee) ? AIGroupAnimTreeTemplate : default.Mesh.AnimTreeTemplate));
    // End:0x1DC
    if(bBlend)
    {
        SnapshotNode = AdvAnim_SkeletonSnapshot(Mesh.FindAnimNode('SkelSnapshot'));
        BlendNode = AnimNodeBlendByProperty(Mesh.FindAnimNode('BlendBySnapshot'));
        // End:0x1DC
        if((SnapshotNode != none) && BlendNode != none)
        {
            SnapshotNode.SetSnapshot(Snapshot);
            BlendNode.SetActiveChild(int(!bGameToMatinee), 0.0000000);            
        }
    }
    StartedFallingTime = WorldInfo.TimeSeconds;
    //return;    
}

function MAT_BeginAnimControl(InterpGroup InInterpGroup)
{
    // End:0x1B
    if(AIGroupAnimTreeTemplate != none)
    {
        BlendMatineeAndGameAnims(true, true);
    }
    super(Pawn).MAT_BeginAnimControl(InInterpGroup);
    //return;    
}

function MAT_FinishAnimControl(InterpGroup InInterpGroup)
{
    local InterpGroupAI AIGroup;

    AIGroup = InterpGroupAI(InInterpGroup);
    // End:0x66
    if(AIGroupAnimTreeTemplate != none)
    {
        BlendMatineeAndGameAnims(false, (AIGroup != none) && AIGroup.SnapToRootBoneLocationWhenFinished);
    }
    super(Pawn).MAT_FinishAnimControl(InInterpGroup);
    //return;    
}

event MAT_BeginAIGroup(Vector StartLoc, Rotator StartRot)
{
    BeginAIGroup();
    bUsedByMatinee = true;
    //return;    
}

function bool PlayWarnAboutProjectile(EvilProjectile_Base Proj)
{
    // End:0x2B
    if(AdvProjectile_Dynamite_Base(Proj) != none)
    {
        return PlayWarnAboutDynamite(0.5000000);        
    }
    else
    {
        return super.PlayWarnAboutProjectile(Proj);
    }
    //return ReturnValue;    
}

simulated function SizzleAudioFinished(AudioComponent AC)
{
    //return;    
}

simulated function bool DualWieldRefireNotify(AdvWeap_Base Weap)
{
    // End:0x18C
    if(((WeaponLeft != none) && Weapon != none) && !AdvWeap_Base(WeaponLeft).SeperateOffHandFiring)
    {
        // End:0xEF
        if(((Weap == Weapon) && !AdvWeap_Base(WeaponLeft).IsMagazineEmpty()) && int(AdvWeap_Base(WeaponLeft).default.EWeaponType) == int(2))
        {
            WeaponLeft.StartFire(0);
            return true;            
        }
        else
        {
            // End:0x18C
            if(((Weap == WeaponLeft) && !AdvWeap_Base(Weapon).IsMagazineEmpty()) && int(AdvWeap_Base(Weapon).default.EWeaponType) == int(2))
            {
                Weapon.StartFire(0);
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function SetPawnRBChannels(bool bRagdollMode)
{
    // End:0x53
    if(bRagdollMode)
    {
        Mesh.SetRBChannel(16);
        Mesh.SetRBCollidesWithChannel(2, false);        
    }
    //return;    
}

simulated function DestroyMummyBolt()
{
    local editinline StaticMeshComponent SMC;

    // End:0x75
    foreach AllOwnedComponents(Class'Engine.StaticMeshComponent', SMC)
    {
        // End:0x74
        if(ClassIsChildOf(SMC.Class, Class'AdvStaticMeshComponent_Bolt'))
        {
            Mesh.DetachComponent(SMC);
        }        
    }    
    //return;    
}

simulated function OnGiveInventory(SeqAct_GiveInventory inAction)
{
    local int Idx;
    local class<Inventory> InvClass;
    local AdvPlayerController PC;

    PC = AdvPlayerController(Controller);
    // End:0x5D
    if(inAction.bClearExisting)
    {
        InvManager.DiscardInventory();
    }
    // End:0x23F
    if(inAction.InventoryList.Length > 0)
    {
        Idx = 0;
        J0x8D:

        // End:0x23C [Loop If]
        if(Idx < inAction.InventoryList.Length)
        {
            InvClass = inAction.InventoryList[Idx];
            // End:0x1E1
            if(InvClass != none)
            {
                // End:0x1B0
                if(PC.HasPreorder() && PC.GetPreorderWeaponSelectedFromProfile())
                {
                    // End:0x1A1
                    if(ClassIsChildOf(InvClass, Class'AdvWeap_Webley_Base'))
                    {
                        InvClass = class<Inventory>(FindObject("AdvGameContent.AdvWeap_Remington", Class'Core.Class'));
                    }
                    // End:0x1B0
                    if(InvClass == none)
                    {
                    }
                }
                // End:0x1DE
                if(FindInventoryType(InvClass, false) == none)
                {
                    CreateInventory(InvClass);
                }                
            }
            else
            {
                inAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
            }
            Idx++;
            // [Loop Continue]
            goto J0x8D;
        }        
    }
    else
    {
        inAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
    }
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    // End:0x36
    if(bFixedView)
    {
        out_CamLoc = FixedViewLoc;
        out_CamRot = FixedViewRot;        
    }
    else
    {
        // End:0x76
        if(!IsFirstPerson())
        {
            CalcThirdPersonCam(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);            
        }
        else
        {
            GetActorEyesViewPoint(out_CamLoc, out_CamRot);
        }
        // End:0xED
        if(EvilWeap_Base(Weapon) != none)
        {
            EvilWeap_Base(Weapon).WeaponCalcCamera(fDeltaTime, out_CamLoc, out_CamRot);
        }
        // End:0x148
        if(EvilWeap_Base(WeaponLeft) != none)
        {
            EvilWeap_Base(WeaponLeft).WeaponCalcCamera(fDeltaTime, out_CamLoc, out_CamRot);
        }
    }
    return true;
    //return ReturnValue;    
}

function DeactivateSpawnProtection()
{
    // End:0x17
    if(IsPlayerOwned())
    {
        super(UTPawn).DeactivateSpawnProtection();
    }
    //return;    
}

simulated function ChangeSizzleSound(optional SoundCue SC)
{
    local bool bIsPlaying;

    // End:0x38
    if(SC == none)
    {
        SC = default.SizzleSoundComponent.SoundCue;
    }
    bIsPlaying = SizzleSoundComponent.IsPlaying();
    // End:0xE2
    if(SizzleSoundComponent.SoundCue != SC)
    {
        SizzleSoundComponent.SoundCue = SC;
        // End:0xE2
        if(bIsPlaying)
        {
            SizzleSoundComponent.Play();
        }
    }
    //return;    
}

simulated function bool IsInDemonMode()
{
    return false;
    //return ReturnValue;    
}

simulated function SetDemonMode(bool bTurnOn)
{
    //return;    
}

simulated function ApplyPlayDyingRagdollImpulse(Vector ShotDir, Vector HitLocation, name BoneName, class<EvilDmgType_Base> DamageType)
{
    local Vector ApplyImpulse;
    local bool isExplosionDmg;

    ApplyImpulse = ComputeDeathRagdollImpulse(ShotDir, DamageType, false);
    isExplosionDmg = ((ClassIsChildOf(DamageType, Class'AdvDmgType_Grenade') || ClassIsChildOf(DamageType, Class'AdvDmgType_Dynamite')) || ClassIsChildOf(DamageType, Class'AdvDmgType_BarrelExplosion')) || ClassIsChildOf(DamageType, Class'AdvDmgType_Leuchpistol');
    // End:0xB5
    if(isExplosionDmg)
    {
        BoneName = HipsBoneName;
    }
    Mesh.AddImpulse(ApplyImpulse, HitLocation, BoneName, false);
    //return;    
}

state FinisherVictim
{
    ignores TakeDamage, TornOff;
    stop;    
}

simulated state Finisher
{
    ignores TakeDamage;
    stop;    
}

defaultproperties
{
    bShouldPlayFullBodyHit=true
    bCheckAnimDef=true
    bCanBeFinished=true
    MaxEnemyCount=5
    // Reference: SkeletalMeshComponent'Default__AdvPawn.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn.WPawnSkeletalMeshComponent'
        bRootMotionModeChangeNotify=true
        bHasPhysicsAssetInstance=true
        bPerBoneMotionBlur=true
        RootMotionMode=ERootMotionMode.RMM_Velocity
        Materials=/* Array type was not detected. */
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_Foreground
        RBChannel=ERBCollisionChannel.RBCC_Pawn
        bUseOnePassLightingOnTranslucency=true
        CollideActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        RBCollideWithChannels=(Default=true,Pawn=true,EffectPhysics=true,SoftBody=true,FracturedMeshPart=true,BlockingVolume=true)
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    HeadTrackUpdateIntervalRange=(X=0.5000000,Y=2.0000000)
    FaceFXHeadTrackBaseBone="Spine1"
    FaceFXHeadTrackLookAtAxis=EAxis.AXIS_Y
    FaceFXHeadTrackWeightScale=(X=1.5000000,Y=1.0000000)
    FaceFXHeadTrackWeightBias=(X=0.0000000,Y=-0.2000000)
    FaceFXHeadTrackInfluenceInterpSpeed=6.0000000
    FaceFXHeadTrackInfluenceLimits[0]=-1.0000000
    FaceFXHeadTrackInfluenceLimits[1]=1.0000000
    FaceFXHeadTrackInfluenceLimits[2]=1.0000000
    FaceFXHeadTrackInfluenceLimits[3]=-1.0000000
    RequiredAST[0]=false
    RequiredAST[1]=true
    RequiredAST[2]=false
    RequiredAST[3]=false
    RequiredAST[4]=false
    RequiredAST[5]=false
    RequiredAST[6]=false
    RequiredAST[7]=false
    RequiredAST[8]=false
    RequiredAST[9]=false
    RequiredAST[10]=false
    RequiredAST[11]=false
    RequiredAST[12]=false
    RequiredAST[13]=false
    RequiredAST[14]=false
    RequiredAST[15]=false
    RequiredAST[16]=false
    RequiredAST[17]=false
    RequiredAST[18]=false
    RequiredAST[19]=false
    RequiredAST[20]=false
    RequiredAST[21]=false
    RequiredAST[22]=true
    RequiredAST[23]=false
    RequiredAST[24]=false
    RequiredAST[25]=false
    RequiredAST[26]=false
    RequiredAST[27]=false
    RequiredAST[28]=false
    RequiredAST[29]=false
    RequiredAST[30]=false
    RequiredAST[31]=false
    RequiredAST[32]=false
    RequiredAST[33]=false
    RequiredAST[34]=false
    RequiredAST[35]=false
    RequiredAST[36]=false
    RequiredAST[37]=false
    RequiredAST[38]=true
    RequiredAST[39]=false
    RequiredAST[40]=false
    RequiredAST[41]=false
    RequiredAST[42]=false
    RequiredAST[43]=false
    RequiredAST[44]=false
    RequiredAST[45]=false
    RequiredAST[46]=false
    RequiredAST[47]=false
    RequiredAST[48]=false
    RequiredAST[49]=false
    RequiredAST[50]=false
    RequiredAST[51]=false
    RequiredAST[52]=false
    RequiredAST[53]=false
    RequiredAST[54]=false
    RequiredAST[55]=false
    RequiredAST[56]=false
    RequiredAST[57]=false
    RequiredAST[58]=false
    RequiredAST[59]=false
    RequiredAST[60]=false
    RequiredAST[61]=false
    RequiredAST[62]=false
    RequiredAST[63]=false
    RequiredAST[64]=false
    RequiredAST[65]=false
    RequiredAST[66]=false
    RequiredAST[67]=true
    RequiredAST[68]=false
    RequiredAST[69]=true
    RequiredAST[70]=true
    RequiredAST[71]=false
    RequiredAST[72]=false
    RequiredAST[73]=false
    RequiredAST[74]=false
    RequiredAST[75]=false
    RequiredAST[76]=false
    RequiredAST[77]=false
    RequiredAST[78]=false
    RequiredAST[79]=false
    RequiredAST[80]=false
    RequiredAST[81]=false
    RequiredAST[82]=false
    RequiredAST[83]=false
    RequiredAST[84]=false
    RequiredAST[85]=false
    RequiredAST[86]=false
    RequiredAST[87]=false
    RequiredAST[88]=false
    RequiredAST[89]=false
    RequiredAST[90]=false
    RequiredAST[91]=false
    RequiredAST[92]=false
    RequiredAST[93]=false
    RequiredAST[94]=false
    RequiredAST[95]=false
    RequiredAST[96]=false
    RequiredAST[97]=false
    RequiredAST[98]=false
    RequiredAST[99]=false
    RequiredAST[100]=false
    RequiredAST[101]=false
    RequiredAST[102]=false
    RequiredAST[103]=false
    RequiredAST[104]=false
    RequiredAST[105]=false
    RequiredAST[106]=false
    RequiredAST[107]=false
    RequiredAST[108]=true
    RequiredAST[109]=false
    RequiredAST[110]=false
    RequiredAST[111]=false
    RequiredAST[112]=false
    RequiredAST[113]=false
    RequiredAST[114]=false
    RequiredAST[115]=false
    RequiredAST[116]=false
    RequiredAST[117]=false
    RequiredAST[118]=false
    RequiredAST[119]=false
    RequiredAST[120]=false
    RequiredAST[121]=false
    RequiredAST[122]=false
    RequiredAST[123]=false
    RequiredAST[124]=false
    RequiredAST[125]=false
    RequiredAST[126]=false
    RequiredAST[127]=false
    RequiredAST[128]=false
    RequiredAST[129]=false
    RequiredAST[130]=false
    RequiredAST[131]=false
    RequiredAST[132]=false
    RequiredAST[133]=false
    RequiredAST[134]=false
    RequiredAST[135]=false
    RequiredAST[136]=false
    RequiredAST[137]=false
    RequiredAST[138]=false
    RequiredAST[139]=false
    RequiredAST[140]=false
    RequiredAST[141]=false
    RequiredAST[142]=false
    RequiredAST[143]=false
    RequiredAST[144]=false
    RequiredAST[145]=false
    RequiredAST[146]=false
    RequiredAST[147]=false
    RequiredAST[148]=false
    RequiredAST[149]=false
    RequiredAST[150]=false
    RequiredAST[151]=false
    RequiredAST[152]=false
    RequiredAST[153]=false
    RequiredAST[154]=false
    RequiredAST[155]=false
    RequiredAST[156]=false
    RequiredAST[157]=false
    RequiredAST[158]=false
    RequiredAST[159]=false
    RequiredAST[160]=false
    RequiredAST[161]=false
    RequiredAST[162]=false
    RequiredAST[163]=false
    RequiredAST[164]=false
    RequiredAST[165]=false
    RequiredAST[166]=false
    RequiredAST[167]=false
    RequiredAST[168]=false
    RequiredAST[169]=false
    RequiredAST[170]=false
    RequiredAST[171]=false
    RequiredAST[172]=false
    RequiredAST[173]=false
    RequiredAST[174]=false
    RequiredAST[175]=false
    RequiredAST[176]=false
    RequiredAST[177]=false
    RequiredAST[178]=false
    RequiredAST[179]=false
    RequiredAST[180]=false
    RequiredAST[181]=false
    RequiredAST[182]=false
    RequiredAST[183]=false
    RequiredAST[184]=false
    RequiredAST[185]=false
    RequiredAST[186]=false
    RequiredAST[187]=false
    RequiredAST[188]=false
    RequiredAST[189]=false
    RequiredAST[190]=false
    RequiredAST[191]=false
    RequiredAST[192]=false
    RequiredAST[193]=false
    RequiredAST[194]=false
    RequiredAST[195]=false
    RequiredAST[196]=false
    RequiredAST[197]=false
    RequiredAST[198]=false
    RequiredAST[199]=false
    RequiredAST[200]=false
    RequiredAST[201]=false
    RequiredAST[202]=false
    RequiredAST[203]=false
    RequiredAST[204]=false
    RequiredAST[205]=false
    RequiredAST[206]=false
    RequiredAST[207]=false
    RequiredAST[208]=false
    AIGroupAnimTreeTemplate=AnimTree'an_human.AnimTree.AT_Cutscene'
    // Reference: AudioComponent'Default__AdvPawn.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0 class=Class'Engine.AudioComponent'
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    MummyBoltLifeTime=3.0000000
    HandsClass=Class'AdvWeap_MeleeHands'
    MeleeKickWeapClass=Class'AdvWeap_MeleeKick'
    BurnEffectPS=ParticleSystem'ps_Fire.Effects.ps_ch_Burning'
    PawnActionClasses=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    HeadBone="Head"
    // Reference: UTAmbientSoundComponent'Default__AdvPawn.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    InventoryManagerClass=Class'AdvInventoryManager'
    // Reference: EvilAudioComponent'Default__AdvPawn.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=PawnBlocker0
    Components[7]=FaceAudioComponent
    Components[8]=SPawnSkeletalMeshComponent
    Components[9]=SizzleAudioComponent0
    CollisionComponent=CollisionCylinder
}