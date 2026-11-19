class R6FlashbangPointLight extends Light
    native
    placeable
    hidecategories(lighting);

var export editinline PointLightComponent m_PointLight;

defaultproperties
{
    // Reference: PointLightComponent'Default__R6FlashbangPointLight.PointLightComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="PointLightComponent0" class=Class'PointLightComponent'
        CastShadows=true
    end object
    m_PointLight=PointLightComponent0
    m_eLightType=2
    LightComponent=PointLightComponent0
    bStatic=false
    bNoDelete=false
    // Reference: SpriteComponent'Default__R6FlashbangPointLight.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Light.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=PointLightComponent0
}