class SPBulletPersistent extends Projectile
    native
    nativereplication;

struct native SPBulletHitInfo
{
    var Vector HitNormal;
    var Actor HitActor;
    var Vector HitLocation;
    var TraceHitInfo HitInfo;
    var float Damage;
    var bool bHitWorld;
    var SPPhysicalMaterial SPPhysMat;
    var ImpactInfo Impact;
    var Vector ImpulseForce;
    var SPPawn SPInstigatorPawn;
    var bool bPlayImpactSound;
    var bool bDisplayImpactVisuals;

    structdefaultproperties
    {
        HitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitActor=none
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none)
        Damage=0.0000000
        bHitWorld=false
        SPPhysMat=none
        Impact=(HitActor=none,HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),HitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000),RayDir=(X=0.0000000,Y=0.0000000,Z=0.0000000),HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none))
        ImpulseForce=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SPInstigatorPawn=none
        bPlayImpactSound=false
        bDisplayImpactVisuals=false
    }
};

var transient bool HasUpdatedOnce;
var transient bool bNonSuppressing;
var transient bool bReflectBullet;
var bool bScaledUp;
var transient Vector lastFramePosition;
var float BulletForce;
var DamageMatrix.WeaponDamageTypes BulletWeaponDamageType;
var DamageImpactModifier DIM;
var Actor ExcludedFromCollisionActor;
var export editinline PrimitiveComponent Mesh;
var float MeshScaleTime;
var float ScaleTimeCount;
var float MaxScale;
var SPBulletHitInfo bulletHitInfo;
var SPBulletHitInfo bulletTouchInfo;
var ImpactParticlesInfo DefaultImpactParticles;
var ImpactParticlesInfo DefaultReflectedImpactParticles;
var ImpactDecalInfo DefaultImpactDecal;
var ImpactDecalInfo DefaultReflectedImpactDecal;
var transient TraceHitInfo lastTouchTrace;

// Export USPBulletPersistent::execCheckForEffectCreation(FFrame&, void* const)
native function CheckForEffectCreation();

// Export USPBulletPersistent::execSetupHandlingOfBulletHitSomething(FFrame&, void* const)
native simulated function SetupHandlingOfBulletHitSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo);

// Export USPBulletPersistent::execBulletHitEffects(FFrame&, void* const)
native simulated function BulletHitEffects(Actor HitActor, ImpactInfo Impact, SPPhysicalMaterial SPPhysMat);

// Export USPBulletPersistent::execHandleBulletHitSomething(FFrame&, void* const)
native simulated function HandleBulletHitSomething();

// Export USPBulletPersistent::execDoBulletHitSomething(FFrame&, void* const)
native simulated function DoBulletHitSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo);

// Export USPBulletPersistent::execScaleTracer(FFrame&, void* const)
native simulated function ScaleTracer(float Time);

simulated event PostBeginPlay()
{
    local SPWeapon myWeapon;
    local SPWeaponAttachment myWeaponAttachment;
    local float traceRange;

    super.PostBeginPlay();
    myWeapon = SPWeapon(Owner);
    // End:0xA3
    if(myWeapon != none)
    {
        // End:0x72
        if((Pawn(myWeapon.Owner) != none) && Pawn(myWeapon.Owner).IsA('SPBulletGeneratorPawnPersistent'))
        {
            LifeSpan = 5.0000000;            
        }
        else
        {
            // End:0xA0
            if(Speed != float(0))
            {
                LifeSpan = myWeapon.GetTraceRange() / Speed;
            }
        }        
    }
    else
    {
        myWeaponAttachment = SPWeaponAttachment(Owner);
        // End:0x13D
        if((myWeaponAttachment != none) && Speed != float(0))
        {
            // End:0x109
            if(int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                traceRange = myWeaponAttachment.WeaponClass.default.WeaponRange;                
            }
            else
            {
                traceRange = myWeaponAttachment.WeaponClass.default.WeaponRangeMP;
            }
            LifeSpan = traceRange / Speed;            
        }
        else
        {
            LifeSpan = 3.0000000;
        }
    }
    //return;    
}

simulated function ClientRenderTest()
{
    local SPPawn pawnInst;

    pawnInst = SPPawn(Instigator);
    // End:0x48
    if(pawnInst != none)
    {
        pawnInst.LastProjectileFireLocation = Location;
        pawnInst.LastProjectileFireRot = Rotation;        
    }
    //return;    
}

simulated event Init(Vector Direction)
{
    super.Init(Direction);
    // End:0x2C
    if(Instigator != none)
    {
        Velocity += Instigator.Velocity;
    }
    lastFramePosition = Location;
    //return;    
}

singular simulated function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    BulletHitSomething(HitNormal, Wall, Location);
    //return;    
}

simulated function ExplodeBullet()
{
    // End:0x4D
    if((bulletHitInfo.SPPhysMat == none) || !bReflectBullet)
    {
        Explode(bulletHitInfo.HitLocation, bulletHitInfo.HitNormal);
    }
    ImpactedActor = none;
    //return;    
}

simulated event BulletHitSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    local SPPawn theShooter, theTarget;

    theShooter = SPPawn(Instigator);
    theTarget = SPPawn(HitActor);
    // End:0x4E
    if((theShooter != none) && theTarget != none)
    {
        theShooter.HitTarget(theTarget);
    }
    DoBulletHitSomething(HitNormal, HitActor, HitLocation, HitInfo);
    ExplodeBullet();
    //return;    
}

simulated event BulletTouchedSomething(Vector HitNormal, Actor HitActor, Vector HitLocation, optional TraceHitInfo HitInfo)
{
    SetupHandlingOfBulletHitSomething(HitNormal, HitActor, HitLocation, HitInfo);
    bulletTouchInfo = bulletHitInfo;
    BulletHitEffects(bulletTouchInfo.HitActor, bulletTouchInfo.Impact, bulletTouchInfo.SPPhysMat);
    //return;    
}

final simulated event DamageMatrix GetDamageMatrix()
{
    return Class'DamageMatrix'.static.Get();
    //return ReturnValue;    
}

singular simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x22
    if((Other == none) || Other.bDeleteMe)
    {
        return;
    }
    // End:0xA1
    if((Other.StopsProjectile(self) && (int(Role) == int(ROLE_Authority)) || bBegunPlay) && bBlockedByInstigator || Other != Instigator)
    {
        ImpactedActor = Other;
        ProcessTouch(Other, HitLocation, HitNormal);
        ImpactedActor = none;        
    }
    else
    {
        // End:0xF3
        if((Other.CollisionComponent != none) && Other.CollisionComponent.SPBulletTouch)
        {
            BulletTouchedSomething(HitNormal, Other, HitLocation, lastTouchTrace);
        }
    }
    //return;    
}
