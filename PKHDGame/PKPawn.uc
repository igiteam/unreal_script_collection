class PKPawn extends EvilPawn
    native(Pawn)
    config(Pawn)
    hidecategories(Navigation);

enum EPainMaterialType
{
    PKMT_Default,                   // 0
    PKMT_Frozen,                    // 1
    PKMT_Burning,                   // 2
    PKMT_Captured,                  // 3
    PKMT_MAX                        // 4
};

enum EPainHitEffectType
{
    PHEF_Electricity,               // 0
    PHEF_SoulReaper,                // 1
    PHEF_SoulReaperCapture,         // 2
    PHEF_Fire,                      // 3
    PHEF_MAX                        // 4
};

enum EMaterialOverride
{
    EMO_None,                       // 0
    EMO_Demon,                      // 1
    EMO_Ghost,                      // 2
    EMO_MAX                         // 3
};

struct native ReplicatedFrozenParams
{
    var bool bIsFrozen;
    var float FrozenTime;

    structdefaultproperties
    {
        bIsFrozen=false
        FrozenTime=0.0000000
    }
};

struct native ReplicatedSoulParams
{
    var bool bHasSoulEffects;

    structdefaultproperties
    {
        bHasSoulEffects=false
    }
};

struct native ReplicatedHitEffectParams
{
    var bool bStarted;
    var PKPawn.EPainHitEffectType EffectType;

    structdefaultproperties
    {
        bStarted=false
        EffectType=EPainHitEffectType.PHEF_Electricity
    }
};

struct native ReplicatedArchetypeEffectParams
{
    var Vector Location;
    var Rotator Rotation;
    var EvilExplosion EffectType;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        EffectType=none
    }
};

var() config bool bIsBoss;
var config bool bNotCountable;
var config bool bThrowSoul;
var config bool bThrowRedSoul;
var config bool bCanBeFrozen;
var bool bIsFrozen;
var() config bool bUseAimOffsets;
var() config bool bHasTIPAnims45Deg;
var() config bool bHasTIPAnims90Deg;
var() config bool bHasTIPAnims180Deg;
var() config bool bShouldPlayTIPAnimsOnBottomHalfOnly45Deg;
var() config bool bShouldPlayTIPAnimsOnBottomHalfOnly90Deg;
var() config bool bShouldPlayTIPAnimsOnBottomHalfOnly180Deg;
var transient bool bApplyPostTIPYawOffset;
var bool bStopToTurn;
var config bool EnableGibWhenHPBelow;
var bool bGetAdjustedAimFromSocket;
var() bool bPoisoned;
var const transient bool bPinned;
var bool bCanBePinned;
var bool bHitWhenThrow;
var bool bAdjustingVelocity;
var bool bSpawnNextPawnWhenBodyDisapear;
var bool bBlockSpawnNextPawn;
var bool bWasNotCountable;
var bool bEnablePoisonSlowdown;
var PKAIController MyPKAI;
var class<PainItem_Energy> SoulItemClass;
var class<PainItem_Energy> RedSoulItemClass;
var config float InstantGibOriginShiftX;
var config float InstantGibOriginShiftZ;
var config float InstantGibForce;
var repnotify ReplicatedSoulParams RepSoulParams;
var repnotify ReplicatedFrozenParams RepFrozenParams;
var float FrozenTime;
var float RemainingFrozenTime;
var transient float TimeOfDeath;
var ParticleSystem SoulEffectPS;
var export editinline ParticleSystemComponent SoulEffectPSC;
var export editinline ParticleSystemComponent FrozenEffectPSC;
var ParticleSystem FrozenEffectPS;
var EvilLightActor FrozenLightActor;
var EvilLightActor FrozenLightArchetype;
var export editinline ParticleSystemComponent FullBodyHitEffectPSC;
var ParticleSystem ElectricityEffectPS;
var ParticleSystem SoulReaperEffectPS;
var array<SoundCue> SparksSoundCues;
var array<name> ElectricityConvulsionsBones;
var repnotify float StartConvulsionsTime;
var float ConvulsionsLength;
var SoundCue GibImpactSoundCue;
var SoundCue GibFrozenImpactSoundCue;
var SoundCue DetachingLimbSoundCue;
var SoundCue DetachingLimbBySoulSawSoundCue;
var SoundCue FullGibSoundCue;
var SoundCue FullFrozenGibSoundCue;
var ParticleSystem GibImpactParticleSystem;
var array<MaterialInstance> GibImpactDecalMaterials;
var MaterialInterface ImmortalMaterial;
var PhysicalMaterial DefaultImpactMaterial;
var SoundCue BodyExplosionSound;
var ParticleSystem BodyExplosionPS;
var ParticleSystem BodyExplosionNoSoulPS;
var export editinline ParticleSystemComponent BodyExplosionPSC;
var AnimNodeSequence CustomAnimNode;
var config float SoulShiftUpDistance;
var MaterialInterface DemonModeMaterial;
var protected transient array<MaterialInterface> MaterialsBackup;
var() float SlowDownDistance;
var() class<EvilProjectile_Base> ThrowableProjectile;
var() PKMaterialAtlas PKMaterialAtlasArchetype;
var() PainItem_Energy Soul;
var repnotify ReplicatedHitEffectParams RepHitEffectParams;
var repnotify ReplicatedArchetypeEffectParams RepArchetypeEffectParams;
var transient int PostRotationYaw;
var SkelControlSingleBone TIPSpineRotatorSkelControl;
var config float EnableGibWhenHPBelowFactor;
var config float KillScoreSV;
var transient int GibEffectCount;
var transient int GibImpactSoundCount;
var transient int GibImpactDecalCount;
var transient int GibImpactPSCount;
var int GibImpactSoundLimitCount;
var int GibImpactDecalLimitCount;
var int GibImpactPSLimitCount;
var float CaptureIntensity;
var float PoisonTimeout;
var array<PKStakeVirtualProjectile> PinningStakes;
var Pawn CaptureInstigator;
var() export editinline StaticMeshComponent ProjectileSM;
var() export editinline ParticleSystemComponent ProjectilePSC;
var Vector AdjustVelocityDir;
var float AdjustVelocitySpeed;
var float RootMotionExtractedDeltaTime;
var float LastRootMotionExtractedTime;
var class<PKPawn> NextPawnClass;
var PKPawn NextPawnInstance;
var repnotify ParticleSystem SpawnFxPS;
var export editinline ParticleSystemComponent SpawnFxPSC;
var transient int HitByPainCount;
var transient int TreasureGained;
var repnotify PKPawn.EMaterialOverride MaterialOverride;
var SkeletalMesh NoGoreSkeletalMesh;
var transient float CurrentPoisonSpeedModifier;

replication
{
    // Pos:0x000
    if((!bNetOwner || bDemoRecording) && int(Role) == int(ROLE_Authority))
        RepFrozenParams, RepHitEffectParams, 
        StartConvulsionsTime;

    // Pos:0x031
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        MaterialOverride, RepArchetypeEffectParams, 
        RepSoulParams, SpawnFxPS, 
        bThrowSoul;
}

event BumpLevel(Vector HitLocation, Vector HitNormal)
{
    // End:0x40
    if(MyPKAI != none)
    {
        MyPKAI.NotifyBumpLevel(HitLocation, HitNormal);
    }
    //return;    
}

function InitDefaultHealth()
{
    super.InitDefaultHealth();
    // End:0xE1
    if(PKGameSP(WorldInfo.Game) != none)
    {
        Health = int(float(Health) * PKGameSP(WorldInfo.Game).MonsterInitialHealthModifier);
        HealthMax = int(float(HealthMax) * PKGameSP(WorldInfo.Game).MonsterInitialHealthModifier);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local EvilInventoryManager invmng;
    local PKPlayerController PC;

    MovementSpeedModifier = RandRange(0.8500000, 1.1500000);
    super.PostBeginPlay();
    // End:0x5D
    if(int(Physics) == int(4))
    {
        Mesh.bRootMotionExtractedNotify = true;
    }
    LastRootMotionExtractedTime = WorldInfo.TimeSeconds;
    invmng = EvilInventoryManager(InvManager);
    // End:0xD1
    if(invmng != none)
    {
        invmng.bInfiniteAmmo = true;
    }
    // End:0x15A
    if(WorldInfo.IsConsoleBuild())
    {
        Mesh.bCastDynamicShadow = false;
        Mesh.bPerBoneMotionBlur = false;
        Mesh.MotionBlurInstanceScale = 0.0000000;
    }
    // End:0x223
    foreach LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        // End:0x202
        if(PC.IsInState('Demon'))
        {
            PC.DemonModeHighlights.AddItem(Mesh);
            SetDemonMaterial(true, IsSameTeam(PC.Pawn));
            // End:0x223
            break;
            // End:0x222
            continue;
        }
        PC.UpdatePowerUpEffectsFor(self);        
    }    
    // End:0x244
    if(!PlaySpawnVoice())
    {
        MakeNoise(1.0000000, 'PlaySpawnVoice');
    }
    // End:0x298
    if(Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
    {
        TimeToBodyDisappear = TimeToBodyDisappear_NoGore * RandRange(0.8000000, 1.0000000);
    }
    //return;    
}

simulated function SetImmortalMaterial(optional bool bRollback)
{
    // End:0x51
    if(bRollback)
    {
        Mesh.SetMaterial(1, Mesh.default.Materials[1]);        
    }
    else
    {
        Mesh.SetMaterial(1, ImmortalMaterial);
    }
    //return;    
}

simulated event RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
    super(Actor).RootMotionExtracted(SkelComp, ExtractedRootMotionDelta);
    RootMotionExtractedDeltaTime = WorldInfo.TimeSeconds - LastRootMotionExtractedTime;
    // End:0x98
    if((SkelComp == Mesh) && int(Physics) == int(4))
    {
        ProcessFlyingMotion(ExtractedRootMotionDelta, RootMotionExtractedDeltaTime);
    }
    LastRootMotionExtractedTime = WorldInfo.TimeSeconds;
    //return;    
}

simulated function ProcessFlyingMotion(out BoneAtom MotionDelta, float DeltaTime)
{
    // End:0x69
    if((int(CurrentMoveMode) == int(2)) || int(CurrentMoveMode) == int(1))
    {
        MotionDelta.Translation += ((GroundSpeed * Vector(Rotation)) * DeltaTime);
    }
    //return;    
}

reliable client simulated function ClientDisableWeapons()
{
    // End:0x16
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    // End:0x99
    if((Weapon != none) && !Weapon.IsInState('Frozen'))
    {
        InvManager.ClearAllPendingFire(Weapon);
        Weapon.GotoState('Frozen');
    }
    //return;    
}

function DisableWeapons(optional float interval)
{
    // End:0x8E
    if((Weapon != none) && !Weapon.IsInState('Frozen'))
    {
        ClientDisableWeapons();
        InvManager.ClearAllPendingFire(Weapon);
        Weapon.GotoState('Frozen');
    }
    // End:0xB4
    if(interval > 0.0000000)
    {
        EnableWeapons(interval);
    }
    //return;    
}

reliable client simulated function ClientEnableWeapons()
{
    // End:0x16
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    // End:0x6F
    if((Weapon != none) && Weapon.IsInState('Frozen'))
    {
        Weapon.GotoState('Active');
    }
    //return;    
}

function EnableWeapons(optional float Delay)
{
    // End:0x67
    if(Delay > 0.0000000)
    {
        // End:0x64
        if(GetRemainingTimeForTimer(GetFuncName()) < Delay)
        {
            ClearTimer(GetFuncName());
            SetTimer(Delay, false, GetFuncName());
        }        
    }
    else
    {
        // End:0xE9
        if(GetRemainingTimeForTimer(GetFuncName()) <= 0.0000000)
        {
            // End:0xE9
            if((Weapon != none) && Weapon.IsInState('Frozen'))
            {
                ClientEnableWeapons();
                Weapon.GotoState('Active');
            }
        }
    }
    //return;    
}

function bool ShouldPlayFullBodyHit(class<DamageType> DamageType, optional Controller EventInstigator)
{
    return ((super.ShouldPlayFullBodyHit(DamageType, EventInstigator) && MyPKAI != none) && !MyPKAI.bConfused) && (DamageType != Class'PKDmgType_SoulReaper') || (PainPRI(EventInstigator.PlayerReplicationInfo) != none) && int(PainPRI(EventInstigator.PlayerReplicationInfo).Difficulty.default.DifficultyLevel) <= int(0);
    //return ReturnValue;    
}

function OnMissedPlaySound()
{
    // End:0x5A
    if(MyPKAI != none)
    {
        // End:0x5A
        if(MyPKAI.LastMeleeHitTime < MyPKAI.LastMeleeMissedTime)
        {
            PlayMeleeAttackMissSound();
        }
    }
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);
    MyPKAI = PKAIController(C);
    MakeNoise(1.0000000, 'Spawn');
    //return;    
}

