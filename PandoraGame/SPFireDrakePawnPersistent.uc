class SPFireDrakePawnPersistent extends SPPawn
    native
    nativereplication
    config(Game);

enum eFireDrakeActionState
{
    eFDActionNone,                  // 0
    eFDActionAmbush,                // 1
    eFDActionFireSpit,              // 2
    eFDActionTakingHit,             // 3
    eFDActionRingImmolate,          // 4
    eFDActionDirectedImmolatePrepare,// 5
    eFDActionDirectedImmolateHold,  // 6
    eFDActionOpeningMouth,          // 7
    eFDActionSpitObject,            // 8
    eFDActionGrabObject,            // 9
    eFDActionSwipingTentacle,       // 10
    eFDActionDead,                  // 11
    eFDActionQuadrupedToRoll,       // 12
    eFDActionRollToQuadruped,       // 13
    eFDActionWaterDeath,            // 14
    eFireDrakeActionState_MAX       // 15
};

enum eFireDrakeFireSpitState
{
    eFDFireSpitPrepare,             // 0
    eFDFireSpitDoSpit,              // 1
    eFireDrakeFireSpitState_MAX     // 2
};

enum eFireDrakeDodgeState
{
    eFDDodgeNone,                   // 0
    eFDDodgeRight,                  // 1
    eFDDodgeLeft,                   // 2
    eFireDrakeDodgeState_MAX        // 3
};

enum eFireDrakeLastHitDirection
{
    eFDHitNone,                     // 0
    eFDHitLeft,                     // 1
    eFDHitMid,                      // 2
    eFDHitRight,                    // 3
    eFireDrakeLastHitDirection_MAX  // 4
};

