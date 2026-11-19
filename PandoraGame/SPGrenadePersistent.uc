class SPGrenadePersistent extends SPKActor
    abstract
    native;

var ParticleSystem GrenadeTrailSystem;
var ParticleSystem StunParticleTemplate;
var Emitter TrailParticle;
var SPFlareFireObject MolotovFireObject;
var ImpactInfo CollisionImpactInfo;
var SPGrenadeLauncherPersistent GrenadeLauncherParent;
var int ImpulseStrength;
var int ImpulseRadius;
var bool m_bDamageImpulse;
var bool bSwitchToZeroCollision;
var bool bBlockedByInstigator;
var bool bBegunPlay;
var bool bRotationFollowsVelocity;
var float Speed;
var float MaxSpeed;
var Actor ZeroCollider;
var float Damage0;
var float DamageRadius;
var float MomentumTransfer;
var class<DamageType> MyDamageType;
var SoundCue SpawnSound;
var SoundCue SpawnSoundNPC;
var SoundCue ImpactSound;
var SoundCue ExplosionSound;
var Controller InstigatorController;
var float NetCullDistanceSquared;
var export editinline CylinderComponent CylinderComponent;
var export editinline StaticMeshComponent MeshComponent;
var float TossZ;
var float MyDamageAmount;
var float MyDamageRadius;
var float MyPlayerRadius;
var float MyPlayerDamage;
var float m_OverrideGravityZ;

// Export USPGrenadePersistent::execAlertNearbyAIs(FFrame&, void* const)
native function AlertNearbyAIs(float Radius, bool bCheckForWalls);

simulated function PostBeginPlay()
{
    super(KActor).PostBeginPlay();
    // End:0x38
    if((int(Role) == int(ROLE_Authority)) && Instigator != none)
    {
        InstigatorController = Instigator.Controller;
    }
    bBegunPlay = true;
    RandSpin(GetRandSpin());
    AttachParticleTrail();
    LifeSpan = GetDefaultLifeSpan();
    MyDamageAmount = GetDamageAmount();
    MyDamageRadius = GetDamageRadius();
    ImpulseStrength = int(GetImpulseStrength());
    MyPlayerDamage = GetPlayerOnlyDamage();
    MyPlayerRadius = GetPlayerOnlyRadius();
    //return;    
}

simulated function SetGrenadeLauncherParent(SPGrenadeLauncherPersistent gLauncher)
{
    GrenadeLauncherParent = gLauncher;
    //return;    
}

simulated function ApplyRotationRate(float spinRate)
{
    local float radians;
    local Vector W;

    radians = (spinRate * 3.1415930) / 65536.0000000;
    W = Normal(Vector(RotationRate));
    W = W * radians;
    StaticMeshComponent.SetRBAngularVelocity(W);
    //return;    
}

static simulated function float GetDefaultLifeSpan()
{
    return 3.0000000;
    //return ReturnValue;    
}

simulated function float GetDamageAmount()
{
    return MyDamageAmount;
    //return ReturnValue;    
}

simulated function float GetDamageRadius()
{
    return MyDamageRadius;
    //return ReturnValue;    
}

simulated function float GetImpulseStrength()
{
    return float(ImpulseStrength);
    //return ReturnValue;    
}

simulated function float GetPlayerOnlyDamage()
{
    return MyPlayerDamage;
    //return ReturnValue;    
}

simulated function float GetPlayerOnlyRadius()
{
    return MyPlayerRadius;
    //return ReturnValue;    
}

simulated function float GetRandSpin()
{
    return 100000.0000000;
    //return ReturnValue;    
}

simulated function Init(Vector Direction)
{
    SetRotation(Rotator(Direction));
    Velocity = Speed * Direction;
    Velocity *= (GetVelocityScale());
    TossZ = (TossZ + ((FRand() * TossZ) / 2.0000000)) - (TossZ / 4.0000000);
    Velocity.Z += TossZ;
    StaticMeshComponent.SetRBLinearVelocity(Velocity);
    StaticMeshComponent.SetRBRotation(Rotation);
    StaticMeshComponent.WakeRigidBody();
    //return;    
}

simulated event float GetVelocityScale()
{
    return 1.2000000;
    //return ReturnValue;    
}

simulated event float GetGravityScale()
{
    return 450.0000000;
    //return ReturnValue;    
}

simulated function SetGravityZOverride(float GravZ)
{
    m_OverrideGravityZ = GravZ;
    //return;    
}

function InitSpit(Vector Direction, float inspeed, Controller spawningController)
{
    //return;    
}

simulated function bool CanSplash()
{
    return bBegunPlay;
    //return ReturnValue;    
}

simulated function Reset()
{
    Destroy();
    //return;    
}

simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage, optional float fPlayerOnlyRadius, optional float fPlayerOnlyDamage)
{
    local bool bCausedDamage, bResult;

    // End:0x30
    if(bHurtEntry)
    {
        return false;
    }
    bCausedDamage = false;
    // End:0x4E
    if(InstigatedByController == none)
    {
        InstigatedByController = InstigatorController;
    }
    // End:0xDD
    if((CollisionImpactInfo.HitActor != none) && CollisionImpactInfo.HitActor != self)
    {
        CollisionImpactInfo.HitActor.TakeRadiusDamage(InstigatedByController, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, true, self);
        bCausedDamage = CollisionImpactInfo.HitActor.bProjTarget;
    }
    bResult = ExplosiveHurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, CollisionImpactInfo.HitActor, InstigatedByController, bDoFullDamage, fPlayerOnlyRadius, fPlayerOnlyDamage);
    // End:0x152
    if(bResult || bCausedDamage)
    {
        UpdateHitStats(bCausedDamage);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UpdateHitStats(bool bDirectHit)
{
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    Destroy();
    //return;    
}

simulated function RandSpin(float spinRate)
{
    RotationRate.Yaw = int((float(2) * spinRate) - (spinRate * FRand()));
    RotationRate.Pitch = int(((spinRate * float(2)) * FRand()) - spinRate);
    RotationRate.Roll = int(((spinRate * float(2)) * FRand()) - spinRate);
    ApplyRotationRate(spinRate);
    //return;    
}

simulated function FlareRandSpin(float spinRate, optional bool Forward = false)
{
    //return;    
}

function bool IsStationary()
{
    return false;
    //return ReturnValue;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    Destroy();
    //return;    
}

static simulated function float GetRange()
{
    // End:0x1D
    if((GetDefaultLifeSpan()) == 0.0000000)
    {
        return 15000.0000000;        
    }
    else
    {
        return default.MaxSpeed * (GetDefaultLifeSpan());
    }
    //return ReturnValue;    
}

simulated event HitSomething(Vector HitNormal, Actor HitActor, PrimitiveComponent HitComponent, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    //return;    
}

function FindImpactInfo(Vector HitNormal, Actor HitActor, PrimitiveComponent HitComponent, Vector HitLocation, TraceHitInfo HitInfo)
{
    CollisionImpactInfo.HitActor = HitActor;
    CollisionImpactInfo.HitLocation = HitLocation;
    CollisionImpactInfo.HitInfo = HitInfo;
    CollisionImpactInfo.HitNormal = HitNormal;
    CollisionImpactInfo.RayDir = Normal(HitLocation - Location);
    //return;    
}

function CreateDamageImpulse(float DamageAmount, float Radius, class<DamageType> DamageType, float PlayerRadius, float PlayerDamage)
{
    local SPDImpulseActor impulseActor;
    local Vector pos;

    pos = Location;
    impulseActor = Spawn(Class'SPDImpulseActor',,, pos);
    impulseActor.ImpulseComponent.ImpulseFalloff = 1;
    impulseActor.ImpulseComponent.ImpulseStrength = float(ImpulseStrength);
    impulseActor.ImpulseComponent.ImpulseRadius = Radius;
    impulseActor.delay = 0.0000000;
    impulseActor.Damage = int(DamageAmount);
    impulseActor.DamageRadius = Radius;
    impulseActor.DamageType = DamageType;
    impulseActor.bExplosive = true;
    impulseActor.PlayerOnlyRadius = PlayerRadius;
    impulseActor.PlayerOnlyDamage = PlayerDamage;
    impulseActor.bKillDuringLevelTransition = true;
    //return;    
}

simulated function Destroyed()
{
    // End:0x3E
    if(m_bDamageImpulse && int(Role) == int(ROLE_Authority))
    {
        CreateDamageImpulse(MyDamageAmount, MyDamageRadius, MyDamageType, MyPlayerRadius, MyPlayerDamage);
    }
    SpawnStunParticle();
    KillParticleTrail();
    PlayExplosionSound();
    SpawnExplosionLight();
    // End:0x85
    if(GrenadeLauncherParent != none)
    {
        GrenadeLauncherParent.DestroyCurrentGrenade();
    }
    super(KActor).Destroyed();
    //return;    
}

simulated function SpawnStunParticle()
{
    local Emitter E;

    // End:0xB9
    if(StunParticleTemplate != none)
    {
        E = Spawn(Class'Engine.EmitterSpawnable',,, Location, Rotator(vect(0.0000000, 0.0000000, 0.0000000)));
        // End:0xB9
        if(E != none)
        {
            E.SetTemplate(StunParticleTemplate, true);
            E.bDestroyOnSystemFinish = true;
            E.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            E.ParticleSystemComponent.ActivateSystem();
            E.bKillDuringLevelTransition = true;
        }
    }
    //return;    
}

simulated function PlayExplosionSound()
{
    // End:0x1B
    if(ExplosionSound != none)
    {
        PlaySound(ExplosionSound, true);
    }
    //return;    
}

simulated function SpawnExplosionLight()
{
    //return;    
}

simulated function AttachParticleTrail()
{
    // End:0xD4
    if(GrenadeTrailSystem != none)
    {
        TrailParticle = Spawn(Class'Engine.EmitterSpawnable',,, Location, Rotation);
        // End:0xAF
        if(TrailParticle != none)
        {
            TrailParticle.SetTemplate(GrenadeTrailSystem, true);
            TrailParticle.bDestroyOnSystemFinish = true;
            TrailParticle.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            TrailParticle.ParticleSystemComponent.ActivateSystem();
            TrailParticle.bKillDuringLevelTransition = true;
        }
        AttachObject(TrailParticle, 'None', Location, Rotation, true, false);
    }
    //return;    
}

simulated function KillParticleTrail()
{
    // End:0x2C
    if(TrailParticle != none)
    {
        TrailParticle.ParticleSystemComponent.DeactivateSystem();
        TrailParticle = none;
    }
    //return;    
}
