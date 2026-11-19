class PKProjectile_PainkillerBlades_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var() export editinline SkeletalMeshComponent Mesh;
var PKWeap_Painkiller_Base PainkillerWeap;
var repnotify bool bIsReturning;
var transient bool bReturnSoundPlayed;
var float MaxDistanceFromInstigator;
var SoundCue ReturnSound;
var SoundCue ReturnSound1p;
var Actor PinnedToActor;
var float PainHeadBackImpulse;
var float PainHeadMonstersBackVelocity;
var int ThrowItemFromBodyHitCount;
var int ThrowItemFromBodyMaxCount;
var Vector StartPosition;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        bIsReturning;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    StartPosition = Location;
    //return;    
}

simulated function ReturnToInstigator()
{
    bIsReturning = true;
    SetPhysics(default.Physics);
    SetCollision(false, false);
    bCollideWorld = false;
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    bSuppressExplosionFX = true;
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local TraceHitInfo THitInfo;
    local float DragForce;
    local PKPawn P;
    local Vector NVel, DestVelocity;
    local bool bIsNonGoreVersion;

    // End:0x31A
    if(!bIsReturning)
    {
        bIsNonGoreVersion = Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo);
        super.ProcessTouch(Other, HitLocation, HitNormal);
        P = PKPawn(Other);
        // End:0x31A
        if(P != none)
        {
            NVel = Normal(Velocity);
            Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
            DragForce = (VSize(StartPosition - Location) * 0.3500000) * PainHeadMonstersBackVelocity;
            DestVelocity = (NVel * DragForce) / float(10);
            DestVelocity.Z = ((NVel.Z * DragForce) / float(10)) + float(480);
            // End:0x254
            if((++P.HitByPainCount >= ThrowItemFromBodyHitCount) || bIsNonGoreVersion && FRand() < 0.2200000)
            {
                P.HitByPainCount = 0;
                // End:0x254
                if(++P.TreasureGained <= ThrowItemFromBodyMaxCount)
                {
                    P.SpawnBonusTreasure(1, true);
                }
            }
            Class'EvilGame.EvilPawn'.static.SetRBLinearVelocityToLinkedBodies(P.Mesh, DestVelocity, false, THitInfo.BoneName);
            Class'EvilGame.EvilPawn'.static.SetRBLinearVelocity2(P.Mesh, DestVelocity, false, THitInfo.BoneName);
        }
    }
    // End:0x363
    if(((EvilPawn(Other) != none) && !bIsReturning) && int(Role) == int(ROLE_Authority))
    {
        ReturnToInstigator();
    }
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    super.HitWall(HitNormal, Wall, WallComp);
    // End:0x7F
    if(Wall.bStatic || InterpActor(Wall) != none)
    {
        SetPhysics(0);
        SetCollision(false, false);
        PinnedToActor = Wall;
    }
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local Controller C;

    // End:0x1D
    if(int(Role) == int(ROLE_Authority))
    {
        MakeNoise(1.0000000);
    }
    // End:0xD7
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x95
        if(EvilPlayerController(C) != none)
        {
            EvilPlayerController(C).NotifyProjectileExplode(self);
            // End:0xD6
            continue;
        }
        // End:0xD6
        if(EvilAIController(C) != none)
        {
            EvilAIController(C).NotifyProjectileExplode(self);
        }        
    }    
    SpawnExplosionEffects(HitLocation, HitNormal);
    bExploded = true;
    //return;    
}

simulated function CheckForMaxDistance()
{
    // End:0x43
    if(VSize(Instigator.Location - Location) > MaxDistanceFromInstigator)
    {
        ShutDown();
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Vector Dist, DistNormal;

    super.Tick(DeltaTime);
    // End:0x156
    if(bIsReturning && !bShuttingDown)
    {
        Dist = Instigator.Location - Location;
        DistNormal = Normal(Dist);
        // End:0xFE
        if(!bReturnSoundPlayed && VSize(Dist) < float(700))
        {
            bReturnSoundPlayed = true;
            // End:0xFE
            if((ReturnSound != none) && PainkillerWeap != none)
            {
                PainkillerWeap.WeaponPlaySound(ReturnSound, ReturnSound1p);
            }
        }
        // End:0x149
        if(VSize(Dist) > float(100))
        {
            SetRotation(Rotator(-DistNormal));
            Velocity = DistNormal * (MaxSpeed * float(2));            
        }
        else
        {
            ShutDown();
        }        
    }
    else
    {
        CheckForMaxDistance();
    }
    //return;    
}

simulated function ShutDown()
{
    super.ShutDown();
    // End:0x38
    if(PainkillerWeap != none)
    {
        PainkillerWeap.NotifyBladeReturn();
    }
    //return;    
}

simulated event Destroyed()
{
    super.Destroyed();
    // End:0x38
    if(PainkillerWeap != none)
    {
        PainkillerWeap.NotifyBladeDestroyed();
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bIsReturning')
    {
        ReturnToInstigator();        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated event NotifyMoverInterpolationStarted(InterpActor Mover)
{
    // End:0x21
    if(PinnedToActor == Mover)
    {
        ReturnToInstigator();
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKProjectile_PainkillerBlades_Base.SkeletalMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMesh'
    begin object name="SkeletalMesh" class=Class'Engine.SkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMesh
    MaxDistanceFromInstigator=5000.0000000
    PainHeadBackImpulse=-10.0000000
    PainHeadMonstersBackVelocity=-10.0000000
    ThrowItemFromBodyHitCount=3
    ThrowItemFromBodyMaxCount=5
    Speed=1700.0000000
    MaxSpeed=1700.0000000
    MyDamageType=Class'PKDmgType_PainkillerBlades'
    // Reference: CylinderComponent'Default__PKProjectile_PainkillerBlades_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SkeletalMesh
    bNetTemporary=false
    LifeSpan=0.0000000
    CollisionComponent=CollisionCylinder
}