function UnPossessed()
{
    super.UnPossessed();
    MyPKAI = none;
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0xBA
        case 'RepFrozenParams':
            bIsFrozen = RepFrozenParams.bIsFrozen;
            // End:0xAD
            if(bIsFrozen)
            {
                FrozenTime = RepFrozenParams.FrozenTime;
                RemainingFrozenTime = RepFrozenParams.FrozenTime;
                StartFrozenEffect();                
            }
            else
            {
                StopFrozenEffect();
            }
            // End:0x1C1
            break;
        // End:0xD3
        case 'StartConvulsionsTime':
            ClientStartConvulsions();
            // End:0x1C1
            break;
        // End:0xEC
        case 'RepHitEffectParams':
            ClientProcessHitEffectParams();
            // End:0x1C1
            break;
        // End:0x159
        case 'RepArchetypeEffectParams':
            PlayArchetypeEffect(RepArchetypeEffectParams.EffectType, RepArchetypeEffectParams.Location, RepArchetypeEffectParams.Rotation);
            // End:0x1C1
            break;
        // End:0x192
        case 'RepSoulParams':
            // End:0x18F
            if(RepSoulParams.bHasSoulEffects)
            {
                ShowSoulEffects();
            }
            // End:0x1C1
            break;
        // End:0x1AB
        case 'SpawnFxPS':
            ClientSpawnFXPS();
            // End:0x1C1
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

simulated function ClientSpawnFXPS()
{
    SpawnFxPSC = new Class'Engine.ParticleSystemComponent';
    SpawnFxPSC.SetTemplate(SpawnFxPS);
    SpawnFxPSC.SetActorParameter('BoneSocketActor', self);
    AttachComponent(SpawnFxPSC);
    SpawnFxPSC.ActivateSystem();
    //return;    
}

event bool SpecialMoveThruEdge(Pylon.ENavMeshEdgeType EdgeType, int Dir, Vector MoveStart, Vector MoveDest, optional Actor RelActor, optional int RelItem, optional NavigationHandle NavHandle)
{
    // End:0x3D
    if(int(EdgeType) == int(4))
    {
        return SpecialMoveTo_DropDown(Dir, MoveStart, MoveDest);
    }
    return super.SpecialMoveThruEdge(EdgeType, Dir, MoveStart, MoveDest, RelActor, RelItem, NavHandle);
    //return ReturnValue;    
}

function bool SpecialMoveTo_DropDown(int DropHeigth, Vector MoveStart, Vector MoveDest)
{
    local Vector MoveDir;

    MoveDir = MoveDest - MoveStart;
    Controller.SetFocalPoint(Location + (MoveDir * float(1000)));
    DoJump(false);
    Velocity = Normal(MoveDir) * float(200);
    Velocity.Z = 150.0000000;
    return true;
    //return ReturnValue;    
}

simulated function PlayArchetypeEffect(EvilExplosion InArchetype, Vector InLocation, Rotator InRotation)
{
    local Emitter ExplosionEmitter;

    // End:0x86
    if(int(Role) == int(ROLE_Authority))
    {
        RepArchetypeEffectParams.EffectType = InArchetype;
        RepArchetypeEffectParams.Location = InLocation;
        RepArchetypeEffectParams.Rotation = InRotation;
    }
    ExplosionEmitter = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactEmitter(InArchetype.ParticleEmitterTemplate, InLocation, InRotation);
    // End:0x214
    if(ExplosionEmitter != none)
    {
        // End:0x1A2
        if((InArchetype.Attachee != none) && InArchetype.bAttachExplosionEmitterToAttachee)
        {
            ExplosionEmitter.SetBase(InArchetype.Attachee);
        }
        ExplosionEmitter.SetDrawScale(InArchetype.ExplosionEmitterScale);
        ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

function DoPoisonSlowdown(float PoisonSpeedModifier, float TimeInterval)
{
    bEnablePoisonSlowdown = true;
    CurrentPoisonSpeedModifier = PoisonSpeedModifier;
    // End:0xB1
    if(GetTimerCount('RollbackPoisonSlowdown') < TimeInterval)
    {
        // End:0x86
        if(!IsTimerActive('RollbackPoisonSlowdown'))
        {
            // End:0x86
            if(!IsTimerActive('UpdateSpeedMovementModifier'))
            {
                SetTimer(0.0100000, false, 'UpdateSpeedMovementModifier');
            }
        }
        ClearTimer('RollbackPoisonSlowdown');
        SetTimer(TimeInterval, false, 'RollbackPoisonSlowdown');
    }
    //return;    
}

function RollbackPoisonSlowdown()
{
    bEnablePoisonSlowdown = false;
    // End:0x5A
    if(!IsTimerActive('UpdateSpeedMovementModifier'))
    {
        // End:0x47
        if(NewMovementSpeedModifier == 0.0000000)
        {
            NewMovementSpeedModifier = 1.0000000;
        }
        SetTimer(0.0100000, false, 'UpdateSpeedMovementModifier');
    }
    //return;    
}

function UpdateSpeedMovementModifier()
{
    local float Temp;

    // End:0x53
    if(bEnablePoisonSlowdown)
    {
        Temp = NewMovementSpeedModifier;
        NewMovementSpeedModifier = CurrentPoisonSpeedModifier;
        super.UpdateSpeedMovementModifier();
        NewMovementSpeedModifier = Temp;        
    }
    else
    {
        super.UpdateSpeedMovementModifier();
    }
    //return;    
}

function DoPoisonDamage(optional bool bInit)
{
    local bool bAlreadyPoisoned;

    // End:0x5A
    if(bInit)
    {
        bAlreadyPoisoned = bPoisoned;
        PoisonTimeout = Class'PKDmgType_PoisonDrowning'.default.TimeOut;
        bPoisoned = true;        
    }
    else
    {
        // End:0x97
        if(PoisonTimeout > float(0))
        {
            PoisonTimeout -= Class'PKDmgType_PoisonDrowning'.default.interval;            
        }
        else
        {
            bPoisoned = false;
        }
    }
    // End:0x139
    if(bPoisoned && !bAlreadyPoisoned)
    {
        SetTimer(Class'PKDmgType_PoisonDrowning'.default.interval, false, 'DoPoisonDamage');
        TakeDamage(int(Class'PKDmgType_PoisonDrowning'.default.Damage), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_PoisonDrowning');
    }
    //return;    
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    local PKAIController PKAI;

    super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
    PKAI = PKAIController(InstigatedBy);
    // End:0x2C3
    if((PKAI != none) && PKAI.bConfused)
    {
        // End:0x29A
        if((PKAI.MyPKPawn.CaptureInstigator != none) && PKAI.MyPKPawn.CaptureInstigator.Controller != none)
        {
            switch(PainPRI(PKAI.MyPKPawn.CaptureInstigator.Controller.PlayerReplicationInfo).Difficulty.default.DifficultyLevel)
            {
                // End:0x1F3
                case 3:
                    InDamage *= (PKAI.ConfusedDamageScaling * 0.3000000);
                    // End:0x297
                    break;
                // End:0x22B
                case 2:
                    InDamage *= (PKAI.ConfusedDamageScaling * 0.5000000);
                    // End:0x297
                    break;
                // End:0x263
                case 1:
                    InDamage *= (PKAI.ConfusedDamageScaling * 0.7000000);
                    // End:0x297
                    break;
                // End:0x268
                case 0:
                // End:0xFFFF
                default:
                    InDamage *= PKAI.ConfusedDamageScaling;
                    // End:0x297
                    break;
                    break;
            }            
        }
        else
        {
            InDamage *= PKAI.ConfusedDamageScaling;
        }
    }
    // End:0x337
    if((!CanBePoisoned() && (DamageType == Class'PKDmgType_Poison') || DamageType == Class'PKDmgType_PoisonDrowning') || (DamageType == Class'PKDmgType_Poison') && bPoisoned)
    {
        InDamage = 0;
    }
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x5F
    if(ClassIsChildOf(DamageType, Class'PKDmgType_Freezer'))
    {
        ProcessHitByFreezer(Damage, EventInstigator, HitLocation, Momentum, HitInfo, DamageCauser);
        return;        
    }
    else
    {
        // End:0xD4
        if(ClassIsChildOf(DamageType, Class'PKDmgType_Electro') || ClassIsChildOf(DamageType, Class'PKDmgType_ElectroSaw'))
        {
            ProcessHitByElectricity(Damage, EventInstigator, HitLocation, Momentum, HitInfo, DamageCauser);            
        }
        else
        {
            // End:0x12F
            if(ClassIsChildOf(DamageType, Class'PKDmgType_SoulReaper'))
            {
                ProcessHitBySoulReaper(Damage, EventInstigator, HitLocation, Momentum, HitInfo, DamageCauser);                
            }
            else
            {
                // End:0x1A1
                if(ClassIsChildOf(DamageType, Class'PKDmgType_Flamer') || ClassIsChildOf(DamageType, Class'PKDmgType_GrenadeGas'))
                {
                    ProcessHitByFlame(Damage, EventInstigator, HitLocation, Momentum, HitInfo, DamageCauser);
                }
            }
        }
    }
    // End:0x223
    if(PKGame(WorldInfo.Game) != none)
    {
        Damage = int(float(Damage) * PKGame(WorldInfo.Game).MonsterDamageFactor);
    }
    // End:0x264
    if(bIsFrozen)
    {
        Damage = (Damage + Health) + 10;
        Damage *= float(1000);
    }
    // End:0x3E0
    if(PKPlayerController(EventInstigator) != none)
    {
        // End:0x342
        if(PKGame(WorldInfo.Game).bStealHealth && EqualEqual_InterfaceInterface(EvilPlayer_interface(self), EvilPlayer_interface(none)))
        {
            PKPlayerController(EventInstigator).Pawn.HealDamage(int(float(Damage) * 0.0500000), EventInstigator, Class'Engine.DamageType');
        }
        // End:0x399
        if(Class'PainWeap_Base'.static.CanCountHitsByWeaponDamage(DamageType))
        {
            PKPlayerController(EventInstigator).IncrementGlobalIntStat(126, 1);
        }
        // End:0x3E0
        if(!ClassIsChildOf(DamageType, Class'PKDmgType_Stake'))
        {
            PKPlayerController(EventInstigator).StakeGunShots = -85127341;
        }
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x4D5
    if(((!IsAliveAndWell() && DamageCauser != none) && ClassIsChildOf(DamageCauser.Class, Class'PKProjectile_Bolt_Base')) && (WorldInfo.TimeSeconds - TimeOfDeath) < 0.2000000)
    {
        PKProjectile_Bolt_Base(DamageCauser).InformMyWeaponOwnerIKilledSomeone();
    }
    //return;    
}

simulated function bool CanBeKnockedDown()
{
    return (Health <= 0) && super.CanBeKnockedDown();
    //return ReturnValue;    
}

simulated function ProcessHitByFreezer(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    FreezePawn(5.0000000);
    //return;    
}

function ProcessHitByElectricity(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    StartFullBodyHitEffect(0);
    // End:0x30
    if(Damage >= Health)
    {
        StartConvulsions();
    }
    //return;    
}

function ProcessHitByFlame(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    StartFullBodyHitEffect(3);
    //return;    
}

simulated function ClientProcessHitEffectParams()
{
    // End:0x49
    if(RepHitEffectParams.bStarted)
    {
        ShowFullBodyHitEffect(RepHitEffectParams.EffectType);        
    }
    else
    {
        HideFullBodyHitEffect(RepHitEffectParams.EffectType);
    }
    //return;    
}

simulated function ClientStartConvulsions()
{
    StartConvulsions();
    //return;    
}

function ProcessHitBySoulReaper(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    StartFullBodyHitEffect(1);
    //return;    
}

function PKPlayerController FindNearestPKPC()
{
    local PKPlayerController PC, NearestPC;
    local float MinDist;

    MinDist = 10000000000.0000000;
    // End:0xC5
    foreach WorldInfo.LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        // End:0xC4
        if(VSizeSq(Location - PC.Location) < MinDist)
        {
            MinDist = VSizeSq(Location - PC.Location);
            NearestPC = PC;
        }        
    }    
    return NearestPC;
    //return ReturnValue;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local PainPRI PRI;
    local PKPlayerPawn PKPPawn;
    local PKPlayerController PKPC;
    local bool Retval;

    bWasNotCountable = bNotCountable;
    // End:0x45
    if(bSpawnNextPawnWhenBodyDisapear)
    {
        bBlockSpawnNextPawn = bBlockSpawnNextPawn || FRand() >= 0.6000000;
    }
    // End:0xB5
    if(ShouldSpawnNextPawn(DamageType))
    {
        // End:0x8D
        if(TimeToBodyDisappear > 1.0000000)
        {
            TimeToBodyDisappear *= RandRange(0.8000000, 1.0000000);
        }
        // End:0xB2
        if(ShouldForwardCounting())
        {
            bNotCountable = true;
            bThrowSoul = false;
        }        
    }
    SetAnimRateScale(1.0000000);
    // End:0x7B6
    if(!bNotCountable)
    {
        // End:0x4FA
        if((Killer != none) && Killer != Controller)
        {
            // End:0x1E8
            if((PKPawn(Killer.Pawn) != none) && PKPawn(Killer.Pawn).CaptureInstigator != none)
            {
                PRI = PainPRI(PKPawn(Killer.Pawn).CaptureInstigator.Controller.PlayerReplicationInfo);                
            }
            else
            {
                PRI = PainPRI(Killer.PlayerReplicationInfo);
            }
            // End:0x4F7
            if(PRI != none)
            {
                PRI.ScoreMonsterKilled();
                PKPC = PKPlayerController(Killer);
                PKPPawn = PKPlayerPawn(Killer.Pawn);
                // End:0x4F7
                if(PKPC != none)
                {
                    // End:0x2E1
                    if(ClassIsChildOf(DamageType, Class'PKDmgType_Shotgun'))
                    {
                        PKPC.IncrementGlobalIntStat(133, 1);                        
                    }
                    else
                    {
                        // End:0x387
                        if((((ClassIsChildOf(DamageType, Class'PKDmgType_SoulSaw') || ClassIsChildOf(DamageType, Class'PKDmgType_SoulSawCombo')) || ClassIsChildOf(DamageType, Class'PKDmgType_SoulReaperMelee')) || ClassIsChildOf(DamageType, Class'PKDmgType_SoulReaperSlow')) || ClassIsChildOf(DamageType, Class'PKDmgType_SoulReaper'))
                        {
                            PKPC.IncrementGlobalIntStat(132, 1);                            
                        }
                        else
                        {
                            // End:0x3F6
                            if((ClassIsChildOf(DamageType, Class'PKDmgType_Stake') || ClassIsChildOf(DamageType, Class'PKDmgType_StakeBurning')) || ClassIsChildOf(DamageType, Class'PKDmgType_Bolt'))
                            {
                                PKPC.IncrementGlobalIntStat(134, 1);
                            }
                        }
                    }
                    // End:0x42F
                    if(CheckDamageTypeIsEnvironmentalDamage(DamageType))
                    {
                        PKPC.IncrementGlobalIntStat(123, 1);
                    }
                    // End:0x468
                    if(CheckDamageTypeIsExplosiveDamage(DamageType))
                    {
                        PKPC.IncrementGlobalIntStat(124, 1);
                    }
                    // End:0x4A1
                    if(CheckDamageTypeIsComboDamage(DamageType))
                    {
                        PKPC.IncrementGlobalIntStat(130, 1);
                    }
                    // End:0x4F7
                    if((PKPPawn != none) && PKPPawn.bIsBunnyHop)
                    {
                        PKPC.IncrementGlobalIntStat(129, 1);
                    }
                }
            }            
        }
        else
        {
            // End:0x515
            if(ClassIsChildOf(DamageType, Class'Engine.DmgType_Suicided'))
            {                
            }
            else
            {
                // End:0x579
                if(((PKPlayerController(Killer) == none) && PKAIController(Killer) != none) && !PKAIController(Killer).bConfused)
                {                    
                }
                else
                {
                    // End:0x743
                    if(((PKPlayerController(Killer) == none) && PKAIController(Killer) != none) && PKAIController(Killer).bConfused)
                    {
                        // End:0x740
                        if(((Killer.Pawn != none) && PKPawn(Killer.Pawn).CaptureInstigator != none) && PKPawn(Killer.Pawn).CaptureInstigator.Controller != none)
                        {
                            PRI = PainPRI(PKPawn(Killer.Pawn).CaptureInstigator.Controller.PlayerReplicationInfo);
                            // End:0x740
                            if(PRI != none)
                            {
                                PRI.ScoreMonsterKilled();
                            }
                        }                        
                    }
                    else
                    {
                        PKPC = FindNearestPKPC();
                        // End:0x7B6
                        if(PKPC != none)
                        {
                            PRI = PainPRI(PKPC.PlayerReplicationInfo);
                            PRI.ScoreMonsterKilled();
                        }
                    }
                }
            }
        }
    }
    // End:0x7FA
    if(!ProjectileSM.HiddenGame)
    {
        bHitWhenThrow = true;
        OnStartThrow();
        OnDetachProjectile();
    }
    Retval = super.Died(Killer, DamageType, HitLocation);
    // End:0x85B
    if(Retval && LastHitBy == none)
    {
        LastHitBy = Killer;
    }
    return Retval;
    //return ReturnValue;    
}

simulated function SpawnedBy(PKPawn Spawner)
{
    // End:0x59
    if(AIFactory.SpawnMethod != none)
    {
        AIFactory.SpawnMethod.PostCreateActor(self);
    }
    //return;    
}

simulated function bool SpawnNextPawn(optional class<DamageType> DamageType)
{
    local int Num;
    local Pawn Enemy;
    local Vector out_HitLocation, out_HitNormal, SpawnLocation, Location2D, InstigatorLocation2D;

    local Rotator SpawnRotation;

    // End:0x597
    if(ShouldSpawnNextPawn(DamageType))
    {
        Num = int(GetTeamNum());
        // End:0x594
        if(((int(WorldInfo.NetMode) != int(NM_Client)) && MyPKAI != none) && !bSpawnNextPawnWhenBodyDisapear || MyPKAI.IsPointOnNavMesh(Location))
        {
            // End:0xDA
            if(!bSpawnNextPawnWhenBodyDisapear)
            {
                SetHidden(true);
                bTearOff = true;
                bForceNetUpdate = true;
                Destroy();
            }
            SpawnLocation = Location;
            SpawnRotation = Rotation;
            // End:0x1B3
            if(Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
            {
                Trace(out_HitLocation, out_HitNormal, Location + vect(0.0000000, 0.0000000, -500.0000000), Location, false, vect(1.0000000, 1.0000000, 1.0000000),, 1);
                out_HitLocation.Z += ((GetCollisionHeight()) * 0.5000000);
                SpawnLocation = out_HitLocation;
            }
            // End:0x2D5
            if((CurrentHitInformation.EventInstigator != none) && CurrentHitInformation.EventInstigator.Pawn != none)
            {
                Location2D = Location;
                Location2D.Z = 0.0000000;
                InstigatorLocation2D = CurrentHitInformation.EventInstigator.Pawn.Location;
                InstigatorLocation2D.Z = 0.0000000;
                SpawnRotation = Rotator(InstigatorLocation2D - Location2D);
            }
            NextPawnInstance = Spawn(NextPawnClass,,, SpawnLocation, SpawnRotation,, true);
            // End:0x570
            if(NextPawnInstance != none)
            {
                // End:0x34E
                if(ShouldForwardCounting())
                {
                    NextPawnInstance.bNotCountable = bWasNotCountable;
                }
                NextPawnInstance.AIFactory = AIFactory;
                NextPawnInstance.SpawnDefaultController();
                // End:0x52E
                if(NextPawnInstance.Controller != none)
                {
                    // End:0x41A
                    if(!WorldInfo.Game.ChangeTeam(NextPawnInstance.Controller, Num, false))
                    {
                    }
                    // End:0x52E
                    if(NextPawnInstance.MyPKAI != none)
                    {
                        // End:0x49E
                        if((MyPKAI != none) && MyPKAI.Enemy != none)
                        {
                            Enemy = MyPKAI.Enemy;                            
                        }
                        else
                        {
                            // End:0x4D5
                            if(LastHitBy != none)
                            {
                                Enemy = LastHitBy.Pawn;
                            }
                        }
                        NextPawnInstance.MyPKAI.ProcessStimulus(Enemy, 3, name((GetHumanReadableName()) @ string(GetFuncName())));
                    }
                }
                NextPawnInstance.SpawnedBy(self);
                NextPawnInstance.PlayTransformSound();                
            }
            else
            {
                // End:0x592
                if(ShouldForwardCounting())
                {
                    bNotCountable = bWasNotCountable;
                }
                return false;
            }
        }        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool ShouldSpawnNextPawn(class<DamageType> DamageType)
{
    return ((((!bBlockSpawnNextPawn && NextPawnClass != none) && bThrowSoul) && PKGame(WorldInfo.Game) != none) && PKGame(WorldInfo.Game).bSpawnSkeletons) && !bPinned;
    //return ReturnValue;    
}

function bool ShouldForwardCounting()
{
    return false;
    //return ReturnValue;    
}

function FreezePawn(float inTime)
{
    // End:0xEA
    if((CanBeFrozen()) && !bIsFrozen)
    {
        FrozenTime = inTime;
        bIsFrozen = true;
        ServerDoPawnAction(59, true);
        // End:0x7C
        if(MyPKAI != none)
        {
            MyPKAI.NotifyPawnFrozen(true);
        }
        RemainingFrozenTime = FrozenTime;
        RepFrozenParams.bIsFrozen = true;
        RepFrozenParams.FrozenTime = FrozenTime;
        bForceNetUpdate = true;
        StartFrozenEffect();
    }
    //return;    
}

function UnFreezePawn()
{
    bIsFrozen = false;
    ServerEndPawnAction();
    // End:0x46
    if(MyPKAI != none)
    {
        MyPKAI.NotifyPawnFrozen(false);
    }
    StopFrozenEffect();
    RepFrozenParams.bIsFrozen = false;
    bForceNetUpdate = true;
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    //return;    
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector Loc;
    local Rotator Rot, rot2;

    // End:0x32F
    if(bGetAdjustedAimFromSocket)
    {
        // End:0x15C
        if((((((W != none) && EvilWeap_Base(W) != none) && CurrentWeaponLeftAttachment != none) && CurrentWeaponLeftAttachment.Mesh != none) && CurrentWeaponLeftAttachment.Mesh.SkeletalMesh != none) && EvilWeap_Base(W).AttachmentClass == CurrentWeaponLeftAttachment.Class)
        {
            CurrentWeaponLeftAttachment.Mesh.GetSocketWorldLocationAndRotation(CurrentWeaponLeftAttachment.MuzzleFlashSocket, Loc, Rot, 0);            
        }
        else
        {
            // End:0x234
            if(((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.Mesh != none) && CurrentWeaponAttachment.Mesh.SkeletalMesh != none)
            {
                CurrentWeaponAttachment.Mesh.GetSocketWorldLocationAndRotation(CurrentWeaponAttachment.MuzzleFlashSocket, Loc, Rot, 0);                
            }
            else
            {
                // End:0x296
                if(CurrentWeaponAttachment != none)
                {
                    Mesh.GetSocketWorldLocationAndRotation(CurrentWeaponAttachment.MuzzleFlashSocket, Loc, Rot, 0);                    
                }
                else
                {
                    // End:0x2E3
                    if(Weapon != none)
                    {
                        Mesh.GetSocketWorldLocationAndRotation(WeaponSocket, Loc, Rot, 0);                        
                    }
                    else
                    {
                        return super(Pawn).GetAdjustedAimFor(W, StartFireLoc);
                    }
                }
            }
        }
        rot2 = Rotator(Normal(GetRotatorAxis(Rot, 0)));
        return rot2;        
    }
    else
    {
        return super(Pawn).GetAdjustedAimFor(W, StartFireLoc);
    }
    //return ReturnValue;    
}

function bool CanBePoisoned()
{
    return !bPoisoned;
    //return ReturnValue;    
}

function bool CanAim()
{
    return true;
    //return ReturnValue;    
}

simulated function OnScreamAttack()
{
    PlayScreamVoice();
    //return;    
}

simulated function OnScreamAttackEnd()
{
    // End:0x64
    if(int(EvilAudioComponent(FacialAudioComp).SoundSetType) == int(5))
    {
        EvilAudioComponent(FacialAudioComp).FadeOut(0.5000000, 0.0000000);
    }
    //return;    
}

simulated function OnStartFire()
{
    // End:0x17
    if(IsAiming())
    {
        StopAim();
    }
    StartFire(0);
    super.OnStartFire();
    //return;    
}

simulated function OnStartFireAlt()
{
    // End:0x17
    if(IsAiming())
    {
        StopAim();
    }
    StartFire(1);
    super.OnStartFireAlt();
    //return;    
}

simulated function OnStopFire()
{
    StopFire(0);
    super.OnStopFire();
    //return;    
}

simulated function OnStopFireAlt()
{
    StopFire(1);
    super.OnStopFireAlt();
    //return;    
}

function OnCheckPoint(SeqAct_Checkpoint Action)
{
    super.OnCheckPoint(Action);
    CapturedSuicide();
    //return;    
}

simulated function CapturedSuicide()
{
    bBlockSpawnNextPawn = true;
    // End:0x39
    if(Soul != none)
    {
        SetTimer((FRand() * 0.5000000) + 0.1000000, false, 'Suicide');
    }
    //return;    
}

function StartJump()
{
    SetPhysics(2);
    //return;    
}

simulated function StartAim()
{
    super.StartAim();
    ServerDoPawnAction(10,,, GetAimAnimIndex());
    //return;    
}

simulated function StopAim()
{
    super.StopAim();
    // End:0x23
    if(IsAiming())
    {
        EndPawnAction(10);
    }
    //return;    
}

function int GetJumpPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 176;
    // End:0x27
    if((AST_GetAnimCount(AST)) < 1)
    {
        return 0;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function int GetPrepareJumpPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    AST = 177;
    // End:0x27
    if((AST_GetAnimCount(AST)) < 1)
    {
        return 0;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

function SetJumpVelocity()
{
    local Vector Vel;

    // End:0x65
    if(MyPKAI != none)
    {
        Vel = MyPKAI.GetJumpVelocity();
        // End:0x65
        if(VSize(Vel) > 0.0000000)
        {
            SetPhysics(2);
            Velocity = Vel;
        }
    }
    //return;    
}

simulated function StartShootAttack()
{
    PlaySoundFromArchetypeByChance(7);
    ServerDoPawnAction(11,,, GetShootAnimPackedIndex());
    //return;    
}

function StartMeleeAttack()
{
    // End:0x17
    if(IsAiming())
    {
        StopAim();
    }
    super.StartMeleeAttack();
    //return;    
}

function DoMeleeAttackDamage()
{
    local EvilWeap_Melee_Base Wpn;

    Wpn = FindMeleeWeapon();
    // End:0x75
    if(Wpn != none)
    {
        // End:0x3C
        if(CurrentMeleeWeaponAttachmentClass == none)
        {
            WeaponMeleeAttachmentChanged();
        }
        // End:0x75
        if(MyPKAI != none)
        {
            Wpn.DoMeleeDamage(DamageScaling, none);
        }
    }
    //return;    
}

function PrepareJumpAttack()
{
    ServerDoPawnAction(34,,, GetPrepareJumpPackedIndex());
    //return;    
}

function StartJumpAttack()
{
    ServerDoPawnAction(25,,, GetJumpPackedIndex());
    //return;    
}

function PrepareFarAttack()
{
    ServerDoPawnAction(60);
    //return;    
}

function ScreamAttack()
{
    ServerDoPawnAction(33,,, GetScreamPackedIndex());
    //return;    
}

simulated function StartReload()
{
    ServerDoPawnAction(12,,, GetReloadAnimPackedIndex());
    //return;    
}

function NotifyStartFullBodyHit()
{
    // End:0x19
    if(!IsPlayingHitSound())
    {
        PlayHitSound();
    }
    //return;    
}

function NotifyEndFullBodyHit()
{
    //return;    
}

function Actor ThrowSoul()
{
    // End:0x41
    if(!bThrowSoul || ClassIsChildOf(WorldInfo.GetGameClass(), Class'PKGameSurvival'))
    {
        return none;
    }
    Soul = Spawn(((bThrowRedSoul) ? RedSoulItemClass : SoulItemClass), ((NextPawnInstance != none) ? NextPawnInstance : self),, Mesh.GetBoneLocation(HipsBoneName, 0) + (vect(0.0000000, 0.0000000, 1.0000000) * SoulShiftUpDistance),,, true);
    Soul.bMonsterWasGibbed = bGibbed;
    // End:0x191
    if(NextPawnInstance != none)
    {
        NextPawnInstance.Soul = Soul;
        NextPawnInstance.Soul.SetBase(NextPawnInstance);
        NextPawnInstance.StartSoulEffects();
    }
    // End:0x279
    if((PKPlayerController(LastHitBy) != none) && PKRailCar_Rollercoaster_Base(EvilPawn(LastHitBy.Pawn).ClampedBase) != none)
    {
        Soul.SetCatchingTarget(LastHitBy.Pawn);
        Soul.ForceMoveToCatchingTarget = true;
        Soul.CatchMaxSpeed *= 4.0000000;
    }
    return Soul;
    //return ReturnValue;    
}

simulated function ExplodeBody()
{
    // End:0x0F
    if(bHidden)
    {
        return;
    }
    PlaySound(BodyExplosionSound, true,,, Location);
    BodyExplosionPSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(((bThrowSoul) ? BodyExplosionPS : BodyExplosionNoSoulPS));
    AttachComponent(BodyExplosionPSC);
    BodyExplosionPSC.SetActorParameter('BoneSocketActor', self);
    BodyExplosionPSC.ActivateSystem();
    //return;    
}

simulated function RemoveAllStakeVirtualProjectiles()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x53 [Loop If]
    if(I < PinningStakes.Length)
    {
        PinningStakes[I].Destroy();
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    PinningStakes.Length = 0;
    //return;    
}

simulated function PlayNoGoreDyingEffects()
{
    // End:0x6D
    if((int(WorldInfo.NetMode) == int(NM_Client)) && Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
    {
        SetTimer(TimeToBodyDisappear_NoGore, false, 'PlayDeathEffects');
    }
    //return;    
}

simulated function PlayDeathEffects()
{
    local editinline MeshComponent ComponentIt;

    RemoveAllStakeVirtualProjectiles();
    // End:0xD5
    if(!Mesh.HiddenGame)
    {
        ExplodeBody();
        Mesh.SetHidden(true);
        SetCollision(false, false, true);
        CollisionComponent.SetTraceBlocking(false, false);
        // End:0xD4
        foreach Mesh.AttachedComponents(Class'Engine.MeshComponent', ComponentIt)
        {
            ComponentIt.SetHidden(true);            
        }        
    }
    //return;    
}

simulated event CacheAnimNodes()
{
    super.CacheAnimNodes();
    CustomAnimNode = AnimNodeSequence(Mesh.FindAnimNode('CustomAnimNode'));
    TIPSpineRotatorSkelControl = SkelControlSingleBone(Mesh.FindSkelControl('TurnInPlaceSpineRotator'));
    // End:0x97
    if(bCanSlowDown)
    {
        UpdateSlowDownDistance();
    }
    //return;    
}

simulated event AnimSetListUpdated()
{
    super(Pawn).AnimSetListUpdated();
    // End:0x21
    if(bCanSlowDown)
    {
        UpdateSlowDownDistance();
    }
    //return;    
}

simulated function UpdateSlowDownDistance()
{
    local Vector Trans;
    local Quat Rot;
    local name SeqName;

    // End:0x56
    if((MoveModeNode == none) || AnimNodeSequence(MoveModeNode.Children[4].Anim) == none)
    {
        return;
    }
    SeqName = AnimNodeSequence(MoveModeNode.Children[4].Anim).AnimSeqName;
    // End:0xCB
    if(SeqName == 'None')
    {
        return;
    }
    // End:0xF7
    if(!GetTotalRootMotionForSequence(SeqName, Trans, Rot))
    {
        return;
    }
    // End:0x123
    if(!IsZero(Trans))
    {
        SlowDownDistance = VSize(Trans) + float(10);
    }
    //return;    
}

simulated function BackUpMaterials()
{
    local int I;

    MaterialsBackup.Length = Mesh.GetNumElements();
    I = 0;
    J0x35:

    // End:0xAC [Loop If]
    if(I < Mesh.GetNumElements())
    {
        MaterialsBackup[I] = Mesh.GetMaterial(I);
        ++I;
        // [Loop Continue]
        goto J0x35;
    }
    //return;    
}

simulated function RestoreMaterialsFromBackUp()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x6C [Loop If]
    if(I < MaterialsBackup.Length)
    {
        Mesh.SetMaterial(I, MaterialsBackup[I]);
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    MaterialsBackup.Length = 0;
    //return;    
}

simulated function MaterialInterface FindBackUpMaterialByNormalMap(Texture inNM)
{
    local int I;
    local Texture NM;

    I = 0;
    J0x0B:

    // End:0xA0 [Loop If]
    if(I < MaterialsBackup.Length)
    {
        MaterialInstanceConstant(MaterialsBackup[I]).GetTextureParameterValue('NormalMap', NM);
        // End:0x92
        if(NM == inNM)
        {
            return MaterialsBackup[I];
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

function SetAimingAnim(optional EPA_Aim AimAction, optional bool bRunMode, optional bool bForceOff)
{
    //return;    
}

simulated function bool IsDemonMaterial(MaterialInterface M)
{
    return (M == DemonModeMaterial) || ((MaterialInstance(M) == none) ? false : IsDemonMaterial(MaterialInstance(M).Parent));
    //return ReturnValue;    
}

simulated function SetDemonMaterial(bool bEnable, bool bSameTeam)
{
    local int I;
    local MaterialInstanceConstant MIC;
    local Texture NM;
    local editinline SkeletalMeshComponent SMC;
    local MaterialInterface MI;

    // End:0x3B
    if((IsDemonMaterial(Mesh.GetMaterial(0))) == bEnable)
    {
        return;
    }
    // End:0x1E7
    if(!bEnable)
    {
        // End:0x66
        if(Health > 0)
        {
            RestoreMaterialsFromBackUp();            
        }
        else
        {
            // End:0x1B7
            foreach ComponentList(Class'Engine.SkeletalMeshComponent', SMC)
            {
                I = 0;
                J0x90:

                // End:0x1B6 [Loop If]
                if(I < SMC.GetNumElements())
                {
                    // End:0x1A8
                    if(IsDemonMaterial(SMC.GetMaterial(I)))
                    {
                        MaterialInstanceConstant(SMC.GetMaterial(I)).GetTextureParameterValue('NormalMap', NM);
                        MI = FindBackUpMaterialByNormalMap(NM);
                        // End:0x1A8
                        if(MI != none)
                        {
                            SMC.SetMaterial(I, MI);
                        }
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x90;
                }                
            }            
            MaterialsBackup.Length = 0;
        }
        // End:0x1E4
        if(int(Role) == int(ROLE_Authority))
        {
            MaterialOverride = 0;
        }        
    }
    else
    {
        // End:0x373
        if(!bSameTeam)
        {
            BackUpMaterials();
            I = 0;
            J0x20B:

            // End:0x353 [Loop If]
            if(I < Mesh.GetNumElements())
            {
                MIC = new (self) Class'Engine.MaterialInstanceConstant';
                MIC.SetParent(DemonModeMaterial);
                // End:0x314
                if((MaterialInstanceConstant(MaterialsBackup[I]) != none) && MaterialInstanceConstant(MaterialsBackup[I]).GetTextureParameterValue('NormalMap', NM))
                {
                    MIC.SetTextureParameterValue('NormalMap', NM);
                }
                Mesh.SetMaterial(I, MIC);
                ++I;
                // [Loop Continue]
                goto J0x20B;
            }
            // End:0x373
            if(int(Role) == int(ROLE_Authority))
            {
                MaterialOverride = 1;
            }
        }
    }
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local EvilAnim_TurnInPlace_Player Player;
    local int L, R;

    super.PostInitAnimTree(SkelComp);
    // End:0x7AE
    if(((PlayerReplicationInfo == none) && SkelComp == Mesh) && TurnInPlaceNode != none)
    {
        TurnInPlaceNode.SetUseAimOffsets(bUseAimOffsets);
        Player = EvilAnim_TurnInPlace_Player(TurnInPlaceNode.Children[1].Anim);
        L = TurnInPlaceNode.RotTransitions.Find('TransName', 'Lt_45');
        R = TurnInPlaceNode.RotTransitions.Find('TransName', 'Rt_45');
        // End:0x1DA
        if(!bHasTIPAnims45Deg)
        {
            // End:0x1A1
            if(L >= 0)
            {
                TurnInPlaceNode.RotTransitions.Remove(L, 1);
                // End:0x1A1
                if(R > L)
                {
                    --R;
                }
            }
            // End:0x1DA
            if(R >= 0)
            {
                TurnInPlaceNode.RotTransitions.Remove(R, 1);
            }
        }
        // End:0x30C
        if(Player != none)
        {
            L = Player.TIP_Transitions.Find('TransName', 'Lt_45');
            R = Player.TIP_Transitions.Find('TransName', 'Rt_45');
            // End:0x30C
            if(bShouldPlayTIPAnimsOnBottomHalfOnly45Deg)
            {
                // End:0x2BF
                if(L >= 0)
                {
                    Player.TIP_Transitions[L].bBottomHalfOnly = true;
                }
                // End:0x30C
                if(R >= 0)
                {
                    Player.TIP_Transitions[R].bBottomHalfOnly = true;
                }
            }
        }
        L = TurnInPlaceNode.RotTransitions.Find('TransName', 'Lt_90');
        R = TurnInPlaceNode.RotTransitions.Find('TransName', 'Rt_90');
        // End:0x42B
        if(!bHasTIPAnims90Deg)
        {
            // End:0x3F2
            if(L >= 0)
            {
                TurnInPlaceNode.RotTransitions.Remove(L, 1);
                // End:0x3F2
                if(R > L)
                {
                    --R;
                }
            }
            // End:0x42B
            if(R >= 0)
            {
                TurnInPlaceNode.RotTransitions.Remove(R, 1);
            }
        }
        // End:0x55D
        if(Player != none)
        {
            L = Player.TIP_Transitions.Find('TransName', 'Lt_90');
            R = Player.TIP_Transitions.Find('TransName', 'Rt_90');
            // End:0x55D
            if(bShouldPlayTIPAnimsOnBottomHalfOnly90Deg)
            {
                // End:0x510
                if(L >= 0)
                {
                    Player.TIP_Transitions[L].bBottomHalfOnly = true;
                }
                // End:0x55D
                if(R >= 0)
                {
                    Player.TIP_Transitions[R].bBottomHalfOnly = true;
                }
            }
        }
        L = TurnInPlaceNode.RotTransitions.Find('TransName', 'Lt_180');
        R = TurnInPlaceNode.RotTransitions.Find('TransName', 'Rt_180');
        // End:0x67C
        if(!bHasTIPAnims180Deg)
        {
            // End:0x643
            if(L >= 0)
            {
                TurnInPlaceNode.RotTransitions.Remove(L, 1);
                // End:0x643
                if(R > L)
                {
                    --R;
                }
            }
            // End:0x67C
            if(R >= 0)
            {
                TurnInPlaceNode.RotTransitions.Remove(R, 1);
            }
        }
        // End:0x7AE
        if(Player != none)
        {
            L = Player.TIP_Transitions.Find('TransName', 'Lt_180');
            R = Player.TIP_Transitions.Find('TransName', 'Rt_180');
            // End:0x7AE
            if(bShouldPlayTIPAnimsOnBottomHalfOnly180Deg)
            {
                // End:0x761
                if(L >= 0)
                {
                    Player.TIP_Transitions[L].bBottomHalfOnly = true;
                }
                // End:0x7AE
                if(R >= 0)
                {
                    Player.TIP_Transitions[R].bBottomHalfOnly = true;
                }
            }
        }
    }
    // End:0x84F
    if((!WorldInfo.GRI.ShouldShowGore() && NoGoreSkeletalMesh != none) && NoGoreSkeletalMesh != Mesh.SkeletalMesh)
    {
        Mesh.SetSkeletalMesh(NoGoreSkeletalMesh);
    }
    //return;    
}

simulated function ParticleSystem OverrideHitImpactEffect(class<EvilDmgType_Base> EvilDamageType, PhysicalMaterial PhysMat)
{
    // End:0x17
    if(bIsFrozen)
    {
        return ParticleSystem'ps_wp_Shotgun.Effects.ps_ch_FreezeGib';
    }
    return none;
    //return ReturnValue;    
}

simulated function SoundCue OverrideHitImpactSound(class<EvilDmgType_Base> EvilDamageType, PhysicalMaterial PhysMat, SoundCue DefaultSoundCue)
{
    // End:0x22
    if(ClassIsChildOf(EvilDamageType, Class'PKDmgType_Painkiller'))
    {
        return SoundCue'a_Painkiller.Cue.painkiller-hit';
    }
    return DefaultSoundCue;
    //return ReturnValue;    
}

simulated function ParticleSystem OverrideDetachFX()
{
    // End:0x17
    if(bIsFrozen)
    {
        return ParticleSystem'ps_wp_Shotgun.Effects.ps_ch_FreezeGib';
    }
    return none;
    //return ReturnValue;    
}

simulated function SoundCue OverrideDetachLimbSoundCue(class<EvilDmgType_Base> EvilDamageType)
{
    // End:0x3B
    if(!bIsFrozen)
    {
        // End:0x31
        if(ClassIsChildOf(EvilDamageType, Class'PKDmgType_SoulSaw'))
        {
            return DetachingLimbBySoulSawSoundCue;
        }
        return DetachingLimbSoundCue;
    }
    return none;
    //return ReturnValue;    
}

simulated function ParticleSystem OverrideBloodFountainFX()
{
    // End:0x17
    if(bIsFrozen)
    {
        return ParticleSystem'ps_wp_Shotgun.Effects.ps_ch_FreezeGib';
    }
    return none;
    //return ReturnValue;    
}

function bool CanChangeMoveMode(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    // End:0x0F
    if(bIsFrozen)
    {
        return false;
    }
    return super.CanChangeMoveMode(InNewMode, InOldMode);
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
    super.Tick(DeltaTime);
    // End:0x42
    if(bAdjustingVelocity)
    {
        MoveSmooth((AdjustVelocityDir * AdjustVelocitySpeed) * DeltaTime);
    }
    TickFrozen(DeltaTime);
    //return;    
}

function Vector GetRightWeaponTraceForShootLocation(optional Weapon CurrentWeapon)
{
    return GetRightWeaponStartTraceLocation(CurrentWeapon);
    //return ReturnValue;    
}

function Vector GetLeftWeaponTraceForShootLocation(optional Weapon CurrentWeapon)
{
    return GetLeftWeaponStartTraceLocation(CurrentWeapon);
    //return ReturnValue;    
}

function Vector GetRightWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    // End:0x33
    if(CurrentWeaponAttachment != none)
    {
        return CurrentWeaponAttachment.GetEffectLocation();        
    }
    else
    {
        return GetWeaponStartTraceLocation(CurrentWeapon);
    }
    //return ReturnValue;    
}

function Vector GetLeftWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    // End:0x33
    if(CurrentWeaponLeftAttachment != none)
    {
        return CurrentWeaponLeftAttachment.GetEffectLocation();        
    }
    else
    {
        return GetWeaponStartTraceLocation(CurrentWeapon);
    }
    //return ReturnValue;    
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    // End:0x25
    if(bFiringLeft)
    {
        return GetLeftWeaponStartTraceLocation(CurrentWeapon);        
    }
    else
    {
        return GetRightWeaponStartTraceLocation(CurrentWeapon);
    }
    //return ReturnValue;    
}

function StartSoulEffects()
{
    // End:0x33
    if(int(Role) == int(ROLE_Authority))
    {
        RepSoulParams.bHasSoulEffects = true;
    }
    ShowSoulEffects();
    //return;    
}

simulated function ShowSoulEffects()
{
    // End:0x35
    if((SoulEffectPSC != none) && SoulEffectPSC.bIsActive)
    {
        return;
    }
    SoulEffectPSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(SoulEffectPS);
    AttachComponent(SoulEffectPSC);
    SoulEffectPSC.SetActorParameter('BoneSocketActor', self);
    SoulEffectPSC.ActivateSystem();
    TimeToBodyDisappear = 0.1000000;
    //return;    
}

private final simulated function ShowFreezeEffects()
{
    // End:0x35
    if((FrozenEffectPSC != none) && FrozenEffectPSC.bIsActive)
    {
        return;
    }
    FrozenEffectPSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(FrozenEffectPS);
    AttachComponent(FrozenEffectPSC);
    FrozenEffectPSC.SetActorParameter('BoneSocketActor', self);
    FrozenEffectPSC.ActivateSystem();
    FrozenLightActor = Spawn(Class'EvilGame.EvilLightActor', self,, Location,, FrozenLightArchetype);
    FrozenLightActor.SetBase(self);
    FrozenLightActor.Activate();
    //return;    
}

private final function HideFreezeEffects()
{
    // End:0x39
    if(FrozenEffectPSC != none)
    {
        FrozenEffectPSC.DeactivateSystem();
        FrozenEffectPSC = none;
    }
    // End:0x72
    if(FrozenLightActor != none)
    {
        FrozenLightActor.Deactivate();
        FrozenLightActor = none;
    }
    //return;    
}

function HideSoulEffects()
{
    // End:0x39
    if(SoulEffectPSC != none)
    {
        SoulEffectPSC.DeactivateSystem();
        SoulEffectPSC = none;
    }
    //return;    
}

simulated function bool CanBeFrozen()
{
    return bCanBeFrozen;
    //return ReturnValue;    
}

private final simulated function StartFrozenEffect()
{
    ShowFreezeEffects();
    // End:0x33
    if(!SetBaseMaterial(1))
    {
        SetParameterForAllMaterials('State', 1.0000000);
    }
    //return;    
}

private final simulated function StopFrozenEffect()
{
    SetAnimRateScale(1.0000000);
    HideFreezeEffects();
    // End:0x42
    if(!SetBaseMaterial(0))
    {
        SetParameterForAllMaterials('State', 0.0000000);
    }
    //return;    
}

simulated function float ComputeFrozenAnimRate()
{
    local float AnimRate, FreezeBlendInTime;

    FreezeBlendInTime = 1.2000000;
    // End:0x64
    if((FrozenTime - RemainingFrozenTime) < FreezeBlendInTime)
    {
        AnimRate = 1.0000000 - ((FrozenTime - RemainingFrozenTime) / FreezeBlendInTime);        
    }
    else
    {
        // End:0xA3
        if(RemainingFrozenTime < FreezeBlendInTime)
        {
            AnimRate = 1.0000000 - (RemainingFrozenTime / FreezeBlendInTime);            
        }
        else
        {
            AnimRate = 0.0010000;
        }
    }
    return AnimRate;
    //return ReturnValue;    
}

simulated function TickFrozen(float DeltaTime)
{
    local float AnimRate;

    // End:0x24
    if(!CanBeFrozen() || RemainingFrozenTime <= float(0))
    {
        return;
    }
    RemainingFrozenTime -= DeltaTime;
    AnimRate = ComputeFrozenAnimRate();
    SetAnimRateScale(AnimRate);
    SetParameterForAllMaterials('Intensity', 1.0000000 - AnimRate);
    // End:0xB1
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xB1
        if(RemainingFrozenTime <= float(0))
        {
            UnFreezePawn();
        }
    }
    //return;    
}

simulated function ProcessConvulsions_T()
{
    local int BoneIndex;
    local Vector Force, BoneLoc;

    BoneIndex = Rand(ElectricityConvulsionsBones.Length);
    BoneLoc = Mesh.GetBoneLocation(ElectricityConvulsionsBones[BoneIndex]);
    // End:0x8F
    if(FRand() > 0.5000000)
    {
        Force = vect(0.0000000, 0.0000000, 1.0000000) * RandRange(10.0000000, 20.0000000);        
    }
    else
    {
        Force = vect(0.0000000, 0.0000000, -1.0000000) * RandRange(10.0000000, 20.0000000);
    }
    Mesh.AddForce(Force, BoneLoc, ElectricityConvulsionsBones[BoneIndex]);
    // End:0x139
    if(FRand() > 0.9000000)
    {
        PlaySound(SparksSoundCues[Rand(SparksSoundCues.Length)],,,, BoneLoc);
    }
    // End:0x1C1
    if(((WorldInfo.TimeSeconds > (StartConvulsionsTime + ConvulsionsLength)) || bGibbed) || Mesh.HiddenGame)
    {
        ClearTimer('ProcessConvulsions_T');
        StopFullBodyHitEffect();
    }
    //return;    
}

simulated function StartConvulsions()
{
    StartConvulsionsTime = WorldInfo.TimeSeconds;
    ConvulsionsLength = 5.0000000;
    ClearTimer('StopFullBodyHitEffect');
    SetTimer(0.0100000, true, 'ProcessConvulsions_T');
    //return;    
}

protected simulated function ShowFullBodyHitEffect(PKPawn.EPainHitEffectType EffectType)
{
    local ParticleSystem PS;
    local editinline ParticleSystemComponent PSC;

    switch(EffectType)
    {
        // End:0x41
        case 0:
            PS = ElectricityEffectPS;
            PSC = FullBodyHitEffectPSC;
            // End:0x179
            break;
        // End:0x6F
        case 1:
            PS = SoulReaperEffectPS;
            PSC = FullBodyHitEffectPSC;
            // End:0x179
            break;
        // End:0xC6
        case 2:
            PS = CapturedEffectPS;
            PSC = CapturedEffectPSC;
            // End:0xC3
            if(!SetBaseMaterial(3))
            {
                SetParameterForAllMaterials('Capture', 1.0000000);
            }
            // End:0x179
            break;
        // End:0x176
        case 3:
            // End:0x10C
            if(Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
            {
                PS = BurnEffectPS_NoGore;                
            }
            else
            {
                PS = BurnEffectPS;
            }
            PSC = BurnEffectPSC;
            // End:0x15B
            if(!SetBaseMaterial(2))
            {
                SetParameterForAllMaterials('State', 2.0000000);
            }
            SetParameterForAllMaterials('Intensity', 1.0000000);
            // End:0x179
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x2C7
    if(PSC == none)
    {
        // End:0x2C4
        if(PS != none)
        {
            PSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(PS);
            AttachComponent(PSC);
            PSC.SetActorParameter('BoneSocketActor', self);
            PSC.ActivateSystem();
            switch(EffectType)
            {
                // End:0x270
                case 0:
                // End:0x28B
                case 1:
                    FullBodyHitEffectPSC = PSC;
                    // End:0x2C4
                    break;
                // End:0x2A6
                case 2:
                    CapturedEffectPSC = PSC;
                    // End:0x2C4
                    break;
                // End:0x2C1
                case 3:
                    BurnEffectPSC = PSC;
                    // End:0x2C4
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {            
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x2C4! */
        else
        {
            // End:0x30B
            if(!PSC.bIsActive)
            {
                PSC.ActivateSystem();
            }
        }
        RepHitEffectParams.EffectType = EffectType;
        RepHitEffectParams.bStarted = true;
        bForceNetUpdate = true;
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x179! */
}

private final simulated function HideFullBodyHitEffect(PKPawn.EPainHitEffectType EffectType)
{
    switch(RepHitEffectParams.EffectType)
    {
        // End:0x2B
        case 0:
        // End:0x6C
        case 1:
            // End:0x69
            if(FullBodyHitEffectPSC != none)
            {
                FullBodyHitEffectPSC.DeactivateSystem();
                FullBodyHitEffectPSC = none;
            }
            // End:0xE5
            break;
        // End:0xDD
        case 3:
            // End:0xAA
            if(BurnEffectPSC != none)
            {
                BurnEffectPSC.DeactivateSystem();
                BurnEffectPSC = none;
            }
            SetParameterForAllMaterials('State', 0.0000000);
            SetParameterForAllMaterials('Intensity', 0.0000000);
            // End:0xE5
            break;
        // End:0xE2
        case 2:
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function StartFullBodyHitEffect(PKPawn.EPainHitEffectType EffectType, optional bool bDontStopByTimer)
{
    // End:0x2C
    if(IsTimerActive('StopFullBodyHitEffect'))
    {
        ClearTimer('StopFullBodyHitEffect');
    }
    ShowFullBodyHitEffect(EffectType);
    // End:0x61
    if(!bDontStopByTimer)
    {
        SetTimer(1.0000000, false, 'StopFullBodyHitEffect');
    }
    //return;    
}

simulated function StopFullBodyHitEffect()
{
    HideFullBodyHitEffect(RepHitEffectParams.EffectType);
    RepHitEffectParams.bStarted = false;
    bForceNetUpdate = true;
    //return;    
}

function bool SetBaseMaterial(PKPawn.EPainMaterialType MaterialType)
{
    local MaterialInterface MaterialReference;
    local MaterialInstance MatInst;
    local int I;
    local bool bGetDefaultMat, bResult;

    MaterialReference = PKMaterialAtlasArchetype.GetBaseMaterial(MaterialType);
    // End:0x63
    if((int(MaterialType) == int(0)) && MaterialReference == none)
    {
        bGetDefaultMat = true;
    }
    I = 0;
    J0x6E:

    // End:0x1FA [Loop If]
    if(I < Mesh.Materials.Length)
    {
        MatInst = MaterialInstance(Mesh.GetMaterial(I));
        // End:0x1EC
        if(MatInst != none)
        {
            // End:0x17B
            if(bGetDefaultMat && MaterialInstance(Mesh.default.Materials[I]) != none)
            {
                MaterialReference = MaterialInstance(Mesh.default.Materials[I]).Parent;
            }
            // End:0x1EC
            if((MaterialReference != none) && MaterialReference != MatInst.Parent)
            {
                MatInst.SetParent(MaterialReference);
                bResult = true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x6E;
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool SetCapturedEnemy(float TimeToLive, Pawn CaptInstigator)
{
    local PainGRI_SP PKGRI_SP;

    // End:0x0F
    if(bIsBoss)
    {
        return false;
    }
    // End:0xC4
    if(MyPKAI != none)
    {
        // End:0xA1
        if(PainGRI(WorldInfo.GRI).IsMultiplayerGame())
        {
            MyPKAI.SetTeam(int(CaptInstigator.GetTeamNum()));            
        }
        else
        {
            MyPKAI.SetTeam(1 - 1);
        }
    }
    // End:0x122
    if(MyPKAI != none)
    {
        MyPKAI.NotifyConfused();
        MyPKAI.SetTimer(0.5000000, true, 'CheckEnemyInfo', MyPKAI);
    }
    CaptureInstigator = CaptInstigator;
    // End:0x1C5
    if(!PainGRI(WorldInfo.GRI).IsMultiplayerGame() || PainGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
    {
        bIsInvulnerable = true;
    }
    // End:0x217
    if(TimeToLive > 0.0000000)
    {
        SetTimer(RandRange(FMax(TimeToLive - 0.5000000, 0.5000000), TimeToLive + 0.5000000), false, 'KillCapturedEnemy');
    }
    // End:0x29F
    if(int(WorldInfo.NetMode) < int(NM_Client))
    {
        PKGRI_SP = PainGRI_SP(WorldInfo.GRI);
        // End:0x29F
        if(PKGRI_SP != none)
        {
            PKGRI_SP.IncrementMonstersPossessedBySoulCatcher();
        }
    }
    bBlockSpawnNextPawn = true;
    return true;
    //return ReturnValue;    
}

function ChangeMoveMode(EvilTypesNative.EMoveMode InNewMode, optional float InBlendTime = -1.0000000)
{
    super.ChangeMoveMode(InNewMode, InBlendTime);
    //return;    
}

function MoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    local EvilAnim_AST AnimNode;

    // End:0x114
    if((MyPKAI != none) && MyPKAI.bConfused || PKGame(WorldInfo.Game).bConfuseEnemies)
    {
        AnimNode = EvilAnim_AST(MoveModeNode.Children[int(InNewMode)].Anim);
        // End:0x111
        if(AnimNode != none)
        {
            AnimNode.Rate = MyPKAI.ConfusedMovementSpeedScaling;
        }        
    }
    //return;    
}

simulated function KillCapturedEnemy()
{
    bThrowSoul = false;
    bIsInvulnerable = false;
    Died(CaptureInstigator.Controller, Class'PKDmgType_InstantGib', vect(0.0000000, 0.0000000, 0.0000000));
    //return;    
}

simulated function ApplyPlayDyingRagdollImpulse(Vector ShotDir, Vector HitLocation, name BoneName, class<EvilDmgType_Base> DamageType)
{
    local Vector ApplyImpulse;

    // End:0x1A
    if(ClassIsChildOf(DamageType, Class'PKDmgType_Stake'))
    {
        return;
    }
    ApplyImpulse = ComputeDeathRagdollImpulse(ShotDir, DamageType, false);
    Mesh.AddImpulse(ApplyImpulse, HitLocation, BoneName, false);
    ClientAddDeathImpulse(DamageType);
    //return;    
}

simulated function PinBody(name BoneName)
{
    local RB_BodyInstance Body;

    // End:0xC0
    if(((Mesh != none) && Mesh.PhysicsAssetInstance != none) && Mesh.PhysicsAsset != none)
    {
        Body = Mesh.PhysicsAssetInstance.FindBodyInstance(BoneName, Mesh.PhysicsAsset);
    }
    // End:0xEE
    if(Body != none)
    {
        Body.FreezeBody();
    }
    //return;    
}

simulated function bool ShouldGib(class<EvilDmgType_Base> EvilDamageType)
{
    // End:0x29
    if(ClassIsChildOf(EvilDamageType, Class'EvilGame.EvilDmgType_InstantGib') || bIsFrozen)
    {
        return true;
    }
    // End:0x54
    if((Health <= 0) && ClassIsChildOf(EvilDamageType, Class'PKDmgType_SoulSaw'))
    {
        return true;
    }
    // End:0xC8
    if(((EnableGibWhenHPBelow && float(Health) < EnableGibWhenHPBelowFactor) || EvilDamageType.default.bAlwaysGibs) && !EvilDamageType.default.bNeverGibs)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

protected function bool CanBePartialGib(class<EvilDmgType_Base> EvilDamageType)
{
    return !bIsFrozen && EvilDamageType.default.bCanDoPartialGibs;
    //return ReturnValue;    
}

protected function CollectPartialGibs(out array<int> PartialGibs, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation)
{
    local int I, ZoneIndex;
    local Vector BoneLoc;
    local bool bNearBone;

    I = 0;
    J0x0B:

    // End:0x1F6 [Loop If]
    if(I < GoreSettings.GoreBreakableJoints.Length)
    {
        // End:0x1E8
        if(GoreSettings.GoreBreakableJoints[I].BreakableConstraintName != 'None')
        {
            ZoneIndex = GetZoneIndex(GoreSettings.GoreBreakableJoints[I].BreakableConstraintName);
            BoneLoc = Mesh.GetBoneLocation(GoreSettings.GoreBreakableJoints[I].BreakableConstraintName);
            bNearBone = ClassIsChildOf(EvilDamageType, Class'PKDmgType_SoulSaw') && VSizeSq(HitLocation - BoneLoc) < float(30 * 30);
            // End:0x1E8
            if((ZoneIndex != -1) && (HitZones[ZoneIndex].Health != HealthMax) || bNearBone)
            {
                PartialGibs.AddItem(I);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

protected function SpawnInstantGibParticle()
{
    local editinline ParticleSystemComponent PSC;

    // End:0x162
    if((((GoreSettings.InstantGibParticle != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bIsFrozen) && WorldInfo.GRI.ShouldShowGore())
    {
        PSC = WorldInfo.MyEmitterPool.SpawnEmitter(GoreSettings.InstantGibParticle, Location);
        PSC.SetScale(GoreSettings.InstantGibParticleScale);
        PSC.SetAbsolute(,,, true);
    }
    //return;    
}

function SpawnBonusTreasure(int numberofTreasures, optional bool bIgnoreTimeOfDeathAndFastTraceCondition = false)
{
    local int I;
    local Vector RootBodyLocation, LinearImpulse;
    local Matrix BodyTM;
    local class<PainItem_Treasure_Base> TreasureClass;
    local PainItem_Treasure_Base SpawnedTreasure;

    // End:0x76
    if((PainGRI(WorldInfo.GRI) != none) && PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        return;
    }
    BodyTM = Mesh.GetRootBodyInstance().GetUnrealWorldTM();
    RootBodyLocation = MatrixGetOrigin(BodyTM);
    // End:0x2FE
    if(bIgnoreTimeOfDeathAndFastTraceCondition || ((TimeOfDeath - WorldInfo.TimeSeconds) > -0.0100000) && FastTrace(RootBodyLocation, RootBodyLocation + (vect(0.0000000, 0.0000000, -1.0000000) * float(100))))
    {
        I = 0;
        J0x150:

        // End:0x2FE [Loop If]
        if(I < numberofTreasures)
        {
            switch(Rand(3))
            {
                // End:0x18F
                case 0:
                    TreasureClass = Class'PainItem_RingR';
                    // End:0x1BF
                    break;
                // End:0x1A9
                case 1:
                    TreasureClass = Class'PainItem_RingG';
                    // End:0x1BF
                    break;
                // End:0xFFFF
                default:
                    TreasureClass = Class'PainItem_RingB';
                    break;
            }
            LinearImpulse = VRand() * float(7);
            LinearImpulse.Z = RandRange(15.0000000, 20.0000000);
            SpawnedTreasure = Spawn(TreasureClass,,, RootBodyLocation + (VRand() * float(10)), Rotator(VRand()),, true);
            // End:0x2F0
            if(SpawnedTreasure != none)
            {
                SpawnedTreasure.bFromFallenEnemy = true;
                SpawnedTreasure.CollisionComponent.AddImpulse(LinearImpulse, RootBodyLocation);
                SpawnedTreasure.CollisionComponent.SetRBAngularVelocity(VRand() * 2.0000000);
            }
            I++;
            // [Loop Continue]
            goto J0x150;
        }
    }
    //return;    
}

protected function bool InstantGib(int Damage, class<EvilDmgType_Base> EvilDamageType, Vector HitLocation, Vector Momentum, optional bool bPartialGibEnabled)
{
    local PainGRI_SP PKGRI_SP;
    local bool bResult;
    local Vector KnockDownOrigin;
    local bool bPartialGib, bWasGibbed;
    local PKPlayerController PKPC;
    local PainPRI PRI;

    bPartialGib = CanBePartialGib(EvilDamageType);
    PKGRI_SP = PainGRI_SP(WorldInfo.GRI);
    bWasGibbed = bGibbed;
    bResult = super.InstantGib(Damage, EvilDamageType, HitLocation, Momentum, bPartialGib);
    // End:0x4B0
    if(bResult)
    {
        // End:0x2BD
        if(!bWasGibbed)
        {
            PKPC = PKPlayerController(CurrentHitInformation.EventInstigator);
            // End:0x1B0
            if(PKPC != none)
            {
                PKPC.IncrementGlobalIntStat(120);
                PRI = PainPRI(PKPC.PlayerReplicationInfo);
                PRI.ScoreMonsterGibbed();
                // End:0x1B0
                if(ClassIsChildOf(EvilDamageType, Class'PKDmgType_Rocket'))
                {
                    PKPC.IncrementGlobalIntStat(138);
                }
            }
            // End:0x22D
            if(!bPartialGib)
            {
                // End:0x1FE
                if(bIsFrozen)
                {
                    // End:0x1FB
                    if(FullFrozenGibSoundCue != none)
                    {
                        PlaySound(FullFrozenGibSoundCue,,,, Location);
                    }                    
                }
                else
                {
                    // End:0x22D
                    if(FullGibSoundCue != none)
                    {
                        PlaySound(FullGibSoundCue,,,, Location);
                    }
                }
            }
            // End:0x282
            if(bPartialGib && ClassIsChildOf(EvilDamageType, Class'PKDmgType_SoulSaw'))
            {
                // End:0x282
                if(PKGRI_SP != none)
                {
                    PKGRI_SP.IncrementPawnsDetachedLimbs();
                }
            }
            // End:0x2BD
            if(bIsFrozen)
            {
                // End:0x2BD
                if(PKGRI_SP != none)
                {
                    PKGRI_SP.IncrementGibbedFrozenMonsters();
                }
            }
        }
        // End:0x49E
        if(!IsZero(Momentum) && !bIsFrozen)
        {
            // End:0x368
            if(ClassIsChildOf(EvilDamageType, Class'PKDmgType_SoulSaw'))
            {
                KnockDownOrigin = (HitLocation - (Normal(Momentum) * float(10))) + (vect(0.0000000, 0.0000000, 1.0000000) * (-GetCollisionHeight() * 0.5000000));
                Knockdown(,,, KnockDownOrigin, 1000.0000000, InstantGibForce);                
            }
            else
            {
                // End:0x406
                if(ClassIsChildOf(EvilDamageType, Class'PKDmgType_Painkiller'))
                {
                    KnockDownOrigin = (Location - (Normal(Momentum) * float(50))) + (vect(0.0000000, 0.0000000, 1.0000000) * (-GetCollisionHeight() * 0.5000000));
                    Knockdown(,,, KnockDownOrigin, 1000.0000000, EvilDamageType.default.KDeathVel);                    
                }
                else
                {
                    // End:0x49E
                    if(!ClassIsChildOf(EvilDamageType, Class'PKDmgType_Stake'))
                    {
                        KnockDownOrigin = (HitLocation - (Normal(Momentum) * InstantGibOriginShiftX)) + (vect(0.0000000, 0.0000000, 1.0000000) * InstantGibOriginShiftZ);
                        Knockdown(,,, KnockDownOrigin, 1000.0000000, EvilDamageType.default.KDeathVel);
                    }
                }
            }
        }
        SpawnBonusTreasure(Rand(2) + 1);
    }
    return bResult;
    //return ReturnValue;    
}

function int GetHitAnimIndex(class<EvilDmgType_Base> EvilDamageType, optional bool bKickHit = false)
{
    return super.GetHitAnimIndex(EvilDamageType);
    //return ReturnValue;    
}

function EvilTypesNative.EAnimationSetType TryGetHitAnimIndexPerBallisticType(EvilTypes.EHitDirectionType HitDirectionID, EvilTypes.EBodyParts BP, class<EvilDmgType_Base> EvilDamageType)
{
    return 0;
    //return ReturnValue;    
}

function bool CanBePinned()
{
    return bCanBePinned;
    //return ReturnValue;    
}

function bool CanBeDamagedBy(Controller EventInstigator)
{
    // End:0x6D
    if(ClassIsChildOf(WorldInfo.GetGameClass(), Class'PKGameSurvival'))
    {
        return !(MyEvilAI != none) && MyEvilAI.IsFriendly(EventInstigator);        
    }
    else
    {
        // End:0x161
        if(ClassIsChildOf(WorldInfo.GetGameClass(), Class'PKGameTeamDeathmatch') && !PKGameMP_Base(WorldInfo.Game).bTeamDamage)
        {
            return (EventInstigator.PlayerReplicationInfo.Team != Controller.PlayerReplicationInfo.Team) || Controller == EventInstigator;
        }
    }
    return super.CanBeDamagedBy(EventInstigator);
    //return ReturnValue;    
}

function bool CanFastSpinUp()
{
    return ((int(CurrentMoveMode) == int(0)) && int(SupremeMoveMode) >= int(2)) && (AST_GetAnimCount(73)) > 0;
    //return ReturnValue;    
}

function RequestFastSpinUp(optional int InYawDelta, optional bool InWithoutRotating, optional bool InWithoutBlendFromMovingToIdle)
{
    bFastSpinUp = true;
    PackedFastSpinUpAnimInfo = PackRandomAnimInfo(73);
    //return;    
}

function bool CanSlowDown(EvilAICmd_MoveToGoal MTG)
{
    local float Dist, GD;
    local bool Retval;

    // End:0xE0
    if((((!bCanSlowDown || MyEvilAI == none) || MTG == none) || int(CurrentMoveMode) != int(2)) || (MTG.MoveGoalIsValid() && EvilNavPoint(MTG.MoveGoal) != none) && !EvilNavPoint(MTG.MoveGoal).bCanSlowDown)
    {
        return false;
    }
    Dist = VSizeSq(MTG.GetMoveGoalLocation() - Location);
    GD = MTG.GoalDistance + SlowDownDistance;
    Retval = (Dist < (GD * GD)) && Dist > ((GD - 10.0000000) * (GD - 10.0000000));
    return Retval;
    //return ReturnValue;    
}

simulated function bool CanThrowWeapon()
{
    local bool bResult;

    // End:0x39
    if(WeaponLeft != none)
    {
        bResult = WeaponLeft.bCanThrow;
    }
    return bResult && super(Pawn).CanThrowWeapon();
    //return ReturnValue;    
}

function ThrowWeaponOnDeath()
{
    //return;    
}

function CollectDamageLocations(Vector InDamageInstigatorLocation, Vector DamageLocation, class<DamageType> DamageType)
{
    // End:0x36
    if(!ClassIsChildOf(DamageType, Class'PKDmgType_Shotgun') || ClassIsChildOf(DamageType, Class'PKDmgType_Painkiller'))
    {
        return;
    }
    // End:0xA8
    if(LastDamageCollectionTime != WorldInfo.RealTimeSeconds)
    {
        LastDamageCollectionIndex = 0;
        LastDamageCollectionTime = WorldInfo.RealTimeSeconds;
        DamageInstigatorLocation = InDamageInstigatorLocation;
    }
    // End:0x108
    if(WorldInfo.RealTimeSeconds == LastDamageCollectionTime)
    {
        // End:0xE9
        if(LastDamageCollectionIndex > (20 - 1))
        {
            return;
        }
        DamageLocations[LastDamageCollectionIndex++] = DamageLocation;
    }
    //return;    
}

simulated function Projectile ThrowGrenade(Rotator Rot, Vector Loc, optional out Vector SuggestedTossVelocity)
{
    local Projectile Proj;

    Mesh.GetSocketWorldLocationAndRotation(GrenadeSocket, Loc, Rot, 0);
    Proj = Spawn(GrenadeProjectile, self,, Loc, Rot);
    Proj.Init(Normal(Vector(Rot)));
    // End:0xD5
    if(!bHitWhenThrow)
    {
        Proj.Velocity = SuggestedTossVelocity;        
    }
    else
    {
        Proj.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    }
    Proj.Damage = 450.0000000;
    return Proj;
    //return ReturnValue;    
}

simulated function bool CanAttachProjectile()
{
    return int(PawnAction) == 9;
    //return ReturnValue;    
}

simulated function OnAttachProjectile()
{
    // End:0x11
    if(!CanAttachProjectile())
    {
        return;
    }
    // End:0x66
    if(!ProjectileSM.bAttached)
    {
        Mesh.AttachComponentToSocket(ProjectileSM, GrenadeSocket);
    }
    ProjectileSM.SetHidden(false);
    // End:0x130
    if((ProjectilePSC != none) && ProjectilePSC.Template != none)
    {
        // End:0x110
        if(!ProjectilePSC.bAttached)
        {
            Mesh.AttachComponentToSocket(ProjectilePSC, GrenadeSocket);
        }
        ProjectilePSC.ActivateSystem();
    }
    //return;    
}

simulated function OnDetachProjectile()
{
    // End:0x42
    if(ProjectileSM.bAttached)
    {
        ProjectileSM.SetHidden(true);
    }
    // End:0x70
    if(ProjectilePSC != none)
    {
        ProjectilePSC.DeactivateSystem();
    }
    bHitWhenThrow = false;
    //return;    
}

simulated function ThrowInventory(Inventory Inv, optional Vector ForceVelocity, optional bool bAlternateWeapon)
{
    local EvilProjectile_Base Proj;
    local Vector Loc, TossVel;
    local Rotator Rot;
    local Vector X, AngularAxisY, Z;

    super.ThrowInventory(Inv, ForceVelocity, bAlternateWeapon);
    // End:0x14D
    if(ThrowableProjectile != none)
    {
        GetAxes(Rotation, X, AngularAxisY, Z);
        Mesh.GetSocketWorldLocationAndRotation(((bAlternateWeapon) ? WeaponSocket2 : WeaponSocket), Loc, Rot, 0);
        TossVel = Normal(MyEvilAI.Enemy.Location - Location);
        Proj = Spawn(ThrowableProjectile, self,, Loc);
        Proj.Init(TossVel);
    }
    //return;    
}

simulated function ApplyKnockdownForceAndVelocity()
{
    // End:0x19B
    if(int(Physics) == int(10))
    {
        // End:0x74
        if(!IsZero(KnockdownImpulse.AngularVelocity))
        {
            Mesh.SetRBAngularVelocity(KnockdownImpulse.AngularVelocity, true);
        }
        // End:0xD4
        if(!IsZero(KnockdownImpulse.LinearVelocity))
        {
            Mesh.SetRBLinearVelocity(KnockdownImpulse.LinearVelocity, true);
        }
        // End:0x198
        if((KnockdownImpulse.RadialRadius > 0.0000000) && KnockdownImpulse.RadialStrength > 0.0000000)
        {
            Mesh.AddRadialImpulse(KnockdownImpulse.RadialOrigin, KnockdownImpulse.RadialRadius, KnockdownImpulse.RadialStrength, 1, false);
        }        
    }
    //return;    
}

simulated function BreakConstraint(Vector Momentum, Vector HitLocation, class<EvilDmgType_Base> EvilDamageType, const out _GoreBreakableJoints BreakableJointInfo)
{
    Mesh.super(SkeletalMeshComponent).BreakConstraint(vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), BreakableJointInfo.BreakableConstraintName, false);
    //return;    
}

simulated function CopyLimbsHealth()
{
    local int I, ZoneIndex;

    // End:0xE7
    if(GoreSettings != none)
    {
        I = 0;
        J0x1A:

        // End:0xE7 [Loop If]
        if(I < GoreSettings.GoreBreakableJoints.Length)
        {
            ZoneIndex = GetZoneIndexByBodyPart(GoreSettings.GoreBreakableJoints[I].Type);
            // End:0xD9
            if(ZoneIndex != -1)
            {
                HitZones[ZoneIndex].Health = Health;
            }
            I++;
            // [Loop Continue]
            goto J0x1A;
        }
    }
    //return;    
}

// Export UPKPawn::execCheckDefaultImpactMaterial(FFrame&, void* const)
native final function bool CheckDefaultImpactMaterial(int BodyIndex);

simulated function SpawnImpactDecal(Vector HitLoc, Vector HitNorm)
{
    local MaterialInstance DecalMat;

    // End:0x5F
    if((GibImpactDecalMaterials.Length > 0) && !Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
    {
        DecalMat = GibImpactDecalMaterials[Rand(GibImpactDecalMaterials.Length)];
    }
    // End:0xBC
    if(DecalMat != none)
    {
        // End:0xBC
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            LeaveABloodDecalCustomMaterial(HitLoc, HitNorm, DecalMat);
        }
    }
    //return;    
}

simulated event PlayRagdollImpactEffect(int BodyIndex, Vector HitLoc, Vector HitNorm, float SquaredForce)
{
    // End:0x2D
    if(Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
    {
        return;
    }
    // End:0xF2
    if((((WorldInfo.TimeSeconds > (TimeOfDeath + 0.5000000)) && GibImpactSoundCount < GibImpactSoundLimitCount) && FallImpactSound != none) && !bPinned)
    {
        GibImpactSoundCount++;
        PlaySound(FallImpactSound, true, true, true, HitLoc);
        // End:0xF2
        if(!IsTimerActive('ResetGibEffects', self))
        {
            SetTimer(1.0000000, false, 'ResetGibEffects', self);
        }
    }
    // End:0x15D
    if((GibImpactDecalCount < GibImpactDecalLimitCount) && SquaredForce > float(50000))
    {
        // End:0x15D
        if(CheckDefaultImpactMaterial(BodyIndex))
        {
            GibImpactDecalCount++;
            SpawnImpactDecal(HitLoc, HitNorm);
        }
    }
    //return;    
}

simulated function ResetGibEffects()
{
    GibEffectCount = 0;
    GibImpactDecalCount = 0;
    GibImpactSoundCount = 0;
    GibImpactPSCount = 0;
    //return;    
}

simulated function GetImpactEffectsFromNonDefaultMaterial(int BodyIndex, Vector HitLocation, Vector HitNormal, float SquaredForce, out SoundCue SND, out ParticleSystem PS, out MaterialInstance DecalMat)
{
    SND = Mesh.PhysicsAsset.BodySetup[BodyIndex].PhysMaterial.ImpactSound;
    //return;    
}

simulated event ShowGibEffect(int BodyIndex, Vector HitLocation, Vector HitNormal, float SquaredForce)
{
    local SoundCue SND;
    local MaterialInstance DecalMat;
    local ParticleSystem PS;
    local editinline ParticleSystemComponent PSC;
    local bool bForcePlayNonDefaultMaterialEffects;

    // End:0x1B2
    if((Mesh.PhysicsAsset.BodySetup[BodyIndex].PhysMaterial != none) && !Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
    {
        // End:0x15D
        if(CheckDefaultImpactMaterial(BodyIndex))
        {
            // End:0x15A
            if(!IsTimerActive('ProcessConvulsions_T') && bGibbed)
            {
                // End:0xE8
                if(bIsFrozen)
                {
                    SND = GibFrozenImpactSoundCue;                    
                }
                else
                {
                    SND = GibImpactSoundCue;
                    PS = GibImpactParticleSystem;
                    DecalMat = GibImpactDecalMaterials[Rand(GibImpactDecalMaterials.Length)];
                }
                // End:0x15A
                if(!IsTimerActive('ResetGibEffects', self))
                {
                    SetTimer(0.2000000, false, 'ResetGibEffects', self);
                }
            }            
        }
        else
        {
            GetImpactEffectsFromNonDefaultMaterial(BodyIndex, HitLocation, HitNormal, SquaredForce, SND, PS, DecalMat);
            bForcePlayNonDefaultMaterialEffects = true;
        }
    }
    // End:0x23B
    if(SND != none)
    {
        // End:0x23B
        if((GibImpactSoundCount < GibImpactSoundLimitCount) || bForcePlayNonDefaultMaterialEffects)
        {
            GibImpactSoundCount++;
            // End:0x23B
            if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
            {
                PlaySound(SND, true, true, true, HitLocation);
            }
        }
    }
    // End:0x30C
    if(PS != none)
    {
        // End:0x30C
        if(GibImpactPSCount < GibImpactPSLimitCount)
        {
            GibImpactPSCount++;
            // End:0x30C
            if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
            {
                PSC = WorldInfo.MyEmitterPool.SpawnEmitter(PS, HitLocation);
                PSC.SetAbsolute(,,, true);
            }
        }
    }
    // End:0x38B
    if(DecalMat != none)
    {
        // End:0x38B
        if(GibImpactDecalCount < GibImpactDecalLimitCount)
        {
            GibImpactDecalCount++;
            // End:0x38B
            if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
            {
                LeaveABloodDecalCustomMaterial(HitLocation, HitNormal, DecalMat);
            }
        }
    }
    //return;    
}

simulated function PostSwitchSkeletalMeshFromGoreSettings()
{
    // End:0x53
    if(bIsFrozen)
    {
        CreatePawnMaterials();
        SetParameterForAllMaterials('Intensity', 1.0000000 - (ComputeFrozenAnimRate()));
        SetParameterForAllMaterials('State', 1.0000000);
    }
    //return;    
}

simulated function LandedOnPawn(Vector HitNormal, EvilPawn FloorPawn)
{
    FloorPawn.Knockdown(Velocity, vect(0.0000000, 0.0000000, 0.0000000));
    FloorPawn.TakeDamage(int(VSize(Velocity) * 0.0100000), MyEvilAI, Location, Velocity, Class'EvilGame.EvilDmgType_Fell');
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    local editinline PKPlayerOverlayComponent poc;

    poc = Class'PKPlayerOverlayComponent'.static.GetForActor(self);
    // End:0x59
    if(poc != none)
    {
        poc.Dehighlight();
    }
    // End:0x8E
    if((Soul != none) && Soul.CatchingTarget == self)
    {
    }
    TimeOfDeath = WorldInfo.TimeSeconds;
    // End:0x102
    if(bSpawnNextPawnWhenBodyDisapear || !SpawnNextPawn(class<EvilDmgType_Base>(DamageType)))
    {
        super.PlayDying(DamageType, HitLoc);
    }
    DetachingSpecificLimbEnabled = true;
    // End:0x125
    if(bIsFrozen)
    {
        LimitPhysicsAssetConstraints();
    }
    //return;    
}

simulated function LimitPhysicsAssetConstraints()
{
    local int ConstraintIndex;
    local RB_ConstraintInstance Constraint;
    local RB_ConstraintSetup ConstraintSetup;

    // End:0x16A
    if((Mesh != none) && Mesh.PhysicsAssetInstance != none)
    {
        ConstraintIndex = 0;
        J0x40:

        // End:0x16A [Loop If]
        if(ConstraintIndex < Mesh.PhysicsAssetInstance.Constraints.Length)
        {
            Constraint = Mesh.PhysicsAssetInstance.Constraints[ConstraintIndex];
            ConstraintSetup = Mesh.PhysicsAsset.ConstraintSetup[Constraint.ConstraintIndex];
            Constraint.SetAngularDOFLimitScale(0.0000000, 0.0000000, 0.0000000, ConstraintSetup);
            ConstraintIndex++;
            // [Loop Continue]
            goto J0x40;
        }
    }
    //return;    
}

simulated function class<EvilBloodGlob> GetBloodGlobClass(class<EvilDmgType_Base> dmgType)
{
    // End:0x6C
    if(((((IsFirstPerson()) || ClassIsChildOf(dmgType, Class'PKDmgType_Electro')) || ClassIsChildOf(dmgType, Class'PKDmgType_SoulReaper')) || ClassIsChildOf(dmgType, Class'PKDmgType_Flamer')) || bIsFrozen)
    {
        return none;
    }
    // End:0x99
    if(Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
    {
        return none;
    }
    return Class'PKBloodGlob';
    //return ReturnValue;    
}

simulated function bool CheckDamageTypeIsEnvironmentalDamage(class<DamageType> DamageType)
{
    local bool bResult;

    // End:0x24
    if(ClassIsChildOf(DamageType, Class'PKDmgType_Explosion'))
    {
        bResult = true;
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool CheckDamageTypeIsExplosiveDamage(class<DamageType> DamageType)
{
    local bool bResult;

    // End:0x27
    if(ClassIsChildOf(DamageType, Class'PKDmgType_Rocket'))
    {
        bResult = true;        
    }
    else
    {
        // End:0x4E
        if(ClassIsChildOf(DamageType, Class'PKDmgType_Heater'))
        {
            bResult = true;            
        }
        else
        {
            // End:0x75
            if(ClassIsChildOf(DamageType, Class'PKDmgType_Grenade'))
            {
                bResult = true;                
            }
            else
            {
                // End:0x99
                if(ClassIsChildOf(DamageType, Class'PKDmgType_GasBarrel'))
                {
                    bResult = true;
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool CheckDamageTypeIsComboDamage(class<DamageType> DamageType)
{
    local bool bResult;

    // End:0x27
    if(ClassIsChildOf(DamageType, Class'PKDmgType_ElectroSaw'))
    {
        bResult = true;        
    }
    else
    {
        // End:0x4E
        if(ClassIsChildOf(DamageType, Class'PKDmgType_GasBarrel'))
        {
            bResult = true;            
        }
        else
        {
            // End:0x75
            if(ClassIsChildOf(DamageType, Class'PKDmgType_GrenadeGas'))
            {
                bResult = true;                
            }
            else
            {
                // End:0x9C
                if(ClassIsChildOf(DamageType, Class'PKDmgType_PainkillerBladesRotating'))
                {
                    bResult = true;                    
                }
                else
                {
                    // End:0xC3
                    if(ClassIsChildOf(DamageType, Class'PKDmgType_SoulSawCombo'))
                    {
                        bResult = true;                        
                    }
                    else
                    {
                        // End:0xEA
                        if(ClassIsChildOf(DamageType, Class'PKDmgType_GrenadeCombo'))
                        {
                            bResult = true;                            
                        }
                        else
                        {
                            // End:0x10E
                            if(ClassIsChildOf(DamageType, Class'PKDmgType_HeaterCombo'))
                            {
                                bResult = true;
                            }
                        }
                    }
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function OnJump(SeqAct_Jump Action)
{
    // End:0x11
    if(CurrentJumpInfo != none)
    {
        return;
    }
    // End:0xA9
    if(Action.ImpulseVector != none)
    {
        JumpImpulseFromKismet = Vector(Action.ImpulseVector.Rotation) * Action.ImpulseVector.ImpulseStrength;
    }
    Controller.Focus = none;
    Controller.SetFocalPoint(Location + (Normal(JumpImpulseFromKismet * vect(1.0000000, 1.0000000, 0.0000000)) * float(1000)));
    AddVelocity(JumpImpulseFromKismet, vect(0.0000000, 0.0000000, 0.0000000), none);
    //return;    
}

simulated function TurnOff()
{
    // End:0x43
    if(EvilAIController(Controller) != none)
    {
        EvilAIController(Controller).DisableAI(false, true, true);
    }
    // End:0x63
    if(int(PawnAction) != 0)
    {
        DoPawnAction(0, true);
    }
    super(UTPawn).TurnOff();
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    bBlockSpawnNextPawn = true;
    super(UTPawn).FellOutOfWorld(dmgType);
    //return;    
}

simulated state Dying
{
    ignores OnAnimEnd, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, 
	    BreathTimer, StartFeignDeathRecoveryAnim, ForceRagdoll, FellOutOfWorld;

    event Timer()
    {
        // End:0xDF
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            // End:0x41
            if(bSpawnNextPawnWhenBodyDisapear)
            {
                SpawnNextPawn();
            }
            // End:0x5D
            if(Soul == none)
            {
                ThrowSoul();                
            }
            else
            {
                // End:0xDF
                if(Soul.Owner == self)
                {
                    Soul.CheckTouching();
                    Soul.SetHidden(false);
                    Soul.SetDestroyTimer();
                }
            }
        }
        bThrowSoul = false;
        PlayDeathEffects();
        LifeSpan = 2.0000000;
        //return;        
    }
    stop;    
}

defaultproperties
{
    bThrowSoul=true
    bCanBeFrozen=true
    bUseAimOffsets=true
    EnableGibWhenHPBelow=true
    bGetAdjustedAimFromSocket=true
    bCanBePinned=true
    bSpawnNextPawnWhenBodyDisapear=true
    SoulItemClass=Class'PainItem_Energy'
    RedSoulItemClass=Class'PainItem_EnergyRed'
    InstantGibOriginShiftX=100.0000000
    InstantGibOriginShiftZ=-50.0000000
    InstantGibForce=100.0000000
    SoulEffectPS=ParticleSystem'ps_all_Levels.Effects.ps_ch_SkeletonWithSoul'
    FrozenEffectPS=ParticleSystem'ps_wp_Shotgun.Effects.ps_ch_Freeze'
    FrozenLightArchetype=EvilLightActor'ps_wp_Shotgun.ar_wp_FreezerLightChar'
    ElectricityEffectPS=ParticleSystem'ps_wp_Electrodriver.Effects.ps_ch_Electro'
    SoulReaperEffectPS=ParticleSystem'ps_wp_SoulReaper.Effects.ps_ch_Soul'
    SparksSoundCues[0]=SoundCue'a_ElectroDriver.Cue.electro-shoot-spark1'
    SparksSoundCues[1]=SoundCue'a_ElectroDriver.Cue.electro-shoot-spark2'
    SparksSoundCues[2]=SoundCue'a_ElectroDriver.Cue.electro-shoot-spark3'
    ElectricityConvulsionsBones[0]="LeftForeArm"
    ElectricityConvulsionsBones[1]="RightForeArm"
    ElectricityConvulsionsBones[2]="Hips"
    ElectricityConvulsionsBones[3]="LeftLeg"
    ElectricityConvulsionsBones[4]="RightLeg"
    ElectricityConvulsionsBones[5]="Head"
    GibImpactSoundCue=SoundCue'a_ImpactsFlesh.Cue.meat-splash'
    GibFrozenImpactSoundCue=SoundCue'a_ImpactsFlesh.Cue.meat_frozen-splash'
    DetachingLimbSoundCue=SoundCue'a_ImpactsFlesh.Cue.gib_part'
    DetachingLimbBySoulSawSoundCue=SoundCue'a_SoulReaper.Cue.a_DiscHitMeat'
    FullGibSoundCue=SoundCue'a_ImpactsFlesh.Cue.gib_big'
    FullFrozenGibSoundCue=SoundCue'a_ImpactsFlesh.Cue.gib_frozen'
    GibImpactParticleSystem=ParticleSystem'ps_Blood.Effects.ps_Bloodhit_GibExplo'
    GibImpactDecalMaterials[0]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver1'
    GibImpactDecalMaterials[1]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver2'
    GibImpactDecalMaterials[2]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver3'
    GibImpactDecalMaterials[3]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver4'
    DefaultImpactMaterial=PhysicalMaterial'pm_materials.PM_Flesh'
    BodyExplosionSound=SoundCue'a_MonsterDefault.Cue.monster_body_explosion'
    BodyExplosionPS=ParticleSystem'ps_all_Levels.Effects.ps_ch_MorphToSoul'
    BodyExplosionNoSoulPS=ParticleSystem'ps_all_Levels.Effects.ps_ch_MorphToSoulEnclave'
    SoulShiftUpDistance=50.0000000
    DemonModeMaterial=Material'PP_PKHD.Materials.DemonVisionMonsterMaterial'
    PKMaterialAtlasArchetype=PKMaterialAtlas'MaterialsAtlas_ch.Archetypes.MaterialsAtlas_Generic'
    KillScoreSV=1.0000000
    GibImpactSoundLimitCount=3
    GibImpactDecalLimitCount=8
    GibImpactPSLimitCount=8
    // Reference: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        HiddenGame=true
        BlockActors=false
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    begin object name="ProjectileEffect" class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bAimWhenFullBodySlotAnim=true
    bPlayHitSoundInPlayHit=false
    bShouldPlayDeathAnimationToRagdoll=true
    bHasDirectionalMoveAnims=false
    DetachingSpecificLimbEnabled=false
    bCanDoTurnInPlaceAnim=false
    NPCAimingHelpRadius=100.0000000
    DefaultHealth=100.0000000
    MaximumRagdollSpeed=1400.0000000
    TimeToBodyDisappear=7.0000000
    BurnEffectPS=ParticleSystem'ps_FireEffects.Effects.ps_ch_Burning'
    BurnEffectPS_NoGore=ParticleSystem'ps_FireEffects.Effects.ps_ch_Burning_noGore'
    CapturedEffectPS=ParticleSystem'ps_ch_Captured.Effects.ps_ch_Plazma'
    PawnActionClasses=/* Array type was not detected. */
    DetachingLimbSoundLimiter=1
    TurnInPlaceWhileMovingYawThreshold=256.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    DefaultAirControl=1.0000000
    // Reference: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    HeadBone="Head"
    // Reference: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'EvilGame.Default__EvilPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'EvilGame.Default__EvilPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    FallImpactSound=SoundCue'a_PlayerMP.Cue.Body_Falls'
    FallSpeedThreshold=150.0000000
    // Reference: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'EvilGame.Default__EvilPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'EvilGame.Default__EvilPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    MaxStepHeight=45.0000000
    WalkableFloorZ=0.6000000
    bCanPickupInventory=false
    // Reference: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        SkipLodModel=1
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
        RBCollideWithChannels=(DeadPawn=true)
        Translation=(X=0.0000000,Y=0.0000000,Z=-60.0000000)
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=57.0000000
        CollisionRadius=20.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    InventoryManagerClass=Class'PKInventoryManager'
    // Reference: EvilAudioComponent'Default__PKPawn.FaceAudioComponent'
    // Archetype: EvilAudioComponent'EvilGame.Default__EvilPawn.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
}