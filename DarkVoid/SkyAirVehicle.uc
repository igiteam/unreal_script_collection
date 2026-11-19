class SkyAirVehicle extends SkyVehicle
    native
    config(Game);

enum ETerrainCollisionSource
{
    Terrain_None,                   // 0
    Terrain_Above,                  // 1
    Terrain_Below,                  // 2
    Terrain_Right,                  // 3
    Terrain_Left,                   // 4
    Terrain_MAX                     // 5
};

enum EVehicleTakeoffType
{
    ETAKEOFF_Ground,                // 0
    ETAKEOFF_Battleship,            // 1
    ETAKEOFF_MAX                    // 2
};

enum EVehicleLandingState
{
    ELANDING_Landed,                // 0
    ELANDING_Interp,                // 1
    ELANDING_Anim,                  // 2
    ELANDING_MAX                    // 3
};

enum ECockpitState
{
    Cockpit_Closed,                 // 0
    Cockpit_Opening,                // 1
    Cockpit_Open,                   // 2
    Cockpit_Closing,                // 3
    Cockpit_MAX                     // 4
};

enum ESkyAirVehicleState
{
    SKY_AVSTATE_Unoccupied,         // 0
    SKY_AVSTATE_Landed,             // 1
    SKY_AVSTATE_TakingOff,          // 2
    SKY_AVSTATE_Flying,             // 3
    SKY_AVSTATE_Landing,            // 4
    SKY_AVSTATE_MAX                 // 5
};

struct native s_PilotChatter
{
    var() SoundCue VO_TakingDamage;
    var() SoundCue VO_TargetedEnemy;
    var() SoundCue VO_Taunts;
    var() SoundCue VO_Evading;
    var() SoundCue VO_DestroyedTarget;
    var() SoundCue VO_Acquiringtarget;
    var() SoundCue VO_Attacking;
    var() SoundCue VO_TargetedRocketPack;
    var() SoundCue VO_LostVisual;

    structdefaultproperties
    {
        VO_TakingDamage=none
        VO_TargetedEnemy=none
        VO_Taunts=none
        VO_Evading=none
        VO_DestroyedTarget=none
        VO_Acquiringtarget=none
        VO_Attacking=none
        VO_TargetedRocketPack=none
        VO_LostVisual=none
    }
};

struct native MaterialRefEffect
{
    var() name MaterialType;
    var() ParticleSystem ParticleTemplate;
    var() SoundCue Sound;

    structdefaultproperties
    {
        MaterialType="None"
        ParticleTemplate=none
        Sound=none
    }
};

struct native s_TurnAroundVolumeData
{
    var SkyTurnAroundVolume Vol;
    var Vector HitNormal;

