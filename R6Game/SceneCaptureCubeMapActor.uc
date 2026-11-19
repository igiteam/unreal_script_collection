class SceneCaptureCubeMapActor extends SceneCaptureActor
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SceneCaptureCubeMapComponent'Default__SceneCaptureCubeMapActor.SceneCaptureCubeMapComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SceneCaptureCubeMapComponent0" class=Class'SceneCaptureCubeMapComponent'
    end object
    SceneCapture=SceneCaptureCubeMapComponent0
    // Reference: SpriteComponent'Default__SceneCaptureCubeMapActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__SceneCaptureActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=SceneCaptureCubeMapComponent0
}