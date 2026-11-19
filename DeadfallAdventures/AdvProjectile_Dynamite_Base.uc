class AdvProjectile_Dynamite_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var Actor LastHit;
var() export editinline StaticMeshComponent Mesh;
var() float VelocityDampingFactor;
var() float Bounciness;
var() float StopSimulatingVelocityThreshhold;
var transient Rotator DesiredRotator;
var export editinline ParticleSystemComponent FuseFireParticleComponent;

function Init(Vector Direction)
{
    super.Init(Direction);
    RotationRate = MakeRotator(35000, 0, 10000);
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetCollisionType(2);
    //return;    
}

event TakeDamage(int DamageAmmount, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local EvilTypes.EImpactTypeBallistic ITBallisticID;
    local EvilTypes.EImpactTypeExplosion ITExplosionID;

    // End:0x15E
    if(!bPendingExplode && !bExploded)
    {
        bPendingExplode = true;
        ITBallisticID = class<EvilDmgType_Base>(DamageType).default.ImpactTypeBallisticID;
        ITExplosionID = class<EvilDmgType_Base>(DamageType).default.ImpactTypeExplosionID;
        // End:0x15E
        if((((((int(ITBallisticID) != int(0)) && int(ITBallisticID) != int(8)) && int(ITBallisticID) != int(9)) && int(ITBallisticID) != int(10)) && int(ITBallisticID) != int(11)) || ((int(ITExplosionID) == int(2)) || int(ITExplosionID) == int(5)) || int(ITExplosionID) == int(3))
        {
            Explode(HitLocation, vect(0.0000000, 0.0000000, 1.0000000));
        }
    }
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x103
    if(LastHit != Other)
    {
        // End:0xF0
        if((EvilPawn(Other) != none) && bBounce)
        {
            EvilPawn(Other).DirectHitByProjectile();
            // End:0xD4
            if(DamageRadius == float(0))
            {
                Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * -HitNormal, MyDamageType,, self);
            }
            Bounce(HitNormal, Other);
        }
        LastHit = Other;
    }
    //return;    
}

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local KActorFromStatic NewKActor;
    local editinline StaticMeshComponent HitStaticMesh;

    super(Actor).HitWall(HitNormal, Wall, WallComp);
    // End:0xEA
    if(Wall.bWorldGeometry)
    {
        HitStaticMesh = StaticMeshComponent(WallComp);
        // End:0xEA
        if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
        {
            NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
            // End:0xEA
            if(NewKActor != none)
            {
                Wall = NewKActor;
            }
        }
    }
    // End:0x209
    if((StaticMeshComponent(WallComp) != none) && !bInWater)
    {
        // End:0x209
        if(StaticMeshComponent(WallComp).GetMaterial(0).GetPhysicalMaterial() == PhysicalMaterial'pm_materials.PM_Water')
        {
            bBounce = false;
            bInWater = true;
            Velocity = vect(0.0000000, 0.0000000, -500.0000000);
            Acceleration = vect(0.0000000, 0.0000000, -500.0000000);
            WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ps_Water.Effects.ps_wp_GranadePlusk', Location);
            PlaySound(SoundCue'a_Grenade.a_GrenadeHitWater');
        }
    }
    ImpactedActor = Wall;
    // End:0x2B0
    if(!Wall.bStatic && DamageRadius == float(0))
    {
        Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
    }
    Bounce(HitNormal, Wall);
    ImpactedActor = none;
    //return;    
}

simulated function Bounce(Vector HitNormal, Actor Other)
{
    // End:0x1CF
    if(((Other != none) && ShouldBounce(Other, HitNormal)) && int(Physics) == int(2))
    {
        Velocity -= (((1.0000000 + Bounciness) * HitNormal) * (Velocity Dot HitNormal));
        Velocity *= VelocityDampingFactor;
        RotationRate *= VelocityDampingFactor;
        // End:0xD3
        if(ImpactSound != none)
        {
            PlaySound(ImpactSound);
        }
        // End:0x1CC
        if(VSize(Velocity) < StopSimulatingVelocityThreshhold)
        {
            bBounce = false;
            RotationRate = MakeRotator(0, 0, 0);
            DesiredRotator = MakeRotator(Rotation.Pitch, Rotation.Yaw, int(float(((((float(Rotation.Roll) * 0.0054932) < float(90)) || (float(Rotation.Roll) * 0.0054932) > float(-90)) ? 0 : 180)) * 182.0444000));
        }        
    }
    else
    {
        // End:0x212
        if(bBounce && EvilPawn(Other) == none)
        {
            Explode(Location, HitNormal);
        }
    }
    //return;    
}

simulated function bool ShouldBounce(Actor Touched, Vector HitNormal, optional PrimitiveComponent HitComponent)
{
    return true;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x75
    if((DesiredRotator != MakeRotator(0, 0, 0)) && DesiredRotator != Rotation)
    {
        SetRotation(RInterpTo(Rotation, DesiredRotator, DeltaTime, 10.0000000));
    }
    //return;    
}

simulated function ShutDown()
{
    FuseFireParticleComponent.DeactivateSystem();
    super.ShutDown();
    //return;    
}

simulated function EnteredWaterVolume()
{
    super.EnteredWaterVolume();
    ExplosionArchetype = none;
    // End:0x4D
    if(AmbientComponent != none)
    {
        AmbientComponent.FadeOut(0.1000000, 0.0000000);
    }
    // End:0x7B
    if(ProjEffects != none)
    {
        ProjEffects.DeactivateSystem();
    }
    FuseFireParticleComponent.DeactivateSystem();
    // End:0xC7
    if(ProjectileLight != none)
    {
        DetachComponent(ProjectileLight);
        ProjectileLight = none;
    }
    // End:0xF9
    if(ProjectileLightActor != none)
    {
        ProjectileLightActor.Destroy();
        ProjectileLightActor = none;
    }
    TimeToExplode = 10.0000000;
    ToExplodeTimer = 10.0000000;
    //return;    
}

simulated function HideProjectile()
{
    FuseFireParticleComponent.DeactivateSystem();
    super.HideProjectile();
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvProjectile_Dynamite_Base.StaticMesh'
    begin object name=StaticMesh class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        AlwaysCheckCollision=true
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.8000000
    Bounciness=0.2000000
    StopSimulatingVelocityThreshhold=300.0000000
    TimeToExplode=3.0000000
    AmbientSound=SoundCue'a_GameplaySounds.Dynamite.a_DynamiteFuseFireLoop'
    TossZ=200.0000000
    Speed=1200.0000000
    MaxSpeed=1200.0000000
    DamageRadius=0.0000000
    MyDamageType=Class'AdvDmgType_Dynamite'
    // Reference: CylinderComponent'Default__AdvProjectile_Dynamite_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    bBounce=true
    CollisionComponent=StaticMesh
}