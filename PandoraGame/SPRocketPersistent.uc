class SPRocketPersistent extends Projectile
    native;

enum SPRocketGuidanceMode
{
    eRocketGuidance_None,           // 0
    eRocketGuidance_Steered,        // 1
    eRocketGuidance_Homing,         // 2
    eRocketGuidance_MAX             // 3
};

struct native SPRocketGuidance
{
    var() SPRocketPersistent.SPRocketGuidanceMode Mode;
    var() Vector TargetPoint;
    var() Actor targetActor;

    structdefaultproperties
    {
        Mode=eRocketGuidance_None
        TargetPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        targetActor=none
    }
};

var SPRocketGuidance m_targetting;
var ParticleSystem ExplodeParticleTemplate;
var ParticleSystem ExhaustParticleTemplate;
var Emitter ExhaustParticle;
var int ImpulseStrength;
var Vector Target;
var Vector LastLocation;
var float TurnRate;
var float Age;
var float MaxAge;
var SPPhysicalMaterial SPPhysMat;
var SPRocketLauncherPersistent RocketLauncher;
var SoundCue RocketExhaustSound;
var SoundCue RocketExplosionSound;
var float WeaponRange;
var bool m_bJustFired;
var Vector m_VEndTrace;
var Vector m_VStartTrace;
var Vector m_VDirection;
var float m_splashDamageRadius;
var float m_splashDamage;
var float MyPlayerRadius;
var float MyPlayerDamage;
var ImpactParticlesInfo DefaultImpactParticles;
var ImpactDecalInfo DefaultImpactDecal;
var transient float m_startTime;

// Export USPRocketPersistent::execUpdateTarget(FFrame&, void* const)
native function UpdateTarget();

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetPhysics(6);
    ExhaustParticle = Spawn(Class'Engine.EmitterSpawnable',,, Location, Rotation);
    // End:0x9D
    if(ExhaustParticle != none)
    {
        ExhaustParticle.SetTemplate(ExhaustParticleTemplate, true);
        ExhaustParticle.bDestroyOnSystemFinish = true;
        ExhaustParticle.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
        ExhaustParticle.ParticleSystemComponent.ActivateSystem();
    }
    bBegunPlay = true;
    AttachObject(ExhaustParticle, 'None', Location, Rotation, true, false);
    CreateAudioComponent(RocketExhaustSound, true, true);
    m_bJustFired = true;
    m_startTime = WorldInfo.TimeSeconds;
    //return;    
}

function SetRocketRotationFromGenerator(Vector Loc)
{
    SetRotation(Rotator(Loc - Location));
    //return;    
}

simulated function Vector TargetLocation(Actor homingTarget)
{
    local SPPawn aPawn;
    local Box boundBox;
    local editinline SkeletalMeshComponent Mesh;
    local editinline StaticMeshComponent StaticMesh;
    local Vector startTargetLocation, boneTargetLocation;

    // End:0x175
    if(homingTarget != none)
    {
        aPawn = SPPawn(homingTarget);
        // End:0x53
        if((aPawn != none) && SPGriffonPawnPersistent(aPawn) == none)
        {
            return aPawn.GetTargetLocation();            
        }
        else
        {
            startTargetLocation = homingTarget.Location;
            Mesh = homingTarget.GetSkeletalMeshComponent();
            StaticMesh = homingTarget.GetStaticMeshComponent();
            // End:0x16F
            if((StaticMesh != none) || Mesh != none)
            {
                homingTarget.GetComponentsBoundingBox(boundBox);
                startTargetLocation = (boundBox.Min + boundBox.Max) * 0.5000000;
                // End:0x16F
                if(Mesh != none)
                {
                    boneTargetLocation = Mesh.GetClosestCollidingBoneLocation(startTargetLocation, true, true);
                    // End:0x16F
                    if(((boneTargetLocation.X != float(0)) || boneTargetLocation.Y != float(0)) || boneTargetLocation.Z != float(0))
                    {
                        startTargetLocation = boneTargetLocation;
                    }
                }
            }
            return startTargetLocation;
        }
    }
    //return ReturnValue;    
}