    structdefaultproperties
    {
        Vol=none
        HitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native AirVehicleVolume
{
    var Volume Vol;
    var bool bHitThisFrame;

    structdefaultproperties
    {
        Vol=none
        bHitThisFrame=false
    }
};

var(PilotChatterSounds) s_PilotChatter PilotChatter;
var int PredictionSetupRefCount;
var transient bool bFakeRigidBody;
var bool ForceRoll;
var transient bool bTargetLocationDelay;
var repnotify bool bFlying;
var transient bool bTakeoff;
var bool bIsBoosting;
var transient bool bHijackChangingDrivers;
var(Hijack) bool bHijackable;
var(Hijack) bool bFadeToBlackHijack;
var bool bHasHijacker;
var transient bool bBeenHijacked;
var bool bNoRagdollOnDriverLeave;
var repnotify transient bool bPropsOn;
var bool ShouldLoopThrottle;
var bool bBoosting;
var bool bHovering;
var bool ModCollisionPos;
var bool ModCollisionRot;
var bool bIsCritical;
var transient bool bDisableSpecialManeuver;
var(SpecialManeuvers) bool bAllowSpecialMoves;
var(SpecialManeuvers) bool bCanHover;
var transient bool bOverrideThrottle;
var() bool bBrakeDuringExitAnim;
var bool bBrakingOnExit;
var bool bShouldHover;
var transient bool bFlyingUnmanned;
var() bool bShowRadar;
var(PropWash) bool bUsePropWash;
var(PropWash) bool bPropWashPlayerOnly;
var bool bUseTakeOffPropWash;
var(Shield) bool HijackShieldPreventsHijack;
var(Sounds) bool bAutoPlayEngineLoop;
var bool bTurningAroundFromVolume;
var float AIHitBoxWidth;
var float AIHitBoxReductionCharging;
var(SkyAI) float AINoseOffset;
var float SlowDownTurnThrottleRatio;
var float TurnSlowDownDotLimit;
var float AICruisingAltHitBoxHeight;
var float AICruisingAltHitBoxWidth;
var float AICruisingAltHitBoxLength;
var float AICruisingAltHitBoxLookAhead;
var float AIStraightForwardCollMult;
var float AIForwardConeCollMult;
var float AISideConeCollMult;
var float AIBackwardConeCollMult;
var float AIStraightBackCollMult;
var float CruisingAltitude;
var float CurrentMaxSpeed;
var int ForceRollValue;
var float LastFrameSteerTime;
var transient Vector LocationBeforeSpecialManeuver;
var transient Vector VelocityBeforeSpecialManeuver;
var transient int CurrentCollisionPredictionStage;
var() float LargestSpecialManueverCollisionCheckRadius;
var transient float LastDeltaYaw;
var transient float LastDeltaPitch;
var(ProgrammerDebug) float SteeringScalar;
var(ProgrammerDebug) float RiseScalar;
var(ProgrammerDebug) float DesiredChangeInRotationScalar;
var float DiveIntensity;
var const float MaxDiveIntensity;
var() float HardSoftRollInTurn;
var() int MaxSoftRollInTurn;
var() int MinHardRollInTurn;
var() int MaxHardRollInTurn;
var() int RollInTurnRate;
var() int RollInTurnArbitraryEaseNumber;
var transient int RollFromTurn;
var() name RollBoneName;
var int RollBoneIndex;
var transient Vector LastRootPosition;
var transient float RootVelocity;
var float LastCurVel;
var transient SkyPawn PotentialHijacker;
var(Health) float MinHealthPercentOnDriverEnter;
var(Hijack) float HJ_TimeUntilFadeToBlack;
var(Hijack) float HJ_TimeOfFadeToBlack;
var(Hijack) float HJ_TimeOfBlack;
var(Hijack) float HJ_TimeOfFadeFromBlack;
var(Hijack) array<name> HijackSockets;
var(Hijack) float ScramFromHijackForce;
var(Props) array<name> PropControlNames;
var(Props) export editinline array<export editinline MeshComponent> Props;
var(Props) name PropSpeedParamName;
var(Sounds) array<SoundCue> PropSounds;
var array<SkelControlBase> PropControls;
var array<MaterialInstanceConstant> PropMatInst1;
var array<MaterialInstanceConstant> PropMatInst2;
var export editinline array<export editinline AudioComponent> PropSoundComponents;
var(Sounds) export editinline AudioComponent ThrottleSound;
var(Sounds) export editinline AudioComponent ThrottleSoundLoop;
var(Sounds) export editinline AudioComponent BrakeSound;
var(Sounds) export editinline AudioComponent DiveSound;
var(Sounds) export editinline AudioComponent IdleSound;
var array<name> LeftBoostControl;
var array<name> RightBoostControl;
var float LastLeftBoostFlapValue;
var float LastRightBoostFlapValue;
var array<SkelControlSingleBone> LeftBoostSkel;
var array<SkelControlSingleBone> RightBoostSkel;
var SkelControlSingleBone RollFromTurnSkel;
var SkelControlSingleBone StabilizerSkel;
var() ViewShakeInfo BoostShake;
var() editinline ForceFeedbackWaveform BoostFFeedback;
var(Collisions) ViewShakeInfo CollisionShake;
var(Collisions) editinline ForceFeedbackWaveform CollisionFFeedback;
var(CloseCall) float CloseCall_MinRelativeSpeedMPH;
var(CloseCall) float CloseCall_MaxDistance;
var(CloseCall) ViewShakeInfo CloseCallShake;
var(CloseCall) editinline ForceFeedbackWaveform CloseCallFFeedback;
var(CloseCall) float CloseCall_SleepTime;
var float FreezeCollisionDamage;
var(Collisions) float FreezeCollisionDamagePtP;
var(Collisions) float FreezeCollisionDamageTerrain;
var(Collisions) float InstantDeathAngle;
var(Collisions) float InstantDeathAngleBraking;
var(Collisions) float InstantDeathAngleBoosting;
var(Collisions) float InstantDeathFreeze;
var(Collisions) float InstantDeathDamage;
var float FreezeCollision;
var(Collisions) float FreezeCollisionPtP;
var(Collisions) float FreezeCollisionTerrain;
var float NoExitFromCollision;
var(Collisions) float FreezeExitPtP;
var(Collisions) float FreezeExitTerrain;
var(Collisions) float CollisionSlerpTime;
var(Collisions) class<DamageType> CollisionDmgType;
var class<DamageType> CollisionDmgTypeOverRide;
var float CurrentCollisionSpeedModifier;
var(Collisions) float CollisionSpeedModifier;
var(Collisions) float CollisionSpeedRampOutTime;
var float CollisionSpeedRampOutTimer;
var(Collisions) float CollisionSpeedRampOutTimeLimitMultiplier;
var transient Vector CollisionVelocity;
var string DebugInfoText0;
var string DebugInfoText1;
var string DebugInfoText2;
var string DebugInfoText3;
var transient Actor CollisionBuddy;
var float CollisionDamageMultPlaneToPlane;
var int DelayedCollisionDamage;
var deprecated int DelayedCollisionDamageValue;
var(Collisions) int DelayedCollisionDamageValuePtP;
var(Collisions) int DelayedCollisionDamageValueTerrain;
var(Collisions) int DelayedCollisionDamageValueTerrainBraking;
var(Collisions) int DelayedCollisionDamageValueTerrainBoosting;
var Vector CollisionLoc;
var Rotator CollisionRot;
var Quat OldCollisionRotQuat;
var float CollisionRotSlerpTime;
var Vector CollisionNormal;
var Vector CollisionContactPoint;
var PhysicalMaterial CollisionPhysMat;
var SkyAirVehicle.ETerrainCollisionSource LastTerrainCollisionSource;
var SkyAirVehicle.EVehicleTakeoffType TakeoffType;
var deprecated SkyAirVehicle.EVehicleLandingState LandingState;
var transient SkyAirVehicle.ECockpitState CockpitState;
var SkyAirVehicle.ESkyAirVehicleState AirVehicleState;
var float SpecialManeuverFuelCur;
var(SpecialManeuvers) float SpecialManeuverFuelMax;
var(SpecialManeuvers) float SpecialManeuverFuelRegenPerSecond;
var(SpecialManeuvers) float SpecialManeuverFuelRegenDelay;
var float SpecialManeuverFuelRegenDelayCur;
var(SpecialManeuvers) float SpecialManeuverFuelRegenDelaySpecialMove;
var(SpecialManeuvers) float SpecialManeuverFuelCriticalPercent;
var(SpecialManeuvers) name SpinOutSpecialManeuver;
var(SpecialManeuvers) float BoostFuelCost;
var(SpecialManeuvers) float HoverFuelCost;
var(SpecialManeuvers) float SpecialManeuverSensitivity;
var transient float OverrideThrottleSetting;
var() float MagneticAmplification;
var Vector SpecialManeuverVelocity;
var Vector SpecialManeuverAcceleration;
var deprecated SkyVolumeLanding LandingVolume;
var Vector LandingLocation;
var Rotator LandingRotation;
var Rotator LandingStartRotation;
var SkyVehicleFactory_AirVehicles DockedFactory;
var SkyInteractor_LandAirVehicle LandingTarget;
var transient Pawn OldPilot;
var transient float EjectCollisionFreezeTime;
var(PropWash) name PropWashTraceSocket;
var(PropWash) float TraceDistance;
var(PropWash) array<MaterialRefEffect> PropWashEffects;
var(PropWash) MaterialRefEffect DefaultPropWashEffect;
var export editinline ParticleSystemComponent PropWashPSC;
var export editinline AudioComponent PropWashAC;
var(PropWash) array<MaterialRefEffect> TakeOffPropWashEffects;
var(PropWash) MaterialRefEffect DefaultTakeOffPropWashEffect;
var export editinline ParticleSystemComponent TakeOffPropWashPSC;
var(Cockpit) float CockpitOpeningTime;
var(Cockpit) float CockpitClosingTime;
var(Shield) export editinline SkeletalMeshComponent ShieldSkelMeshComp;
var(Shield) float HijackShieldHealth;
var(Shield) name ShieldSocket;
var const float InteractionCheckPeriod;
var transient float InteractionCheckTimer;
var array<s_TurnAroundVolumeData> TurnAroundVolumeList;
var Vector LastFramePos;
var int MovementDisabledRefCount;
var() float TimeUntilRampMovingLevelVelOut;
var() float TimeToRampMovingLevelVelOut;
var float TimerUntilRampMovingLevelVelOut;
var float TimerToRampMovingLevelVelOut;
var Vector MovingLevelVel;
var(Hijack) protectedwrite SkyPawn HijackDriverArchetype;
var array<AirVehicleVolume> EncompassingVolumes;
var transient float ImpactDamage;
var transient float ImpactMomentum;
var transient Vector ImpactMomentumVect;
var transient Actor ImpactActor;
var(Collisions) float ImpactDamageScaling;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        RollFromTurn, bFlying, 
        bHasHijacker, bPropsOn, 
        bTakeoff;
}

// Export USkyAirVehicle::execOverrideThrottleEnd(FFrame&, void* const)
native function OverrideThrottleEnd();

// Export USkyAirVehicle::execSpawnDriverForHijackInteraction(FFrame&, void* const)
native function SpawnDriverForHijackInteraction();

// Export USkyAirVehicle::execOpenCockpit(FFrame&, void* const)
native function OpenCockpit(optional bool immediate);

// Export USkyAirVehicle::execCloseCockpit(FFrame&, void* const)
native function CloseCockpit(optional bool immediate);

// Export USkyAirVehicle::execOpenCockpitTimer(FFrame&, void* const)
native function OpenCockpitTimer();

// Export USkyAirVehicle::execCloseCockpitTimer(FFrame&, void* const)
native function CloseCockpitTimer();

// Export USkyAirVehicle::execSetStalled(FFrame&, void* const)
native function SetStalled(bool bOn);

// Export USkyAirVehicle::execMoveVehicleAwayFromHijackArea(FFrame&, void* const)
native function MoveVehicleAwayFromHijackArea();

// Export USkyAirVehicle::execCalculateGasForMPH(FFrame&, void* const)
native function float CalculateGasForMPH(float MPH);

// Export USkyAirVehicle::execIsDirectionUnobstructed(FFrame&, void* const)
native final function bool IsDirectionUnobstructed(const Rotator requiredRotation, float fDistanceToCheck);

// Export USkyAirVehicle::execCalculateLookAheadDist(FFrame&, void* const)
native final function float CalculateLookAheadDist();

// Export USkyAirVehicle::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(Actor RequestedBy, optional bool bRequestAlternateLoc);

// Export USkyAirVehicle::execForceFlying(FFrame&, void* const)
native function ForceFlying();

// Export USkyAirVehicle::execGetTargetVelocity(FFrame&, void* const)
native simulated function Vector GetTargetVelocity();

simulated event ReplicatedEvent(name VarName)
{
    // End:0x30
    if(VarName == 'bFlying')
    {
        // End:0x30
        if(Mesh != none)
        {
            Mesh.bForceDiscardRootMotion = false;
        }
    }
    // End:0x66
    if(VarName == 'bPropsOn')
    {
        // End:0x59
        if(bPropsOn)
        {
            StartProps();            
        }
        else
        {
            StopProps();
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function GetSVehicleDebug(out array<string> DebugInfo)
{
    super(SkyGameVehicle).GetSVehicleDebug(DebugInfo);
    // End:0x171
    if(SimObj != none)
    {
        DebugInfo[DebugInfo.Length] = "--- Air Vehicle State ---";
        // End:0x6A
        if(int(AirVehicleState) == int(0))
        {
            DebugInfo[DebugInfo.Length] = "Unoccupied";            
        }
        else
        {
            // End:0x92
            if(int(AirVehicleState) == int(1))
            {
                DebugInfo[DebugInfo.Length] = "Landed";                
            }
            else
            {
                // End:0xBE
                if(int(AirVehicleState) == int(2))
                {
                    DebugInfo[DebugInfo.Length] = "Taking Off";                    
                }
                else
                {
                    // End:0xE6
                    if(int(AirVehicleState) == int(3))
                    {
                        DebugInfo[DebugInfo.Length] = "Flying";                        
                    }
                    else
                    {
                        // End:0x10C
                        if(int(AirVehicleState) == int(4))
                        {
                            DebugInfo[DebugInfo.Length] = "Landing";
                        }
                    }
                }
            }
        }
        DebugInfo[DebugInfo.Length] = "--- SimObj ---";
        DebugInfo[DebugInfo.Length] = DebugInfoText0;
        DebugInfo[DebugInfo.Length] = DebugInfoText1;
        DebugInfo[DebugInfo.Length] = DebugInfoText2;
        DebugInfo[DebugInfo.Length] = DebugInfoText3;
    }
    //return;    
}

simulated function ImpactActorDamage()
{
    local TraceHitInfo TraceHitDummy;

    // End:0xB8
    if(ImpactActor != none)
    {
        ImpactActor.TakeDamage(int(ImpactDamage * ImpactDamageScaling), Controller, Location, ImpactMomentumVect, Class'SkyDmgType_Collision', TraceHitDummy, self);
        // End:0xB8
        if((SkyPawn(ImpactActor) != none) && SkyPawn(ImpactActor).Health <= 0)
        {
            SkyPawn(ImpactActor).Mesh.AddImpulse(ImpactMomentumVect * 0.1000000, Location, SkyPawn(ImpactActor).CollisionAnchorBone);
        }
    }
    //return;    
}

simulated function ImpactRadialDamage()
{
    HurtRadius(ImpactDamage * ImpactDamageScaling, VSize(CollisionComponent.Bounds.BoxExtent), 0.0000000, Class'SkyDmgType_Collision', ImpactMomentum, Location, self);
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;
    local name Bone;
    local SkelControlBase propControl;

    super.PostBeginPlay();
    SpecialManeuverFuelCur = SpecialManeuverFuelMax;
    I = 0;
    J0x18:

    // End:0x6F [Loop If]
    if(I < LeftBoostControl.Length)
    {
        LeftBoostSkel[I] = SkelControlSingleBone(Mesh.FindSkelControl(LeftBoostControl[I]));
        // End:0x65
        if(LeftBoostSkel[I] == none)
        {
        }
        ++I;
        // [Loop Continue]
        goto J0x18;
    }
    I = 0;
    J0x76:

    // End:0xCD [Loop If]
    if(I < LeftBoostControl.Length)
    {
        RightBoostSkel[I] = SkelControlSingleBone(Mesh.FindSkelControl(RightBoostControl[I]));
        // End:0xC3
        if(RightBoostSkel[I] == none)
        {
        }
        ++I;
        // [Loop Continue]
        goto J0x76;
    }
    // End:0x387
    if((PropControlNames.Length > 0) && PropControlNames.Length == Props.Length)
    {
        PropControls.Insert(0, PropControlNames.Length);
        PropSoundComponents.Insert(0, PropControlNames.Length);
        I = 0;
        J0x10D:

        // End:0x387 [Loop If]
        if(I < PropControlNames.Length)
        {
            // End:0x37D
            if(Props[I] != none)
            {
                propControl = PropControls[I];
                GetSkelControlAndBone(PropControlNames[I], propControl, Bone);
                PropControls[I] = propControl;
                // End:0x2FC
                if(PropControls[I] != none)
                {
                    Mesh.AttachComponent(Props[I], Bone);
                    // End:0x2FC
                    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bDeleteMe)
                    {
                        PropMatInst1[I] = new (Outer) Class'Engine.MaterialInstanceConstant';
                        PropMatInst2[I] = new (Outer) Class'Engine.MaterialInstanceConstant';
                        PropMatInst1[I].SetParent(Props[I].GetMaterial(0));
                        PropMatInst2[I].SetParent(Props[I].GetMaterial(1));
                        Props[I].SetMaterial(0, PropMatInst1[I]);
                        Props[I].SetMaterial(1, PropMatInst2[I]);
                        PropMatInst1[I].SetScalarParameterValue(PropSpeedParamName, 0.0000000);
                        PropMatInst2[I].SetScalarParameterValue(PropSpeedParamName, 0.0000000);
                    }
                }
                // End:0x37D
                if((I < PropSounds.Length) && PropSounds[I] != none)
                {
                    PropSoundComponents[I] = new (Outer) Class'Engine.AudioComponent';
                    Mesh.AttachComponent(PropSoundComponents[I], Bone);
                    PropSoundComponents[I].SoundCue = PropSounds[I];
                }
            }
            ++I;
            // [Loop Continue]
            goto J0x10D;
        }
    }
    RollFromTurnSkel = SkelControlSingleBone(Mesh.FindSkelControl('RollFromTurn'));
    StabilizerSkel = SkelControlSingleBone(Mesh.FindSkelControl('Stabilizer'));
    // End:0x3E7
    if(Driver == none)
    {
        StopProps();        
    }
    else
    {
        StartProps();
    }
    LastFrameSteerTime = WorldInfo.TimeSeconds;
    // End:0x426
    if(BrakeSound.Owner == none)
    {
        AttachComponent(BrakeSound);
    }
    // End:0x453
    if(ShieldSocket != 'None')
    {
        Mesh.AttachComponentToSocket(ShieldSkelMeshComp, ShieldSocket);
    }
    //return;    
}

simulated event Destroyed()
{
    // End:0x2E
    if((IsBeingHijacked()) && PotentialHijacker != none)
    {
        PotentialHijacker.AbortHijacking();
    }
    super(SkyGameVehicle).Destroyed();
    //return;    
}

// Export USkyAirVehicle::execStartProps(FFrame&, void* const)
native function StartProps();

// Export USkyAirVehicle::execStopProps(FFrame&, void* const)
native function StopProps();

// Export USkyAirVehicle::execUpdateProps(FFrame&, void* const)
native function UpdateProps();

// Export USkyAirVehicle::execGetSkelControlAndBone(FFrame&, void* const)
native function GetSkelControlAndBone(name ControlName, out SkelControlBase SkelControl, out name BoneName);

// Export USkyAirVehicle::execGetAdjustedFocalPoint(FFrame&, void* const)
native function Vector GetAdjustedFocalPoint(Actor Focus);

// Export USkyAirVehicle::execDoCollisionPrediction(FFrame&, void* const)
native function bool DoCollisionPrediction(float DeltaSeconds);

// Export USkyAirVehicle::execSetLandingTarget(FFrame&, void* const)
native function SetLandingTarget(SkyInteractor_LandAirVehicle Target);

// Export USkyAirVehicle::execLand(FFrame&, void* const)
native function Land(SkyInteractor_LandAirVehicle Target);

simulated event Takeoff()
{
    local int I;

    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        ClientTakeoff();
    }
    bTakeoff = true;
    SetPhysics(10);
    I = 0;
    J0x2E:

    // End:0x54 [Loop If]
    if(I < Wheels.Length)
    {
        SetWheelCollision(I, false);
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    // End:0x77
    if(DockedFactory != none)
    {
        DockedFactory.DockedVehicle = none;
        DockedFactory = none;
    }
    bUseTakeOffPropWash = true;
    SetAirVehicleState(2);
    VehicleEvent('EngineStart');
    // End:0xBB
    if(Mesh != none)
    {
        Mesh.bForceDiscardRootMotion = false;
    }
    bFlying = true;
    bNetDirty = true;
    bShouldHover = false;
    //return;    
}

reliable client simulated function ClientTakeoff()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        Takeoff();
    }
    //return;    
}

simulated function TargetLocationDelay()
{
    bTargetLocationDelay = false;
    //return;    
}

// Export USkyAirVehicle::execTakeDamage(FFrame&, void* const)
native simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyAirVehicle::execIsValidEnemyTargetFor(FFrame&, void* const)
native function bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);

