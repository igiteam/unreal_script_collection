class SkyProjectile extends Projectile
    native;

struct native PhysMatEffect
{
    var() name Material;
    var() ParticleSystem Effect;
    var() float ParticleDrawScale;
    var() SoundCue Sound;
    var() MaterialInterface Decal;
    var() float DecalDepth;
    var() float DecalOffset;
    var float DecalWidth;
    var float DecalHeight;
    var() float DecalMinSize;
    var() float DecalMaxSize;
    var float DecalRotation;
    var() float DecalMinRotation;
    var() float DecalMaxRotation;
    var int SubImageIndex;
    var() int SubImages_Horizontal;
    var() int SubImages_Vertical;
    var() int SubImageMinIndex;
    var() int SubImageMaxIndex;
    var() bool bLocalToHitPawn;
    var() name PawnAttachBoneName;

    structdefaultproperties
    {
        Material="None"
        Effect=none
        ParticleDrawScale=1.0000000
        Sound=none
        Decal=none
        DecalDepth=200.0000000
        DecalOffset=50.0000000
        DecalWidth=0.0000000
        DecalHeight=0.0000000
        DecalMinSize=200.0000000
        DecalMaxSize=200.0000000
        DecalRotation=0.0000000
        DecalMinRotation=0.0000000
        DecalMaxRotation=360.0000000
        SubImageIndex=0
        SubImages_Horizontal=1
        SubImages_Vertical=1
        SubImageMinIndex=0
        SubImageMaxIndex=0
        bLocalToHitPawn=false
        PawnAttachBoneName="None"
    }
};

struct native ExplosionTouchEffect
{
    var() name MaterialType;
    var() ParticleSystem ParticleSystem;
    var() float ParticleDrawScale;
    var() SoundCue Sound;
    var() MaterialInterface DecalMaterial;
    var() float DecalMinSize;
    var() float DecalMaxSize;
    var() int SubImages_Horizontal;
    var() int SubImages_Vertical;
    var() int SubImageMinIndex;
    var() int SubImageMaxIndex;
    var() float FadeDistanceMin;
    var() float FadeDistanceMax;
    var() bool bKillOnMaxDistance;

    structdefaultproperties
    {
        MaterialType="None"
        ParticleSystem=none
        ParticleDrawScale=1.0000000
        Sound=none
        DecalMaterial=none
        DecalMinSize=10.0000000
        DecalMaxSize=10.0000000
        SubImages_Horizontal=1
        SubImages_Vertical=1
        SubImageMinIndex=0
        SubImageMaxIndex=0
        FadeDistanceMin=0.0000000
        FadeDistanceMax=0.0000000
        bKillOnMaxDistance=false
    }
};

struct native ExplodeTouchEffectContact
{
    var Actor TouchEffectActor;
    var array<CollisionImpactData> RigidCollisionData;

    structdefaultproperties
    {
        TouchEffectActor=none
        RigidCollisionData=none
    }
};

struct native SIgnoreList
{
    var Actor Target;
    var bool OldCollideActorsValue;
    var bool OldBlockActorsValue;

    structdefaultproperties
    {
        Target=none
        OldCollideActorsValue=false
        OldBlockActorsValue=false
    }
};

struct native SCollisionScaleInfo
{
    var() float BeginDistance;
    var() float EndDistance;
    var() float MinRadius;
    var() float MinHeight;

    structdefaultproperties
    {
        BeginDistance=0.0000000
        EndDistance=0.0000000
        MinRadius=0.0000000
        MinHeight=0.0000000
    }
};

