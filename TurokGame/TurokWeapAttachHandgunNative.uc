class TurokWeapAttachHandgunNative extends TurokWeapAttachDualWield
    native
    config(WeapHandGun);

var int mAltFireSndIndex;
var array mAltFireSndCues;
var array mAltFireStereoSndCues;

// Export UTurokWeapAttachHandgunNative::execPlayFiringSound(FFrame&, void* const)
native function PlayFiringSound(byte FireModeNum);
