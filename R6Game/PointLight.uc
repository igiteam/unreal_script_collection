class PointLight extends Light
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: PointLightComponent'Default__PointLight.PointLightComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="PointLightComponent0" class=Class'PointLightComponent'
    end object
    LightComponent=PointLightComponent0
    // Reference: SpriteComponent'Default__PointLight.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Light.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: DrawLightRadiusComponent'Default__PointLight.DrawLightRadius0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawLightRadius0" class=Class'DrawLightRadiusComponent'
    end object
    Components[1]=DrawLightRadius0
    Components[2]=PointLightComponent0
}