var(Sounds) SoundCue AmbientSound;
var(Sounds) SoundCue ExplosionSound;
var export editinline AudioComponent ExplosionSoundComp;
var bool bImportantAmbientSound;
var bool bSuppressExplosionFX;
var(Projectile) bool bWaitForEffects;
var transient bool bProjEffectsFinished;
var transient bool bProjectileFinished;
var deprecated bool bCheckProjectileLight;
var(Projectile) bool bExplosionLocalToHitPawn;
var(Effects) bool bCauseLocalEffectOnDamage;
var transient bool bSkyPoolActive;
var(Projectile) bool bPoolingAllowed;
var transient bool Exploded;
var transient bool bAlreadySpawnedExplosionEffects;
var bool bSkipShutdownOnExplode;
var(Projectile) bool bSkipSpawnEffectsInDestroyed;
var deprecated bool bAccelerateBounce;
var(Ricochet) bool bBounceTowardNearestTarget;
var(Ricochet) bool bBounceOnPierce;
var deprecated bool bDetonateOnFirstImpact;
var(AI) bool bSendWarningToBots;
var transient bool bShuttingDown;
var bool CausesImpactEffect;
var transient bool bAlreadyTriggeredWhizzBy;
var(Effects) export editinline array<export editinline SkyParticleSystemComponent> ProjEffects;
var Emitter ProjExplosion;
var(Effects) array<ParticleSystem> ProjFlightTemplate;
var(Effects) ParticleSystem ProjExplosionTemplate;
var(Effects) array<ParticleSystem> RandomProjExplosionTemplates;
var ParticleSystem FastProjFlightTemplate;
var ParticleSystem FastProjExplosionTemplate;
var(Effects) MaterialInterface ExplosionDecal;
var(Effects) float DecalWidth;
var(Effects) float DecalHeight;
var(Effects) float MaxEffectDistance;
var(Effects) float MaxDecalDistance;
var(Effects) notforconsole editinline array<editinline ForceFieldSettingsRadial> ProjExplosionForceRadial;
var(Effects) notforconsole editinline array<editinline ForceFieldSettingsCylindrical> ProjExplosionForceCylindrical;
var(Effects) notforconsole editinline array<editinline ForceFieldSettingsGeneric> ProjExplosionForceGeneric;
var(Effects) notforconsole export editinline ApexTurbulenceForcefieldComponent TurbulenceForcefieldArchetype;
var notforconsole export editinline ApexTurbulenceForcefieldComponent TurbulenceForcefieldInstance;
var(Projectile) float AccelRate;
var(Projectile) Vector AdditionalAcceleration;
var float TossZ;
var float TerminalVelocity;
var int FiringOwnerStatsID;
var int FiringWeaponStatsID;
var int FiringWeaponMode;
var SkyWeaponBase FiringWeapon;
var SAntiGravParamsNew AntiGravParams;
var SDisableRocketpackParams DisableRocketpackParams;
var SPoisonParams PoisonParams;
var array<SVisualEffectParams> VisualEffectParams;
var SExplosionParams ExplosionParams;
var array<SkyPawn.EWeaponEffect> WeaponEffects;
var deprecated class<PointLightComponent> ProjectileLightClass;
var export editinline deprecated PointLightComponent ProjectileLight;
var deprecated class<SkyExplosionLight> ExplosionLightClass;
var deprecated float MaxExplosionLightDistance;
var(Projectile) Rotator ProjectileRotationRate;
var(Projectile) float LifeSpanVariance;
var Vector SpawnLocation;
var(Projectile) float DamagePercentToInstigator;
var(SI_Projectile) float DamageRadiusInner;
var(Effects) array<PhysMatEffect> ExplodeEffects;
var(Projectile) name ExplosionPawnAttachBoneName;
var deprecated SkyLocalEffect DamageLocalEffect;
var(Effects) editinline SkyLocalEffectSettings DamageLocalEffectSettings;
var(Effects) float ExplosionTouchEffectRadius;
var(Effects) array<ExplosionTouchEffect> ExplosionTouchEffects;
var export editinline RB_BodySetup ExplosionTouchEffectBodySetup;
var export editinline RB_BodyInstance ExplosionTouchEffectBodyInstance;
var export editinline RB_ConstraintSetup ExplosionTouchEffectConstraintSetup;
var export editinline RB_ConstraintInstance ExplosionTouchEffectConstraintInstance;
var array<ExplodeTouchEffectContact> ExplodeTouchEffectContacts;
var float CheckDecalDepth;
var(Reaction) float ExplosionStrength;
var SkyWeaponBase StoredWeaponThatDetonatesMe;
var(Projectile) float RangeTaperMinDamage;
var(Projectile) float RangeTaperStartDistance;
var(Projectile) float RangeTaperEndDistance;
var(Ricochet) int NumBounces;
var(Ricochet) float NearestTargetRadius;
var array<SIgnoreList> IgnoreList;
var Actor LastBounceTarget;
var SPiercingParams PiercingParams;
var int NumPiercings;
var(Projectile) SCollisionScaleInfo CollisionScaleInfo;
var transient Actor LastHitActor;
var float ExplodeShakeRadius;
var ViewShakeInfo ExplodeViewShake;
var float ExplodeRumbleRadius;
var ForceFeedbackWaveform ExplodeRumble;
var export editinline AudioComponent AmbientSoundComponent;
var(Sound) float AmbientSoundStartupTime;
var(Sound) SoundCue WhizzBySound;
var(Sound) float WhizzByRange;
var(Projectile) float TriggerPlayerVUpDangleProbability;