var MaterialInstanceConstant HeatMaterialInst;
var SkeletalMesh m_FDDeathMesh;
var PhysicsAsset m_FDDeathPhysicsAsset;
/** Amount of time before FD explodes when dyingvar float                       m_DeathTime; Time at which FD entered the dying state */
var() float m_TimeTillExplosion;
var float m_TexTransAlpha;
/** Number of seconds to wait prior to transition */
var() float m_TexTransDelay;
var float m_TexTransLastTime;
var ParticleSystem m_DeathExplosionParticleTemplate;
var EmitterSpawnable ImmolateEmitter;
var EmitterSpawnable ImmolatePrepareEmitter;
var ParticleSystem WaterDamageParticleTemplate;
var EmitterSpawnable WaterDamageEmitter;
var class<SPGrenadePersistent> SpitProjectileClass;
var class<DamageType> SpitDamageType;
var Material m_DeathMtl[3];
var SPGameDifficultyTuneFireDrake m_FireDrakeGDTuneData;
var Quat m_rollingQuaternion;
var bool m_bUsingRollingMovement;
var bool m_bIsHeatUpLightAllowed;
var bool m_bEnableTongueStretch;
var bool m_bWaterDeathAnimFinished;
var bool m_bWaterDamageEffectOn;
var bool m_bPinballPhysics;
var bool m_bResetAction;
var bool m_bRestartHitState;
var bool m_deathAnimFinished;
var SPWallAnimationReachSpec m_transitionCachedReachSpec;
var int m_transitionCachedVertexID;
var float m_materialHeatValue;
var float m_currentHeatUpRate;
var float m_currentHeatUpTargetValue;
var export editinline PointLightComponent HeatUpLight;
var float m_tongueStretchDuration;
var float m_tongueUnstretchDuration;
var Vector m_tongueFullExtensionRange;
var Actor m_tongueTarget;
var SoundCue DeathSoundCue;
var SoundCue RollingSoundCue;
var SoundCue WaterDamageSoundCue;
var SPLoopingSoundActor RollingSoundActor;
var float m_waterDamageCurrentValue;
var float m_waterDamageRate;
var Vector m_AnimusPulseOrigin;
var float m_AnimPulseNormalizedStrength;
/** VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPFireDrakePawnPersistent.eFireDrakeActionState m_actionState;
var SPFireDrakePawnPersistent.eFireDrakeLastHitDirection m_LastHitDir;
var ParticleSystem RingImmolateParticleTemplate;
var ParticleSystem RingImmolatePrepareParticleTemplate;
var ParticleSystem DirectedImmolateParticleTemplate;
var ParticleSystem DirectedImmolatePrepareParticleTemplate;
var MaterialInterface RollingDecalTemplate;
var ParticleSystem RollingParticleTemplate;
var MaterialInterface AlternateRollingDecalTemplate;
var class<DamageType> m_damageType;
var int m_activeWallAnimChannel;
var WallAnimChannelData m_wallAnimChannelData[2];
var float m_lastDamagedTime;
var name m_sBoneName;
var float m_FDHitTime;
var float m_distanceTraveledSinceLastDecal;
var float m_distanceTraveledSinceLastParticle;
var float m_minDistanceLeftToTravelWhileRolling;
var Actor SpitTarget;
var transient SkelControlSingleBone m_pRollingBoneControl;

replication
{
    // Pos:0x000
    if(bNetDirty
        m_actionState;
}

// Export USPFireDrakePawnPersistent::execGetDefaultBoneName(FFrame&, void* const)
native function name GetDefaultBoneName();

// Export USPFireDrakePawnPersistent::execGetCurrentRageLevelIndex(FFrame&, void* const)
native function int GetCurrentRageLevelIndex();

// Export USPFireDrakePawnPersistent::execGetGroundFriction(FFrame&, void* const)
native function float GetGroundFriction();

simulated event PrepareForNonAnimationBasedMovement()
{
    // End:0x4C
    if(SPFireDrakeAIController(Controller).IsDoingSpecifiedMovementType(10))
    {
        // End:0x40
        if(m_currentWallPose == 'f110b_wall_mobile_knee_alert_pwallcrawlroll')
        {
            ForceMovementType(9);            
        }
        else
        {
            ForceMovementType(8);
        }
    }
    SetMovementPhysics();
    //return;    
}

simulated event Destroyed()
{
    DestroyRollingSoundActor();
    super.Destroyed();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    UpdateHeatMaterial(DeltaTime);
    UpdateHeatLight(DeltaTime);
    UpdateRollingSound();
    ServerTick_SPFireDrakePawnPersistent(DeltaTime);
    super.Tick(DeltaTime);
    //return;    
}

final function ServerTick_SPFireDrakePawnPersistent(float DeltaTime)
{
    //return;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

simulated function SwitchFromWallWalkingToWalking()
{
    // End:0x1F
    if((int(Role) < int(ROLE_Authority)) && !m_bIgnoreServerMoves)
    {
        return;
    }
    // End:0x37
    if(m_bUsingRollingMovement)
    {
        ForceMovementType(9);        
    }
    else
    {
        ForceMovementType(8);
    }
    SetMovementPhysics();
    super.SwitchFromWallWalkingToWalking();
    //return;    
}

function ForceMovementType(SPPawn.SPEMovementType Type)
{
    m_bUsingRollingMovement = int(Type) == int(9);
    SetMovementType(Type);
    //return;    
}

simulated function SetMovementType(SPPawn.SPEMovementType Type)
{
    local bool bKillGroundMovement;

    // End:0x1F
    if((int(Role) < int(ROLE_Authority)) && !m_bIgnoreServerMoves)
    {
        return;
    }
    // End:0x82
    if((int(Type) == int(8)) && int(m_movementTypeInfo[m_currentMovementTypeIndex].movementType) == int(9))
    {
        m_bUsingRollingMovement = false;
        // End:0x7F
        if(int(m_actionState) == int(0))
        {
            SetAnimActionState(13, true);
            bKillGroundMovement = true;
        }        
    }
    else
    {
        // End:0xEF
        if(((int(Type) == int(9)) && int(m_movementTypeInfo[m_currentMovementTypeIndex].movementType) == int(8)) && int(m_actionState) == int(0))
        {
            // End:0xEC
            if(int(m_actionState) == int(0))
            {
                SetAnimActionState(12, true);
                bKillGroundMovement = true;
            }            
        }
        else
        {
            // End:0x113
            if(int(Type) != int(10))
            {
                m_bUsingRollingMovement = int(Type) == int(9);
            }
        }
    }
    super.SetMovementType(Type);
    // End:0x132
    if(bKillGroundMovement)
    {
        GroundSpeed = 0.0000000;
    }
    //return;    
}

simulated event GenerateRollTrailDecal(float RotationAngle, out ImpactInfo FloorImpactInfo)
{
    local Rotator theRotation;
    local Vector centeredLocation;
    local Rotator axisRotation;

    // End:0x0D
    if(WorldInfo == none)
    {
        return;
    }
    // End:0x24
    if(WorldInfo.MyDecalManager == none)
    {
        return;
    }
    // End:0x38F
    if(m_bUsingRollingMovement && RollingDecalTemplate != none)
    {
        // End:0x38F
        if(FloorImpactInfo.HitActor != none)
        {
            centeredLocation.X = m_FireDrakeGDTuneData.RollingDecalWidth * 0.5000000;
            centeredLocation.Y = m_FireDrakeGDTuneData.RollingDecalHeight * 0.5000000;
            centeredLocation.Z = 0.0000000;
            axisRotation.Yaw = int((RotationAngle / 360.0000000) * float(65536));
            axisRotation.Roll = 0;
            axisRotation.Pitch = 0;
            centeredLocation = FloorImpactInfo.HitLocation - (centeredLocation << axisRotation);
            theRotation = Rotator(-FloorImpactInfo.HitNormal);
            theRotation.Roll = int((RotationAngle / 360.0000000) * float(65536));
            // End:0x286
            if(m_FireDrakeGDTuneData.bUseAlternateRollDecalTemplate)
            {
                WorldInfo.MyDecalManager.SpawnDecal(AlternateRollingDecalTemplate, FloorImpactInfo.HitLocation + FloorImpactInfo.HitNormal, theRotation, m_FireDrakeGDTuneData.RollingDecalWidth, m_FireDrakeGDTuneData.RollingDecalHeight, m_FireDrakeGDTuneData.RollingDecalThickness, m_FireDrakeGDTuneData.RollingDecalNoClip, 0.0000000, FloorImpactInfo.HitInfo.HitComponent, true, true, FloorImpactInfo.HitInfo.BoneName, FloorImpactInfo.HitInfo.Item, FloorImpactInfo.HitInfo.LevelIndex, m_FireDrakeGDTuneData.DecalTrailLifeSpan);                
            }
            else
            {
                WorldInfo.MyDecalManager.SpawnDecal(RollingDecalTemplate, FloorImpactInfo.HitLocation + FloorImpactInfo.HitNormal, theRotation, m_FireDrakeGDTuneData.RollingDecalWidth, m_FireDrakeGDTuneData.RollingDecalHeight, m_FireDrakeGDTuneData.RollingDecalThickness, m_FireDrakeGDTuneData.RollingDecalNoClip, 0.0000000, FloorImpactInfo.HitInfo.HitComponent, true, true, FloorImpactInfo.HitInfo.BoneName, FloorImpactInfo.HitInfo.Item, FloorImpactInfo.HitInfo.LevelIndex, m_FireDrakeGDTuneData.DecalTrailLifeSpan);
            }
        }
    }
    //return;    
}

simulated event GenerateRollTrailParticle(out ImpactInfo FloorImpactInfo)
{
    local Emitter E;

    // End:0xC4
    if(RollingParticleTemplate != none)
    {
        E = Spawn(Class'Engine.EmitterSpawnable',,, FloorImpactInfo.HitLocation, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
        // End:0xC4
        if(E != none)
        {
            E.SetTemplate(RollingParticleTemplate, true);
            E.bDestroyOnSystemFinish = true;
            E.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            E.ParticleSystemComponent.ActivateSystem();
            E.bKillDuringLevelTransition = true;
        }
    }
    //return;    
}

function bool ShouldClearVelocityWhenClearingKynapse()
{
    return !m_bWaterDamageEffectOn;
    //return ReturnValue;    
}

function StartWaterDamageEffect()
{
    local float Rate;
    local SPFireDrakeAIController MyController;
    local Rotator Rot;

    // End:0x1E2
    if(!m_bWaterDamageEffectOn)
    {
        m_bWaterDamageEffectOn = true;
        MyController = SPFireDrakeAIController(Controller);
        // End:0x42
        if(MyController != none)
        {
            MyController.NotifyDying();
        }
        // End:0x59
        if(m_bUsingRollingMovement)
        {
            AccelRate = 0.0000000;            
        }
        else
        {
            ForceMovementType(8);
            SetAnimActionState(14, true);
        }
        PlaySound(WaterDamageSoundCue, false, false, true);
        Rot = Rotator(vect(0.0000000, 0.0000000, 1.0000000));
        WaterDamageEmitter = Spawn(Class'Engine.EmitterSpawnable',,, Location, Rot);
        // End:0x17A
        if(WaterDamageEmitter != none)
        {
            WaterDamageEmitter.SetTemplate(WaterDamageParticleTemplate, true);
            WaterDamageEmitter.bDestroyOnSystemFinish = true;
            WaterDamageEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            WaterDamageEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_CT_Root', true);
            WaterDamageEmitter.SetOwner(self);
            WaterDamageEmitter.ParticleSystemComponent.ActivateSystem();
            WaterDamageEmitter.bKillDuringLevelTransition = true;
        }
        // End:0x1C1
        if((m_FireDrakeGDTuneData != none) && m_FireDrakeGDTuneData.WaterCoolDownTime != 0.0000000)
        {
            Rate = -m_materialHeatValue / m_FireDrakeGDTuneData.WaterCoolDownTime;            
        }
        else
        {
            Rate = -m_materialHeatValue;
        }
        SetHeatUpRate(Rate, 0.0000000);
    }
    //return;    
}

simulated function StartHeatUpEffect()
{
    // End:0x33
    if(!m_bWaterDamageEffectOn)
    {
        SetHeatUpRate(m_FireDrakeGDTuneData.AttackHeatUpRate, m_FireDrakeGDTuneData.AttackHeatUpTargetValue);
    }
    //return;    
}

simulated function StartCoolDown()
{
    // End:0x33
    if(!m_bWaterDamageEffectOn)
    {
        SetHeatUpRate(m_FireDrakeGDTuneData.AttackCoolDownRate, m_FireDrakeGDTuneData.NormalHeatUpTargetValue);
    }
    //return;    
}

simulated function StartPreImmolateEffect()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x11F
    if(!m_bWaterDamageEffectOn)
    {
        SetHeatUpRate(m_FireDrakeGDTuneData.AttackHeatUpRate, m_FireDrakeGDTuneData.AttackHeatUpTargetValue);
        // End:0x11F
        if(RingImmolatePrepareParticleTemplate != none)
        {
            // End:0x71
            if(!Mesh.GetSocketWorldLocationAndRotation('ImmolatePrepare', pos, Rot))
            {
                pos = Location;
            }
            ImmolatePrepareEmitter = Spawn(Class'Engine.EmitterSpawnable',,, pos, Rotator(vect(0.0000000, 0.0000000, 0.0000000)));
            // End:0x11F
            if(ImmolatePrepareEmitter != none)
            {
                ImmolatePrepareEmitter.SetTemplate(RingImmolatePrepareParticleTemplate, true);
                ImmolatePrepareEmitter.bDestroyOnSystemFinish = true;
                ImmolatePrepareEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                ImmolatePrepareEmitter.ParticleSystemComponent.ActivateSystem();
                ImmolatePrepareEmitter.bKillDuringLevelTransition = true;
            }
        }
    }
    //return;    
}

simulated function CleanupImmolate()
{
    StartCoolDown();
    // End:0x36
    if(ImmolatePrepareEmitter != none)
    {
        ImmolatePrepareEmitter.ParticleSystemComponent.DeactivateSystem();
        ImmolatePrepareEmitter = none;
    }
    //return;    
}

simulated event DirectedImmolateFromAnimNotify()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x165
    if(!m_bWaterDamageEffectOn)
    {
        // End:0x165
        if(DirectedImmolateParticleTemplate != none)
        {
            // End:0x55
            if(Mesh.GetSocketWorldLocationAndRotation('DirectedImmolate', pos, Rot) == false)
            {
                pos = Location;
                Rot = Rotation;
            }
            ImmolateEmitter = Spawn(Class'Engine.EmitterSpawnable',,, pos, Rot);
            // End:0x165
            if(ImmolateEmitter != none)
            {
                ImmolateEmitter.SetTemplate(DirectedImmolateParticleTemplate, true);
                ImmolateEmitter.bDestroyOnSystemFinish = true;
                ImmolateEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                ImmolateEmitter.ParticleSystemComponent.SetScale3D(m_FireDrakeGDTuneData.DirectedImmolateParticleScale);
                ImmolateEmitter.SetBase(self, vect(1.0000000, 0.0000000, 0.0000000), Mesh, 'DirectedImmolate', true);
                ImmolateEmitter.SetOwner(self);
                ImmolateEmitter.ParticleSystemComponent.ActivateSystem();
                ImmolateEmitter.bKillDuringLevelTransition = true;
            }
        }
    }
    //return;    
}

function DisableTongueStretch()
{
    m_bEnableTongueStretch = false;
    m_tongueTarget = none;
    //return;    
}

event EnableTongueStretch(float stretchDuration, float unstretchDuration, Vector fullExtensionRange)
{
    // End:0x39
    if(int(m_actionState) == int(9))
    {
        m_bEnableTongueStretch = true;
        m_tongueStretchDuration = stretchDuration;
        m_tongueUnstretchDuration = unstretchDuration;
        m_tongueFullExtensionRange = fullExtensionRange;
    }
    //return;    
}

function CATAttackFinished()
{
    // End:0x2C
    if(ImmolateEmitter != none)
    {
        ImmolateEmitter.ParticleSystemComponent.DeactivateSystem();
        ImmolateEmitter = none;
    }
    //return;    
}

function CreateImmolatePulseGenerator()
{
    //return;    
}

simulated event RingImmolateFromAnimNotify()
{
    // End:0x1F
    if(!m_bWaterDamageEffectOn)
    {
        CleanupImmolate();
        CreateImmolatePulseGenerator();
    }
    //return;    
}

simulated function SetSpitTarget(Actor spitTarg)
{
    SpitTarget = spitTarg;
    //return;    
}

simulated event LaunchSpitFromAnimNotify()
{
    // End:0x25
    if(!m_bWaterDamageEffectOn)
    {
        // End:0x25
        if(int(m_actionState) == int(2))
        {
            LaunchSpit();
        }
    }
    //return;    
}

simulated function LaunchSpit()
{
    local Vector launchVel;
    local float impactTime, Distance, linearInterpValue, accuracyOffset;
    local Vector aimPos, pos;
    local Rotator Rot;
    local SPFireDrakeAIController FDController;
    local SPGrenadePersistent SpawnedProjectile;
    local SPPawn pawnTarget;
    local float adjustedPitch, deltaZ;
    local Vector TargetVelocity;

    StartCoolDown();
    // End:0x17
    if(SpitTarget == none)
    {
        return;
    }
    // End:0x22
    if(m_bWaterDamageEffectOn)
    {
        return;
    }
    // End:0x4D
    if(Mesh.GetSocketWorldLocationAndRotation('emit', pos, Rot) == false)
    {
        return;
    }
    TargetVelocity = SpitTarget.Velocity;
    pawnTarget = SPPawn(SpitTarget);
    // End:0xC1
    if(pawnTarget != none)
    {
        aimPos = pawnTarget.Location + pawnTarget.GetShotTargetOnBody();
        TargetVelocity = pawnTarget.m_amortizedVelocity;        
    }
    else
    {
        // End:0x103
        if(SpitTarget.CollisionComponent != none)
        {
            aimPos = SpitTarget.CollisionComponent.Bounds.Origin;            
        }
        else
        {
            aimPos = SpitTarget.Location;
        }
    }
    TargetVelocity = TargetVelocity * m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitTargetVelocityConsiderationPercent);
    Distance = VSize(aimPos - Location);
    linearInterpValue = (Distance - m_FireDrakeGDTuneData.SpitDistMin) / (m_FireDrakeGDTuneData.SpitDistMax - m_FireDrakeGDTuneData.SpitDistMin);
    accuracyOffset = (linearInterpValue * (m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitAccuracyAtMaxRange) - m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitAccuracyAtMinRange))) + m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitAccuracyAtMinRange);
    aimPos.X += (accuracyOffset - (2.0000000 * (FRand() * accuracyOffset)));
    aimPos.Y += (accuracyOffset - (2.0000000 * (FRand() * accuracyOffset)));
    deltaZ = aimPos.Z - pos.Z;
    // End:0x2D4
    if(deltaZ < m_FireDrakeGDTuneData.SpitBelowTargetThreshold)
    {
        adjustedPitch = RandRange(m_FireDrakeGDTuneData.SpitBelowTargetMinTrajectoryAdjust, m_FireDrakeGDTuneData.SpitBelowTargetMaxTrajectoryAdjust);        
    }
    else
    {
        // End:0x31A
        if(deltaZ > m_FireDrakeGDTuneData.SpitAboveTargetThreshold)
        {
            adjustedPitch = RandRange(m_FireDrakeGDTuneData.SpitAboveTargetMinTrajectoryAdjust, m_FireDrakeGDTuneData.SpitAboveTargetMaxTrajectoryAdjust);            
        }
        else
        {
            adjustedPitch = RandRange(m_FireDrakeGDTuneData.SpitLevelTargetMinTrajectoryAdjust, m_FireDrakeGDTuneData.SpitLevelTargetMaxTrajectoryAdjust);
        }
    }
    // End:0x426
    if(CalcVelocityToHitMovingTarget(pos, aimPos, TargetVelocity, m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitGravity), int(adjustedPitch), launchVel, impactTime))
    {
        // End:0x426
        if(int(Role) == int(ROLE_Authority))
        {
            SpawnedProjectile = Spawn(SpitProjectileClass, self,, pos);
            // End:0x426
            if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
            {
                SpawnedProjectile.InitSpit(Normal(launchVel), VSize(launchVel), Controller);
                SpawnedProjectile.SetOwner(self);
                SpawnedProjectile.bKillDuringLevelTransition = true;
            }
        }
    }
    FDController = SPFireDrakeAIController(Controller);
    // End:0x455
    if(FDController != none)
    {
        FDController.SpitLaunched();
    }
    //return;    
}

function ParticleCollision(ImpactInfo Impact)
{
    //return;    
}

simulated function SetSpiderMovementType()
{
    SetMovementType(10);
    //return;    
}

function PrepareForNavPoint(NavigationPoint goal)
{
    // End:0x2E
    if((m_wallMovementData.ReachSpec != none) && m_wallMovementData.bDoingMove)
    {
        return;
    }
    // End:0x46
    if(m_bUsingRollingMovement)
    {
        SetMovementType(9);        
    }
    else
    {
        SetMovementType(8);
    }
    super.PrepareForNavPoint(goal);
    //return;    
}

simulated function SetDefaultWallPose()
{
    // End:0x1B
    if(m_bUsingRollingMovement)
    {
        m_currentWallPose = 'f110b_wall_mobile_knee_alert_pwallcrawlroll';        
    }
    else
    {
        m_currentWallPose = 'f110a_wall_mobile_knee_alert_protinvarient';
    }
    //return;    
}

simulated function UpdateWallPose(name newPoseName)
{
    // End:0x1E
    if(newPoseName == 'f110b_wall_mobile_knee_alert_pwallcrawlroll')
    {
        m_bUsingRollingMovement = true;        
    }
    else
    {
        m_bUsingRollingMovement = false;
    }
    super.UpdateWallPose(newPoseName);
    //return;    
}

simulated function int GetFreeWallAnimationChannel()
{
    // End:0x10
    if(m_activeWallAnimChannel == 0)
    {
        return 1;        
    }
    else
    {
        return 0;
    }
    //return ReturnValue;    
}

simulated function SetSingleWallAnimation(name NodeName, name AnimName)
{
    // End:0xC1
    if((Mesh != none) && Mesh.Animations != none)
    {
        m_wallRegistrationNode = SPAnimNodeSequence(Mesh.Animations.FindAnimNode(NodeName));
        // End:0xC1
        if(m_wallRegistrationNode != none)
        {
            m_wallRegistrationNode.SetAnim(AnimName, false);
            m_wallRegistrationNode.SetPosition(0.0000000, false);
            m_wallRegistrationNode.bLooping = false;
            m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'SingleAnim';            
        }
    }
    //return;    
}

simulated function WallAnimationChannel1SingleAnimFinished()
{
    // End:0x5A
    if((m_activeWallAnimChannel == 0) && m_wallAnimChannelData[m_activeWallAnimChannel].MCBName == 'SingleAnim')
    {
        // End:0x52
        if(m_wallMovementData.bExecutingTransition)
        {
            WallTransitionFinished();            
        }
        else
        {
            ArrivedAtWallPathEnd(true, true);
        }
    }
    //return;    
}

simulated function WallAnimationChannel2SingleAnimFinished()
{
    // End:0x5A
    if((m_activeWallAnimChannel == 1) && m_wallAnimChannelData[m_activeWallAnimChannel].MCBName == 'SingleAnim')
    {
        // End:0x52
        if(m_wallMovementData.bExecutingTransition)
        {
            WallTransitionFinished();            
        }
        else
        {
            ArrivedAtWallPathEnd(true, true);
        }
    }
    //return;    
}

simulated function SetFourWayWallAnimation(name NodeName, name forwardName, name backwardName, name leftName, name rightName)
{
    local SPAnimBlendDirectionalNode fourWayNode;
    local AnimNodeSequence Seq;

    // End:0x1C3
    if((Mesh != none) && Mesh.Animations != none)
    {
        fourWayNode = SPAnimBlendDirectionalNode(Mesh.Animations.FindAnimNode(NodeName));
        // End:0x1A3
        if(fourWayNode != none)
        {
            Seq = AnimNodeSequence(fourWayNode.Children[0].Anim);
            // End:0xA3
            if(Seq != none)
            {
                Seq.SetAnim(forwardName, false);
            }
            // End:0x1A0
            if(fourWayNode.Children.Length >= 4)
            {
                Seq = AnimNodeSequence(fourWayNode.Children[1].Anim);
                // End:0x106
                if(Seq != none)
                {
                    Seq.SetAnim(backwardName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[2].Anim);
                // End:0x153
                if(Seq != none)
                {
                    Seq.SetAnim(leftName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[3].Anim);
                // End:0x1A0
                if(Seq != none)
                {
                    Seq.SetAnim(rightName, false);
                }
            }            
        }
        m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'FourWayAnim';
    }
    //return;    
}

simulated function PrepareForWallAnimationReachSpec(SPWallAnimationReachSpec ReachSpec, int kyEndVertexID)
{
    // End:0x4B
    if((int(m_actionState) == int(12)) || int(m_actionState) == int(13))
    {
        // End:0x32
        if(int(Physics) == int(8))
        {
        }
        m_transitionCachedReachSpec = ReachSpec;
        m_transitionCachedVertexID = kyEndVertexID;        
    }
    else
    {
        m_transitionCachedReachSpec = none;
        m_transitionCachedVertexID = -1;
        super.PrepareForWallAnimationReachSpec(ReachSpec, kyEndVertexID);
    }
    //return;    
}

simulated function bool StartWallTransitionAnimations()
{
    local name transName;

    SetSpiderMovementType();
    SetMovementPhysics();
    m_wallRegistrationNode = none;
    m_wallMovementData.bExecutingTransition = true;
    // End:0x130
    if(m_wallMovementData.TransitionData.currentTransition < m_wallMovementData.TransitionData.TransitionList.Length)
    {
        transName = m_wallMovementData.TransitionData.TransitionList[m_wallMovementData.TransitionData.currentTransition].transitionAnimName;
        m_activeWallAnimChannel = GetFreeWallAnimationChannel();
        m_wallAnimChannelData[m_activeWallAnimChannel].bReset = true;
        // End:0xF0
        if(transName == 'None')
        {
            return false;
        }
        // End:0x116
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallAnimation('WallAnimationChannel1Single', transName);            
        }
        else
        {
            SetSingleWallAnimation('WallAnimationChannel2Single', transName);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function StartWallMovementAnimations()
{
    local SPAWallAnimation wallData;

    SetSpiderMovementType();
    SetMovementPhysics();
    m_wallRegistrationNode = none;
    wallData = m_wallMovementData.wallAnimData;
    m_wallMovementData.bExecutingTransition = false;
    m_activeWallAnimChannel = GetFreeWallAnimationChannel();
    m_wallAnimChannelData[m_activeWallAnimChannel].bReset = true;
    // End:0x8A
    if(wallData.MainAnimationName == 'None')
    {
    }
    // End:0x120
    if(m_activeWallAnimChannel == 0)
    {
        // End:0xCE
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation('WallAnimationChannel1Single', wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation('WallAnimationChannel1FourWay', wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }        
    }
    else
    {
        // End:0x159
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation('WallAnimationChannel2Single', wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation('WallAnimationChannel2FourWay', wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }
    }
    //return;    
}

function SetSingleWallIdleAnimation(name NodeName, name AnimName)
{
    local SPAnimNodeSequence Seq;

    // End:0x94
    if((Mesh != none) && Mesh.Animations != none)
    {
        Seq = SPAnimNodeSequence(Mesh.Animations.FindAnimNode(NodeName));
        // End:0x94
        if(Seq != none)
        {
            Seq.SetAnim(AnimName, false);
            m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'IdleAnim';            
        }
    }
    //return;    
}

event StopWallMovementAnimation()
{
    // End:0x96
    if(!m_wallMovementData.bIsSingleAnim && m_wallMovementData.wallAnimData != none)
    {
        // End:0x69
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallIdleAnimation('WallAnimationChannel1Idle', m_wallMovementData.wallAnimData.IdleAnimation);            
        }
        else
        {
            SetSingleWallIdleAnimation('WallAnimationChannel2Idle', m_wallMovementData.wallAnimData.IdleAnimation);
        }
    }
    //return;    
}

simulated function name WallAnimationChannelSelectMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    // End:0x33
    if(m_wallAnimChannelData[m_activeWallAnimChannel].bReset)
    {
        m_wallAnimChannelData[m_activeWallAnimChannel].bReset = false;
    }
    // End:0x50
    if(m_activeWallAnimChannel == 0)
    {
        retval = 'Channel1';        
    }
    else
    {
        retval = 'Channel2';
    }
    return retval;
    //return ReturnValue;    
}

simulated function name WallAnimationChannel1MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[0].MCBName;
    //return ReturnValue;    
}

simulated function name WallAnimationChannel2MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[1].MCBName;
    //return ReturnValue;    
}

k2override function SetAnimActionState(SPFireDrakePawnPersistent.eFireDrakeActionState actionState, optional bool bRestart)
{
    // End:0x13
    if(int(m_actionState) == int(14))
    {
        return;
    }
    m_bResetAction = bRestart;
    m_actionState = actionState;
    //return;    
}

simulated function SetupHeatMaterial()
{
    // End:0x5E
    if(HeatMaterialInst == none)
    {
        HeatMaterialInst = new (none) Class'Engine.MaterialInstanceConstant';
        HeatMaterialInst.SetParent(Mesh.GetMaterial(0));
        Mesh.SetMaterial(0, HeatMaterialInst);
    }
    m_materialHeatValue = m_FireDrakeGDTuneData.NormalHeatUpTargetValue;
    m_waterDamageCurrentValue = m_FireDrakeGDTuneData.NormalWaterDamageValue;
    //return;    
}

simulated function SetHeatUpRate(float heatUpRate, float heatUpTargetValue)
{
    // End:0x21
    if(m_materialHeatValue > heatUpTargetValue)
    {
        heatUpRate = -Abs(heatUpRate);        
    }
    else
    {
        heatUpRate = Abs(heatUpRate);
    }
    m_currentHeatUpRate = heatUpRate;
    m_currentHeatUpTargetValue = heatUpTargetValue;
    // End:0xAE
    if(m_bWaterDamageEffectOn)
    {
        // End:0xA3
        if(m_currentHeatUpRate != 0.0000000)
        {
            m_waterDamageRate = (m_currentHeatUpTargetValue - m_materialHeatValue) / m_currentHeatUpRate;
            // End:0xA0
            if(m_waterDamageRate != 0.0000000)
            {
                m_waterDamageRate = m_FireDrakeGDTuneData.NormalWaterDamageValue / m_waterDamageRate;
            }            
        }
        else
        {
            m_waterDamageRate = 0.0000000;
        }
    }
    //return;    
}

simulated function UpdateHeatMaterial(float DeltaTime)
{
    local Vector StartColor, endColor, difColor;
    local LinearColor linearColorValue;

    m_materialHeatValue = m_materialHeatValue + (DeltaTime * m_currentHeatUpRate);
    // End:0x7A
    if(((m_currentHeatUpRate > 0.0000000) && m_materialHeatValue >= m_currentHeatUpTargetValue) || (m_currentHeatUpRate < 0.0000000) && m_materialHeatValue <= m_currentHeatUpTargetValue)
    {
        m_materialHeatValue = m_currentHeatUpTargetValue;
        SetHeatUpRate(0.0000000, m_materialHeatValue);
    }
    // End:0x3C3
    if(HeatMaterialInst != none)
    {
        // End:0x112
        if(m_bWaterDamageEffectOn)
        {
            StartColor.X = m_FireDrakeGDTuneData.WaterHeatColor.R;
            StartColor.Y = m_FireDrakeGDTuneData.WaterHeatColor.G;
            StartColor.Z = m_FireDrakeGDTuneData.WaterHeatColor.B;            
        }
        else
        {
            StartColor.X = m_FireDrakeGDTuneData.NormalHeatColor.R;
            StartColor.Y = m_FireDrakeGDTuneData.NormalHeatColor.G;
            StartColor.Z = m_FireDrakeGDTuneData.NormalHeatColor.B;
        }
        endColor.X = m_FireDrakeGDTuneData.AttackHeatColor.R;
        endColor.Y = m_FireDrakeGDTuneData.AttackHeatColor.G;
        endColor.Z = m_FireDrakeGDTuneData.AttackHeatColor.B;
        difColor = (endColor * m_currentHeatUpTargetValue) - StartColor;
        difColor = Normal(difColor);
        difColor = StartColor + (difColor * m_materialHeatValue);
        linearColorValue = MakeLinearColor(difColor.X, difColor.Y, difColor.Z, 1.0000000);
        HeatMaterialInst.SetVectorParameterValue('HeatScaleValue', linearColorValue);
        // End:0x334
        if(m_bWaterDamageEffectOn)
        {
            m_waterDamageCurrentValue = m_waterDamageCurrentValue + (DeltaTime * m_waterDamageRate);
            // End:0x306
            if((m_waterDamageCurrentValue < 0.0000000) || m_waterDamageRate == 0.0000000)
            {
                m_waterDamageCurrentValue = 0.0000000;                
            }
            else
            {
                // End:0x334
                if(m_waterDamageCurrentValue > m_FireDrakeGDTuneData.NormalWaterDamageValue)
                {
                    m_waterDamageCurrentValue = m_FireDrakeGDTuneData.NormalWaterDamageValue;
                }
            }
        }
        HeatMaterialInst.SetScalarParameterValue('WaterDamageScaleValue', m_waterDamageCurrentValue);
        // End:0x3C3
        if(m_bWaterDamageEffectOn && m_waterDamageCurrentValue == 0.0000000)
        {
            // End:0x3C3
            if((m_bUsingRollingMovement && VSize(Velocity) < 1.0000000) || m_bWaterDeathAnimFinished)
            {
                // End:0x3C3
                if(int(m_hitDeathState) != int(3))
                {
                    Health = 0;
                    Died(none, Class'SPDamageTypeWater', Location);
                }
            }
        }
    }
    //return;    
}

simulated function UpdateHeatLight(float DeltaTime)
{
    local float linearInterpVal, Brightness;
    local Color NewColor;
    local float R, G, B, A;

    // End:0x1E
    if(!IsHeatUpLightEnabled() || HeatUpLight == none)
    {
        return;
    }
    // End:0x4A
    if(m_materialHeatValue <= m_FireDrakeGDTuneData.NormalHeatUpTargetValue)
    {
        HeatUpLight.SetEnabled(false);
        return;
    }
    HeatUpLight.SetEnabled(true);
    linearInterpVal = (m_materialHeatValue - m_FireDrakeGDTuneData.NormalHeatUpTargetValue) / (m_FireDrakeGDTuneData.AttackHeatUpTargetValue - m_FireDrakeGDTuneData.NormalHeatUpTargetValue);
    Brightness = m_FireDrakeGDTuneData.StartingLightBrightness + (linearInterpVal * (m_FireDrakeGDTuneData.EndingLightBrightness - m_FireDrakeGDTuneData.StartingLightBrightness));
    R = float(m_FireDrakeGDTuneData.StartingLightColor.R) + (linearInterpVal * float(int(m_FireDrakeGDTuneData.EndingLightColor.R) - int(m_FireDrakeGDTuneData.StartingLightColor.R)));
    G = float(m_FireDrakeGDTuneData.StartingLightColor.G) + (linearInterpVal * float(int(m_FireDrakeGDTuneData.EndingLightColor.G) - int(m_FireDrakeGDTuneData.StartingLightColor.G)));
    B = float(m_FireDrakeGDTuneData.StartingLightColor.B) + (linearInterpVal * float(int(m_FireDrakeGDTuneData.EndingLightColor.B) - int(m_FireDrakeGDTuneData.StartingLightColor.B)));
    A = float(m_FireDrakeGDTuneData.StartingLightColor.A) + (linearInterpVal * float(int(m_FireDrakeGDTuneData.EndingLightColor.A) - int(m_FireDrakeGDTuneData.StartingLightColor.A)));
    NewColor.R = byte(R);
    NewColor.G = byte(G);
    NewColor.B = byte(B);
    NewColor.A = byte(A);
    HeatUpLight.Radius = m_FireDrakeGDTuneData.StartingLightRadius + (linearInterpVal * (m_FireDrakeGDTuneData.EndingLightRadius - m_FireDrakeGDTuneData.StartingLightRadius));
    HeatUpLight.SetLightProperties(Brightness, NewColor, HeatUpLight.Function);
    //return;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].FireDrake;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.FireDrakeGD;
    //return ReturnValue;    
}

simulated function InitFromTuneData()
{
    m_FireDrakeGDTuneData = SPGameDifficultyTuneFireDrake(GetMyGDData());
    //return;    
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    InitFromTuneData();
    //return;    
}

simulated function PostBeginPlay()
{
    SetupHeatMaterial();
    super.PostBeginPlay();
    m_pRollingBoneControl = SkelControlSingleBone(Mesh.FindSkelControl('Spinner'));
    CreateRollingSoundActor();
    SetMovementType(8);
    SetMovementPhysics();
    //return;    
}

simulated function CreateRollingSoundActor()
{
    // End:0x45
    if(RollingSoundActor == none)
    {
        RollingSoundActor = Spawn(Class'SPLoopingSoundActor',,, Location);
        // End:0x45
        if(RollingSoundActor != none)
        {
            RollingSoundActor.bKillDuringLevelTransition = true;
        }
    }
    //return;    
}

simulated event DestroyRollingSoundActor()
{
    // End:0x35
    if(RollingSoundActor != none)
    {
        RollingSoundActor.StopSound();
        RollingSoundActor.Destroy();
        RollingSoundActor = none;
    }
    //return;    
}

simulated function UpdateRollingSound()
{
    // End:0x41
    if(m_bUsingRollingMovement && int(Physics) != int(8))
    {
        // End:0x3E
        if(!IsRollingSoundActive())
        {
            StartRollingSound(0.7500000, 1.0000000);
        }        
    }
    else
    {
        // End:0x7F
        if(!m_bUsingRollingMovement || int(Physics) == int(8))
        {
            // End:0x7F
            if(IsRollingSoundActive())
            {
                StopRollingSound(0.5000000, 0.0000000);
            }
        }
    }
    //return;    
}

simulated function StartRollingSound(optional float FadeInDuration, optional float fadeInVolume)
{
    // End:0x32
    if(RollingSoundActor != none)
    {
        RollingSoundActor.StartSound(RollingSoundCue, self, false, FadeInDuration, fadeInVolume);
    }
    //return;    
}

simulated function StopRollingSound(optional float FadeOutDuration, optional float FadeVolumeLevel)
{
    // End:0x2B
    if(RollingSoundActor != none)
    {
        RollingSoundActor.StopSound(FadeOutDuration, FadeVolumeLevel);
    }
    //return;    
}

simulated function bool IsRollingSoundActive()
{
    // End:0x20
    if(RollingSoundActor != none)
    {
        return RollingSoundActor.IsSoundPlaying();
    }
    return false;
    //return ReturnValue;    
}

simulated function bool IsDoingVulnerableAction()
{
    return (m_materialHeatValue > m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.VulnerableHeatValue)) && !m_bWaterDamageEffectOn;
    //return ReturnValue;    
}

simulated function float GetDamageModifierPercent(class<DamageType> DamageType, Controller InstigatorController)
{
    local int damageInfoIndex;
    local float distanceFromDamager, tuneDataDist;

    // End:0x161
    if(!IsDoingVulnerableAction())
    {
        damageInfoIndex = GetDamageReductionInfoIndex(DamageType, InstigatorController);
        // End:0x161
        if(damageInfoIndex != -1)
        {
            distanceFromDamager = 1000.0000000 * 1000.0000000;
            // End:0x96
            if(InstigatorController != none)
            {
                // End:0x96
                if(InstigatorController.Pawn != none)
                {
                    distanceFromDamager = VSizeSq(InstigatorController.Pawn.Location - Location);
                }
            }
            tuneDataDist = m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.DamageReductionInfo[damageInfoIndex].MaxDistanceFromAttackerNearRangeDamage);
            // End:0x125
            if(distanceFromDamager > (tuneDataDist * tuneDataDist))
            {
                return 0.0100000 * m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.DamageReductionInfo[damageInfoIndex].FarRangeDamageModifierPercent);                
            }
            else
            {
                return 0.0100000 * m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.DamageReductionInfo[damageInfoIndex].NearRangeDamageModifierPercent);
            }
        }
    }
    return 1.0000000;
    //return ReturnValue;    
}

simulated event bool AllowBulletsToReflectOffMe(bool bHitMaterialAllowsReflection, class<DamageType> DamageType, Controller InstigatorController)
{
    local float modifiedDamage;

    // End:0x58
    if(bHitMaterialAllowsReflection)
    {
        modifiedDamage = GetDamageModifierPercent(DamageType, InstigatorController);
        // End:0x58
        if((modifiedDamage * float(100)) < m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.MaxDamageModifierAtWhichToReflectBullets))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function int GetDamageReductionInfoIndex(class<DamageType> DamageType, Controller InstigatorController)
{
    local int I, bestIndex, closestDist, curDist;

    // End:0x11
    if(DamageType == none)
    {
        return -1;
    }
    bestIndex = -1;
    closestDist = 99999;
    I = 0;
    J0x2E:

    // End:0xE2 [Loop If]
    if(I < m_FireDrakeGDTuneData.DamageReductionInfo.Length)
    {
        curDist = DamageType.DistClassFromAncestor(DamageType, m_FireDrakeGDTuneData.DamageReductionInfo[I].DamageType);
        // End:0xCA
        if((curDist != -1) && (curDist < closestDist) || bestIndex == -1)
        {
            closestDist = curDist;
            bestIndex = I;
        }
        // End:0xD8
        if(closestDist == 0)
        {
            // [Explicit Break]
            goto J0xE2;
        }
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    J0xE2:

    return bestIndex;
    //return ReturnValue;    
}

simulated function bool CanWeReactToAnimusPulse()
{
    local SPFireDrakeAIController MyController;

    // End:0x0B
    if(m_bWaterDamageEffectOn)
    {
        return false;
    }
    MyController = SPFireDrakeAIController(Controller);
    // End:0x3B
    if(MyController != none)
    {
        // End:0x3B
        if(MyController.m_bAIDisabled)
        {
            return false;
        }
    }
    // End:0x55
    if((CATAttackerPawn != none) || CATDefenderPawn != none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function ProcDynDamage(float DamageAmount, Pawn DamageInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local float damageModifierPercent;

    damageModifierPercent = GetDamageModifierPercent(DamageType, EventInstigator);
    DamageAmount = DamageAmount * damageModifierPercent;
    // End:0x67
    if((int(Physics) != int(8)) && DamageType == Class'SPDamageTypeWater')
    {
        StartWaterDamageEffect();
        DamageAmount = 0.0000000;        
    }
    else
    {
        // End:0x82
        if(ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse'))
        {
            DamageAmount = 0.0000000;
        }
    }
    m_lastDamagedTime = WorldInfo.TimeSeconds;
    m_damageType = DamageType;
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function HitByDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    local SPFireDrakeAIController MyController;

    super.HitByDamagePulse(Origin, normalizedStrength, DamageType);
    // End:0xA1
    if((ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse') && Health > 0) && !IsPendingKill())
    {
        // End:0x50
        if(!CanWeReactToAnimusPulse())
        {
            return;
        }
        MyController = SPFireDrakeAIController(Controller);
        // End:0x6D
        if(MyController == none)
        {
            return;
        }
        MyController.StartAnimusPulseEffect();
        m_AnimusPulseOrigin = Origin;
        m_AnimPulseNormalizedStrength = normalizedStrength;
        GotoAnimusPulseState();
    }
    //return;    
}

function GotoAnimusPulseState()
{
    PushState('AnimusPulseEffect');
    //return;    
}

function SetAnimHitDeathState(SPPawn.EHitDeathState hitDeathState, optional bool bRestart)
{
    // End:0x42
    if((int(m_hitDeathState) != int(hitDeathState)) || bRestart == true)
    {
        bRestart = true;
        // End:0x42
        if(int(hitDeathState) == int(3))
        {
            m_deathAnimFinished = false;
        }
    }
    m_hitDeathState = hitDeathState;
    m_bRestartHitState = bRestart;
    //return;    
}

function SwapDeathMesh()
{
    local int I;

    Mesh.SetSkeletalMesh(m_FDDeathMesh, true, true);
    Mesh.SetPhysicsAsset(m_FDDeathPhysicsAsset);
    I = 0;
    J0x34:

    // End:0x6E [Loop If]
    if(I < 3)
    {
        Mesh.SetMaterial(I, m_DeathMtl[I]);
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    InitFadeMaterials();
    AttemptPhysAnimState_Ragdoll(true);
    //return;    
}

simulated function name DodgeTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'Default';
    Node.m_overrideBlendTime = 0.2500000;
    return retval;
    //return ReturnValue;    
}

simulated function DeathFinished()
{
    m_deathAnimFinished = true;
    //return;    
}

simulated function bool ShouldExplodeOnDeath()
{
    return IsDoingVulnerableAction();
    //return ReturnValue;    
}

simulated function name UberStateMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'NoAction';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetAction)
    {
        bResetChildOut = 1;
        m_bResetAction = false;
    }
    // End:0x64
    if((int(m_hitDeathState) == int(3)) || int(m_hitDeathState) == int(1))
    {
        return retval;
    }
    switch(m_actionState)
    {
        // End:0x83
        case 0:
            retval = 'NoAction';
            // End:0x16C
            break;
        // End:0x9A
        case 2:
            retval = 'FireSpit';
            // End:0x16C
            break;
        // End:0xB1
        case 4:
            retval = 'RingImmolate';
            // End:0x16C
            break;
        // End:0xC8
        case 5:
            retval = 'DirectedImmolatePrepare';
            // End:0x16C
            break;
        // End:0xDF
        case 6:
            retval = 'DirectedImmolateHold';
            // End:0x16C
            break;
        // End:0xF6
        case 8:
            retval = 'SpitObject';
            // End:0x16C
            break;
        // End:0x10D
        case 9:
            retval = 'GrabObject';
            // End:0x16C
            break;
        // End:0x124
        case 10:
            retval = 'SwipingTentacle';
            // End:0x16C
            break;
        // End:0x13B
        case 12:
            retval = 'QuadrupedToRoll';
            // End:0x16C
            break;
        // End:0x152
        case 13:
            retval = 'RollToQuadruped';
            // End:0x16C
            break;
        // End:0x169
        case 14:
            retval = 'WaterDeath';
            // End:0x16C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated function ActionFinished()
{
    local SPFireDrakeAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPFireDrakeAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.ActionFinished();
        }
    }
    //return;    
}

simulated function WaterDeathFinished()
{
    m_bWaterDeathAnimFinished = true;
    //return;    
}

function MouthOpenFinished()
{
    //return;    
}

k2override function ResumeCachedWallMove()
{
    // End:0x26
    if(m_transitionCachedReachSpec != none)
    {
        PrepareForWallAnimationReachSpec(m_transitionCachedReachSpec, m_transitionCachedVertexID);
        m_transitionCachedReachSpec = none;
    }
    //return;    
}

simulated function QuadrupedToRollFinished()
{
    local SPFireDrakeAIController MyController;

    // End:0x8D
    if(int(m_actionState) == int(12))
    {
        // End:0x2F
        if(int(Physics) != int(8))
        {
            SetMovementType(9);            
        }
        SetAnimActionState(0);
        m_bUsingRollingMovement = true;
        // End:0x83
        if(int(Physics) != int(8))
        {
            MyController = SPFireDrakeAIController(Controller);
            // End:0x83
            if(MyController != none)
            {
                MyController.QuadrupedToRollFinished();
            }
        }
        ResumeCachedWallMove();
    }
    //return;    
}

simulated function RollToQuadrupedFinished()
{
    local SPFireDrakeAIController MyController;

    // End:0x85
    if(int(m_actionState) == int(13))
    {
        // End:0x2F
        if(int(Physics) != int(8))
        {
            SetMovementType(8);            
        }
        SetAnimActionState(0);
        // End:0x7B
        if(int(Physics) != int(8))
        {
            MyController = SPFireDrakeAIController(Controller);
            // End:0x7B
            if(MyController != none)
            {
                MyController.RollToQuadrupedFinished();
            }
        }
        ResumeCachedWallMove();
    }
    //return;    
}

simulated function EnableHeatUpLight()
{
    local Vector Offset;

    m_bIsHeatUpLightAllowed = true;
    // End:0x7A
    if(Mesh != none)
    {
        Offset.X = 0.0000000;
        Offset.Y = 0.0000000;
        Offset.Z = 0.0000000;
        Mesh.AttachComponent(HeatUpLight, 'JO_CT_Spine_A', Offset);
    }
    //return;    
}

simulated function DisableHeatUpLight()
{
    m_bIsHeatUpLightAllowed = false;
    // End:0x24
    if(HeatUpLight != none)
    {
        HeatUpLight.SetEnabled(false);
    }
    //return;    
}

simulated function bool IsHeatUpLightEnabled()
{
    return m_bIsHeatUpLightAllowed;
    //return ReturnValue;    
}

simulated function OnToggleFireDrakeLight(SeqAct_ToggleFireDrakeLight Action)
{
    // End:0x2D
    if(Action.InputLinks[0].bHasImpulse)
    {
        EnableHeatUpLight();        
    }
    else
    {
        // End:0x5A
        if(Action.InputLinks[1].bHasImpulse)
        {
            DisableHeatUpLight();            
        }
        else
        {
            // End:0x74
            if(IsHeatUpLightEnabled())
            {
                DisableHeatUpLight();                
            }
            else
            {
                EnableHeatUpLight();
            }
        }
    }
    //return;    
}

state AnimusPulseEffect
{
    event PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        m_bExtractVelocityFromAnimationInPhysWalking = true;
        // End:0x2C
        if(Controller != none)
        {
            SPFireDrakeAIController(Controller).PulseEffectFinished();
        }
        ClearTimer('StartCoolDown');
        StartCoolDown();
        m_bPinballPhysics = false;
        //return;        
    }

    function SetLaunchVelocity()
    {
        local Vector launchDir;
        local Rotator launchAngle;

        m_bExtractVelocityFromAnimationInPhysWalking = false;
        launchDir = Location - m_AnimusPulseOrigin;
        launchAngle = Rotator(launchDir);
        launchAngle.Pitch += m_FireDrakeGDTuneData.AnimuPulseExtraLaunchRotatorPitch;
        // End:0x78
        if(launchAngle.Pitch > 16000)
        {
            launchAngle.Pitch = 16000;
        }
        // End:0xBC
        if(launchAngle.Pitch < m_FireDrakeGDTuneData.AnimuPulseExtraLaunchRotatorPitch)
        {
            launchAngle.Pitch = m_FireDrakeGDTuneData.AnimuPulseExtraLaunchRotatorPitch;
        }
        launchDir = Vector(launchAngle);
        Velocity += (launchDir * ((0.5000000 * (float(1) + m_AnimPulseNormalizedStrength)) * m_FireDrakeGDTuneData.AnimuPulseMaxLaunchSpeed));
        //return;        
    }

    function GotoAnimusPulseState()
    {
        GotoState('AnimusPulseEffect', 'Begin', false, true);
        //return;        
    }
Begin:

    // End:0x19
    if(int(Physics) == int(8))
    {
        SetLocation(Location);
    }
    SetAnimActionState(0);
    ForceMovementType(9);
    SetPhysics(2);
    m_bPinballPhysics = true;
    SetLaunchVelocity();
    StartHeatUpEffect();
    SetTimer(m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.AnimuPulseVulnerableTime), false, 'StartCoolDown');
    Sleep(m_FireDrakeGDTuneData.AnimuPulseSleepTime);
    PopState();
    stop;            
}

state Dying
{
    function StartDying()
    {
        local SPFireDrakeAIController MyController;

        SetCollision(true, false);
        MyController = SPFireDrakeAIController(Controller);
        // End:0x38
        if(MyController != none)
        {
            MyController.NotifyDying();            
        }
        else
        {
            // End:0x71
            if(Controller != none)
            {
                // End:0x64
                if(Controller.bIsPlayer)
                {
                    DetachFromController();                    
                }
                else
                {
                    Controller.Destroy();
                }
            }
        }
        // End:0x9D
        if(WaterDamageEmitter != none)
        {
            WaterDamageEmitter.ParticleSystemComponent.DeactivateSystem();
            WaterDamageEmitter = none;
        }
        StopRollingSound();
        DestroyRollingSoundActor();
        PlaySound(DeathSoundCue);
        //return;        
    }

    function EndDying()
    {
        local int I;
        local SPFireDrakeAIController MyController;

        MyController = SPFireDrakeAIController(Controller);
        // End:0x5D
        if(MyController != none)
        {
            MyController.NotifyDied();
            // End:0x50
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
            }
        }
        I = 0;
        J0x64:

        // End:0xA9 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x9F
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x64;
        }
        //return;        
    }

    function AddDeathImpulse()
    {
        local Vector upwards;

        // End:0xD0
        if(ShouldExplodeOnDeath())
        {
            upwards.X = 0.0000000;
            upwards.Y = 0.0000000;
            upwards.Z = 1.0000000;
            Mesh.AddImpulse(upwards * m_FireDrakeGDTuneData.ExplodingDeathUpwardsImpulseStrength, Location, 'None', true, 0.0000000, 0.0000000, self);
            Mesh.AddRadialImpulse(Location, m_FireDrakeGDTuneData.ExplodingDeathDamageRadius, m_FireDrakeGDTuneData.ExplodingDeathRadialImpulseStrength, 1, false, 0.0000000, 0.0000000, self);
        }
        //return;        
    }

    function HandleExplodingDeath()
    {
        local Emitter E;

        // End:0x10F
        if(ShouldExplodeOnDeath())
        {
            E = Spawn(Class'Engine.EmitterSpawnable',,, Location, Rotator(vect(0.0000000, 0.0000000, 0.0000000)));
            // End:0xBB
            if(E != none)
            {
                E.SetTemplate(m_DeathExplosionParticleTemplate, true);
                E.bDestroyOnSystemFinish = true;
                E.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                E.ParticleSystemComponent.ActivateSystem();
                E.bKillDuringLevelTransition = true;
            }
            AddDeathImpulse();
            HurtRadius(m_FireDrakeGDTuneData.ExplodingDeathDamageAmount, m_FireDrakeGDTuneData.ExplodingDeathDamageRadius, Class'SPDamageTypeExplosionFireDrakeDeath', m_FireDrakeGDTuneData.ExplodingDeathRadialImpulseStrength, Location, self, Controller, false);
        }
        //return;        
    }

    function bool IsRagdollDeath()
    {
        local class<PandoraDamageType> pandamage;

        pandamage = class<PandoraDamageType>(m_damageType);
        // End:0x35
        if((pandamage != none) && pandamage.default.bRagdollDeath == true)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    DisableTongueStretch();
    SetAnimHitDeathState(3);
    SetNovodexBoundingVolume(false);
    m_bEnablePhysicsPushing = false;
    SwapDeathMesh();
    PawnDeathDestructiblePropertyCheck();
    StartDying();
    HandleExplodingDeath();
    Sleep(0.0000000);
    EndDying();
    HandleBodyCleanup();
    stop;        
}
