class R6TacticClearRoom extends R6TacticCombat
    native;

enum ETacticClearRoomStep
{
    CLEARROOM_GetClearSeg,          // 0
    CLEARROOM_MoveToClearSeg,       // 1
    CLEARROOM_UseClearSegAlgorithm, // 2
    CLEARROOM_Finish,               // 3
    CLEARROOM_EntryAnim,            // 4
    CLEARROOM_MoveToEntryLocation,  // 5
    CLEARROOM_MAX                   // 6
};

enum ETacticClearRoomRole
{
    ETCRROLE_ScanAndWait,           // 0
    ETCRROLE_Advance,               // 1
    ETCRROLE_MAX                    // 2
};

struct sClearMemberInfo
{
    var R6Pawn m_pClearMember;
    var R6TacticClearRoom.ETacticClearRoomStep m_eCurrentStep;
    var Vector m_vPivotToClear;
    var Vector m_vPivotToSlice;
    var bool m_bIsWaitingForSafeSeg;
    var bool m_bIsUpdateClearList;
    var bool m_bHasClearedCurrentPivot;
    var bool m_bIsCreatingClearList;
    var int m_iIdxToClear;
    var array<int> m_aIdxToScan;
    var bool m_bIsFocusOnEnemy;
    var Actor m_pLastActorUsed;
    var bool m_bIsEnteringRoom;
    var Vector m_vEntryLocation;
    var array<Vector> m_avPivotRadial;
    var int m_iCurrentRadialIdx;
    var bool m_bIsUsingRadial;
    var bool m_bIsLeftRadial;
    var int m_iEndRadial;
    var bool m_bIsFocusOnEntryLocation;
    var bool m_bIsRadialUsable;
    var array<Vector> m_avExposedCover;
    var int m_iOrderOfEntry;

    structdefaultproperties
    {
        m_pClearMember=none
        m_eCurrentStep=0
        m_vPivotToClear=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vPivotToSlice=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bIsWaitingForSafeSeg=false
        m_bIsUpdateClearList=false
        m_bHasClearedCurrentPivot=false
        m_bIsCreatingClearList=false
        m_iIdxToClear=0
        m_aIdxToScan=none
        m_bIsFocusOnEnemy=false
        m_pLastActorUsed=none
        m_bIsEnteringRoom=false
        m_vEntryLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_avPivotRadial=none
        m_iCurrentRadialIdx=0
        m_bIsUsingRadial=false
        m_bIsLeftRadial=false
        m_iEndRadial=0
        m_bIsFocusOnEntryLocation=false
        m_bIsRadialUsable=false
        m_avExposedCover=none
        m_iOrderOfEntry=0
    }
};

var array<sClearMemberInfo> m_aClearMemberInfo;
var int m_iZoneToClear;
var bool m_bIsClearListCreated;
var bool m_bIsClearListReady;
var bool m_bIsReadyToStartClearRoom;
var bool m_bIsTeamMemberAdvancing;
var bool m_bIsAllTeamMemberLocked;
var bool m_bIsClearMessageSent;
var bool m_bIsTeamRushing;
var bool m_bIsTeamLocked;
var bool m_bIsWaitToStartClear;
var bool m_bIsTeamInTactic;
var bool m_bIsEntryInsideToOutside;
var bool m_bIsAbortNeeded;

defaultproperties
{
    m_eType=19
    m_bIsInternalTactic=true
}