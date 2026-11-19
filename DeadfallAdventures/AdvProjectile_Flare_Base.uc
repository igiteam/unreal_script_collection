class AdvProjectile_Flare_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var Actor LastHit;
var() export editinline StaticMeshComponent Mesh;
var() float VelocityDampingFactor;
var() float Bounciness;
var() float StopSimulatingVelocityThreshhold;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x37
    if(EvilPawn(Other) == none)
    {
        Explode(HitLocation, HitNormal);        
    }
    else
    {
        // End:0x1EE
        if(LastHit != Other)
        {
            // End:0xA1
            if(float(EvilPawn(Other).Health) > Damage)
            {
                Explode(HitLocation, HitNormal);
            }
            HitNormal = HitLocation - Other.Location;
            HitNormal.Z = 0.0000000;
            HitNormal = Normal(HitNormal);
            Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * -HitNormal, MyDamageType,, self);
            EvilPawn(Other).Knockdown((MomentumTransfer / EvilPawn(Other).Mass) * -HitNormal, VRand() * float(2));
            LastHit = Other;
        }
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
    ImpactedActor = Wall;
    // End:0x191
    if(!Wall.bStatic && DamageRadius == float(0))
    {
        Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
    }
    // End:0x250
    if(((Wall != none) && ShouldBounce(Wall, HitNormal)) && int(Physics) == int(2))
    {
        Velocity -= (((1.0000000 + Bounciness) * HitNormal) * (Velocity Dot HitNormal));
        Velocity *= VelocityDampingFactor;
        // End:0x24D
        if(VSize(Velocity) < StopSimulatingVelocityThreshhold)
        {
            bBounce = false;
        }        
    }
    else
    {
        // End:0x293
        if(bBounce && EvilPawn(Wall) == none)
        {
            Explode(Location, HitNormal);
        }
    }
    ImpactedActor = none;
    //return;    
}

simulated function bool ShouldBounce(Actor Touched, Vector HitNormal, optional PrimitiveComponent HitComponent)
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvProjectile_Flare_Base.StaticMesh'
    begin object name=StaticMesh class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bOnlyOwnerSee=true
        AlwaysCheckCollision=true
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.6000000
    Bounciness=0.5000000
    StopSimulatingVelocityThreshhold=300.0000000
    TimeToExplode=1.5000000
    TossZ=100.0000000
    Speed=2700.0000000
    MaxSpeed=4000.0000000
    DamageRadius=400.0000000
    MyDamageType=Class'AdvDmgType_FlareGun'
    // Reference: CylinderComponent'Default__AdvProjectile_Flare_Base.CollisionCylinder'
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