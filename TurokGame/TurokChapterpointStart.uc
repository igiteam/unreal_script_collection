class TurokChapterpointStart extends Actor
    native
    placeable
    hidecategories(Navigation);

defaultproperties
{
    bStatic=true
    bHidden=true
    bCollideActors=true
    // Reference: SpriteComponent'Default__TurokChapterpointStart.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__TurokChapterpointStart.Arrow'
    begin object name=Arrow class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
        ArrowSize=0.5000000
    end object
    Components[1]=Arrow
}