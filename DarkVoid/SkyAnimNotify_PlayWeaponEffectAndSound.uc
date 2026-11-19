class SkyAnimNotify_PlayWeaponEffectAndSound extends AnimNotify_Scripted
    native
    config(Engine)
    editinlinenew
    collapsecategories;

var() int FireMode;
var() editoronly SkyWeapon PreviewArchetype;

event SoundCue GetPlaySound(SkyWeapon SkyWeap)
{
    // End:0x34
    if(SkyWeap.WeaponFireSnd[FireMode] != none)
    {
        return SkyWeap.WeaponFireSnd[FireMode];        
    }
    else
    {
        // End:0x5D
        if(SkyWeap.WeaponFireSnd[0] != none)
        {
            return SkyWeap.WeaponFireSnd[0];
        }
    }
    //return ReturnValue;    
}
