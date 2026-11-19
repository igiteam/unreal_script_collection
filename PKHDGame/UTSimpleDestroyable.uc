class UTSimpleDestroyable extends DynamicSMActor
    abstract
    hidecategories(Navigation,Collision);

var() bool bDestroyOnDamage;
var() bool bDestroyOnPlayerTouch;
var() bool bDestroyOnVehicleTouch;
var bool bDestroyed;
var() StaticMesh MeshOnDestroy;
var() SoundCue SoundOnDestroy;
var() ParticleSystem ParticlesOnDestroy;
var() StaticMesh SpawnPhysMesh;
var() float SpawnPhysMeshLifeSpan;
var() Vector SpawnPhysMeshLinearVel;
var() Vector SpawnPhysMeshAngularVel;
var() float RespawnTime;
var StaticMesh RespawnStaticMesh;
var float TimeToRespawn;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    RespawnStaticMesh = StaticMeshComponent.StaticMesh;
    // End:0x87
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        SetCollision(false, false);
        DetachComponent(StaticMeshComponent);
        BeginState('IgnoreItAll');
    }
    //return;    
}

simulated function GoBoom()
{
    local UTSD_SpawnedKActor PhysMesh;

    // End:0x3B
    if(MeshOnDestroy != none)
    {
        StaticMeshComponent.SetStaticMesh(MeshOnDestroy);        
    }
    else
    {
        StaticMeshComponent.SetStaticMesh(none);
        DetachComponent(StaticMeshComponent);
    }
    // End:0xD1
    if(ParticlesOnDestroy != none)
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(ParticlesOnDestroy, Location, Rotation);
    }
    // End:0xF8
    if(SoundOnDestroy != none)
    {
        PlaySound(SoundOnDestroy, true);
    }
    // End:0x2D9
    if(SpawnPhysMesh != none)
    {
        PhysMesh = Spawn(Class'UTSD_SpawnedKActor',,, Location, Rotation);
        PhysMesh.StaticMeshComponent.SetStaticMesh(SpawnPhysMesh);
        PhysMesh.StaticMeshComponent.SetRBLinearVelocity(SpawnPhysMeshLinearVel, false);
        PhysMesh.StaticMeshComponent.SetRBAngularVelocity(SpawnPhysMeshAngularVel, false);
        PhysMesh.StaticMeshComponent.WakeRigidBody();
        PhysMesh.SetCollision(false, false);
        PhysMesh.StaticMeshComponent.SetRBChannel(1);
        PhysMesh.StaticMeshComponent.SetRBCollidesWithChannel(0, true);
        PhysMesh.LifeSpan = SpawnPhysMeshLifeSpan;
    }
    bDestroyed = true;
    TimeToRespawn = RespawnTime;
    SetTimer(1.0000000, true, 'CheckRespawn');
    //return;    
}

simulated function RespawnDestructible()
{
    StaticMeshComponent.SetStaticMesh(RespawnStaticMesh);
    // End:0x60
    if(!StaticMeshComponent.bAttached)
    {
        AttachComponent(StaticMeshComponent);
    }
    bDestroyed = false;
    //return;    
}

simulated function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x2A
    if(!bDestroyed && bDestroyOnDamage)
    {
        GoBoom();
    }
    //return;    
}

simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x0F
    if(bDestroyed)
    {
        return;
    }
    // End:0x41
    if(Vehicle(Other) != none)
    {
        // End:0x3E
        if(bDestroyOnVehicleTouch)
        {
            GoBoom();
        }        
    }
    else
    {
        // End:0x58
        if(bDestroyOnPlayerTouch)
        {
            GoBoom();
        }
    }
    //return;    
}

simulated event CheckRespawn()
{
    // End:0x98
    if(bDestroyed)
    {
        TimeToRespawn -= 1.0000000;
        // End:0x98
        if((TimeToRespawn < 0.0000000) && StaticMeshComponent.LastRenderTime < (WorldInfo.TimeSeconds - 1.0000000))
        {
            RespawnDestructible();
            ClearTimer('CheckRespawn');
        }
    }
    //return;    
}

state IgnoreItAll
{
    ignores Touch, TakeDamage, Tick;
    stop;    
}

defaultproperties
{
    bDestroyOnDamage=true
    bDestroyOnPlayerTouch=true
    bDestroyOnVehicleTouch=true
    SpawnPhysMeshLifeSpan=5.0000000
    RespawnTime=30.0000000
    // Reference: StaticMeshComponent'Default__UTSimpleDestroyable.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Engine.Default__DynamicSMActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__UTSimpleDestroyable.MyLightEnvironment'
        CastShadow=false
        BlockActors=false
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__UTSimpleDestroyable.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor.MyLightEnvironment'
    begin object name="MyLightEnvironment"
        bDynamic=false
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    bNoDelete=true
    bCollideActors=true
    bProjTarget=true
    bPathColliding=false
    CollisionComponent=StaticMeshComponent0
}