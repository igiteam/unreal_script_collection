class TurokWeapAttachStickyGunNative extends TurokWeapAttachDualWield
    config(Weapon);

var @NULL mDetonateSndCue;

simulated function PlayDetonateSound()
{
    PlayLimitedWeaponSound(mDetonateSndCue, false);
    //return;    
}
