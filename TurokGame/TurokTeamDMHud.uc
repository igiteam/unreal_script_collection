class TurokTeamDMHud extends TurokTeamGameHud
    transient
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokTeamDMHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}