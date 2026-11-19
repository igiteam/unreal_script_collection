class R6TeamManager extends Actor
    native
    notplaceable
    hidecategories(lighting);

enum eRISKPOINT_TYPE
{
    RISKPOINTTYPE_OBJECT,           // 0
    RISKPOINTTYPE_CORNER,           // 1
    RISKPOINTTYPE_ENEMY,            // 2
    RISKPOINTTYPE_MAX               // 3
};

enum ERiskPointMode
{
    RISKPOINT_None,                 // 0
    RISKPOINT_Default,              // 1
    RISKPOINT_ShareCover,           // 2
    RISKPOINT_MovingLR,             // 3
    RISKPOINT_MovingRL,             // 4
    RISKPOINT_MAX                   // 5
};

struct sUnsafeLocation
{
    var Actor m_pUnsafeActor;
    var Vector m_vUnsafeLocation;
    var float m_fUnsafeTimer;

    structdefaultproperties
    {
        m_pUnsafeActor=none
        m_vUnsafeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fUnsafeTimer=0.0000000
    }
};

struct LatentTacticSwitch
{
    var array<R6Pawn> m_aPawnToSwitch;
    var R6Tactic m_pNewTactic;
    var array<R6Tactic> m_aOldTactic;
    var int m_iOptionalIntData;
    var Vector m_vOptionalVectorData;
    var float m_fOptionalFloatData;
    var byte m_u8OptionalByteData;
    var ENavMesh m_pOptNavMesh;

    structdefaultproperties
    {
        m_aPawnToSwitch=none
        m_pNewTactic=none
        m_aOldTactic=none
        m_iOptionalIntData=0
        m_vOptionalVectorData=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fOptionalFloatData=0.0000000
        m_u8OptionalByteData=0
        m_pOptNavMesh=none
    }
};

struct sAvailableMemberInfo
{
    var R6Pawn m_pAvailableMember;
    var Actor.ETacticType m_eSuggestedTactic;

    structdefaultproperties
    {
        m_pAvailableMember=none
        m_eSuggestedTactic=0
    }
};

struct sClearSegInfo
{
    var R6CoverSeg_Ptr m_pCoverSeg;
    var bool m_bIsCleared;
    var array<Vector> m_avExposedCover;
    var bool m_bIsSafeToClear;
    var int m_iExposureCount;
    var Vector m_vPivotToConsider;
    var Vector m_vPivotToSlice;
    var float m_fPivotDistanceToPawn;
    var bool m_bIsValidSegToConsider;
    var float m_fPartnerRatio;

    structdefaultproperties
    {
        m_pCoverSeg=(I=none)
        m_bIsCleared=false
        m_avExposedCover=none
        m_bIsSafeToClear=false
        m_iExposureCount=0
        m_vPivotToConsider=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vPivotToSlice=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fPivotDistanceToPawn=0.0000000
        m_bIsValidSegToConsider=false
        m_fPartnerRatio=0.0000000
    }
};

struct RISKPOINT
{
    var Vector m_vLocation;
    var Actor m_pActor;
    var R6TeamManager.eRISKPOINT_TYPE m_eType;
    var int m_iResponsibility;
    var float m_fThreat;

    structdefaultproperties
    {
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pActor=none
        m_eType=0
        m_iResponsibility=0
        m_fThreat=0.0000000
    }
};

struct sPatrol
{
    var name m_nNameId;
    var int m_iUsed;

    structdefaultproperties
    {
        m_nNameId="None"
        m_iUsed=0
    }
};

struct sAmbush
{
    var array<R6AmbushTrigger> m_pTriggerHide;
    var array<R6AmbushVolume> m_pVolumeHide;
    var array<R6AmbushTrigger> m_pTriggerAttack;
    var array<R6AmbushVolume> m_pVolumeAttack;

    structdefaultproperties
    {
        m_pTriggerHide=none
        m_pVolumeHide=none
        m_pTriggerAttack=none
        m_pVolumeAttack=none
    }
};

struct sPotentialSearchPawn
{
    var R6Pawn m_pPawn;
    var int m_iZoneDistance;
    var array<int> m_aSearchZonePath;

    structdefaultproperties
    {
        m_pPawn=none
        m_iZoneDistance=0
        m_aSearchZonePath=none
    }
};

struct sActorLOS
{
    var Actor m_pActor;
    var bool m_bIsVisible;

    structdefaultproperties
    {
        m_pActor=none
        m_bIsVisible=false
    }
};

struct sCoverLOSCache
{
    var Vector m_vLocation;
    var array<sActorLOS> m_aActorLOS;

    structdefaultproperties
    {
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_aActorLOS=none
    }
};

struct sPotentialSearchTeam
{
    var int m_iEventZoneIdx;
    var EAIEvent m_sAIEvent;
    var array<R6Pawn> m_aSearchPawn;

    structdefaultproperties
    {
        m_iEventZoneIdx=0
        m_sAIEvent=(m_eEventType=0,m_eGoalType=0,m_nGoalID="None",m_vEventLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_pEventTarget=none,m_damageType=none)
        m_aSearchPawn=none
    }
};

