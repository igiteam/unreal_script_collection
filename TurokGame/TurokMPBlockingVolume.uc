class TurokMPBlockingVolume extends BlockingVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer);

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPBlockingVolume.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: BrushComponent'Default__TurokMPBlockingVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}