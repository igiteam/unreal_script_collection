class R6TacticEntryAssault extends R6TacticCombat
    native;

struct sEntryMemberInfo
{
    var R6Pawn m_pEntryMember;
    var bool m_bIsInStackLocation;
    var Vector m_vStackLocation;
    var Vector m_vEntryLocation;
    var bool m_bIsInExecuteXTOS;
    var bool m_bIsStackLocationOnWall;
    var bool m_bIsInAssault;
    var R6AICommunicateDef_Ptr m_pXTOSCommand;
    var byte m_u8Animation;
    var bool m_bIsCreatingClearList;
    var bool m_bIsProcessedClearList;
    var bool m_bIsFinishedClearList;
    var int m_iOrderOfEntry;
    var int m_iStackIdxUsed;
    var bool m_bIsInSpecialActionLocation;
    var bool m_bIsDoorMember;
    var R6Pawn m_pEntryEnemy;

    structdefaultproperties
    {
        m_pEntryMember=none
        m_bIsInStackLocation=false
        m_vStackLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vEntryLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bIsInExecuteXTOS=false
        m_bIsStackLocationOnWall=false
        m_bIsInAssault=false
        m_pXTOSCommand=(I=none)
        m_u8Animation=0
        m_bIsCreatingClearList=false
        m_bIsProcessedClearList=false
        m_bIsFinishedClearList=false
        m_iOrderOfEntry=0
        m_iStackIdxUsed=0
        m_bIsInSpecialActionLocation=false
        m_bIsDoorMember=false
        m_pEntryEnemy=none
    }
};

var int m_iZoneToAssault;
var array<sEntryMemberInfo> m_aEntryMemberInfo;
var bool m_bIsRainbowEntryAssault;
var bool m_bIsClearRoomInit;
var bool m_bIsClearRoomReady;
var bool m_bIsEntryBegin;
var bool m_bIsAssaultBegin;
var bool m_bIsClearSegListCreated;
var bool m_bIsClearSegListReady;
var bool m_bIsGrenadeThrown;
var bool m_bCoopCommunicationRequired;
var bool m_bIsEntryBlocked;
var int m_iAssaultZoneIdx;
var int m_iCurrentEntryCount;
var float m_fThrownGrenadeTimer;
var R6ObstacleAllowance m_pObstacleAllowance;
var int m_iWarnPlayerCount;
var R6Pawn m_pLastPawnToWarnPlayer;

defaultproperties
{
    m_bIsInternalTactic=true
}