class R6TacticChokeEntry extends R6Tactic
    native;

enum ETacticChokeEntry
{
    TCE_None,                       // 0
    TCE_Begin,                      // 1
    TCE_MoveToChoke,                // 2
    TCE_FocusOnChoke,               // 3
    TCE_DecideNextAction,           // 4
    TCE_PutAwayWeapon,              // 5
    TCE_OpenOrBreach,               // 6
    TCE_ArmWeapon,                  // 7
    TCE_FocusForGrenade,            // 8
    TCE_ThrowGrenade,               // 9
    TCE_WaitForGrenade,             // 10
    TCE_ChooseEntryDestinations,    // 11
    TCE_Enter,                      // 12
    TCE_SettingBreach,              // 13
    TCE_DetonateBreach,             // 14
    TCE_ScopeInProgress,            // 15
    TCE_MAX                         // 16
};

var Vector m_vLocation;
var int m_iTargetChokeIdx;
var Vector m_vGrenadeTarget;
var R6Pawn m_pawnGrenadeMan;
var R6Pawn m_pawnBreachMan;
var float m_fExplosionTime;
var float m_fScopeSetupTime;
var Vector m_vLocationByChoke[4];
var Rotator m_rotLookAt[5];
var Rotator m_rotDirectionFacing[5];
var R6Pawn m_pawnTacticLeader;
var int m_iNumWaitingAtChoke;
var Vector m_vOriginalLocationByChoke;
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
    m_eType=17
}