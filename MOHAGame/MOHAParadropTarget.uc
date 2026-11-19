class MOHAParadropTarget extends Actor
    native
    placeable
    hidecategories(Navigation);

var() bool bDestroyTrooperOnLanded;
var() float targetRadius;
var() float noSteerHeightThreshold;

defaultproperties
{
    targetRadius=700.0000000
    noSteerHeightThreshold=1000.0000000
    // Reference: SpriteComponent'Default__MOHAParadropTarget.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EngineResources.S_NavP'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    bStatic=true
}