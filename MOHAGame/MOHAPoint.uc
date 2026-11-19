class MOHAPoint extends Actor
    placeable
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SpriteComponent'Default__MOHAPoint.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    bStatic=true
    bHidden=true
}