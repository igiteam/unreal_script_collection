class R6TacticSearch extends R6TacticPreCombat
    native;

enum ETacticSearchStep
{
    SEARCHSTEP_MoveToSearchZone,    // 0
    SEARCHSTEP_GetClearSeg,         // 1
    SEARCHSTEP_MoveToClearSeg,      // 2
    SEARCHSTEP_UseClearSegAlgorithm,// 3
    SEARCHSTEP_LookAtExposedCover,  // 4
    SEARCHSTEP_StopAndInvestigate,  // 5
    SEARCHSTEP_Finish,              // 6
    SEARCHSTEP_MAX                  // 7
};

struct sSearchMemberInfo
{
    var R6Pawn m_pSearchMember;
    var bool m_bIsCreatingClearList;
    var R6TacticSearch.ETacticSearchStep m_eCurrentStep;
    var Vector m_vPivotToClear;
    var Vector m_vPivotToSlice;
    var bool m_bIsUpdateClearList;
    var bool m_bHasClearedCurrentPivot;
    var int m_iIdxToClear;
    var array<Vector> m_avPivotRadial;
    var int m_iCurrentRadialIdx;
    var bool m_bIsUsingRadial;
    var bool m_bIsLeftRadial;
    var int m_iEndRadial;
    var int m_iCurrentSearchZone;
    var Vector m_vSearchLineStart;
    var Vector m_vSearchLineEnd;
    var bool m_bIsSearchListCreated;
    var bool m_bIsSearchListReady;
    var array<int> m_aSearchZoneList;
    var array<Vector> m_avExposedCover;
    var bool m_bIsRadialUsable;
    var float m_fTimeToStopAndInvestigate;
    var float m_fInvestigateFocusTimer;
    var array<int> m_aSearchZoneCleared;
    var float m_fStuckTimer;
    var int m_InvestigateDirectionLooked;
    var Vector m_vFinalSearchLocation;
    var int m_iFinalSearchZoneIdx;
    var int m_iFinalSearchTriIdx;

    structdefaultproperties
    {
        m_pSearchMember=none
        m_bIsCreatingClearList=false
        m_eCurrentStep=0
        m_vPivotToClear=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vPivotToSlice=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bIsUpdateClearList=false
        m_bHasClearedCurrentPivot=false
        m_iIdxToClear=0
        m_avPivotRadial=none
        m_iCurrentRadialIdx=0
        m_bIsUsingRadial=false
        m_bIsLeftRadial=false
        m_iEndRadial=0
        m_iCurrentSearchZone=0
        m_vSearchLineStart=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vSearchLineEnd=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bIsSearchListCreated=false
        m_bIsSearchListReady=false
        m_aSearchZoneList=none
        m_avExposedCover=none
        m_bIsRadialUsable=false
        m_fTimeToStopAndInvestigate=0.0000000
        m_fInvestigateFocusTimer=0.0000000
        m_aSearchZoneCleared=none
        m_fStuckTimer=0.0000000
        m_InvestigateDirectionLooked=0
        m_vFinalSearchLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iFinalSearchZoneIdx=0
        m_iFinalSearchTriIdx=0
    }
};

var array<sClearSegInfo> m_aCoverSegToClear;
var array<sSearchMemberInfo> m_aSearchMemberInfo;
var int m_iSearchZoneIdx;
var Vector m_vSearchLocation;
var int m_iSearchTriIdx;
var float m_fSearchStartTime;
var Vector m_vLastDeathLocation;
var int m_iLastDeathZoneIdx;
var int m_iLastDeathTriIdx;

defaultproperties
{
    m_eType=6
}