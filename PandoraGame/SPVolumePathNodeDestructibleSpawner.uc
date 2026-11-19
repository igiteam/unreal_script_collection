class SPVolumePathNodeDestructibleSpawner extends VolumePathNode
    native;

struct native SpawnPropsType
{
    /** STRUCT DECLARATIONS */
    var() SPDestructibleProperties Destructible1;
    /** STRUCT DECLARATIONS */
    var() SPDestructibleProperties Destructible2;
    /** STRUCT DECLARATIONS */
    var() SPDestructibleProperties Destructible3;

    structdefaultproperties
    {
        Destructible1=none
        Destructible2=none
        Destructible3=none
    }
};

/** VARIABLE DECLARATIONS */
var() SpawnPropsType Destructibles;
var() int MaxSpawnCount;
var() bool bEnabled;
var transient int SpawnCount;
var SPVolumePathNodeDestructibleSpawner nextPt;

// Export USPVolumePathNodeDestructibleSpawner::execInitPhysics(FFrame&, void* const)
native function bool InitPhysics(SkeletalMeshComponent SmComponent, float Weight);

// Export USPVolumePathNodeDestructibleSpawner::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

function SPDestructibleProperties GetProp(int Index)
{
    // End:0x1C
    if(Index == 0)
    {
        return Destructibles.Destructible1;
    }
    // End:0x38
    if(Index == 1)
    {
        return Destructibles.Destructible2;
    }
    // End:0x55
    if(Index == 2)
    {
        return Destructibles.Destructible3;
    }
    return none;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    local PandoraGameInfo spGameInfo;
    local SPVolumePathNodeDestructibleSpawner Spawner;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x76
    if(spGameInfo.SPVolumePathNodeDestructibleSpawnerList == none)
    {
        // End:0x75
        foreach AllActors(Class'SPVolumePathNodeDestructibleSpawner', Spawner)
        {
            Spawner.nextPt = spGameInfo.SPVolumePathNodeDestructibleSpawnerList;
            spGameInfo.SPVolumePathNodeDestructibleSpawnerList = Spawner;            
        }        
    }
    //return;    
}

static function SPVolumePathNodeDestructibleSpawner GetFirst()
{
    local PandoraGameInfo spGameInfo;

    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    return spGameInfo.SPVolumePathNodeDestructibleSpawnerList;
    //return ReturnValue;    
}

function SetDestructComponent(Actor SrcActor, SPDestructibleProperties Destructproperties)
{
    local editinline SPActorDestructComponent spComponent;

    spComponent = SPActorDestructComponent(SrcActor.GetActorDestructComponent());
    // End:0xA7
    if(spComponent != none)
    {
        // End:0xA7
        if(Destructproperties != none)
        {
            spComponent.SetProperties(Destructproperties);
            spComponent.HitPoints = Destructproperties.HitPoints;
            spComponent.MinCollisionVelocity = Destructproperties.MinCollisionVelocity;
            spComponent.MaxCollisionVelocity = Destructproperties.MaxCollisionVelocity;
        }
    }
    //return;    
}

function Actor SpawnRigidBody(SPDestructibleProperties Props)
{
    local SPDRigidBody newActor;

    newActor = Spawn(Class'SPDRigidBody',,, Location, Rotation);
    // End:0x97
    if(newActor != none)
    {
        newActor.StaticMeshComponent.SetStaticMesh(Props.StaticMesh);
        newActor.SetPhysics(10);
        newActor.StaticMeshComponent.WakeRigidBody();
        SetDestructComponent(newActor, Props);
    }
    return newActor;
    //return ReturnValue;    
}

function Actor SpawnPHAT(SPDestructibleProperties Props)
{
    local SPDPhysSkel newActor;

    newActor = Spawn(Class'SPDPhysSkel',,, Location, Rotation);
    // End:0xEF
    if(newActor != none)
    {
        newActor.InitSkeletalMesh(newActor.SkeletalMeshComponent, Props.SkeletalMesh, Props.PhysicsAsset, vect(0.0000000, 0.0000000, 0.0000000), vect(1.0000000, 1.0000000, 1.0000000));
        newActor.SetPhysics(10);
        InitPhysics(newActor.SkeletalMeshComponent, Props.PhysicsWeight);
        newActor.SkeletalMeshComponent.WakeRigidBody();
        SetDestructComponent(newActor, Props);
    }
    return newActor;
    //return ReturnValue;    
}

function Actor SpawnSkeletal(SPDestructibleProperties Props)
{
    local SPDSkeletalMesh newActor;

    newActor = Spawn(Class'SPDSkeletalMesh',,, Location, Rotation);
    // End:0xB0
    if(newActor != none)
    {
        newActor.SkeletalMeshComponent.SetPhysicsWeight(Props.PhysicsWeight);
        newActor.SkeletalMeshComponent.SetPhysicsAsset(none);
        newActor.SkeletalMeshComponent.SetSkeletalMesh(Props.SkeletalMesh);
        SetDestructComponent(newActor, Props);
    }
    return newActor;
    //return ReturnValue;    
}

function Actor SpawnFromProps(SPDestructibleProperties Props)
{
    // End:0x0D
    if(Props == none)
    {
        return none;
    }
    // End:0x35
    if(Props.StaticMesh != none)
    {
        return SpawnRigidBody(Props);        
    }
    else
    {
        // End:0x74
        if((Props.SkeletalMesh != none) && Props.PhysicsAsset != none)
        {
            return SpawnPHAT(Props);            
        }
        else
        {
            // End:0x99
            if(Props.SkeletalMesh != none)
            {
                return SpawnSkeletal(Props);
            }
        }
    }
    return none;
    //return ReturnValue;    
}

function bool CanCreate()
{
    return bEnabled && SpawnCount < MaxSpawnCount;
    //return ReturnValue;    
}

function Actor CreateDestructible()
{
    local int propIndex, attempts;
    local Actor Actor;

    // End:0x14
    if(!CanCreate())
    {
        return none;        
    }
    else
    {
        propIndex = Rand(3);
        attempts = 0;
        J0x25:

        // End:0x8A [Loop If]
        if(attempts < 3)
        {
            Actor = SpawnFromProps(GetProp(propIndex));
            // End:0x68
            if(Actor != none)
            {
                SpawnCount++;
                return Actor;
            }
            propIndex = int(float(propIndex + 1) % float(3));
            ++attempts;
            // [Loop Continue]
            goto J0x25;
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0x86
            if(Action.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
            }
        }
    }
    //return;    
}
