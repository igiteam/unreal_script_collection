class R6TacticInvestigate extends R6TacticPreCombat
    native;

enum ETacticInvestigateStep
{
    INVESTIGATE_MoveAndLook,        // 0
    INVESTIGATE_StopAndLook,        // 1
    INVESTIGATE_Finish,             // 2
    INVESTIGATE_MAX                 // 3
};

enum EInvestigateFocusType
{
    INVESTFOCUS_Forward,            // 0
    INVESTFOCUS_Head,               // 1
    INVESTFOCUS_Body,               // 2
    INVESTFOCUS_MAX                 // 3
};

var Vector m_vInvestigateLocation;
var int m_iInvestigateTri;
var int m_iInvestigateZone;
var float m_fMaxDistFromSearchLocation;
var Vector m_vLastLocation;
var bool m_bIsUsingRandomCoverFocus;
var Vector m_vInterDest;
var float m_fTravelDistToFocusUpdate;
var float m_fTravelDistRemaining;
var Vector m_vFocusLocation;
var float m_fTimeToStopAndInvestigate;
var R6TacticInvestigate.ETacticInvestigateStep m_eInvestigateStep;
var R6TacticInvestigate.EInvestigateFocusType m_eCurrentFocusType;
var R6TacticInvestigate.EInvestigateFocusType m_ePreviousFocusType;
var int m_iTimesInRowHeadFocus;
var int m_iTimesInRowBodyFocus;
var int m_iTimesInRowForwardFocus;
var int m_iMaxHeadFocusCount;
var int m_iMaxBodyFocusCount;
var int m_iMaxForwardFocusCount;
var float m_fFocusTimer;

defaultproperties
{
    m_eType=40
}