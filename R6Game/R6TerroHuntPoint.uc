class R6TerroHuntPoint extends R6SpawnPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

var bool m_bDeactivated;
var float m_fPriority;

defaultproperties
{
    // Reference: SpriteComponent'Default__R6TerroHuntPoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6SpawnPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AITerroHuntPoint_Pic'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__R6TerroHuntPoint.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6SpawnPoint.Arrow'
    begin object name="Arrow"
    end object
    Components[1]=Arrow
}