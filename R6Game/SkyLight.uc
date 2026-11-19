class SkyLight extends Light
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkyLightComponent'Default__SkyLight.SkyLightComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SkyLightComponent0" class=Class'SkyLightComponent'
    end object
    LightComponent=SkyLightComponent0
    // Reference: SpriteComponent'Default__SkyLight.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Light.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_SkyLight'
    end object
    Components[0]=Sprite
    Components[1]=SkyLightComponent0
}