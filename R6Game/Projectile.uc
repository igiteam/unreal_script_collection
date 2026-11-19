class Projectile extends Actor
    abstract
    native
    config(ProjectilesConfig)
    notplaceable
    hidecategories(lighting);

var config float Speed;
var float MaxSpeed;
var float TossZ;
var bool bSwitchToZeroCollision;
var bool bBegunPlay;
var Actor ZeroCollider;
var float Damage;
var float DamageRadius;
var float MomentumTransfer;
var class<DamageType> MyDamageType;
var float ExploWallOut;
var Controller InstigatorController;
var Actor ImpactedActor;
var float NetCullDistanceSquared;
var export editinline CylinderComponent CylinderComponent;

function bool EncroachingOn(Actor other)
{
    // End:0x12
    if(Brush(other) != none)
    {
        return true;
    }
    return false;
    return;
}

simulated function PostBeginPlay()
{
    // End:0x9D
    if(((int(Role) == int(ROLE_Authority)) && Instigator != none) && Instigator.Controller != none)
    {
        InstigatorController = Instigator.Controller;
        // End:0x9D
        if((InstigatorController.ShotTarget != none) && InstigatorController.ShotTarget.Controller != none)
        {
            InstigatorController.ShotTarget.Controller.ReceiveProjectileWarning(self);
        }
    }
    bBegunPlay = true;
    return;
}

// Export UProjectile::execInit(FFrame&, void* const)
native function Init(Rotator rDirection);

// Export UProjectile::execExplode(FFrame&, void* const)
native function Explode(Vector vHitLocation, Vector vHitNormal);

simulated function bool CanSplash()
{
    return bBegunPlay;
    return;
}

simulated function bool HurtRadius(float fDistMaxDam, float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController)
{
    local bool bCausedDamage, bResult;

    ((Instigator != none) ? Instigator.Controller : none);
    // End:0x2C
    if(bHurtEntry)
    {
        return false;
    }
    bCausedDamage = false;
    // End:0x4A
    if(InstigatedByController == none)
    {
        InstigatedByController = InstigatorController;
    }
    // End:0xC7
    if(((ImpactedActor != none) && ImpactedActor != self) && int(ImpactedActor.Role) == int(ROLE_Authority))
    {
        ImpactedActor.TakeRadiusDamage(InstigatedByController, fDistMaxDam, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, true);
        bCausedDamage = ImpactedActor.bProjTarget;
    }
    bResult = HurtRadius(fDistMaxDam, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController);
    // End:0x120
    if(bResult || bCausedDamage)
    {
        UpdateHitStats(bCausedDamage);
        return true;
    }
    return false;
    return;
}

function UpdateHitStats(bool bDirectHit)
{
    return;
}

simulated event EncroachedBy(Actor other)
{
    HitWall(Normal(Location - other.Location), other, Location);
    return;
}

simulated function BlowUp(Vector HitLocation, Vector HitNormal)
{
    HurtRadius(0.0000000, Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    // End:0x42
    if(int(Role) == int(ROLE_Authority))
    {
        MakeNoise(1.0000000);
    }
    return;
}

final simulated function RandSpin(float spinRate)
{
    DesiredRotation = RotRand();
    RotationRate.Yaw = int(((spinRate * float(2)) * FRand()) - spinRate);
    RotationRate.Pitch = int(((spinRate * float(2)) * FRand()) - spinRate);
    RotationRate.Roll = int(((spinRate * float(2)) * FRand()) - spinRate);
    return;
}

function bool IsStationary()
{
    return false;
    return;
}

defaultproperties
{
    MaxSpeed=2000.0000000
    TossZ=100.0000000
    DamageRadius=220.0000000
    MyDamageType=Class'DamageType'
    NetCullDistanceSquared=400000000.0000000
    // Reference: CylinderComponent'Default__Projectile.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'CylinderComponent'
        CollisionHeight=0.0000000
        CollisionRadius=0.0000000
    end object
    CylinderComponent=CollisionCylinder
    bReplicateInstigator=true
    UseCharacterLights=true
    UsePawnLights=true
    bGameRelevant=true
    bCanBeDamaged=true
    bCollideActors=true
    bCollideWorld=true
    // Reference: SpriteComponent'Default__Projectile.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Physics=6
    RemoteRole=1
    NetPriority=2.5000000
    LifeSpan=14.0000000
    CollisionComponent=CollisionCylinder
}