class R6AttackDefendGame extends R6TeamDeathmatchGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var array< class<R6ObjectiveBasicMP> > m_SupportedMissionType;
var R6GameEnums.ETEAMIDENTITY m_eCurrentAttackingTeam;
var R6ObjectiveBasicMP m_pObjective;

// Export UR6AttackDefendGame::execRetrieveMissionType(FFrame&, void* const)
native function int RetrieveMissionType();

event InitGame(string Options, out string ErrorMessage)
{
    InitGame(Options, ErrorMessage);
    return;
}

function CreateInitialObjectives()
{
    local R6Objective pObjective;
    local int iType;

    iType = RetrieveMissionType();
    // End:0x1E
    if(iType == -1)
    {
        return;
    }
    pObjective = __NFUN_278__(m_SupportedMissionType[iType]);
    // End:0x58
    if(pObjective != none)
    {
        m_ObjectiveManager.AddObjective(pObjective);
    }
    return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return;
}

function AddObjectiveScore(PlayerReplicationInfo Scorer, int Score)
{
    AddObjectiveScore(Scorer, Score);
    return;
}

function OnObjectiveFailed(R6Objective pObjective)
{
    local R6ObjectiveHostageRescue pHRObj;
    local R6PlayerController P;

    // End:0x118
    if(m_ObjectiveManager.IsMissionFailed())
    {
        // End:0x118
        if(!bGameEnded)
        {
            pHRObj = R6ObjectiveHostageRescue(m_pObjective);
            // End:0x100
            if((pHRObj != none) && pHRObj.m_HostageKiller != none)
            {
                // End:0xFC
                foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
                {
                    // End:0xFB
                    if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team != none) && P.PlayerReplicationInfo.Team != pHRObj.m_HostageKiller.Team)
                    {
                        EndGame(P.PlayerReplicationInfo, "missionaborted");
                        // End:0xFC
                        break;
                    }                    
                }                                
            }
            else
            {
                EndGame(none, "missionaborted");
            }
        }
    }
    return;
}

function OnObjectiveSucceeded(R6Objective pObjective)
{
    local R6ObjectiveBasicMP pMPObjective;

    pMPObjective = R6ObjectiveBasicMP(pObjective);
    // End:0x1D
    if(pMPObjective == none)
    {
        return;
    }
    ScoreObjective(pMPObjective.m_pScorer, pMPObjective.m_iScore);
    // End:0xE0
    if(pMPObjective != none)
    {
        // End:0x97
        if(pMPObjective.IsA('R6ObjectiveExtractionItem'))
        {
            GetGameManager().m_StatisticsManager.IncrementBriefcases(R6PlayerReplicationInfo(pMPObjective.m_pScorer).m_iStatsPlayerID);            
        }
        else
        {
            // End:0xE0
            if(pMPObjective.IsA('R6ObjectiveBomb'))
            {
                GetGameManager().m_StatisticsManager.IncrementBombs(R6PlayerReplicationInfo(pMPObjective.m_pScorer).m_iStatsPlayerID);
            }
        }
    }
    // End:0x105
    if(!bGameEnded)
    {
        EndGame(none, "missioncompleted");
    }
    return;
}

function OnObjectiveRegistered(R6Objective pObjective)
{
    local R6ObjectiveBasicMP pMPObjective;

    pMPObjective = R6ObjectiveBasicMP(pObjective);
    // End:0x1D
    if(pMPObjective == none)
    {
        return;
    }
    m_pObjective = pMPObjective;
    // End:0x48
    if(m_pObjective != none)
    {
        m_pObjective.SetTeamNum(m_eCurrentAttackingTeam);
    }
    return;
}

function taken(R6CarriedObject pObject)
{
    // End:0x20
    if(m_pObjective != none)
    {
        m_pObjective.OnTaken(pObject);
    }
    return;
}

function Dropped(R6CarriedObject pObject)
{
    // End:0x20
    if(m_pObjective != none)
    {
        m_pObjective.OnDropped(pObject);
    }
    return;
}

function Respawned(R6CarriedObject pObject)
{
    // End:0x20
    if(m_pObjective != none)
    {
        m_pObjective.OnRespawned(pObject);
    }
    return;
}

function Interacted(R6InteractiveActor pActor, Pawn pPawn, bool bSuccess)
{
    // End:0x2B
    if(m_pObjective != none)
    {
        m_pObjective.OnInteracted(pActor, pPawn, bSuccess);
    }
    return;
}

function Exploded(R6InteractiveBomb pBomb)
{
    // End:0x20
    if(m_pObjective != none)
    {
        m_pObjective.OnExploded(pBomb);
    }
    return;
}

function PawnInteracted(R6Pawn pPawn, Pawn pInteractor, bool bSuccess)
{
    // End:0x2B
    if(m_pObjective != none)
    {
        m_pObjective.OnPawnInteracted(pPawn, pInteractor, bSuccess);
    }
    return;
}

event OnHostagesSpawned()
{
    LogInternal("R6AttackDefendGame::OnHostagesSpawned()");
    // End:0x48
    if(m_pObjective != none)
    {
        m_pObjective.OnHostagesSpawned();
    }
    return;
}

state s_MatchInProgress
{
    function bool TimeHasExpired()
    {
        // End:0x45
        if(((m_pObjective != none) && m_pObjective.GetTimer() != -1) && m_pObjective.GetTimer() == m_iTimeLimitSeconds)
        {
            return false;
        }
        return (m_iTimeLimitSeconds > 0) && (GetRemainingTime()) <= 0;
        return;
    }
    stop;
}

defaultproperties
{
    m_SupportedMissionType[0]=Class'R6ObjectiveBomb'
    m_SupportedMissionType[1]=Class'R6ObjectiveExtractionItem'
    m_SupportedMissionType[2]=Class'R6ObjectiveHostageRescue'
    m_szCustomTeamInfoClass[0]="R6Game.R6TeamAttackDefendAInfo"
    m_szCustomTeamInfoClass[1]="R6Game.R6TeamAttackDefendBInfo"
    m_bAllowRespawn=true
    m_iTimeLimitSeconds=900
    GameDescription="COMPLETE FINAL OBJECTIVE"
    GameName="ATTACK & DEFEND"
    MaxLives=0
}