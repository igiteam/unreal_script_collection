class Note extends Actor
    native
    placeable
    hidecategories(lighting,Actor,Advanced,Collision,Display,Events,Fire,Movement,Object);

var() string Text;
var() string ErrorUrl;

defaultproperties
{
    bStatic=true
    bHidden=true
    bNoDelete=true
    bMovable=false
    // Reference: SpriteComponent'Default__Note.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Note'
    end object
    Components[0]=Sprite
}