// Export USkyProjectile::execSetNoDelete(FFrame&, void* const)
native final function SetNoDelete(bool bNewNoDelete);

// Export USkyProjectile::execInitForPooling(FFrame&, void* const)
native simulated function InitForPooling();

// Export USkyProjectile::execDestroyFromPooling(FFrame&, void* const)
native simulated function DestroyFromPooling();

// Export USkyProjectile::execCanTick(FFrame&, void* const)
native simulated function bool CanTick();

// Export USkyProjectile::execIsPoolAvailable(FFrame&, void* const)
native simulated function bool IsPoolAvailable();

// Export USkyProjectile::execReset(FFrame&, void* const)
native simulated function Reset();

// Export USkyProjectile::execInit(FFrame&, void* const)
native function Init(Vector Direction);

// Export USkyProjectile::execSetStartLocation(FFrame&, void* const)
native function SetStartLocation(Vector newStartLoc);

function PlayAmbientSound()
{
    // End:0x1B
    if(AmbientSoundComponent != none)
    {
        AmbientSoundComponent.Play();
    }
    //return;    
}

// Export USkyProjectile::execShutDown(FFrame&, void* const)
native simulated function ShutDown();

event TornOff()
{
    ShutDown();
    super(Actor).TornOff();
    //return;    
}

// Export USkyProjectile::execHandleLifeSpanExpired(FFrame&, void* const)
native simulated function HandleLifeSpanExpired();

simulated function Destroyed()
{
    // End:0x7F
    if((((ProjExplosion == none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX) && !bSkipSpawnEffectsInDestroyed)
    {
        SpawnExplosionEffects(Location, Vector(Rotation) * float(-1));
        Explode(Location, vect(0.0000000, 0.0000000, 1.0000000));
    }
    super(Actor).Destroyed();
    //return;    
}

// Export USkyProjectile::execMyOnParticleSystemFinished(FFrame&, void* const)
native simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC);

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x3A
    if((int(Role) < int(ROLE_Authority)) && AccelRate != 0.0000000)
    {
        GotoState('WaitingForVelocity');        
    }
    else
    {
        GotoState('Auto');
    }
    //return;    
}

// Export USkyProjectile::execHideProjectile(FFrame&, void* const)
native simulated function HideProjectile();

// Export USkyProjectile::execUnhideProjectile(FFrame&, void* const)
native simulated function UnhideProjectile();

// Export USkyProjectile::execCanDamageActor(FFrame&, void* const)
native simulated function bool CanDamageActor(Actor HitActor);

// Export USkyProjectile::execCanPierce(FFrame&, void* const)
native function bool CanPierce(Actor Victim, Vector HitLocation);

// Export USkyProjectile::execAddToIgnoreList(FFrame&, void* const)
native function AddToIgnoreList(Actor Victim);

// Export USkyProjectile::execGetRangeTaperDamageAmount(FFrame&, void* const)
native simulated function int GetRangeTaperDamageAmount(Vector HitLocation);

// Export USkyProjectile::execDoBounce(FFrame&, void* const)
native simulated function DoBounce(Vector HitLocation, Vector HitNormal, Actor Victim, bool bPierced, bool bCausedDamage);

