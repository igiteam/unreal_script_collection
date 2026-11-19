class DestructibleStaticMesh extends DynamicSMActor
    native;

struct native SwapParticle
{
    var() ParticleSystem ParticleSystem;
    var() Vector Offset;

    structdefaultproperties
    {
        ParticleSystem=none
        Offset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SwapKAsset
{
    var() SkeletalMesh SkelMesh;
    var() PhysicsAsset PhysAsset;

    structdefaultproperties
    {
        SkelMesh=none
        PhysAsset=none
    }
};

var() int HitPoints;
var() StaticMesh SwapMesh;
var() bool UseKActor;
var() SwapKAsset SwapSkel;
var() array<SwapParticle> Particles;
var export editinline DrawSphereComponent RenderComponent;
var() const editconst export editinline RB_RadialImpulseComponent ImpulseComponent;
var() int ImpulseDamage;
var() float ImpulseDamageDelay;
var() float SystemLifeSpan;
var export editinline DrawSphereComponent PreviewSphere;
var float FloatDamageRemainder;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x22
    if(bHidden == true)
    {
        SetHiddenFlag(bHidden);
    }
    //return;    
}

function Swap()
{
    local int I;
    local SwapParticle P;
    local Emitter ps;
    local SPKAsset ka;
    local KActor kh;
    local bool destroyMe;
    local Vector AsimOffset;

    destroyMe = true;
    // End:0xC7
    if(UseKActor == true)
    {
        StaticMeshComponent.SetStaticMesh(none);
        kh = Spawn(Class'Engine.KActor',,, Location, Rotation);
        // End:0xC4
        if(kh != none)
        {
            kh.StaticMeshComponent.SetStaticMesh(SwapMesh);
            kh.SetPhysics(10);
            kh.StaticMeshComponent.WakeRigidBody();
            // End:0xC4
            if(SystemLifeSpan > float(0))
            {
                kh.LifeSpan = SystemLifeSpan;
            }
        }        
    }
    else
    {
        StaticMeshComponent.SetStaticMesh(SwapMesh);
        destroyMe = false;
    }
    I = 0;
    J0xEF:

    // End:0x1EB [Loop If]
    if(I < Particles.Length)
    {
        P = Particles[I];
        ps = Spawn(Class'Engine.EmitterSpawnable',,, Location + P.Offset, Rotation);
        // End:0x1E1
        if(ps != none)
        {
            ps.SetTemplate(P.ParticleSystem, true);
            ps.bDestroyOnSystemFinish = true;
            ps.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            ps.ParticleSystemComponent.ActivateSystem();
            // End:0x1E1
            if(SystemLifeSpan > float(0))
            {
                ps.LifeSpan = SystemLifeSpan;
            }
        }
        I++;
        // [Loop Continue]
        goto J0xEF;
    }
    // End:0x324
    if(SwapSkel.SkelMesh != none)
    {
        AsimOffset = Location;
        AsimOffset.X += float(64);
        ka = Spawn(Class'SPKAsset',,, AsimOffset, Rotation);
        // End:0x324
        if(ka != none)
        {
            ka.SkeletalMeshComponent.SetPhysicsWeight(1.0000000);
            ka.SkeletalMeshComponent.SetPhysicsAsset(SwapSkel.PhysAsset);
            ka.SkeletalMeshComponent.SetSkeletalMesh(SwapSkel.SkelMesh);
            ka.SetPhysics(10);
            ka.InitPhysics();
            ka.SkeletalMeshComponent.WakeRigidBody();
            // End:0x324
            if(SystemLifeSpan > float(0))
            {
                ka.LifeSpan = SystemLifeSpan;
            }
        }
    }
    // End:0x38C
    if(ImpulseComponent.ImpulseStrength > float(0))
    {
        ImpulseComponent.FireImpulse(Location);
        // End:0x38C
        if(ImpulseDamage > 0)
        {
            // End:0x382
            if(ImpulseDamageDelay > float(0))
            {
                SetTimer(ImpulseDamageDelay, false, 'DoDamage');                
            }
            else
            {
                DoDamage();
            }
        }
    }
    // End:0x39B
    if(destroyMe)
    {
        Destroy();        
    }
    else
    {
        LifeSpan = SystemLifeSpan;
    }
    //return;    
}

function Destroyed()
{
    //return;    
}

function DoDamage()
{
    // End:0x3F
    if(ImpulseDamage > 0)
    {
        HurtRadius(float(ImpulseDamage), ImpulseComponent.ImpulseRadius, Class'PandoraDamageType', 1.0000000, Location);
    }
    //return;    
}

function int FloatingPointAdjustDamage(float Damage)
{
    local int intDamage, extraDamage;

    intDamage = int(Damage);
    FloatDamageRemainder += (Damage - float(intDamage));
    extraDamage = int(FloatDamageRemainder);
    intDamage += extraDamage;
    FloatDamageRemainder = FloatDamageRemainder - float(extraDamage);
    return intDamage;
    //return ReturnValue;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    DamageAmount = float(FloatingPointAdjustDamage(DamageAmount));
    // End:0x56
    if(HitPoints > 0)
    {
        HitPoints = int(float(HitPoints) - DamageAmount);
        // End:0x56
        if(HitPoints <= 0)
        {
            HitPoints = 0;
            Swap();
        }
    }
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    TakeFallingDamage();
    //return;    
}

function TakeFallingDamage()
{
    // End:0x45
    if(Velocity.Z < -100.0000000)
    {
        TakeDamageAndProcEffects(float(HitPoints), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
    }
    //return;    
}

event bool CanBeUsed(Pawn User)
{
    // End:0x5A
    if(User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != none)
    {
        return PandoraPlayerController(User.Controller).AttemptPickup(self, true);
    }
    return false;
    //return ReturnValue;    
}

event bool UsedBy(Pawn User)
{
    // End:0x5A
    if(User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != none)
    {
        return PandoraPlayerController(User.Controller).AttemptPickup(self, false);
    }
    return false;
    //return ReturnValue;    
}
