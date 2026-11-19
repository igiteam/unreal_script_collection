class R6AnimNotify_EquipWeapon extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EAnimNotifyWeaponSocket
{
    ANIMNOT_WEAPON_SOCKET_NONE,     // 0
    ANIMNOT_WEAPON_SOCKET_GRAB_01,  // 1
    ANIMNOT_WEAPON_SOCKET_GRAB_02,  // 2
    ANIMNOT_WEAPON_SOCKET_GRAB_03,  // 3
    ANIMNOT_WEAPON_SOCKET_IK_LH,    // 4
    ANIMNOT_WEAPON_SOCKET_IK_RH,    // 5
    ANIMNOT_WEAPON_SOCKET_MAX       // 6
};

enum EAnimNotifyHand
{
    ANIMNOT_RIGHTHAND,              // 0
    ANIMNOT_LEFTHAND,               // 1
    ANIMNOT_NONE,                   // 2
    ANIMNOT_MAX                     // 3
};

var() R6AnimNotify_EquipWeapon.EAnimNotifyHand m_eHand;
var() R6AnimNotify_EquipWeapon.EAnimNotifyWeaponSocket m_eSocket;
var() bool m_bAttach;

// Export UR6AnimNotify_EquipWeapon::execGetWeaponSocketName(FFrame&, void* const)
native final function name GetWeaponSocketName();

defaultproperties
{
    m_bAttach=true
}