reliable server event SetBeingHijacked(SkyPawn newHijacker)
{
    local SkyBotControllerPilot SBCP;

    PotentialHijacker = newHijacker;
    bHasHijacker = PotentialHijacker != none;
    // End:0x55
    if(bHasHijacker == true)
    {
        SBCP = SkyBotControllerPilot(Controller);
        // End:0x55
        if(SBCP != none)
        {
            SBCP.BeingHijacked();
        }
    }
    //return;    
}

// Export USkyAirVehicle::execIsBeingHijacked(FFrame&, void* const)
native simulated function bool IsBeingHijacked();

// Export USkyAirVehicle::execNeedToTurnNative(FFrame&, void* const)
native final function bool NeedToTurnNative(Vector targ);

function bool NeedToTurn(Vector targ)
{
    return NeedToTurnNative(targ);
    //return ReturnValue;    
}

simulated function OnToggleHover(SkySeqAct_ToggleHover Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = SkyBotControllerPilot(Controller);
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnToggleHover(Action);
    }
    //return;    
}

function bool TooCloseToAttack(Actor Other)
{
    return false;
    //return ReturnValue;    
}

function OnExitVehicle(SkySeqAct_ExitVehicle Action)
{
    DriverLeave(true);
    //return;    
}

simulated function bool DriverLeave(bool bForceLeave)
{
    local bool Result;
    local Pawn OldDriver;
    local SkyPawn oldSPDriver;
    local SkyPlayerController SPC;

    // End:0x2A
    if(SkyPawn_Dweller(Driver) != none)
    {
        bCollideWorld = true;
        Driver.bCollideWorld = true;
    }
    OldDriver = Driver;
    oldSPDriver = SkyPawn(Driver);
    SPC = SkyPlayerController(Controller);
    // End:0xAF
    if(SPC != none)
    {
        SPC.StopRumble(BoostFFeedback);
        // End:0xAF
        if(SPC.PlayerInput != none)
        {
            SkyPlayerInput(SPC.PlayerInput).bWaitingForSpecialMoveInput = false;
        }
    }
    Result = super.DriverLeave(bForceLeave);
    // End:0xFD
    if((Driver != none) && Health > 0)
    {
        Driver.SetHidden(false);
        Driver.bStasis = false;
    }
    // End:0x149
    if(SPC != none)
    {
        // End:0x137
        if((Result == false) && SkyAirVehicle_RocketPackThrust(self) != none)
        {
            SPC.bAlreadyEjecting = true;            
        }
        else
        {
            SPC.bAlreadyEjecting = false;
        }
    }
    // End:0x199
    if(Result == true)
    {
        TriggerEventClass(Class'SkySeqEvent_PilotBail', self);
        // End:0x196
        if((SPC != none) && SkyAirVehicle_RocketPackThrust(self) != none)
        {
            SkyAirVehicle_RocketPackThrust(self).StopWarningLoopSound();
        }        
    }
    else
    {
        // End:0x1C6
        if((oldSPDriver != none) && oldSPDriver.ExitingVehicle != none)
        {
            OpenCockpit();
        }
    }
    // End:0x1E4
    if(!Result && bBrakeDuringExitAnim)
    {
        bBrakingOnExit = true;
    }
    // End:0x254
    if(Result && !bHijackChangingDrivers)
    {
        bFlying = false;
        StopProps();
        OldPilot = OldDriver;
        MoveVehicleAwayFromHijackArea();
        EjectCollisionFreezeTime = 1.0000000;
        VehicleEvent('EngineStop');
        SPC.LockoutExitRocketpackTimerAfterTurnAroundVolume = 0.5000000;
    }
    return Result;
    //return ReturnValue;    
}

