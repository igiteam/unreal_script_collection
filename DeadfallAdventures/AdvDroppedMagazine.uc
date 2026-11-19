class AdvDroppedMagazine extends KActorSpawnable;

simulated function Initialize()
{
    super.Initialize();
    StaticMeshComponent.SetRBCollidesWithChannel(2, false);
    StaticMeshComponent.SetRBCollidesWithChannel(16, false);
    StaticMeshComponent.WakeRigidBody();
    StaticMeshComponent.SetRBAngularVelocity(VRand() * 1.5000000);
    SetTimer(LifeSpan - 1.0000000, false, 'Recycle');
    //return;    
}

simulated event RecycleInternal()
{
    Destroy();
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvDroppedMagazine.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvDroppedMagazine.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvDroppedMagazine.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    RemoteRole=ENetRole.ROLE_None
    LifeSpan=6.0000000
    CollisionComponent=StaticMeshComponent0
}