class TurokDMHud extends TurokMultiplayerHud
    transient
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokDMHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}