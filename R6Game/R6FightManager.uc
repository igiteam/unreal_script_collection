class R6FightManager extends Object
    native;

var private native const noexport Pointer VfTable_FTickableObject;
var float m_fTimerToCheckFight;
var bool m_bFightGoingOn;
var bool m_bFightJustStarted;
var float m_fTimeEndOfFight;
var array<R6Pawn> m_aPawnInCombatReady;
var array<R6TeamManager> m_aTeamWithPawnInCombat;
