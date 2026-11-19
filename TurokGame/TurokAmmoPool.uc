class TurokAmmoPool extends Object
    abstract
    native;

var int mAmmoMaximum;
var int mAmmoCounter;
var @NULL mPickUpSndCue;

// Export UTurokAmmoPool::execAdjustMP(FFrame&, void* const)
native function AdjustMP();

defaultproperties
{
    mAmmoMaximum=999
    mPickUpSndCue=SoundCue'SndWeapSmg.SMGReloadESndCue'
}