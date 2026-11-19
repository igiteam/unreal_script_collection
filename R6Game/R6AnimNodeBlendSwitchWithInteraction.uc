class R6AnimNodeBlendSwitchWithInteraction extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum EWeaponSwitchType
{
    SWITCH_HOLSTER,                 // 0
    SWITCH_DRAW,                    // 1
    SWITCH_ANY,                     // 2
    SWITCH_MAX                      // 3
};

var(Weapon) R6AnimNodeBlendSwitchWithInteraction.EWeaponSwitchType m_eType;
var(Weapon) bool m_bSwitchOnlyWithEType;

defaultproperties
{
    m_bCannotChangeChildBeforeResetWeaponAnim=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}