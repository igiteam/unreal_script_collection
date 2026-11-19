class SceneCapture2DActor extends SceneCaptureActor
    native
    placeable
    hidecategories(lighting);

var const export editinline DrawFrustumComponent DrawFrustum;

defaultproperties
{
    // Reference: DrawFrustumComponent'Default__SceneCapture2DActor.DrawFrust0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawFrust0" class=Class'DrawFrustumComponent'
        FrustumColor=(R=255,G=255,B=255,A=255)
    end object
    DrawFrustum=DrawFrust0
    // Reference: SceneCapture2DComponent'Default__SceneCapture2DActor.SceneCapture2DComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SceneCapture2DComponent0" class=Class'SceneCapture2DComponent'
    end object
    SceneCapture=SceneCapture2DComponent0
    // Reference: SpriteComponent'Default__SceneCapture2DActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__SceneCaptureActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__SceneCapture2DActor.CamMesh0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CamMesh0" class=Class'StaticMeshComponent'
    end object
    Components[1]=CamMesh0
    Components[2]=DrawFrust0
    Components[3]=SceneCapture2DComponent0
}