function SetHomingTarget(Actor homingTarget, bool bUsingGenerator)
{
    // End:0x40
    if(homingTarget == none)
    {
        // End:0x2A
        if(bUsingGenerator)
        {
            m_targetting.Mode = 0;            
        }
        else
        {
            m_targetting.Mode = 1;
        }        
    }
    else
    {
        m_targetting.targetActor = homingTarget;
        m_targetting.Mode = 2;
        m_targetting.TargetPoint = TargetLocation(m_targetting.targetActor);
    }
    //return;    
}

function UpdateHoming()
{
    // End:0x41
    if(m_targetting.targetActor != none)
    {
        m_targetting.TargetPoint = TargetLocation(m_targetting.targetActor);
    }
    //return;    
}

simulated event Vector CalculateTarget()
{
    switch(m_targetting.Mode)
    {
        // End:0x30
        case 0:
            return Location + (Vector(Rotation) * float(10000));
        // End:0x40
        case 1:
            return CalculateUnguidedMoveToLocation();
        // End:0x60
        case 2:
            UpdateHoming();
            return m_targetting.TargetPoint;
        // End:0xFFFF
        default:
            //return ReturnValue;
            break;
    }    
}

function Vector CalculateUnguidedMoveToLocation()
{
    local Vector HitLocation, HitNormal, DirToEnd, OldEndTrace, DirectionNormal, ToEnd,
	    ToHit;

    local float DistToEnd, DistToHit;
    local Actor HitActor;

    // End:0x85
    if(m_bJustFired == true)
    {
        m_VStartTrace = Instigator.GetWeaponStartTraceLocation();
        m_VEndTrace = m_VStartTrace + (Vector(Instigator.GetAdjustedAimFor(RocketLauncher, m_VStartTrace)) * WeaponRange);
        m_VDirection = m_VStartTrace - m_VEndTrace;
        m_VDirection = Normal(m_VDirection);
        m_bJustFired = false;        
    }
    else
    {
        OldEndTrace = m_VEndTrace;
        m_VStartTrace = Instigator.GetWeaponStartTraceLocation();
        m_VEndTrace = m_VStartTrace + (Vector(Instigator.GetAdjustedAimFor(RocketLauncher, m_VStartTrace)) * WeaponRange);
        DirectionNormal = m_VStartTrace - m_VEndTrace;
        DirectionNormal = Normal(DirectionNormal);
        // End:0x11F
        if((DirectionNormal Dot m_VDirection) < 0.6000000)
        {
            m_VEndTrace = OldEndTrace;
        }
    }
    HitActor = Trace(HitLocation, HitNormal, m_VEndTrace, m_VStartTrace, true,,, 8);
    // End:0x17E
    if(HitActor != none)
    {
        DirToEnd = m_VEndTrace - HitLocation;
        DirToEnd = Normal(DirToEnd);
        m_VStartTrace = HitLocation + DirToEnd;
    }
    // End:0x197
    if(HitActor == none)
    {
        HitLocation = m_VEndTrace;        
    }
    else
    {
        ToEnd = Instigator.Location - Location;
        ToHit = Instigator.Location - HitLocation;
        DistToEnd = VSize(ToEnd);
        DistToHit = VSize(ToHit);
        // End:0x203
        if(DistToEnd > DistToHit)
        {
            HitLocation = m_VEndTrace;
        }
    }
    return HitLocation;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    Age += DeltaTime;
    // End:0x1E
    if(Age >= MaxAge)
    {
        Destroy();
    }
    //return;    
}

function SetRocketLauncher(SPRocketLauncherPersistent theRocketLauncher)
{
    RocketLauncher = theRocketLauncher;
    //return;    
}