struct RecordedHTEvents
{
    var float m_fRadius;
    var byte m_nType;
    var Vector m_vNoiseLoc;
    var Actor m_pNoiseMaker;
    var int m_iTriIndex;
    var ENavMesh m_pNavMesh;
    var float m_fOccuredTime;

    structdefaultproperties
    {
        m_fRadius=0.0000000
        m_nType=0
        m_vNoiseLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pNoiseMaker=none
        m_iTriIndex=0
        m_pNavMesh=none
        m_fOccuredTime=0.0000000
    }
};

var array<R6PointOfInterest> m_aPointOfInterest;
var array<sUnsafeLocation> m_aUnsafeLocation;
var array<Actor> m_aGasActors;
var float m_fLastGasTest;
var array<sCoverLOSCache> m_aCoverLOSCache;
var array<sAvailableMemberInfo> m_aAvailableMember;
var array<LatentTacticSwitch> m_arrLatentTacticSwitch;
var array<R6AICommunicateDef_Ptr> m_aTeamMessage;
var array<float> m_afTeamGrenadeTimer;
var array<R6TeamObjective> m_aTeamObjective;
var array<R6Tactic> m_aTeamTactic;
var array<R6Pawn> m_aTeamMember;
var array<int> m_aRestrictionZoneIndex;
var array<R6ShareCover_Ptr> m_ShareCovers;
var array<Actor.ETacticType> m_aLeaderTactic;
var Actor.ETacticType m_eActiveLeaderTactic;
var R6TeamManager.ERiskPointMode m_eRiskPointMode;
var R6GameEnums.ESpawnGameMode m_eExistsInSpawnGameMode;
var R6GameEnums.EEventRelativeLocation m_eStunReactionLocation;
var bool m_bCreateCoverSegs;
var bool m_bShowRiskPoints;
var bool m_bRenderDebug;
var bool m_bShowCoverResults;
var bool m_bMemberSpawned;
var bool m_bIsROESwitchActive;
var bool m_bIsTeamBreachDoor;
var bool m_bTeamHasBeenTriggered;
var bool m_bBroadcastVisionCoverage;
var bool m_bIsRainbowAddedAsEnemyWhenSpawned;
var bool m_bIsClearSegListInitialized;
var bool m_bIsClearSegListReady;
var bool m_bRainbowSpotted;
var bool m_bCanGiveNegativeFeedback;
var bool m_bReplayHTEvents;
var bool m_bIsInTearGasRange;
var bool m_bIsInSmokeRange;
var bool m_bIsInDarkRange;
var bool m_bIsFirstStunReactionSet;
var bool m_bSearchGraphPathFound;
var bool m_bSearchGraphFlankCheck;
var array<sClearSegInfo> m_aCoverSegToClear;
var R6Pawn m_pawnTeamLeader;
var R6AIServiceManager m_pAIServiceManager;
var float m_fLastPeekOutOfCover;
var Vector m_vListDestinations[5];
var float m_fShortestDistance;
var Vector m_vLeadersLastPosition;
var Vector m_vLeaderPositionHistory[3];
var float m_fPositionTimer;
var int m_iNumPositionsCollected;
var Vector m_vLeaderDirection;
var array<Vector> m_aCornerPoI;
var array<RISKPOINT> m_RiskPoint;
var array<RISKPOINT> m_NewRiskPoints;
var int m_iNbRiskPointsChecked;
var Vector m_vTeamDirection;
var transient array<R6Pawn> sm_aOriginalMember;
var array<int> m_aAreaOfOperationIndexes;
var ENavMesh m_pAreaOfOperationNavMesh;
var float m_fTriggerTimer;
var float m_fTimeLeftBeforeTriggerSpawn;
var array<int> m_aExcludedZone;
var R6TeamActor m_pTeamActor;
var int m_iCurrentZone;
var int m_iPreviousZone;
var R6TeamTemplate m_pTeamTemplate;
var Class m_eTypeClass;
var array<R6SpawnPoint> m_aSpawnPoints;
var array<R6WavePoint> m_aWavePoints;
var array<R6TerroHuntPoint> m_aTerroHuntPoints;
var array<R6Wave> m_aWaves;
var array<R6SnipePoint> m_aSnipePoints;
var array<R6ActionSpot> m_aActionSpots;
var array<string> m_aExternalActionSpots;
var int m_iMaxSpawnedByFrame;
var float m_fTimeLeftBeforeNextCheck;
var int m_iNumPatrolLeftToAssign;
var array<sPatrol> m_aPatrols;
var int m_iMinAssignedToPatrols;
var int m_iMaxAssignedToPatrols;
var sAmbush m_sAmbush;
var array<R6TeamManager> m_aTeamWeHaveTheDropOn;
var array<sPotentialSearchTeam> m_aPotentialSearchTeam;
var float m_fTimeToDelaySearchStart;
var float m_fStuckTimer;
var R6ComputedCoverData_Ptr m_pComputedCoverData;
var R6ComputedCornerData_Ptr m_pComputedCornerData;
var R6ComputedFindPath_Ptr m_pComputedSafePathData;
var R6ComputedSearchData_Ptr m_pComputedSearchData;
var R6ComputedAmbushData_Ptr m_pComputedAmbushData;
var R6ComputedAdvanceData_Ptr m_pComputedAdvanceData;
var array<int> m_aFavoredRooms;
var array<Actor> m_aKnownCorpses;
var array<int> m_aActiveTeamSearchZone;
var array<RecordedHTEvents> m_aRecordedHTEvents;
var RecordedHTEvents m_LastCommunicatedEvent;
var array<R6Pawn> m_aHeardLastCommunicatedEvent;
var int m_iCheckpointIdx;
var R6GameInfo m_pCurrentGameInfo;
var int m_iNbTerroristSpawned;
var int m_iSearchGraphFinishZone;
var int m_iSearchGraphHotZone;
var int m_iSearchGraphSupressZone;
var array<int> m_aiSearchGraphStagingZone;

