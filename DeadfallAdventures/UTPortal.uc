class UTPortal extends PortalTeleporter
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__UTPortal.StaticMeshComponent2'
    begin object name=StaticMeshComponent2
        ReplacementPrimitive=none
    end object
    StaticMesh=StaticMeshComponent2
    // Reference: SceneCapturePortalComponent'Default__UTPortal.SceneCapturePortalComponent0'
    begin object name=SceneCapturePortalComponent0
    end object
    SceneCapture=SceneCapturePortalComponent0
    Components[0]=SceneCapturePortalComponent0
    Components[1]=none
    Components[2]=StaticMeshComponent2
    bEdShouldSnap=true
    CollisionComponent=StaticMeshComponent2
}