class AdvRailCar_Truck_Base extends AdvRailCar_Base
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvRailCar_Truck_Base.EditorWheelsPreviewMesh0'
    begin object name=EditorWheelsPreviewMesh0
        ReplacementPrimitive=none
    end object
    EditorWheelsPreviewMesh=EditorWheelsPreviewMesh0
    bEngineRunning=true
    EngineRPMAccelRange=(X=30.0000000,Y=5000.0000000)
    EngineRPMVelRange=(X=100.0000000,Y=2800.0000000)
    bDisallowPawnMovement=true
    bForceStickToClosestNavPoint=true
    // Reference: StaticMeshComponent'Default__AdvRailCar_Truck_Base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvRailCar_Truck_Base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvRailCar_Truck_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=EditorWheelsPreviewMesh0
    CollisionComponent=StaticMeshComponent0
}