simulated function DriverLeft()
{
    local Vector Offset;

    // End:0x25
    if((Controller != none) || (SavedAIController != none) && bSaveAIController)
    {
        return;
    }
    super.DriverLeft();
    // End:0xE3
    if((bFlying && !bHijackChangingDrivers) && bNoRagdollOnDriverLeave == false)
    {
        // End:0xDB
        if(Mesh != none)
        {
            Offset.X = 0.0000000;
            Offset.Y = 0.0000000;
            Offset.Z = 0.0000000;
            InitVehicleRagdoll(Mesh.SkeletalMesh, Mesh.PhysicsAsset, Offset, false);
            Mesh.SetNotifyRigidBodyCollision(true);
        }
        bFlyingUnmanned = true;
    }
    SetVehicleSoundSpatialization(true);
    //return;    
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    Throttle = InForward;
    Steering = InStrafe;
    Rise = InUp;
    //return;    
}

simulated function bool DriverEnter(Pawn P)
{
    local bool Result;
    local SkyPlayerController PC;

    // End:0x2A
    if(SkyPawn_Dweller(P) != none)
    {
        bCollideWorld = false;
        P.bCollideWorld = false;
    }
    bBrakingOnExit = false;
    PC = SkyPlayerController(P.Controller);
    // End:0xA9
    if(PC != none)
    {
        // End:0x9B
        if(SkyAirVehicle_RocketPackThrust(self) != none)
        {
            BoostFuelCost = ((PC.UsingUltraPack()) ? 0.0000000 : SkyAirVehicle(ObjectArchetype).BoostFuelCost);
        }
        SetVehicleSoundSpatialization(false);        
    }
    else
    {
        BoostFuelCost = SkyAirVehicle(ObjectArchetype).BoostFuelCost;
        SetVehicleSoundSpatialization(true);
    }
    Result = super.DriverEnter(P);
    // End:0x196
    if(Result)
    {
        StartProps();
        // End:0x122
        if(!bHijackChangingDrivers && !IsHumanControlled())
        {
            bFlying = true;
            SetAirVehicleState(3);            
        }
        else
        {
            // End:0x13C
            if(!bHijackChangingDrivers)
            {
                SetAirVehicleState(1);                
            }
            else
            {
                SetAirVehicleState(3);
                // End:0x196
                if(float(Health) < (float(SkyAirVehicle(ObjectArchetype).Health) * MinHealthPercentOnDriverEnter))
                {
                    Health = int(float(SkyAirVehicle(ObjectArchetype).Health) * MinHealthPercentOnDriverEnter);
                }
            }
        }
    }
    // End:0x1B1
    if(IdleSound != none)
    {
        IdleSound.Play();
    }
    SetBeingHijacked(none);
    bHijackChangingDrivers = false;
    bFlyingUnmanned = false;
    // End:0x1FA
    if((Driver != none) && int(CockpitState) == int(0))
    {
        Driver.SetHidden(true);
    }
    return Result;
    //return ReturnValue;    
}