// Export USkyProjectile::execHitWall(FFrame&, void* const)
native simulated function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp, optional int Item);

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local float PawnMultiplier;
    local int I;
    local float DamageToUse;
    local SkyPawn pSP, pVictim;
    local bool bPierced, bAlreadyExploded;

    // End:0x0B
    if(bShuttingDown)
    {
        return;
    }
    // End:0x37
    if(!CanDamageActor(Other))
    {
        HitWall(HitNormal, Other, none);
        return;
    }
    // End:0x8A
    if(SkyWaterVolume(Other) != none)
    {
        Other.Touch(self, none, HitLocation, HitNormal);
        // End:0x8A
        if(SkyWaterVolume(Other).DestroysClass(Class))
        {
            return;
        }
    }
    // End:0xBC
    if((SkyVehicle(Instigator) != none) && Other == SkyVehicle(Instigator).Driver)
    {
        return;
    }
    // End:0xE1
    if(FiringWeapon != none)
    {
        pSP = SkyPawn(FiringWeapon.Owner);
    }
    // End:0x165
    if((((pSP != none) && pSP.CurrWeaponAttachment != none) && pSP.Weapon != none) && int(pSP.Weapon.WeaponFireTypes) == int(1))
    {
        pSP.CurrWeaponAttachment.PlayImpactEffectsRetrace(HitLocation);
    }
    // End:0x1B0
    if(PiercingParams.bIsPiercing && CanPierce(Other, HitLocation))
    {
        AddToIgnoreList(Other);
        ++NumPiercings;
        bPierced = true;
    }
    // End:0x1E9
    if(DamageRadius > 0.0000000)
    {
        Explode(HitLocation, HitNormal, Other, bPierced);
        bAlreadyExploded = true;        
    }
    else
    {
        PawnMultiplier = DefaultImpulse;
        I = 0;
        J0x1FB:

        // End:0x25E [Loop If]
        if(I < ImpulseScalers.Length)
        {
            // End:0x254
            if(ImpulseScalers[I].ImpactedClass == Other.Class)
            {
                PawnMultiplier = ImpulseScalers[I].ImpulseScale;
                // [Explicit Break]
                goto J0x25E;
            }
            ++I;
            // [Loop Continue]
            goto J0x1FB;
        }
        J0x25E:

        DamageToUse = float(GetRangeTaperDamageAmount(HitLocation));
        Other.TakeDamage(int(DamageToUse), InstigatorController, HitLocation, PawnMultiplier * Normal(Velocity), MyDamageType,, self);
        pVictim = SkyPawn(Other);
        // End:0x30F
        if(pVictim != none)
        {
            pVictim.DoWeaponEffects(WeaponEffects, none, self, Normal(Velocity));
            pVictim.PlayBoneDamageEffect(pVictim.LastHitsBoneType);
        }
        // End:0x324
        if(!bPierced)
        {
            ShutDown();
        }
    }
    // End:0x34F
    if(!bAlreadyExploded)
    {
        DoBounce(HitLocation, HitNormal, Other, bPierced, true);
    }
    //return;    
}

// Export USkyProjectile::execSpawnExplosionTouchEffects(FFrame&, void* const)
native simulated function SpawnExplosionTouchEffects();

// Export USkyProjectile::execExplode(FFrame&, void* const)
native simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor Other, optional bool bContinueAfterExplosion);

simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, float InnerDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage)
{
    local bool bCausedDamage;
    local float ImpulseScale;
    local int Idx;
    local Actor Victim;
    local SkyPawn SP;
    local Vector ShotDir;
    local float SplashDamagePct;

    // End:0x55
    if((WeaponEffects.Length == 0) && !(DamageAmount > 0.0000000) && InDamageRadius > 0.0000000)
    {
        return false;
    }
    // End:0x60
    if(bHurtEntry)
    {
        return false;
    }
    bCausedDamage = false;
    // End:0x7E
    if(InstigatedByController == none)
    {
        InstigatedByController = InstigatorController;
    }
    // End:0x1D3
    if((ImpactedActor != none) && ImpactedActor != self)
    {
        ImpulseScale = DefaultImpulse;
        Idx = 0;
        J0xA8:

        // End:0x10B [Loop If]
        if(Idx < ImpulseScalers.Length)
        {
            // End:0x101
            if(ImpulseScalers[Idx].ImpactedClass == ImpactedActor.Class)
            {
                ImpulseScale = ImpulseScalers[Idx].ImpulseScale;
                // [Explicit Break]
                goto J0x10B;
            }
            ++Idx;
            // [Loop Continue]
            goto J0xA8;
        }
        J0x10B:

        ImpactedActor.TakeRadiusDamage(InstigatedByController, DamageAmount, InDamageRadius, InnerDamageRadius, DamageType, ImpulseScale, HurtOrigin, true, self);
        SP = SkyPawn(ImpactedActor);
        // End:0x1BC
        if(SP != none)
        {
            // End:0x17E
            if(SP == LastHitActor)
            {
                ShotDir = Normal(Velocity);                
            }
            else
            {
                ShotDir = Normal(LastHitActor.Location - HurtOrigin);
            }
            SP.DoWeaponEffects(WeaponEffects, none, self, ShotDir);
        }
        bCausedDamage = ImpactedActor.bProjTarget;
    }
    // End:0x200
    if((InstigatedByController == none) && Instigator != none)
    {
        InstigatedByController = Instigator.Controller;
    }
    // End:0x210
    if(bHurtEntry)
    {
        return bCausedDamage;
    }
    bHurtEntry = true;
    // End:0x4B9
    foreach VisibleCollidingActors(Class'Engine.Actor', Victim, DamageRadius, HurtOrigin)
    {
        // End:0x248
        if(Victim == ImpactedActor)
        {
            continue;            
        }
        ImpulseScale = DefaultImpulse;
        Idx = 0;
        J0x25A:

        // End:0x2BD [Loop If]
        if(Idx < ImpulseScalers.Length)
        {
            // End:0x2B3
            if(ImpulseScalers[Idx].ImpactedClass == Victim.Class)
            {
                ImpulseScale = ImpulseScalers[Idx].ImpulseScale;
                // [Explicit Break]
                goto J0x2BD;
            }
            ++Idx;
            // [Loop Continue]
            goto J0x25A;
        }
        J0x2BD:

        Momentum = ImpulseScale;
        // End:0x4B8
        if(((!Victim.bWorldGeometry && Victim.bStatic && Victim != self) && Victim != IgnoredActor) && Victim.bProjTarget || NavigationPoint(Victim) == none)
        {
            // End:0x36B
            if((Pawn(Victim) != none) && Pawn(Victim) == Instigator)
            {
                SplashDamagePct = DamagePercentToInstigator;                
            }
            else
            {
                SplashDamagePct = 1.0000000;
            }
            // End:0x3D6
            if(Victim.IsA('SkyPawn'))
            {
                Victim.TakeRadiusDamage(InstigatedByController, DamageAmount * SplashDamagePct, DamageRadius, InnerDamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);                
            }
            else
            {
                Victim.TakeRadiusDamage(InstigatedByController, DamageAmount * SplashDamagePct, DamageRadius, InnerDamageRadius, DamageType, Momentum, HurtOrigin, true, self);
            }
            SP = SkyPawn(Victim);
            // End:0x496
            if(SP != none)
            {
                // End:0x450
                if(SP == LastHitActor)
                {
                    ShotDir = Normal(Velocity);                    
                }
                else
                {
                    ShotDir = Normal(LastHitActor.Location - HurtOrigin);
                }
                SP.DoWeaponEffects(WeaponEffects, none, self, ShotDir);
                bCausedDamage = true;
            }
            bCausedDamage = bCausedDamage || Victim.bProjTarget;
        }        
    }    
    bHurtEntry = false;
    return bCausedDamage;
    //return ReturnValue;    
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    super(Actor).Landed(HitNormal, FloorActor);
    Explode(Location, HitNormal);
    //return;    
}

// Export USkyProjectile::execCreateExplosionTouchEffectBody(FFrame&, void* const)
native simulated function CreateExplosionTouchEffectBody();

// Export USkyProjectile::execDestroyExplosionTouchEffectBody(FFrame&, void* const)
native simulated function DestroyExplosionTouchEffectBody();

