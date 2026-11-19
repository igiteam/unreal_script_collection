class R6PointOfInterest extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

var() float m_fThreat;

defaultproperties
{
    m_fThreat=0.8000000
    // Reference: SpriteComponent'Default__R6PointOfInterest.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.POI_Pic'
    end object
    Components[0]=Sprite
}