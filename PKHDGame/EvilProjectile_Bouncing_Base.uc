class EvilProjectile_Bouncing_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var() export editinline StaticMeshComponent Mesh;
var() float VelocityDampingFactor;
var() float Bounciness;
var() float StopSimulatingVelocityThreshhold;
var() Rotator InitialRotationRate;
var transient Rotator DesiredRotator;
var() bool bCanBeDetonatedByDamage;
var Actor LastHitActor;

function Init(Vector Direction)
{
    super.Init(Direction);
    RotationRate = InitialRotationRate;
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
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
    ImpactedActor = Wall;
    // End:0x2C1
    if(((Wall != none) && ShouldBounce(Wall, HitNormal)) && int(Physics) == int(2))
    {
        Velocity -= (((1.0000000 + Bounciness) * HitNormal) * (Velocity Dot HitNormal));
        Velocity *= VelocityDampingFactor;
        RotationRate *= VelocityDampingFactor;
        // End:0x1D0
        if(ImpactSound != none)
        {
            PlaySound(ImpactSound);
        }
        // End:0x2BE
        if(VSize(Velocity) < StopSimulatingVelocityThreshhold)
        {
            bBounce = false;
            RotationRate = MakeRotator(0, 0, 0);
            DesiredRotator = MakeRotator(int(float((((Rotation.Pitch < 0) || (float(Rotation.Pitch) * 0.0054932) > float(180)) ? -90 : 90)) * 182.0444000), Rotation.Yaw, Rotation.Roll);
        }        
    }
    else
    {
        // End:0x304
        if(bBounce && EvilPawn(Wall) == none)
        {
            Explode(Location, HitNormal);
        }
    }
    ImpactedActor = none;
    LastHitActor = Wall;
    //return;    
}

simulated function bool ShouldBounce(Actor Touched, Vector HitNormal, optional PrimitiveComponent HitComponent)
{
    return bBounce;
    //return ReturnValue;    
}

simulated function EnteredWaterVolume()
{
    // End:0x53
    if(!bInWater)
    {
        super.EnteredWaterVolume();
        bBounce = false;
        Velocity = vect(0.0000000, 0.0000000, -500.0000000);
        Acceleration = vect(0.0000000, 0.0000000, -500.0000000);
    }
    //return;    
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

simulated event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super(Actor).TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x93
    if(!bExploded && bCanBeDetonatedByDamage)
    {
        bCanBeDetonatedByDamage = false;
        Explode(HitLocation, Normal(Momentum));
    }
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__EvilProjectile_Bouncing_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    begin object name="StaticMesh" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        AlwaysCheckCollision=true
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.6000000
    Bounciness=0.6000000
    StopSimulatingVelocityThreshhold=300.0000000
    bWaitForEffects=true
    Speed=800.0000000
    MaxSpeed=800.0000000
    // Reference: CylinderComponent'Default__EvilProjectile_Bouncing_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
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