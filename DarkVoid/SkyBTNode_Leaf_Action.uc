class SkyBTNode_Leaf_Action extends SkyBTNode_Leaf
    abstract
    native;

enum CombatFiringType
{
    CFT_NotFiring,                  // 0
    CFT_WeaponTargeting,            // 1
    CFT_BurstFiring,                // 2
    CFT_ContinuousFiring,           // 3
    CFT_Default,                    // 4
    CFT_MAX                         // 5
};

enum CombatFocusType
{
    CFL_LockFocusOnEnemy,           // 0
    CFL_UnlockFocus,                // 1
    CFL_Default,                    // 2
    CFL_MAX                         // 3
};

var(Movement) float MovementSpeedScale;
var(Movement) bool bNoPathing;
var(Movement) bool bAllowPartialPath;
var(MovementSpeed) bool bUseInterpolatedMovementSpeed;
var(AreaOfOperation) bool bRespectsAreaOfOperation;
var(Movement) bool bDisableSquadMemberAvoidance;
var(MovementSpeed) float InterpolateMoveSpeedMin;
var(MovementSpeed) float InterpolateMoveSpeedMax;
var(MovementSpeed) float InterpolateMoveSpeedMinDist;
var(MovementSpeed) float InterpolateMoveSpeedMaxDist;
var(Combat) SkyBTNode_Leaf_Action.CombatFiringType UseFiringMode;
var(Combat) SkyBTNode_Leaf_Action.CombatFocusType CombatFocusLock;
