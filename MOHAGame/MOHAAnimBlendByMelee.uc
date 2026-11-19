class MOHAAnimBlendByMelee extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum EMeleeIndices
{
    MELEE_OFF,                      // 0
    MELEE_IDLE,                     // 1
    MELEE_ATTACK,                   // 2
    MELEE_MAX                       // 3
};

var() float BlendTime;
var() float AttackRange;
var() float NPCMeleeAttackRange;
var() float MinRunSpeedForMeleeIdle;

defaultproperties
{
    BlendTime=0.1000000
    AttackRange=250.0000000
    NPCMeleeAttackRange=100.0000000
    MinRunSpeedForMeleeIdle=100.0000000
    Children=/* Array type was not detected. */
}