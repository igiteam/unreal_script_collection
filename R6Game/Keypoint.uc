class Keypoint extends Actor
    abstract
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    bStatic=true
    bHidden=true
    // Reference: SpriteComponent'Default__Keypoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Keypoint'
    end object
    Components[0]=Sprite
}