singular simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local bool bStopsProjectile;

    bStopsProjectile = Other.bProjTarget || Other.bBlockActors;
    // End:0x82
    if((((Other == none) || Other.bDeleteMe) || Other.IsA('Trigger')) || Other.IsA('TriggerVolume'))
    {
        return;
    }
    // End:0xE4
    if((bStopsProjectile && (int(Role) == int(ROLE_Authority)) || bBegunPlay) && Other != Instigator)
    {
        ImpactedActor = Other;
        ProcessTouch(Other, HitLocation, HitNormal);
        ImpactedActor = none;
    }
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x23
    if(Other != Instigator)
    {
        Explode(HitLocation, HitNormal);
    }
    //return;    
}

reliable client simulated function ClientExplode()
{
    Explode(vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    Destroy();
    //return;    
}

simulated event ForceExplode()
{
    local Vector V;

    Explode(V, V);
    //return;    
}

simulated function BulletHitSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    local Actor physMatHitActor;
    local TraceHitInfo physMatHitInfo;
    local ImpactInfo Impact;
    local Vector Extent;

    // End:0x62
    if((HitActor != none) && HitInfo.Material != none)
    {
        SPPhysMat = SPPhysicalMaterial(HitInfo.Material.PhysMaterial);
        physMatHitInfo = HitInfo;
        physMatHitActor = HitActor;        
    }
    else
    {
        HitActor.TraceForImpactInfo(Location - (HitNormal * float(100)), Location, Extent, Impact);
        physMatHitActor = HitActor;
        physMatHitInfo = Impact.HitInfo;
        // End:0x100
        if((physMatHitActor != none) && physMatHitInfo.Material != none)
        {
            SPPhysMat = SPPhysicalMaterial(physMatHitInfo.Material.PhysMaterial);
        }
    }
    Impact.HitActor = physMatHitActor;
    Impact.HitInfo = physMatHitInfo;
    Impact.HitLocation = HitLocation;
    Impact.HitNormal = HitNormal;
    Impact.RayDir = Normal(HitLocation - Location);
    Impact.HitActor.TakeDamageAndProcEffects(1.0000000, InstigatorController, HitLocation, vect(0.0000000, 0.0000000, 1.0000000), MyDamageType, HitInfo, Instigator);
    Class'SPWeapon'.static.HandleImpactSound(SPPhysMat, Class'SPDamageTypeImpactRocketLauncher', self, Impact.HitLocation);
    Class'SPWeapon'.static.HandleImpactDecal(SPPhysMat, Class'SPDamageTypeImpactFlame', Impact, DefaultImpactDecal);
    Class'SPWeapon'.static.HandleImpactLight(SPPhysMat, Class'SPDamageTypeImpactRocketLauncher', Impact);
    Class'SPWeapon'.static.HandleImpactParticles(SPPhysMat, Class'SPDamageTypeImpactRocketLauncher', Impact, DefaultImpactParticles);
    Destroy();
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
    impulseActor.PlayerOnlyRadius = PlayerRadius;
    impulseActor.PlayerOnlyDamage = PlayerDamage;
    //return;    
}

simulated function Destroyed()
{
    local Emitter E;

    ServerOnlyDestroyed();
    ExhaustParticle.ParticleSystemComponent.DeactivateSystem();
    CreateDamageImpulse(m_splashDamage, m_splashDamageRadius, MyDamageType, MyPlayerRadius, MyPlayerDamage);
    E = Spawn(Class'Engine.EmitterSpawnable',,, Location, Rotator(vect(0.0000000, 0.0000000, 0.0000000)));
    // End:0xE3
    if(E != none)
    {
        E.SetTemplate(ExplodeParticleTemplate, true);
        E.bDestroyOnSystemFinish = true;
        E.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
        E.ParticleSystemComponent.ActivateSystem();
    }
    // End:0xFE
    if(RocketExplosionSound != none)
    {
        PlaySound(RocketExplosionSound, true);
    }
    super(Actor).Destroyed();
    //return;    
}

function ServerOnlyDestroyed()
{
    RocketLauncher.RocketExploded();
    //return;    
}
