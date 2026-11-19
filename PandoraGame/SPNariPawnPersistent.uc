class SPNariPawnPersistent extends SPPawn
    native
    config(Game);

enum ENariMaterialState
{
    NARIMATERIALSTATE_SOLID,        // 0
    NARIMATERIALSTATE_GHOST,        // 1
    NARIMATERIALSTATE_TRANSITIONTOGHOST,// 2
    NARIMATERIALSTATE_TRANSITIONTOSOLID,// 3
    NARIMATERIALSTATE_MAX           // 4
};

enum ENariAttackState
{
    NARINotAttacking,               // 0
    NARIClawSwipe,                  // 1
    NARISonicBlast,                 // 2
    NARITaunt,                      // 3
    NARIPolter,                     // 4
    NARIPathing,                    // 5
    NARIAnticipation,               // 6
    NARICloseTheGap,                // 7
    NARIDaze,                       // 8
    ENariAttackState_MAX            // 9
};

enum ENARIPolterState
{
    NARIIdle,                       // 0
    NARIAttack,                     // 1
    NARIDazed,                      // 2
    ENARIPolterState_MAX            // 3
};

/** VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPGriffonPawnPersistent.EHitReactionState m_hitReactionAnimState;
var SPNariPawnPersistent.ENariMaterialState m_MaterialState;
var SPNariPawnPersistent.ENariAttackState m_AttackState;
var SPNariPawnPersistent.ENARIPolterState m_PolterState;
var export editinline CylinderComponent m_collisionCylinder;
var export editinline CylinderComponent m_PoltergeistCollision;
var MaterialInstanceConstant m_GhostMaterialInstance;
var MaterialInstanceConstant m_TransitionMaterialInstance;
var MaterialInstanceConstant m_SolidMaterialInstance;
var MaterialInstanceConstant m_GhostWingMaterialInstance;
var MaterialInstanceConstant m_SolidWingMaterialInstance;
var MaterialInstanceConstant m_PolterMaterialInstance;
var bool m_bDying;
var bool m_bHasDamagedThisAttack;
var bool m_bFinishedDazed;
var bool m_bDoTransition;
var bool m_bFinishedDying;
var bool m_bSeekingAttackAnchor;
var bool m_resetHitAnim;
var bool m_resetAttackAnim;
var bool m_resetPolterAnim;
var name m_takeDamageBone;
var MaterialInterface m_TransitionMaterial;
var MaterialInterface m_GhostMaterial;
var MaterialInterface m_SolidMaterial;
var MaterialInterface m_GhostWingMaterial;
var MaterialInterface m_SolidWingMaterial;
var MaterialInterface m_PolterMaterial;
var SoundCue ToGhostSound;
var SoundCue ToSolidSound;
var SoundCue ImpactSound;
var SoundCue PoltergeistSound;
var SoundCue IntoWallSound;
var SoundCue OutofWallSound;
var SoundCue DeathSound;
var float m_fTransitionAmount;
var ParticleSystem TrailParticleTemplate;
var ParticleSystem PolterTrailParticleTemplate;
var ParticleSystem SonicParticleTemplate;
var SPEmitter TrailEmitter;
var ParticleSystem ClawParticleTemplate;
var SPEmitter ClawLeftEmitter;
var SPEmitter ClawRightEmitter;
var SPEmitter TransitionEmitter;
var ParticleSystem TransitionParticleTemplate;
var ParticleSystem DeathParticleTemplate;
var Vector lastHitDir;
var int Counter;
var float SuperDamageCounter;
var SPTuneDataNari m_NariTuneData;
var SPGameDifficultyTuneNari m_NariGDTuneData;
var SPNariAIController MyController;
var float m_PolterPulse;
var SkeletalMesh m_SolidMesh;
var SkeletalMesh m_GhostMesh;
var PhysicsAsset m_tempAsset;
var StaticMesh m_SonicCone;
var SPDStaticMesh m_SonicActor;
var transient Vector sonicDrawVector;

// Export USPNariPawnPersistent::execCloseEnoughToBeSolid(FFrame&, void* const)
native function bool CloseEnoughToBeSolid(Pawn MyEnemy);

// Export USPNariPawnPersistent::execSetPoltergeistCollision(FFrame&, void* const)
native function bool SetPoltergeistCollision(Actor polterTarget);

// Export USPNariPawnPersistent::execRemovePoltergeistMaterial(FFrame&, void* const)
native function bool RemovePoltergeistMaterial(Actor polterTarget);

// Export USPNariPawnPersistent::execGetMaxAttackDist(FFrame&, void* const)
native function float GetMaxAttackDist(Pawn MyEnemy);

// Export USPNariPawnPersistent::execSonicRangedAttack(FFrame&, void* const)
native function bool SonicRangedAttack(float Range, Vector Extent);

function SpawnParticleTransition()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x123
    if(Mesh.GetSocketWorldLocationAndRotation('emit', pos, Rot))
    {
        // End:0x123
        if(TransitionParticleTemplate != none)
        {
            // End:0x5D
            if(TransitionEmitter == none)
            {
                TransitionEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
            }
            // End:0x123
            if(TransitionEmitter != none)
            {
                TransitionEmitter.SetTemplate(TransitionParticleTemplate, true);
                TransitionEmitter.bDestroyOnSystemFinish = false;
                TransitionEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                TransitionEmitter.ParticleSystemComponent.ActivateSystem();
                TransitionEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_Root');
                TransitionEmitter.SetOwner(Controller);
                TransitionEmitter.bKillDuringLevelTransition = true;
            }
        }
    }
    //return;    
}

function StopParticleTransition()
{
    // End:0x25
    if(TransitionEmitter != none)
    {
        TransitionEmitter.ParticleSystemComponent.DeactivateSystem();
    }
    //return;    
}

function StartParticleTransition()
{
    // End:0x30
    if(TransitionEmitter != none)
    {
        TransitionEmitter.ParticleSystemComponent.ActivateSystem();
        DebugMe();
    }
    SpawnParticleTransition();
    //return;    
}

function KillParticleTransition()
{
    // End:0x29
    if(TransitionEmitter != none)
    {
        StopParticleTransition();
        TransitionEmitter.Destroy();
        TransitionEmitter = none;
    }
    //return;    
}

function SpawnParticleClaw()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x123
    if(Mesh.GetSocketWorldLocationAndRotation('RightClawEmitter', pos, Rot))
    {
        // End:0x123
        if(ClawParticleTemplate != none)
        {
            // End:0x5D
            if(ClawRightEmitter == none)
            {
                ClawRightEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
            }
            // End:0x123
            if(ClawRightEmitter != none)
            {
                ClawRightEmitter.SetTemplate(ClawParticleTemplate, true);
                ClawRightEmitter.bDestroyOnSystemFinish = false;
                ClawRightEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                ClawRightEmitter.ParticleSystemComponent.ActivateSystem();
                ClawRightEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_Root');
                ClawRightEmitter.SetOwner(Controller);
                ClawRightEmitter.bKillDuringLevelTransition = true;
            }
        }
    }
    // End:0x246
    if(Mesh.GetSocketWorldLocationAndRotation('LeftClawEmitter', pos, Rot))
    {
        // End:0x246
        if(ClawParticleTemplate != none)
        {
            // End:0x180
            if(ClawLeftEmitter == none)
            {
                ClawLeftEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
            }
            // End:0x246
            if(ClawLeftEmitter != none)
            {
                ClawLeftEmitter.SetTemplate(ClawParticleTemplate, true);
                ClawLeftEmitter.bDestroyOnSystemFinish = false;
                ClawLeftEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                ClawLeftEmitter.ParticleSystemComponent.ActivateSystem();
                ClawLeftEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_Root');
                ClawLeftEmitter.bKillDuringLevelTransition = true;
                ClawLeftEmitter.SetOwner(Controller);
            }
        }
    }
    //return;    
}

function StopParticleClaw()
{
    // End:0x25
    if(ClawLeftEmitter != none)
    {
        ClawLeftEmitter.ParticleSystemComponent.DeactivateSystem();
    }
    // End:0x4A
    if(ClawRightEmitter != none)
    {
        ClawRightEmitter.ParticleSystemComponent.DeactivateSystem();
    }
    //return;    
}

function StartParticleClaw()
{
    // End:0x26
    if(ClawLeftEmitter != none)
    {
        ClawLeftEmitter.ParticleSystemComponent.ActivateSystem();
    }
    // End:0x4C
    if(ClawRightEmitter != none)
    {
        ClawRightEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

function KillParticleClaw()
{
    // End:0x3D
    if(ClawLeftEmitter != none)
    {
        StopParticleClaw();
        ClawRightEmitter.Destroy();
        ClawRightEmitter = none;
        ClawLeftEmitter.Destroy();
        ClawLeftEmitter = none;
    }
    //return;    
}

function bool CanGoSolid()
{
    local Actor TempHitActor;
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;

    TempHitActor = none;
    TempHitActor = Trace(HitLocation, HitNormal, Location, Location, true,, HitInfo, 10, true);
    // End:0x3B
    if(TempHitActor == none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function StartParticleTrail()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x12C
    if(Mesh.GetSocketWorldLocationAndRotation('emit', pos, Rot))
    {
        // End:0x31
        if(TrailEmitter != none)
        {
        }
        // End:0x12C
        if((TrailParticleTemplate != none) && TrailEmitter == none)
        {
            TrailEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
            // End:0x12C
            if(TrailEmitter != none)
            {
                TrailEmitter.SetTemplate(TrailParticleTemplate, true);
                TrailEmitter.bDestroyOnSystemFinish = false;
                TrailEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                TrailEmitter.ParticleSystemComponent.ActivateSystem();
                TrailEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_Root');
                TrailEmitter.bKillDuringLevelTransition = true;
                TrailEmitter.SetOwner(self);
            }
        }
    }
    //return;    
}

function StopParticleTrail()
{
    // End:0x2F
    if(TrailEmitter != none)
    {
        TrailEmitter.ParticleSystemComponent.DeactivateSystem();
        DebugMe();
    }
    //return;    
}

function RestartParticleTrail()
{
    // End:0x30
    if(TrailEmitter != none)
    {
        TrailEmitter.ParticleSystemComponent.ActivateSystem();
        DebugMe();
    }
    //return;    
}

function StartPolterParticleTrail()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x11F
    if(Mesh.GetSocketWorldLocationAndRotation('emit', pos, Rot))
    {
        // End:0x11F
        if(PolterTrailParticleTemplate != none)
        {
            // End:0x5D
            if(TrailEmitter == none)
            {
                TrailEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
            }
            // End:0x11F
            if(TrailEmitter != none)
            {
                TrailEmitter.SetTemplate(PolterTrailParticleTemplate, true);
                TrailEmitter.bDestroyOnSystemFinish = false;
                TrailEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                TrailEmitter.ParticleSystemComponent.ActivateSystem();
                TrailEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_Root');
                TrailEmitter.bKillDuringLevelTransition = true;
                TrailEmitter.SetOwner(self);
            }
        }
    }
    //return;    
}

function KillParticleTrail()
{
    // End:0x29
    if(TrailEmitter != none)
    {
        StopParticleTrail();
        TrailEmitter.Destroy();
        TrailEmitter = none;
    }
    //return;    
}

function TransitionToSolid(optional bool Force = false)
{
    local PlayerController playCon;

    NativeSetInvisible(false);
    // End:0x13B
    if(((int(m_MaterialState) != int(0)) || bBlockActors == false) || Force == true)
    {
        // End:0x13B
        if(CanGoSolid())
        {
            m_MaterialState = 0;
            Mesh.SetSkeletalMesh(m_SolidMesh, true, true);
            Mesh.SetMaterial(0, m_SolidWingMaterialInstance);
            Mesh.SetMaterial(1, m_SolidMaterialInstance);
            StopParticleTrail();
            SetCollision(true, true);
            bCollideWorld = true;
            bBlockActors = true;
            StartParticleTransition();
            // End:0xE1
            if(ToSolidSound != none)
            {
                PlaySound(ToSolidSound, true);
            }
            // End:0x137
            foreach LocalPlayerControllers(Class'Engine.PlayerController', playCon)
            {
                // End:0x136
                if(PandoraPlayerController(playCon) != none)
                {
                    PandoraPlayerController(playCon).PlayAmBxScript("event_nari_unghost", 500);
                }                
            }                        
        }
    }
    //return;    
}

function TransitionToGhost(optional bool Force = false)
{
    local PlayerController playCon;

    // End:0x166
    if(((Controller != none) && !Controller.IsInState('CATAttacker')) && !IsInState('CATAttacker'))
    {
        NativeSetInvisible(false);
        // End:0x166
        if(((int(m_MaterialState) != int(1)) || bBlockActors == true) || Force == true)
        {
            m_MaterialState = 1;
            StartParticleTransition();
            Mesh.SetSkeletalMesh(m_GhostMesh, true, true);
            Mesh.SetMaterial(0, m_GhostWingMaterialInstance);
            Mesh.SetMaterial(1, m_GhostMaterialInstance);
            RestartParticleTrail();
            SetCollision(false, false);
            bCollideWorld = false;
            bBlockActors = false;
            // End:0x111
            if(ToGhostSound != none)
            {
                PlaySound(ToGhostSound, true);
            }
            // End:0x165
            foreach LocalPlayerControllers(Class'Engine.PlayerController', playCon)
            {
                // End:0x164
                if(PandoraPlayerController(playCon) != none)
                {
                    PandoraPlayerController(playCon).PlayAmBxScript("event_nari_ghost", 500);
                }                
            }            
        }
    }
    //return;    
}

function bool IsInGhostState()
{
    // End:0x20
    if((int(m_MaterialState) == int(1)) && bBlockActors == false)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInSolidState()
{
    // End:0x20
    if((int(m_MaterialState) == int(0)) && bBlockActors == true)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

// Export USPNariPawnPersistent::execNativeSetInvisible(FFrame&, void* const)
native function NativeSetInvisible(bool DoIt);

simulated function SetInvisible()
{
    NativeSetInvisible(true);
    Mesh.SetMaterial(0, none);
    Mesh.SetMaterial(1, none);
    //return;    
}

simulated function SetGhost()
{
    TransitionToGhost();
    //return;    
}

simulated function SetSolid()
{
    TransitionToSolid();
    //return;    
}

simulated function ScaleSonicMesh()
{
    sonicDrawVector.X += 0.0500000;
    m_SonicActor.SetDrawScale3D(sonicDrawVector);
    //return;    
}

simulated event Tick(float DeltaTime)
{
    ServerTick_SPNariPawnPeristent(DeltaTime);
    super.Tick(DeltaTime);
    //return;    
}

final function ServerTick_SPNariPawnPeristent(float DeltaTime)
{
    // End:0x1B
    if(MyController == none)
    {
        MyController = SPNariAIController(Controller);
    }
    // End:0x47
    if((MyController != none) && MyController.m_PoltergeistTarget != none)
    {
        PulsePoltergeist();
    }
    // End:0x5C
    if(m_SonicActor != none)
    {
        ScaleSonicMesh();
    }
    //return;    
}

simulated function name NariMovementCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local float fAngle;

    fAngle = float(DesiredRotation.Yaw - Rotation.Yaw);
    // End:0x85
    if((fAngle > float(5)) || fAngle < float(-5))
    {
        // End:0x7B
        if(Vector(DesiredRotation) Cross Vector(Rotation).Z < float(0))
        {
            return 'Right';            
        }
        else
        {
            return 'Left';
        }
    }
    // End:0xB1
    if((VSize(Velocity) > float(5)) || int(m_MaterialState) == int(0))
    {
        return 'Forward';
    }
    return 'Idle';
    //return ReturnValue;    
}

simulated function name HitOrDeathAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_resetHitAnim)
    {
        bResetChildOut = 1;
        m_resetHitAnim = false;
    }
    switch(m_hitDeathState)
    {
        // End:0x32
        case 1:
            return 'Hit';
            // End:0x54
            break;
        // End:0x44
        case 3:
            return 'Death';
            // End:0x54
            break;
        // End:0xFFFF
        default:
            return 'Default';
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
}

simulated function name NariISAttackingMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_AttackState)
    {
        // End:0x1A
        case 0:
            return 'NotAttacking';
            // End:0xA8
            break;
        // End:0x2C
        case 1:
            return 'Attacking';
            // End:0xA8
            break;
        // End:0x3E
        case 2:
            return 'Blasting';
            // End:0xA8
            break;
        // End:0x4D
        case 3:
            return 'Taunt';
        // End:0x5C
        case 4:
            return 'Poltergeist';
        // End:0x6B
        case 5:
            return 'Pathing';
        // End:0x7A
        case 6:
            return 'AttackAnticipation';
        // End:0x89
        case 7:
            return 'CloseTheGap';
        // End:0x98
        case 8:
            return 'dazed';
        // End:0xFFFF
        default:
            return 'NotAttacking';
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A8
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A8    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A8
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A8
}

simulated function name NariQuadAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local bool Above, Right;
    local Pawn pEnemyPawn;

    // End:0x18
    if(m_resetAttackAnim)
    {
        bResetChildOut = 1;
        m_resetAttackAnim = false;
    }
    // End:0x2D
    if(MyController == none)
    {
        return 'Center';
    }
    pEnemyPawn = MyController.GetEnemy();
    // End:0x5C
    if(pEnemyPawn == none)
    {
        return 'Center';
    }
    // End:0x9D
    if((Location.Z - pEnemyPawn.Location.Z) > 100.0000000)
    {
        Above = false;        
    }
    else
    {
        // End:0xDE
        if((Location.Z - pEnemyPawn.Location.Z) < 50.0000000)
        {
            Above = true;            
        }
        else
        {
            return 'Center';
        }
    }
    Right = true;
    // End:0x12A
    if(Vector(Rotation) Cross (pEnemyPawn.Location - Location).Z > float(0))
    {
        Right = false;
    }
    // End:0x153
    if(Above)
    {
        // End:0x146
        if(Right)
        {
            return 'HighRight';
        }
        return 'HighLeft';        
    }
    else
    {
        // End:0x166
        if(Right)
        {
            return 'LowRight';
        }
        return 'LowLeft';
    }
    return 'Center';
    //return ReturnValue;    
}

simulated function name NariPoltergeistMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_resetPolterAnim)
    {
        bResetChildOut = 1;
        m_resetPolterAnim = false;
    }
    switch(m_PolterState)
    {
        // End:0x32
        case 0:
            return 'Idle';
            // End:0x66
            break;
        // End:0x44
        case 1:
            return 'Attack';
            // End:0x66
            break;
        // End:0x56
        case 2:
            return 'dazed';
            // End:0x66
            break;
        // End:0xFFFF
        default:
            return 'Idle';
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x066
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x066    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x066
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x066
}

function SetAnimHitDeathState(SPPawn.EHitDeathState hitDeathState, optional bool bRestart)
{
    // End:0x2A
    if((int(m_hitDeathState) != int(hitDeathState)) || bRestart == true)
    {
        bRestart = true;
    }
    m_hitDeathState = hitDeathState;
    //return;    
}

simulated function PulsePoltergeist()
{
    // End:0x1A
    if(m_PolterPulse > 5.0000000)
    {
        m_PolterPulse = 2.0000000;
    }
    m_PolterMaterialInstance.SetScalarParameterValue('FadeIn', FClamp(1.0000000 - (m_PolterPulse / float(3)), 0.6000000, 1.0000000));
    m_PolterMaterialInstance.SetScalarParameterValue('glow', m_PolterPulse);
    m_PolterPulse += 0.1000000;
    //return;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Nari;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.NariGD;
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    m_NariTuneData = SPTuneDataNari(GetMyTuneData());
    m_NariGDTuneData = SPGameDifficultyTuneNari(GetMyGDData());
    //return;    
}

simulated function PostBeginPlay()
{
    m_SolidMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
    m_SolidMaterialInstance.SetParent(m_SolidMaterial);
    m_GhostMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
    m_GhostMaterialInstance.SetParent(Mesh.GetMaterial(1));
    Mesh.SetMaterial(1, m_GhostMaterialInstance);
    m_GhostWingMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
    m_GhostWingMaterialInstance.SetParent(m_GhostWingMaterial);
    Mesh.SetMaterial(0, m_GhostWingMaterialInstance);
    m_SolidWingMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
    m_SolidWingMaterialInstance.SetParent(m_SolidWingMaterial);
    m_PolterMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
    m_PolterMaterialInstance.SetParent(m_PolterMaterial);
    m_PolterMaterialInstance.SetScalarParameterValue('FadeIn', 0.0000000);
    m_PolterMaterialInstance.SetScalarParameterValue('glow', 4.0000000);
    Mesh.CastShadow = false;
    SetCollision(false, false);
    super.PostBeginPlay();
    SpawnParticleTransition();
    StopParticleTransition();
    StartParticleTrail();
    MyController = SPNariAIController(Controller);
    //return;    
}

function NariAttackAnticipationFinishedCB()
{
    m_AttackState = 0;
    //return;    
}

function NariClosetheGapAnimFinishedCB()
{
    m_AttackState = 0;
    //return;    
}

function NariHitAnimFinishCB()
{
    SetAnimHitDeathState(0);
    // End:0x38
    if(Controller.IsInState('TakeHit'))
    {
        Controller.PopState();
    }
    // End:0x4F
    if(IsInState('TakeHit'))
    {
        PopState();
    }
    // End:0x6C
    if(IsInState('Dying'))
    {
        SetAnimHitDeathState(3);
    }
    //return;    
}

function NariDeathAnimFinishCB()
{
    m_bFinishedDying = true;
    //return;    
}

function NariClawSwipeAnimFinishedCB()
{
    m_AttackState = 0;
    //return;    
}

function NariSonicBlastAnimFinishedCB()
{
    m_AttackState = 0;
    //return;    
}

function NariTauntAnimFinishedCB()
{
    m_AttackState = 0;
    //return;    
}

function NariDazedAnimFinishedCB()
{
    m_bFinishedDazed = true;
    m_AttackState = 0;
    //return;    
}

function NariPolterIdleAnimFinishedCB()
{
    m_PolterState = 1;
    //return;    
}

function NariPolterDazedAnimFinishedCB()
{
    m_AttackState = 0;
    m_PolterState = 0;
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    m_takeDamageBone = HitInfo.BoneName;
    // End:0x9C
    if((DamageType == Class'SPDamageTypeAnimusPulse') || ClassIsChildOf(DamageType, Class'SPDamageTypeExplosionFireDrakeImmolate'))
    {
        // End:0x51
        if(Controller.bGodMode == true)
        {
            return;
        }
        MyController.GotoState('dazed');
        super.ServerOnlyTakeDamage(0.0000000, EventInstigator, HitLocation, vect(0.0000000, 0.0000000, 0.0000000), DamageType, HitInfo, DamageCauser);
        return;
    }
    // End:0x114
    if((MyController.m_PoltergeistTarget != none) && MyController.m_bWasBumped)
    {
        // End:0xD3
        if(EventInstigator == none)
        {
            return;
        }
        MyController.m_PoltergeistTarget.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    Momentum = lastHitDir;
    // End:0x137
    if(int(m_hitDeathState) == int(0))
    {
        m_resetHitAnim = true;
    }
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

event HitByDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    // End:0x2D
    if(!Controller.bGodMode == true)
    {
        super.HitByDamagePulse(Origin, normalizedStrength, DamageType);
    }
    //return;    
}

// Export USPNariPawnPersistent::execDebugMe(FFrame&, void* const)
native function DebugMe();

event TakeImpactDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    // End:0x38
    if((MyController.m_PoltergeistTarget != none) && MyController.m_bWasBumped)
    {
        // End:0x38
        if(instigatedBy == none)
        {
            return;
        }
    }
    super(Actor).TakeImpactDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    //return;    
}

event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
{
    local Vector vec;
    local float DamageAmount, Range;
    local Rotator SocketRot;
    local Vector baseLocation;
    local Pawn pEnemyPawn;
    local float tempdmgamount;

    // End:0x0B
    if(m_bHasDamagedThisAttack)
    {
        return false;
    }
    switch(DamageType)
    {
        // End:0x59
        case 10:
            DamageAmount = m_NariGDTuneData.GetValue(m_NariGDTuneData.ClawDamageAmount);
            Range = m_NariGDTuneData.ClawSwipeRange;
            // End:0x19A
            break;
        // End:0x110
        case 11:
            DamageAmount = m_NariGDTuneData.GetValue(m_NariGDTuneData.SuperDamageAmount);
            SuperDamageCounter += DamageAmount;
            tempdmgamount = m_NariGDTuneData.GetValue(m_NariGDTuneData.MaxSuperDamageAmount) - SuperDamageCounter;
            // End:0xF8
            if(tempdmgamount < DamageAmount)
            {
                // End:0xED
                if(tempdmgamount > float(0))
                {
                    DamageAmount = tempdmgamount;                    
                }
                else
                {
                    DamageAmount = 0.0000000;
                }
            }
            Range = m_NariGDTuneData.CloseTheGapRange;
            // End:0x19A
            break;
        // End:0x156
        case 12:
            DamageAmount = m_NariGDTuneData.GetValue(m_NariGDTuneData.ScreamDamageAmount);
            Range = m_NariGDTuneData.SonicRange;
            // End:0x19A
            break;
        // End:0xFFFF
        default:
            DamageAmount = m_NariGDTuneData.GetValue(m_NariGDTuneData.ClawDamageAmount);
            Range = m_NariGDTuneData.ClawSwipeRange;
            // End:0x19A
            break;
            break;
    }
    pEnemyPawn = Controller.GetEnemy();
    // End:0x2E9
    if(int(m_AttackState) == int(2))
    {
        // End:0x2B8
        if(m_SonicActor == none)
        {
            vec = pEnemyPawn.Mesh.GetBoneLocation('JO_head');
            Mesh.GetSocketWorldLocationAndRotation('sonic', baseLocation, SocketRot);
            SocketRot = Rotator(vec - baseLocation);
            m_SonicActor = Spawn(Class'SPDStaticMesh',,, baseLocation, SocketRot);
            m_SonicActor.StaticMeshComponent.SetStaticMesh(m_SonicCone);
            m_SonicActor.SetCollision(false, false);
            SonicRangedAttack(Range, vect(60.0000000, 60.0000000, 60.0000000));
            sonicDrawVector = vect(2.0000000, 2.0000000, 2.0000000);
            return true;            
        }
        else
        {
            m_SonicActor.StaticMeshComponent.SetHidden(true);
            m_SonicActor.Destroy();
            m_SonicActor = none;
            return true;
        }
    }
    // End:0x318
    if(!Mesh.GetSocketWorldLocationAndRotation(SocketName, baseLocation, SocketRot))
    {
        baseLocation = Location;
    }
    vec = baseLocation - pEnemyPawn.Location;
    // End:0x3A5
    if(VSize(vec) < Range)
    {
        pEnemyPawn.TakeDamageAndProcEffects(DamageAmount, Controller, pEnemyPawn.Location, Vector(Rotation), Class'SPDamageTypeNari',, self);
        m_bHasDamagedThisAttack = true;
        // End:0x3A3
        if(ImpactSound != none)
        {
            PlaySound(ImpactSound);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

event ApplySonicDamage(Actor Victim)
{
    local float dmg;

    dmg = m_NariGDTuneData.GetValue(m_NariGDTuneData.ScreamDamageAmount);
    // End:0x54
    if((dmg < 1.0000000) && dmg > 0.0000000)
    {
        dmg = 1.0000000;
    }
    Victim.TakeDamageAndProcEffects(dmg, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'SPDamageTypeImpactNariScream');
    //return;    
}

simulated event Destroyed()
{
    TrailEmitter.Destroy();
    TransitionEmitter.Destroy();
    m_SonicActor.Destroy();
    //return;    
}

state Dying
{
    event PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    function ContinuedState()
    {
        super(Object).ContinuedState();
        //return;        
    }

    event PoppedState()
    {
        KillParticleTransition();
        KillParticleTrail();
        super.PoppedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        KillParticleTransition();
        KillParticleTrail();
        super.EndState(NextStateName);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndDying()
    {
        // End:0x37
        if(Controller != none)
        {
            // End:0x37
            if(MyController != none)
            {
                MyController.NotifyDied();
                Controller.Destroy();
            }
        }
        //return;        
    }

    function SpawnParticleDeath()
    {
        local Vector pos;
        local Rotator Rot;

        // End:0x123
        if(Mesh.GetSocketWorldLocationAndRotation('emit', pos, Rot))
        {
            // End:0x123
            if(TransitionParticleTemplate != none)
            {
                // End:0x5D
                if(TransitionEmitter == none)
                {
                    TransitionEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
                }
                // End:0x123
                if(TransitionEmitter != none)
                {
                    TransitionEmitter.SetTemplate(DeathParticleTemplate, true);
                    TransitionEmitter.bDestroyOnSystemFinish = false;
                    TransitionEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                    TransitionEmitter.ParticleSystemComponent.ActivateSystem();
                    TransitionEmitter.SetBase(self, vect(0.0000000, 0.0000000, 1.0000000), Mesh, 'JO_Root');
                    TransitionEmitter.SetOwner(Controller);
                    TransitionEmitter.bKillDuringLevelTransition = true;
                }
            }
        }
        //return;        
    }
Begin:

    // End:0x1B
    if(DeathSound != none)
    {
        PlaySound(DeathSound, true);
    }
    // End:0x45
    if(MyController.m_PoltergeistTarget != none)
    {
        MyController.ExitPossession();
    }
    ToSolidSound = none;
    TransitionToSolid(true);
    bBlockActors = false;
    StopParticleTrail();
    SetHidden(true);
    SpawnParticleDeath();
    PawnDeathDestructiblePropertyCheck();
    Mesh.StopAnim();
    SetAnimHitDeathState(3);
    Health = 0;
    // End:0xCF
    if(Controller != none)
    {
        Controller.GotoState('ControllerDying');
    }
    Sleep(0.1000000);
    KillParticleClaw();
    TriggerEventClass(Class'Engine.SeqEvent_Death', self);
    Sleep(10.0000000);
    Counter = 0;
    J0x103:

    // End:0x12E [Loop If]
    if(!m_bFinishedDying && Counter < 100)
    {
        Sleep(0.1000000);
        Counter++;
        // [Loop Continue]
        goto J0x103;
    }
    ClearTimer();
    Sleep(15.0000000);
    KillParticleTransition();
    EndDying();
    Destroy();
    stop;            
}

state TakeHit
{
    function ClearState()
    {
        m_hitDeathState = 0;
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearState();
        //return;        
    }

    function PoppedState()
    {
        ClearState();
        //return;        
    }
Begin:

    TransitionToSolid();
    m_hitDeathState = 1;
    stop;                    
}
