class R6HeatSource extends Light
    placeable
    hidecategories(lighting);

defaultproperties
{
    m_eLightType=2
    // Reference: R6HeatSourceComponent'Default__R6HeatSource.R6HeatSourceComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="R6HeatSourceComponent0" class=Class'R6HeatSourceComponent'
    end object
    LightComponent=R6HeatSourceComponent0
    // Reference: SpriteComponent'Default__R6HeatSource.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Light.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=R6HeatSourceComponent0
}