simulated function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local int I;
    local bool Results;

    // End:0x1A
    if(DamageType == Class'SkyDmgType_HazardVolume')
    {
        bNonViolentDeath = true;        
    }
    else
    {
        bNonViolentDeath = false;
    }
    // End:0x50
    if(SkyPlayerController(Controller) != none)
    {
        SkyPlayerController(Controller).StopRumble(BoostFFeedback);
    }
    // End:0xE5
    if(!bNonViolentDeath)
    {
        StopProps();
        // End:0xE5
        if(bHideRagdoll)
        {
            I = 0;
            J0x75:

            // End:0xCE [Loop If]
            if(I < Props.Length)
            {
                // End:0xC4
                if(Props[I] != none)
                {
                    Props[I].SetHidden(true);
                    Props[I].SetCollideActors(false);
                }
                ++I;
                // [Loop Continue]
                goto J0x75;
            }
            SkyVehicleSim_CrimsonAircraft(SimObj).bVehicleFrozen = true;
        }
    }
    // End:0x155
    if((SkyBotControllerPilot(Killer) != none) && int(Killer.GetTeamNum()) != int(Controller.GetTeamNum()))
    {
        SkyBotControllerPilot(Killer).PlayPilotChatter(4, int(Killer.GetTeamNum()));
    }
    Results = super.Died(Killer, DamageType, HitLocation);
    // End:0x1BB
    if(!bNonViolentDeath)
    {
        // End:0x19F
        if(ShouldHideDriverOnDeath(DamageType))
        {
            Driver.SetHidden(true);
        }
        SetVehicleLocationAndRotationRB(Location, Rotation);
        bFlying = false;
    }
    // End:0x1DE
    if(DockedFactory != none)
    {
        DockedFactory.DockedVehicle = none;
        DockedFactory = none;
    }
    return Results;
    //return ReturnValue;    
}

