class TurokLocationMarker extends Actor
    placeable
    hidecategories(Navigation,Attachment,Advanced,Object,Collision,PrimitiveComponent,Rendering,Display,Navigation);

defaultproperties
{
    bStatic=true
    bHidden=true
    bIgnoreEncroachers=true
    bMovable=false
    bCollideWhenPlacing=true
    bNoEncroachCheck=true
    // Reference: SpriteComponent'Default__TurokLocationMarker.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokLocationMarker'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
}