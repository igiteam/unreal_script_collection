class AdvRailCar_Kubelwagen_Base extends AdvRailCar_Base
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvRailCar_Kubelwagen_Base.EditorWheelsPreviewMesh0'
    begin object name=EditorWheelsPreviewMesh0
        ReplacementPrimitive=none
    end object
    EditorWheelsPreviewMesh=EditorWheelsPreviewMesh0
    bEngineRunning=true
    bDisallowPawnMovement=true
    bForceStickToClosestNavPoint=true
    // Reference: StaticMeshComponent'Default__AdvRailCar_Kubelwagen_Base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvRailCar_Kubelwagen_Base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvRailCar_Kubelwagen_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=EditorWheelsPreviewMesh0
    CollisionComponent=StaticMeshComponent0
}