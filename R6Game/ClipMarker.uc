class ClipMarker extends Keypoint
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__ClipMarker.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Keypoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_ClipMarker'
    end object
    Components[0]=Sprite
}