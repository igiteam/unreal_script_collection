class R6RetrievalGame extends R6TeamDeathmatchGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

const MAX_RETRIEVALOBJECTIVE_SCORE = 10;
const MAX_CARRIEDOBJECT_DROPTIME = 30.0f;

var R6Canister m_pCanister;
var R6RadarObjectiveRepInfo m_pRadarInfo;
var float m_fCanisterTimer;
var config float m_fCanisterTimeOut;

event InitGame(string Options, out string ErrorMessage)
{
    local R6InteractiveDepotStation pStation;
    local R6Canister pCanister;

    InitGame(Options, ErrorMessage);
    // End:0x47
    foreach AllActors(Class'R6InteractiveDepotStation', pStation)
    {
        // End:0x46
        if(!pStation.m_bShutdown)
        {
            pStation.EnableRadarDetection(true);
        }        
    }    
    // End:0x9B
    if(m_pCanister == none)
    {
        // End:0x9A
        foreach AllActors(Class'R6Canister', pCanister)
        {
            // End:0x99
            if(!pCanister.m_bShutdown)
            {
                m_pCanister = pCanister;
                m_pCanister.m_fMaxDropTime = 30.0000000;
                // End:0x9A
                break;
            }            
        }        
    }
    return;
}

function MatchStarting()
{
    StartRadarSignal();
    return;
}

event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    // End:0xA0
    if(((int(GetGameStatus()) == int(5)) && m_pCanister != none) && m_pCanister.m_pCarrier != none)
    {
        m_fCanisterTimer += DeltaTime;
        // End:0xA0
        if(m_fCanisterTimer > (m_fCanisterTimeOut + float(Class'R6RetrievalGameMessage'.default.Lifetime)))
        {
            m_fCanisterTimer = 0.0000000;
            BroadcastGameMessage(Class'R6RetrievalGameMessage', 47, m_pCanister.m_pCarrier.PlayerReplicationInfo);
        }
    }
    return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return;
}

function taken(R6CarriedObject pObject)
{
    local R6InteractiveDepotStation pStation;

    // End:0x14
    if(int(GetGameStatus()) != int(5))
    {
        return;
    }
    // End:0x27
    if(!IsValidItem(pObject))
    {
        return;
    }
    // End:0xE4
    if((int(R6GameInfo(WorldInfo.Game).GetGameStatus()) == int(5)) && pObject.m_pCarrier != none)
    {
        pObject.m_pCarrier.PlayerReplicationInfo.bHasFlag = true;
        pObject.m_pCarrier.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        BroadcastGameMessage(Class'R6RetrievalGameMessage', 34, pObject.m_pCarrier.PlayerReplicationInfo);
    }
    // End:0x12E
    if((m_pRadarInfo != none) && pObject.m_pCarrier != none)
    {
        m_pRadarInfo.AssignTeam(pObject.m_pCarrier.GetTeamNum());
    }
    // End:0x194
    foreach AllActors(Class'R6InteractiveDepotStation', pStation)
    {
        // End:0x193
        if(!pStation.m_bShutdown && WorldInfo.GRI.OnSameTeam(pStation, pObject.m_pCarrier))
        {
            pStation.StartRadarSignal();
        }        
    }    
    return;
}

function Dropped(R6CarriedObject pObject)
{
    local R6InteractiveDepotStation pStation;

    // End:0x14
    if(int(GetGameStatus()) != int(5))
    {
        return;
    }
    // End:0x27
    if(!IsValidItem(pObject))
    {
        return;
    }
    // End:0x92
    if(pObject.m_pCarrier != none)
    {
        pObject.m_pCarrier.PlayerReplicationInfo.bHasFlag = false;
        pObject.m_pCarrier.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    }
    // End:0xAF
    if(m_pRadarInfo != none)
    {
        m_pRadarInfo.AssignTeam(2);
    }
    BroadcastGameMessage(Class'R6RetrievalGameMessage', 36);
    // End:0x126
    foreach AllActors(Class'R6InteractiveDepotStation', pStation)
    {
        // End:0x125
        if(!pStation.m_bShutdown && WorldInfo.GRI.OnSameTeam(pStation, pObject.m_pCarrier))
        {
            pStation.StopRadarSignal();
        }        
    }    
    return;
}

