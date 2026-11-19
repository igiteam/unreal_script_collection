class R6WAnimNodeBlendByWeaponStatus extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum EWeaponStateAnim
{
    WEAPONSTATE_Idle,               // 0
    WEAPONSTATE_Firing,             // 1
    WEAPONSTATE_Reloading,          // 2
    WEAPONSTATE_SoundSuppressing,   // 3
    WEAPONSTATE_Drawing,            // 4
    WEAPONSTATE_Holstering,         // 5
    WEAPONSTATE_BreakWindowLeft,    // 6
    WEAPONSTATE_BreakWindowUnder,   // 7
    WEAPONSTATE_MAX                 // 8
};

defaultproperties
{
    m_bCannotChangeChildBeforeResetWeaponAnim=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}