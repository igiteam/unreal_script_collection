class R6EmotionNote extends R6Note
    native
    placeable
    hidecategories(lighting,Actor,Advanced,Collision,Display,Events,Fire,Movement,Object,Actor,Advanced,Attachment,Collision,Display,Events,Fire,Heat,Movement,Object,R6Sound,R6SoundPropagation)
    autoexpandcategories(Note);

defaultproperties
{
    // Reference: SpriteComponent'Default__R6EmotionNote.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6Note.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerResource.S_EmotionNote'
        HiddenGame=false
    end object
    Components[0]=Sprite
}