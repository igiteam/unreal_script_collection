class PolyMarker extends Keypoint
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__PolyMarker.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Keypoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_PolyMarker'
    end object
    Components[0]=Sprite
}