class R6CivilCoverPoint extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

defaultproperties
{
    // Reference: SpriteComponent'Default__R6CivilCoverPoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.CivilCoverPoint_Pic'
    end object
    Components[0]=Sprite
}