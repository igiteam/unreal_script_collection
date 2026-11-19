class UTSD_SpawnedKActor extends KActor;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__UTSD_SpawnedKActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__UTSD_SpawnedKActor.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__UTSD_SpawnedKActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    RemoteRole=ENetRole.ROLE_None
    bNoDelete=false
    CollisionComponent=StaticMeshComponent0
}