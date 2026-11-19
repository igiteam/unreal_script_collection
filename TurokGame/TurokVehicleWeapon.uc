class TurokVehicleWeapon extends TurokWeapon
    abstract
    native
    config(Weapon)
    hidecategories(Navigation);

simulated event bool CanThrowGrenade()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    mPrimaryFireFF=ForceFeedbackWaveform'Default__TurokDamageType.ForceFeedbackWaveform0'
    // Reference: TurokZoomComponent'Default__TurokVehicleWeapon.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
    bCanThrow=false
    bDropOnDeath=false
    bOnlyRelevantToOwner=false
    bAlwaysRelevant=true
    bGameRelevant=true
}