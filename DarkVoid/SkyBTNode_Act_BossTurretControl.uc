class SkyBTNode_Act_BossTurretControl extends SkyBTNode_Leaf_Action
    native;

enum E_TURRET_FIRING_CONTROL
{
    TURR_DEFAULT,                   // 0
    TURR_STOP_FIRING,               // 1
    TURR_START_FIRING,              // 2
    TURR_MAX                        // 3
};

var(Control) int TurretIndex;
var(Control) SkyBTNode_Act_BossTurretControl.E_TURRET_FIRING_CONTROL FiringControl;
var(Control) SkyWeaponMounted.EFiringMode FiringMode;
var(Control) bool bUseCurrentTestTarget;
