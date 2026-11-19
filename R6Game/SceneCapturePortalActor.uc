class SceneCapturePortalActor extends SceneCaptureReflectActor
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__SceneCapturePortalActor.StaticMeshComponent2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StaticMeshComponent2" class=Class'StaticMeshComponent'
        StaticMesh=StaticMesh'EditorMeshes.TexPropPlane'
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    StaticMesh=StaticMeshComponent2
    // Reference: SceneCapturePortalComponent'Default__SceneCapturePortalActor.SceneCapturePortalComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SceneCapturePortalComponent0" class=Class'SceneCapturePortalComponent'
    end object
    SceneCapture=SceneCapturePortalComponent0
    Components[0]=SceneCapturePortalComponent0
    // Reference: StaticMeshComponent'Default__SceneCapturePortalActor.StaticMeshComponent1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StaticMeshComponent1" class=Class'StaticMeshComponent'
        StaticMesh=StaticMesh'EditorMeshes.MatineeCam_SM'
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale3D=(X=-1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    Components[1]=StaticMeshComponent1
    Components[2]=StaticMeshComponent2
    Rotation=(Pitch=0,Yaw=0,Roll=0)
}