simulated function PostBeginPlay()
{
    local SkyBotControllerPilot OtherPilot;
    local SkyHUD SH;
    local SkyPlayerController SPC;
    local SkyAirVehicle ThisVehicle;

    // End:0x1F
    if(TurbulenceForcefieldArchetype != none)
    {
        TurbulenceForcefieldInstance = new Class'Engine.ApexTurbulenceForcefieldComponent' (TurbulenceForcefieldArchetype);
    }
    super.PostBeginPlay();
    // End:0x30
    if(bDeleteMe)
    {
        return;
    }
    // End:0xC8
    if((AmbientSound != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0xC8
        if(bImportantAmbientSound || !WorldInfo.bDropDetail)
        {
            // End:0x9B
            if(AmbientSoundComponent == none)
            {
                AmbientSoundComponent = CreateAudioComponent(AmbientSound, true, true);                
            }
            else
            {
                AmbientSoundComponent.Play();
            }
            // End:0xC8
            if(AmbientSoundComponent != none)
            {
                AmbientSoundComponent.bShouldRemainActiveIfDropped = true;
            }
        }
    }
    LifeSpan = Actor(ObjectArchetype).LifeSpan + (((FRand() * float(2)) - float(1)) * LifeSpanVariance);
    // End:0x1BC
    if(bSendWarningToBots)
    {
        // End:0x1BC
        if(Instigator != none)
        {
            SPC = SkyPlayerController(Instigator.Controller);
            // End:0x1BC
            if(!bDeleteMe && SPC != none)
            {
                SH = SkyHUD(SPC.myHUD);
                // End:0x1BC
                if(SH != none)
                {
                    // End:0x1BB
                    foreach WorldInfo.AllControllers(Class'SkyBotControllerPilot', OtherPilot)
                    {
                        ThisVehicle = SkyAirVehicle(OtherPilot.Pawn);
                        // End:0x1BA
                        if(ThisVehicle != none)
                        {
                            OtherPilot.ReceiveProjectileWarning(self);
                        }                        
                    }                    
                }
            }
        }
    }
    //return;    
}

simulated function launch(Vector Loc, Rotator Rot, Vector Direction, optional Vector ExtraVelocity, optional float spinRate)
{
    CreateExplosionTouchEffectBody();
    //return;    
}

// Export USkyProjectile::execSpawnFlightEffects(FFrame&, void* const)
native simulated function SpawnFlightEffects();

// Export USkyProjectile::execCheckMaxEffectDistance(FFrame&, void* const)
native simulated function bool CheckMaxEffectDistance(PlayerController P, Vector FXSpawnLocation, optional float CullDistance);

// Export USkyProjectile::execSpawnExplosionEffects(FFrame&, void* const)
native simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal, optional Actor Other);

// Export USkyProjectile::execSpawnBaseExplosion(FFrame&, void* const)
native simulated function SpawnBaseExplosion(Vector HitLocation, Vector HitNormal, optional Actor Other);

// Export USkyProjectile::execGetImpactEffects(FFrame&, void* const)
native simulated function Actor GetImpactEffects(Actor HitActor, out Vector HitLocation, out Vector HitNormal, out PhysMatEffect Effect);

// Export USkyProjectile::execOrientZAxisToNormal(FFrame&, void* const)
native static function Rotator OrientZAxisToNormal(Vector HitNormal, Vector Direction, Vector pos);

// Export USkyProjectile::execSpawnMaterialImpact(FFrame&, void* const)
native simulated function SpawnMaterialImpact(Vector HitLocation, Vector HitNormal, PhysMatEffect Effect, optional Actor Other);

// Export USkyProjectile::execSpawnDecalImpact(FFrame&, void* const)
native simulated function SpawnDecalImpact(Vector HitLocation, Vector HitNormal, PhysMatEffect Effect, Actor HitActor);

// Export USkyProjectile::execUpdateHitStats(FFrame&, void* const)
native function UpdateHitStats(bool bDirectHit);

// Export USkyProjectile::execInitStats(FFrame&, void* const)
native function InitStats(SkyWeaponBase InstigatorWeapon);

state WaitingForVelocity
{
    simulated function Tick(float DeltaTime)
    {
        // End:0x2F
        if(!IsZero(Velocity))
        {
            Acceleration = AccelRate * Normal(Velocity);
            GotoState('Auto');
        }
        //return;        
    }
    stop;    
}
