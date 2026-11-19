class TurokMPMaterialInstanceActor extends MaterialInstanceActor
    native
    hidecategories(Navigation,Movement,Advanced,Collision,Display,Actor,Attachment);

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPMaterialInstanceActor.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    bStatic=true
    // Reference: SpriteComponent'Default__TurokMPMaterialInstanceActor.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}