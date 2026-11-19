class R6TacticDoorEntry extends R6Tactic
    native;

enum ETacticDoorEntry
{
    TDE_None,                       // 0
    TDE_Begin,                      // 1
    TDE_MoveToDoor,                 // 2
    TDE_FocusOnDoor,                // 3
    TDE_DecideNextAction,           // 4
    TDE_PutAwayWeapon,              // 5
    TDE_OpenOrBreach,               // 6
    TDE_ArmWeapon,                  // 7
    TDE_FocusForGrenade,            // 8
    TDE_ThrowGrenade,               // 9
    TDE_WaitForGrenade,             // 10
    TDE_ChooseEntryDestinations,    // 11
    TDE_Enter,                      // 12
    TDE_SettingBreach,              // 13
    TDE_DetonateBreach,             // 14
    TDE_ScopeInProgress,            // 15
    TDE_MAX                         // 16
};

var R6InteractiveDoor m_pDoorTarget;
var int m_iTargetDoorIdx;
var Vector m_vGrenadeTarget;
var R6Pawn m_pawnGrenadeMan;
var R6Pawn m_pawnBreachMan;
var float m_fExplosionTime;
var float m_fScopeSetupTime;
var Vector m_vLocationByDoor[4];
var Rotator m_rotLookAt[5];
var Rotator m_rotDirectionFacing[5];
var int m_iNumWaitingAtDoor;
var Vector m_vOriginalLocationByDoor;
var bool m_bBreachSet;
var bool m_bStopScoping;
var bool m_bRequestStopScoping;
var bool m_bAborting;
var int m_iNumFragsToThrow;
var R6EngineEnums.EPreEntryType m_ePreEntryType;
var R6EngineEnums.EBreachMethod m_eBreachMethod;
var R6EngineEnums.EEntryType m_eEntryType;
var R6GadgetExplosive m_pCharge;
var R6GadgetSnakeCam m_pSnakeCam;
var R6XTOSystem m_pXTOS;

defaultproperties
{
    m_eType=16
}