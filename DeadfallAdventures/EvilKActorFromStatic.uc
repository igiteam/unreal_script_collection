class EvilKActorFromStatic extends KActorSpawnable;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__EvilKActorFromStatic.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilKActorFromStatic.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilKActorFromStatic.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    LifeSpan=10.0000000
    CollisionComponent=StaticMeshComponent0
}