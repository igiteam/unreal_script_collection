class EvilProjectile_Pinnable_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var() export editinline StaticMeshComponent Mesh;
var array<name> AcceptedBoneNames;
var transient bool bIsManuallyAttached;
var Actor PinnedToActor;

simulated function RepInit()
{
    super.RepInit();
    DamageVSPlayer = int(Damage);
    //return;    
}

simulated function bool CanAttachToActorClass(class<Actor> TestClass)
{
    // End:0x1D
    if(ClassIsChildOf(TestClass, Class'EvilDestructibleObject'))
    {
        return false;        
    }
    else
    {
        // End:0x3A
        if(ClassIsChildOf(TestClass, Class'EvilDynamicDestructibleObject'))
        {
            return false;            
        }
        else
        {
            // End:0x57
            if(ClassIsChildOf(TestClass, Class'EvilGlassActor'))
            {
                return false;                
            }
            else
            {
                // End:0x71
                if(ClassIsChildOf(TestClass, Class'Engine.FracturedStaticMeshActor'))
                {
                    return false;
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local editinline StaticMeshComponent SMC;
    local name BoneName;
    local EvilPawn P;
    local Rotator boneSpaceRot;
    local Vector boneSpacePos, dirFromHitLocToBonePos, besthitloc;
    local float relScale;
    local Vector relScaleVector;
    local TraceHitInfo THitInfo;

    P = EvilPawn(Other);
    // End:0x101
    if(((((P != none) && WorldInfo.GRI.IsCoopMultiplayerGame()) && NotEqual_InterfaceInterface(EvilPlayer_interface(P), EvilPlayer_interface(none))) || !CanAttachToActorClass(Other.Class)) || (P != none) && !P.bCanPinToThisActor)
    {
        bIsManuallyAttached = true;
    }
    // End:0x3F5
    if(((P != none) && !bIsManuallyAttached) && P.bBlockActors || P.CanBePinned())
    {
        Class'EvilWeap_Base'.static.FindNearestBone(P, HitLocation, BoneName, besthitloc, AcceptedBoneNames);
        dirFromHitLocToBonePos = besthitloc - HitLocation;
        dirFromHitLocToBonePos *= 0.6000000;
        HitLocation += dirFromHitLocToBonePos;
        P.Mesh.TransformToBoneSpace(BoneName, HitLocation, Rotation, boneSpacePos, boneSpaceRot);
        SMC = new (Other) Mesh.Class (Mesh);
        SMC.SetLightEnvironment(P.LightEnvironment);
        relScale = 1.0000000 / P.Mesh.Scale;
        relScaleVector.X = relScale;
        relScaleVector.Y = relScale;
        relScaleVector.Z = relScale;
        P.Mesh.AttachComponent(SMC, BoneName, boneSpacePos, boneSpaceRot, relScaleVector);
        bIsManuallyAttached = true;
    }
    // End:0x66A
    if((Damage > float(0)) && ((P == none) || P.bBlockActors) || P.CanBePinned())
    {
        Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
        // End:0x51C
        if(EvilWeap_Base(Instigator.Weapon) != none)
        {
            EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Other);
        }
        // End:0x5AB
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
        {
            Other.TakeDamage(DamageVSPlayer, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);            
        }
        else
        {
            Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
            // End:0x66A
            if((P != none) && P.Health <= 0)
            {
                ProcessPostDeathTouch(P, BoneName, HitLocation);
            }
        }
    }
    super.ProcessTouch(Other, HitLocation, HitNormal);
    // End:0x70A
    if(!bIsManuallyAttached && ((P == none) || P.bBlockActors) || P.CanBePinned())
    {
        PinnedToActor = Other;
    }
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    // End:0x39
    if(!CanAttachToActorClass(Wall.Class))
    {
        bIsManuallyAttached = true;
    }
    // End:0x1C7
    if(!Wall.bStatic && Damage > float(0))
    {
        // End:0xE3
        if(EvilWeap_Base(Instigator.Weapon) != none)
        {
            EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Wall);
        }
        // End:0x16A
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Wall), EvilPlayer_interface(none)))
        {
            Wall.TakeDamage(DamageVSPlayer, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);            
        }
        else
        {
            Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
        }
    }
    super.HitWall(HitNormal, Wall, WallComp);
    // End:0x20E
    if(!bIsManuallyAttached)
    {
        PinnedToActor = Wall;
    }
    //return;    
}

simulated function ProcessPostDeathTouch(EvilPawn P, name BoneName, Vector HitLocation)
{
    //return;    
}

simulated function ShutDown()
{
    local Vector HitLocation, HitNormal;

    // End:0x19
    if(bIsManuallyAttached)
    {
        super.ShutDown();
        return;
    }
    bShuttingDown = true;
    HitNormal = Normal(Velocity * float(-1));
    Trace(HitLocation, HitNormal, Location + (HitNormal * float(-32)), Location + (HitNormal * float(32)), true, vect(0.0000000, 0.0000000, 0.0000000));
    SetPhysics(0);
    // End:0xD2
    if(ProjEffects != none)
    {
        ProjEffects.DeactivateSystem();
    }
    // End:0x10A
    if(AmbientComponent != none)
    {
        AmbientComponent.FadeOut(0.1000000, 0.0000000);
    }
    // End:0x160
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX)
    {
        SpawnExplosionEffects(Location, HitNormal);
    }
    SetCollision(false, false);
    // End:0x196
    if(!IsTimerActive('FinalClean'))
    {
        SetTimer(DurationOfDecal, false, 'FinalClean');
    }
    //return;    
}

simulated function FinalClean()
{
    HideProjectile();
    // End:0xE0
    if(bWaitForEffects)
    {
        // End:0x7C
        if(bNetTemporary)
        {
            // End:0x53
            if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                Destroy();                
            }
            else
            {
                RemoteRole = ROLE_None;
                LifeSpan = FMax(LifeSpan, 2.0000000);
            }            
        }
        else
        {
            bTearOff = true;
            // End:0xC3
            if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                LifeSpan = 0.1500000;                
            }
            else
            {
                LifeSpan = FMax(LifeSpan, 2.0000000);
            }
        }        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function HideProjectile()
{
    // End:0x17
    if(bIsManuallyAttached)
    {
        super.HideProjectile();
    }
    //return;    
}

simulated event NotifyMoverInterpolationStarted(InterpActor Mover)
{
    // End:0x28
    if(PinnedToActor == Mover)
    {
        bRotationFollowsVelocity = false;
        SetPhysics(2);
    }
    //return;    
}

defaultproperties
{
    // Reference: EvilDissolvingStaticMeshComponent'Default__EvilProjectile_Pinnable_Base.StaticMesh'
    begin object name=StaticMesh class=Class'EvilDissolvingStaticMeshComponent'
        ReplacementPrimitive=none
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    Mesh=StaticMesh
    Speed=2500.0000000
    MaxSpeed=2500.0000000
    bRotationFollowsVelocity=true
    MyDamageType=Class'EvilDmgType_Base'
    // Reference: CylinderComponent'Default__EvilProjectile_Pinnable_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    LifeSpan=10.0000000
    CollisionComponent=CollisionCylinder
}