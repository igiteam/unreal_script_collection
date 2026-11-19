class AmbientSound extends Keypoint
    native
    placeable
    hidecategories(lighting);

var() const editconst export editinline AudioComponent AudioComponent;

defaultproperties
{
    // Reference: SpriteComponent'Default__AmbientSound.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Keypoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Ambient'
    end object
    Components[0]=Sprite
    // Reference: R6AmbientSound'Default__AmbientSound.R6AmbientSound0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="R6AmbientSound0" class=Class'R6AmbientSound'
    end object
    m_R6Sound=R6AmbientSound0
}