simulated function SwitchToRagDoll()
{
    local Rotator Rot;

    super(SkyGameVehicle).SwitchToRagDoll();
    Rot = Rotation;
    Rot.Roll += RollFromTurn;
    SetRotation(Rot);
    //return;    
}

// Export USkyAirVehicle::execCheckForUnrealCollisionAndVolumes(FFrame&, void* const)
native function CheckForUnrealCollisionAndVolumes(Vector NewLocation);

event Vector GetCameraLocation()
{
    return Mesh.GetBoneLocation('j_root', 0);
    //return ReturnValue;    
}

function Rotator GetCameraRotation()
{
    // End:0x3A
    if(bTakeoff && Mesh != none)
    {
        return QuatToRotator(Mesh.GetBoneQuaternion('j_root', 0));        
    }
    else
    {
        return Rotation;
    }
    //return ReturnValue;    
}

simulated function VehiclePlayEnterSound()
{
    // End:0x3C
    if(!bHijackChangingDrivers)
    {
        // End:0x36
        if(bAutoPlayEngineLoop && EnterVehicleSound != none)
        {
            EngineStartOffsetSecs = EnterVehicleSound.Duration;
        }
        super(SVehicle).VehiclePlayEnterSound();
    }
    //return;    
}

simulated function VehiclePlayExitSound()
{
    // End:0x11
    if(!bHijackChangingDrivers)
    {
        super(SVehicle).VehiclePlayExitSound();
    }
    //return;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    // End:0x20
    if(OtherComponent != none)
    {
        CollisionBuddy = OtherComponent.Owner;
    }
    super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
    //return;    
}

