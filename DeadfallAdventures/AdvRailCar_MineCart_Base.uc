class AdvRailCar_MineCart_Base extends AdvRailCar_Base
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvRailCar_MineCart_Base.EditorWheelsPreviewMesh0'
    begin object name=EditorWheelsPreviewMesh0
        ReplacementPrimitive=none
    end object
    EditorWheelsPreviewMesh=EditorWheelsPreviewMesh0
    bEngineRunning=true
    ForwardDir=(X=0.0000000,Y=1.0000000,Z=0.0000000)
    bClampedBaseEnabled=true
    bDisallowPawnMovement=true
    bForceStickToClosestNavPoint=true
    // Reference: StaticMeshComponent'Default__AdvRailCar_MineCart_Base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvRailCar_MineCart_Base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvRailCar_MineCart_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=EditorWheelsPreviewMesh0
    CollisionComponent=StaticMeshComponent0
}