class R6AnimNodeBlendByWeaponStatus extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum EWeaponStatusAnim
{
    WEAPONSTATUS_Normal,            // 0
    WEAPONSTATUS_Reload,            // 1
    WEAPONSTATUS_Shoot,             // 2
    WEAPONSTATUS_Draw,              // 3
    WEAPONSTATUS_Holster,           // 4
    WEAPONSTATUS_Unarmed,           // 5
    WEAPONSTATUS_PutSuppressor,     // 6
    WEAPONSTATUS_Throw,             // 7
    WEAPONSTATUS_Pickup,            // 8
    WEAPONSTATUS_MAX                // 9
};

var() bool m_bKeepActiveChild;
var() float m_fBlendOutBefore;
var() float m_fBlendTime;
var transient bool m_bDontChangeChild;

defaultproperties
{
    m_bCannotChangeChildBeforeResetWeaponAnim=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}