function float GetCollisionDamageModifier(const out array<RigidBodyContactInfo> ContactInfos)
{
    // End:0x1E
    if(SkyAirVehicle(CollisionBuddy) != none)
    {
        CollisionDamageMult = CollisionDamageMultPlaneToPlane;        
    }
    else
    {
        CollisionDamageMult = default.CollisionDamageMult;
    }
    return super(SkyGameVehicle).GetCollisionDamageModifier(ContactInfos);
    //return ReturnValue;    
}

function UpdateControllerOnPossess(bool bVehicleTransition)
{
    Controller.SetRotation(Rotation);
    //return;    
}

simulated function bool CanBeBaseForPawn(Pawn aPawn)
{
    // End:0x12
    if(SkyPawn(aPawn) != none)
    {
        return true;
    }
    return super(Pawn).CanBeBaseForPawn(aPawn);
    //return ReturnValue;    
}

event bool EncroachingOn(Actor Other)
{
    local SkyPawn P;

    P = SkyPawn(Other);
    // End:0x4A
    if((P != none) && (P.HijackTarget == self) || P.IsBasedOn(self))
    {
        return false;
    }
    // End:0x5C
    if(SkyPawn_Archon(Other) != none)
    {
        return false;
    }
    return super(Vehicle).EncroachingOn(Other);
    //return ReturnValue;    
}

event RanInto(Actor Other)
{
    local SkyPawn P;

    P = SkyPawn(Other);
    // End:0x4A
    if((P != none) && (P.HijackTarget == self) || P.IsBasedOn(self))
    {
        return;
    }
    // End:0x5C
    if(SkyPawn_Archon(Other) != none)
    {
        return;
    }
    super(SkyGameVehicle).RanInto(Other);
    //return;    
}

// Export USkyAirVehicle::execGetHijackInteractionStart(FFrame&, void* const)
native function GetHijackInteractionStart(Vector HijackerLoc, out Vector Dest, out Rotator Rot);

// Export USkyAirVehicle::execGetHijackInteractionStartLoc(FFrame&, void* const)
native function Vector GetHijackInteractionStartLoc(Vector HijackerLoc);

// Export USkyAirVehicle::execGetHijackInteractionStartRot(FFrame&, void* const)
native function Rotator GetHijackInteractionStartRot(Vector HijackerLoc);

function OnSetTether(SkySeqAct_SetTether Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = SkyBotControllerPilot(Controller);
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnSetTether(Action);
    }
    //return;    
}

function OnPilotSeekLandingZone(SkySeqAct_PilotSeekLandingZone Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = SkyBotControllerPilot(Controller);
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnPilotSeekLandingZone(Action);
    }
    //return;    
}

function OnSetPilotVars(SkySeqAct_SetPilotVars Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = SkyBotControllerPilot(Controller);
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnSetPilotVars(Action);
    }
    //return;    
}

function OnRequestChangeState(SkySeqAct_RequestChangeState Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = SkyBotControllerPilot(Controller);
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnRequestChangeState(Action);
    }
    //return;    
}

event OnFollowSpline(SkySeqAct_FollowSpline Action)
{
    local SkyBotControllerPilot SBCP;

    SBCP = SkyBotControllerPilot(Controller);
    // End:0x34
    if(SBCP != none)
    {
        SBCP.OnFollowSpline(Action);
    }
    //return;    
}

function BoostViewShakeTimer()
{
    //return;    
}

// Export USkyAirVehicle::execEnterCriticalState(FFrame&, void* const)
native function EnterCriticalState();

// Export USkyAirVehicle::execExitCriticalState(FFrame&, void* const)
native function ExitCriticalState();

// Export USkyAirVehicle::execHitZeroFuel(FFrame&, void* const)
native function HitZeroFuel();

// Export USkyAirVehicle::execUseSpecialManeuverFuel(FFrame&, void* const)
native function UseSpecialManeuverFuel(float Cost, optional bool bSpecialMove);

