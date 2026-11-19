class DirectionalLight extends Light
    placeable
    hidecategories(lighting);

defaultproperties
{
    // Reference: DirectionalLightComponent'Default__DirectionalLight.DirectionalLightComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DirectionalLightComponent0" class=Class'DirectionalLightComponent'
    end object
    LightComponent=DirectionalLightComponent0
    // Reference: SpriteComponent'Default__DirectionalLight.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Light.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=DirectionalLightComponent0
    // Reference: ArrowComponent'Default__DirectionalLight.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
    end object
    Components[2]=ArrowComponent0
    Rotation=(Pitch=-16384,Yaw=0,Roll=0)
    DesiredRotation=(Pitch=-16384,Yaw=0,Roll=0)
}