class R6AnimNodeBlendRagdollWhenDead extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum ER6DeathState
{
    ER6DeathState_Alive,            // 0
    ER6DeathState_NoAnimation,      // 1
    ER6DeathState_Reaction,         // 2
    ER6DeathState_Incapacitated,    // 3
    ER6DeathState_MAX               // 4
};

enum ER6Limb
{
    ER6Limb_None,                   // 0
    ER6Limb_ArmLeft,                // 1
    ER6Limb_ArmRight,               // 2
    ER6Limb_LegLeft,                // 3
    ER6Limb_LegRight,               // 4
    ER6Limb_MAX                     // 5
};

var R6AnimNodeBlendRagdollWhenDead.ER6Limb m_eDeathLimb;

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}