function Respawned(R6CarriedObject pObject)
{
    local R6InteractiveDepotStation pStation;

    // End:0x13
    if(!IsValidItem(pObject))
    {
        return;
    }
    // End:0x7E
    if(pObject.m_pCarrier != none)
    {
        pObject.m_pCarrier.PlayerReplicationInfo.bHasFlag = false;
        pObject.m_pCarrier.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    }
    // End:0x9B
    if(m_pRadarInfo != none)
    {
        m_pRadarInfo.AssignTeam(2);
    }
    // End:0xD0
    foreach AllActors(Class'R6InteractiveDepotStation', pStation)
    {
        // End:0xCF
        if(!pStation.m_bShutdown)
        {
            pStation.StopRadarSignal();
        }        
    }    
    return;
}

function Interacted(R6InteractiveActor pActor, Pawn pPawn, bool bSuccess)
{
    local PlayerReplicationInfo pScorer;
    local R6PlayerController pPCScorer;

    // End:0x14
    if(int(GetGameStatus()) != int(5))
    {
        return;
    }
    // End:0x21
    if(!bSuccess)
    {
        return;
    }
    // End:0x34
    if(!IsValidDepotStation(pActor))
    {
        return;
    }
    // End:0xCF
    if(IsValidCarrier(pPawn))
    {
        pScorer = pPawn.PlayerReplicationInfo;
        pPCScorer = R6PlayerController(pPawn.Controller);
        // End:0x8A
        if(pPCScorer != none)
        {
            pPCScorer.ClientOnCanisterReturned();
        }
        pPawn.PlayerReplicationInfo.bHasFlag = false;
        pPawn.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    }
    BroadcastGameMessage(Class'R6RetrievalGameMessage', 25, pScorer);
    ScoreObjective(pScorer, 10);
    return;
}

function AddObjectiveScore(PlayerReplicationInfo Scorer, int Score)
{
    // End:0x5F
    if((Scorer != none) && Scorer.Team != none)
    {
        Scorer.Team.Score += float(Score);
        R6TeamInfo(Scorer.Team).m_iObjects++;
    }
    GetGameManager().m_StatisticsManager.IncrementCanisters(R6PlayerReplicationInfo(Scorer).m_iStatsPlayerID);
    AddObjectiveScore(Scorer, Score);
    return;
}

function ResetGameInfo()
{
    StopRadarSignal();
    ResetGameInfo();
    return;
}

function bool IsValidItem(R6CarriedObject pItem)
{
    local R6Canister pCarriedItem;

    // End:0x1B
    if(pItem != none)
    {
        pCarriedItem = R6Canister(pItem);
    }
    return ((pCarriedItem != none) && pCarriedItem.m_bShutdown == false) && pCarriedItem == m_pCanister;
    return;
}

function bool IsValidDepotStation(R6InteractiveActor pActor)
{
    local R6InteractiveDepotStation pDepotStation;

    pDepotStation = R6InteractiveDepotStation(pActor);
    return (pDepotStation != none) && !pDepotStation.m_bShutdown;
    return;
}

function bool IsValidCarrier(Pawn pPawn)
{
    local R6Pawn pCarrierPawn;

    pCarrierPawn = R6Pawn(pPawn);
    return ((pCarrierPawn != none) && pCarrierPawn.PlayerReplicationInfo != none) && pCarrierPawn.PlayerReplicationInfo.bHasFlag;
    return;
}

function StartRadarSignal()
{
    // End:0x50
    if(m_pCanister != none)
    {
        // End:0x50
        if(m_pRadarInfo == none)
        {
            m_pRadarInfo = __NFUN_278__(Class'R6RadarObjectiveRepInfo');
            m_pRadarInfo.Init(m_pCanister);
            m_pRadarInfo.m_eObjectiveType = 9;
        }
    }
    return;
}

function StopRadarSignal()
{
    // End:0x1E
    if(m_pRadarInfo != none)
    {
        m_pRadarInfo.Destroy();
        m_pRadarInfo = none;
    }
    return;
}

defaultproperties
{
    m_fCanisterTimeOut=30.0000000
    m_byKillScore=0
    m_bAllowRespawn=true
    GameDescription="TO SCORE A POINT, RETRIEVE THE CANISTER AND DELIVER IT TO YOUR TEAM'S DEPOT STATION."
    GameName="RETRIEVAL"
    MaxLives=0
}