// Export UR6TeamManager::execInitTeamManager(FFrame&, void* const)
native function InitTeamManager();

// Export UR6TeamManager::execPawnReachedWaypoint(FFrame&, void* const)
native function PawnReachedWaypoint(R6Pawn pPawn, R6Waypoint pWaypoint);

// Export UR6TeamManager::execNotifyTeamManager(FFrame&, void* const)
native final function NotifyTeamManager(R6AIController pInstigatorController, EAIEvent pInstigatorEvent);

// Export UR6TeamManager::execSetTacticEntireTeam(FFrame&, void* const)
native final function SetTacticEntireTeam(Actor.ETacticType eTactic, bool bNoFeedBack);

// Export UR6TeamManager::execSendTeamCommunicateMessage(FFrame&, void* const)
native final function bool SendTeamCommunicateMessage(R6EngineEnums.ECommunicationTeamMessageType eMessageType, Actor.ETacticType eSuggestedTacticType, optional Vector vData, optional Actor actorLookAt, optional int iAmount, optional R6Pawn pOptionalPawn);

// Export UR6TeamManager::execGetNavObjIdx(FFrame&, void* const)
native final function int GetNavObjIdx(Actor pActor);

// Export UR6TeamManager::execRemovePawnFromTeam(FFrame&, void* const)
native function RemovePawnFromTeam(R6Pawn pPawn, optional bool bObsolete);

// Export UR6TeamManager::execHasAITeammates(FFrame&, void* const)
native final function bool HasAITeammates();

// Export UR6TeamManager::execToggleShowCoverResults(FFrame&, void* const)
native final function ToggleShowCoverResults();

// Export UR6TeamManager::execIsTeamInteracting(FFrame&, void* const)
native final function bool IsTeamInteracting();

// Export UR6TeamManager::execGetTeamNavObject(FFrame&, void* const)
native final function R6InteractiveActor GetTeamNavObject();

// Export UR6TeamManager::execIsATeammateIncapacitated(FFrame&, void* const)
native final function bool IsATeammateIncapacitated();

// Export UR6TeamManager::execIsATeammateStanding(FFrame&, void* const)
native final function bool IsATeammateStanding();

function OnR6KillTeam(SeqAct_R6KillTeam Action)
{
    local int I;

    // End:0x80
    if(Action.m_bStopWave)
    {
        I = 0;
        J0x19:

        // End:0x48 [Loop If]
        if(I < m_aWaves.Length)
        {
            m_aWaves[I].StopWave();
            ++I;
            // [Loop Continue]
            goto J0x19;
        }
        I = 0;
        J0x4F:

        // End:0x80 [Loop If]
        if(I < m_aWavePoints.Length)
        {
            m_aWavePoints[I].m_bToSpawn = false;
            ++I;
            // [Loop Continue]
            goto J0x4F;
        }
    }
    I = 0;
    J0x87:

    // End:0xB8 [Loop If]
    if(I < m_aSpawnPoints.Length)
    {
        m_aSpawnPoints[I].m_bToSpawn = false;
        ++I;
        // [Loop Continue]
        goto J0x87;
    }
    GotoState('s_KillTeam');
    return;
}

auto state Init
{
    function BeginState(name PreviousStateName)
    {
        InitTeamManager();
        GotoState('None');
        return;
    }
    stop;
}

simulated state s_KillTeam
{
    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(0.1000000, false);
        return;
    }

    simulated event Timer()
    {
        // End:0x2B
        if(m_aTeamMember.Length > 0)
        {
            m_aTeamMember[0].GotoState('s_Obsolete');
            SetTimer(0.1000000, false);
        }
        return;
    }
    stop;
}

defaultproperties
{
    m_eRiskPointMode=1
    m_iCurrentZone=-1
    m_iPreviousZone=-1
    m_iMaxSpawnedByFrame=1
    m_iNumPatrolLeftToAssign=-1
    m_iCheckpointIdx=-1
    bHidden=true
    bHiddenEd=true
    m_bDeleteOnReset=false
    Components=none
    TickGroup=1
    SupportedEvents=/* Array type was not detected. */
}