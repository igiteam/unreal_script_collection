class SpotLight extends Light
    native
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SpotLightComponent'Default__SpotLight.SpotLightComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SpotLightComponent0" class=Class'SpotLightComponent'
    end object
    LightComponent=SpotLightComponent0
    // Reference: SpriteComponent'Default__SpotLight.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Light.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: DrawLightRadiusComponent'Default__SpotLight.DrawLightRadius0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawLightRadius0" class=Class'DrawLightRadiusComponent'
    end object
    Components[1]=DrawLightRadius0
    // Reference: DrawLightConeComponent'Default__SpotLight.DrawInnerCone0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawInnerCone0" class=Class'DrawLightConeComponent'
    end object
    Components[2]=DrawInnerCone0
    // Reference: DrawLightConeComponent'Default__SpotLight.DrawOuterCone0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawOuterCone0" class=Class'DrawLightConeComponent'
        m_bIsOuterCone=true
        ConeColor=(R=200,G=255,B=255,A=255)
    end object
    Components[3]=DrawOuterCone0
    Components[4]=SpotLightComponent0
    // Reference: ArrowComponent'Default__SpotLight.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
    end object
    Components[5]=ArrowComponent0
    Rotation=(Pitch=-16384,Yaw=0,Roll=0)
    DesiredRotation=(Pitch=-16384,Yaw=0,Roll=0)
}