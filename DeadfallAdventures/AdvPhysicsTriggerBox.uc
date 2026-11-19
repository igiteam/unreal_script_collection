class AdvPhysicsTriggerBox extends KActor
    classgroup(Adventurer);

defaultproperties
{
    bWakeOnLevelStart=true
    // Reference: StaticMeshComponent'Default__AdvPhysicsTriggerBox.StaticMeshComponent'
    begin object name=StaticMeshComponent class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        RBChannel=ERBCollisionChannel.RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
        Scale3D=(X=0.3000000,Y=0.3000000,Z=0.3000000)
    end object
    StaticMeshComponent=StaticMeshComponent
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPhysicsTriggerBox.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__AdvPhysicsTriggerBox.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPhysicsTriggerBox.MyLightEnvironment'
    end object
    Components[1]=StaticMeshComponent0
    Components[2]=StaticMeshComponent
    bNoEncroachCheck=false
    CollisionComponent=StaticMeshComponent
}