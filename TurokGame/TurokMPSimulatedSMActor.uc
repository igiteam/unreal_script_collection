class TurokMPSimulatedSMActor extends DynamicSMActor
    native
    hidecategories(Navigation);

simulated function SetStaticMesh(@NULL NewStaticMesh)
{
    StaticMeshComponent.super(TurokMPSimulatedSMActor).SetStaticMesh(NewStaticMesh.StaticMesh);
    //return;    
}

function ForceNetRelevant()
{
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__TurokMPSimulatedSMActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokMPSimulatedSMActor.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPSimulatedSMActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bReplicateMovement=false
    bMovable=false
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    TickGroup=1
    CollisionComponent=StaticMeshComponent0
}