simulated function bool AllowSpecialMoves()
{
    // End:0x0E
    if(bAllowSpecialMoves == false)
    {
        return false;
    }
    // End:0x23
    if(CurrentActiveSpecialManeuver != 'None')
    {
        return false;
    }
    // End:0x35
    if(int(AirVehicleState) == int(3))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event bool CheckInputForSpecialMove(float leftX, float leftY, float rightX, float rightY, bool bUsingController)
{
    local SkySpecialManeuverActor.ESpecialManeuverStickDir curLeftStick, curRightStick;
    local int I;

    // End:0x12
    if((AllowSpecialMoves()) == false)
    {
        return false;
    }
    // End:0x2C
    if(leftX > SpecialManeuverSensitivity)
    {
        curLeftStick = 2;        
    }
    else
    {
        // End:0x48
        if(leftX < -SpecialManeuverSensitivity)
        {
            curLeftStick = 1;            
        }
        else
        {
            // End:0x62
            if(leftY > SpecialManeuverSensitivity)
            {
                curLeftStick = 3;                
            }
            else
            {
                // End:0x7B
                if(leftY < -SpecialManeuverSensitivity)
                {
                    curLeftStick = 4;
                }
            }
        }
    }
    // End:0x95
    if(rightX > SpecialManeuverSensitivity)
    {
        curRightStick = 2;        
    }
    else
    {
        // End:0xB1
        if(rightX < -SpecialManeuverSensitivity)
        {
            curRightStick = 1;            
        }
        else
        {
            // End:0xCB
            if(rightY > SpecialManeuverSensitivity)
            {
                curRightStick = 4;                
            }
            else
            {
                // End:0xE4
                if(rightY < -SpecialManeuverSensitivity)
                {
                    curRightStick = 3;
                }
            }
        }
    }
    // End:0x10C
    if(!bUsingController && int(curLeftStick) == int(0))
    {
        curLeftStick = curRightStick;
    }
    // End:0x130
    if((int(curLeftStick) == int(0)) || int(curRightStick) == int(0))
    {
        return false;
    }
    I = 0;
    J0x137:

    // End:0x23F [Loop If]
    if(I < AvailableSpecialManeuvers.Length)
    {
        // End:0x235
        if((int(AvailableSpecialManeuvers[I].LeftStick) == int(curLeftStick)) && int(AvailableSpecialManeuvers[I].RightStick) == int(curRightStick))
        {
            // End:0x1F7
            if(AvailableSpecialManeuvers[I].ManeuverCost <= SpecialManeuverFuelCur)
            {
                SetCurrentActiveSpecialManeuver(AvailableSpecialManeuvers[I].ManeuverName);
                UseSpecialManeuverFuel(AvailableSpecialManeuvers[I].ManeuverCost, true);
                return true;                
            }
            else
            {
                // End:0x233
                if(AvailableSpecialManeuvers[I].SpinOutJuiceLevel > SpecialManeuverFuelCur)
                {
                    SetCurrentActiveSpecialManeuver(SpinOutSpecialManeuver);
                    SpecialManeuverFuelCur = 0.0000000;
                    return false;
                }
            }
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0x137;
    }
    return false;
    //return ReturnValue;    
}

// Export USkyAirVehicle::execSetVehicleSoundSpatialization(FFrame&, void* const)
native function SetVehicleSoundSpatialization(bool Enabled);

// Export USkyAirVehicle::execSetCurrentActiveSpecialManeuver(FFrame&, void* const)
native function SetCurrentActiveSpecialManeuver(name NewMove);

// Export USkyAirVehicle::execSetVehicleLocationAndRotationRB(FFrame&, void* const)
native function SetVehicleLocationAndRotationRB(Vector NewLoc, Rotator NewRot);

event bool IsOnGround()
{
    return false;
    //return ReturnValue;    
}

// Export USkyAirVehicle::execSetDorment(FFrame&, void* const)
native function SetDorment(bool newDorment);

// Export USkyAirVehicle::execCalcSafeTakeoffVector(FFrame&, void* const)
native final function bool CalcSafeTakeoffVector(Rotator CurrRotation, float DistanceToCheck, out Vector TakeoffVector);

simulated event bool TouchedTurnAroundVolume(SkyTurnAroundVolume Vol, Vector HitNormal)
{
    local int Index;
    local s_TurnAroundVolumeData volData;

    Index = TurnAroundVolumeList.Find('Vol', Vol);
    // End:0x66
    if(Index == -1)
    {
        volData.Vol = Vol;
        volData.HitNormal = HitNormal;
        TurnAroundVolumeList.AddItem(volData);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event UnTouchedTurnAroundVolume(SkyTurnAroundVolume Vol)
{
    local int Index;
    local SkyBotControllerPilot SBCP;

    Index = TurnAroundVolumeList.Find('Vol', Vol);
    // End:0x99
    if(Index != -1)
    {
        // End:0x99
        if((TurnAroundVolumeList[Index].HitNormal Dot Normal(Velocity)) > float(0))
        {
            TurnAroundVolumeList.Remove(Index, 1);
            // End:0x99
            if(TurnAroundVolumeList.Length < 1)
            {
                SBCP = SkyBotControllerPilot(Controller);
                // End:0x99
                if(SBCP != none)
                {
                    SBCP.ExitTurnAroundVolumes();
                }
            }
        }
    }
    //return;    
}

// Export USkyAirVehicle::execHasBeenHijacked(FFrame&, void* const)
native function bool HasBeenHijacked();

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x3D
    if(SkyBotControllerPilot(Controller) != none)
    {
        SkyBotControllerPilot(Controller).Touch(Other, OtherComp, HitLocation, HitNormal);
    }
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

// Export USkyAirVehicle::execShouldHideDriverOnDeath(FFrame&, void* const)
native function bool ShouldHideDriverOnDeath(class<DamageType> dmgType);

event bool CanAttackEvent(Actor Other)
{
    return CanAttack(Other);
    //return ReturnValue;    
}

function ClearSpecialMoveVel()
{
    SpecialManeuverVelocity.X = 0.0000000;
    SpecialManeuverVelocity.Y = 0.0000000;
    SpecialManeuverVelocity.Z = 0.0000000;
    SpecialManeuverAcceleration.X = 0.0000000;
    SpecialManeuverAcceleration.Y = 0.0000000;
    SpecialManeuverAcceleration.Z = 0.0000000;
    //return;    
}

// Export USkyAirVehicle::execSetAirVehicleState(FFrame&, void* const)
native function SetAirVehicleState(SkyAirVehicle.ESkyAirVehicleState NewState);
