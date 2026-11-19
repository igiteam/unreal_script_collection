class SceneCaptureReflectActor extends SceneCaptureActor
    native
    placeable
    hidecategories(lighting);

var() const export editinline StaticMeshComponent StaticMesh;
var Material ReflectMaterial;
var transient MaterialInstanceConstant ReflectMaterialInst;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__SceneCaptureReflectActor.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StaticMeshComponent0" class=Class'StaticMeshComponent'
        StaticMesh=StaticMesh'EditorMeshes.TexPropPlane'
        HiddenGame=true
        CastShadow=false
        CollideActors=false
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale3D=(X=4.0000000,Y=4.0000000,Z=4.0000000)
    end object
    StaticMesh=StaticMeshComponent0
    ReflectMaterial=Material'EngineMaterials.ScreenMaterial'
    // Reference: SceneCaptureReflectComponent'Default__SceneCaptureReflectActor.SceneCaptureReflectComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SceneCaptureReflectComponent0" class=Class'SceneCaptureReflectComponent'
    end object
    SceneCapture=SceneCaptureReflectComponent0
    // Reference: SpriteComponent'Default__SceneCaptureReflectActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__SceneCaptureActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=SceneCaptureReflectComponent0
    Components[2]=StaticMeshComponent0
    Rotation=(Pitch=16384,Yaw=0,Roll=0)
}