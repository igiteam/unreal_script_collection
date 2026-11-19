class TurokAssaultCTFHud extends TurokCTFHud
    transient
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokAssaultCTFHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}