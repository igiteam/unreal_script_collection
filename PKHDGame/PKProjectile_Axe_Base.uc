class PKProjectile_Axe_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var() export editinline StaticMeshComponent Mesh;
var export editinline DynamicLightEnvironmentComponent LightEnvironment;

simulated function SpawnAxeKActor()
{
    local Vector SpawnLocation;
    local Rotator SpawnRotation;
    local KActorSpawnable NewKActor;

    SpawnLocation = Mesh.GetPosition();
    SpawnRotation = Mesh.GetRotation();
    NewKActor = Spawn(Class'Engine.KActorSpawnable',,, SpawnLocation, SpawnRotation);
    NewKActor.SetStaticMesh(Mesh.StaticMesh);
    NewKActor.StaticMeshComponent.SetActorCollision(false, false);
    NewKActor.StaticMeshComponent.SetTraceBlocking(false, false);
    NewKActor.StaticMeshComponent.WakeRigidBody();
    NewKActor.StaticMeshComponent.SetRBAngularVelocity(VRand());
    NewKActor.RemoteRole = ROLE_None;
    NewKActor.LifeSpan = 5.0000000;
    NewKActor.bDamageAppliesImpulse = false;
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    SpawnAxeKActor();
    SetPhysics(0);
    SetCollision(false, false);
    // End:0x43
    if(AmbientComponent != none)
    {
        AmbientComponent.Stop();
    }
    super.ProcessTouch(Other, HitLocation, HitNormal);
    //return;    
}

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    SpawnAxeKActor();
    SetPhysics(0);
    SetCollision(false, false);
    // End:0x4D
    if((ExplosionSound != none) && !bSuppressSounds)
    {
        PlaySound(ExplosionSound, true);
    }
    // End:0x7B
    if(AmbientComponent != none)
    {
        AmbientComponent.Stop();
    }
    super(Actor).HitWall(HitNormal, Wall, WallComp);
    ShutDown();
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKProjectile_Axe_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    begin object name="StaticMesh" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKProjectile_Axe_Base.MyLightEnvironment'
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    Mesh=StaticMesh
    // Reference: DynamicLightEnvironmentComponent'Default__PKProjectile_Axe_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    begin object name="MyLightEnvironment" class=Class'Engine.DynamicLightEnvironmentComponent'
        bUseBooleanEnvironmentShadowing=false
        bSynthesizeSHLight=true
        bIsCharacterLightEnvironment=true
    end object
    LightEnvironment=MyLightEnvironment
    bImportantAmbientSound=true
    bWaitForEffects=true
    CustomGravityScaling=0.0000000
    Speed=700.0000000
    MaxSpeed=700.0000000
    Damage=30.0000000
    DamageRadius=0.0000000
    MyDamageType=Class'PKDmgType_Axe'
    // Reference: CylinderComponent'Default__PKProjectile_Axe_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=StaticMesh
    Physics=EPhysics.PHYS_Falling
    bNetTemporary=false
    LifeSpan=10.0000000
    CollisionComponent=StaticMesh
    RotationRate=(Pitch=-250000,Yaw=0,Roll=0)
}