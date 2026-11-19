class R6AnimNodeBlendTC360WeaponAndThrow extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum ETakeCoverWeaponAnim
{
    TCWEAPON_Normal,                // 0
    TCWEAPON_Reload,                // 1
    TCWEAPON_Shoot,                 // 2
    TCWEAPON_Draw,                  // 3
    TCWEAPON_Holster,               // 4
    TCWEAPON_PutSuppressor,         // 5
    TCWEAPON_Grenades,              // 6
    TCWEAPON_GrenadesLeftArm,       // 7
    TCWEAPON_AimingAdditive,        // 8
    TCWEAPON_MAX                    // 9
};

var transient int m_iDesiredActiveChild;

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}