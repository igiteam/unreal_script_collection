class UTKActor extends UDKKActorBreakable;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__UTKActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__UTKActor.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__UTKActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}