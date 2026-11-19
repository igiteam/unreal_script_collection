class R6AssassinationGame extends R6TeamDeathmatchGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var R6PlayerController m_pPilotController;
var R6ObjectiveEscortPawn m_pObjective;
var R6GameEnums.EGAMEMSG m_eRoundEndMessage;
var R6GameEnums.EGAMEMSG m_eMatchEndMessage;
var class<LocalMessage> AssassinationGameMessageClass;

// Export UR6AssassinationGame::execGetAttackingTeam(FFrame&, void* const)
native final function R6GameEnums.ETEAMIDENTITY GetAttackingTeam();

// Export UR6AssassinationGame::execGetDefendingTeam(FFrame&, void* const)
native final function R6GameEnums.ETEAMIDENTITY GetDefendingTeam();

function StartRadarSignal()
{
    local R6ExtractionZone PZone;

    // End:0x70
    foreach AllActors(Class'R6ExtractionZone', PZone)
    {
        // End:0x6F
        if(!PZone.m_bShutdown)
        {
            PZone.EnableRadarSignal(true);
            PZone.m_pRadarInfo.SetObjectiveType(12);
            PZone.m_pRadarInfo.AssignTeam(GetDefendingTeam());
        }        
    }    
    return;
}

function StopRadarSignal()
{
    local R6ExtractionZone PZone;

    // End:0x22
    foreach AllActors(Class'R6ExtractionZone', PZone)
    {
        PZone.EnableRadarSignal(false);        
    }    
    return;
}

function BroadcastPilotMessage()
{
    // End:0x29
    if(m_pPilotController != none)
    {
        BroadcastGameMessage(Class'R6AssassinationGameMessage', 43, m_pPilotController.PlayerReplicationInfo);
    }
    return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    StopRadarSignal();
    return;
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    // End:0x2C
    if((R6PlayerController(C) != none) && R6PlayerController(C) == m_pPilotController)
    {
        return Class'R6VIPPawn';
    }
    return GetDefaultPlayerClass(C);
    return;
}

function MatchStarting()
{
    local PlayerController PC;
    local int iCount, iPilot;

    MatchStarting();
    // End:0x4A
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x49
        if(int(PC.GetTeamNum()) == int(GetDefendingTeam()))
        {
            iCount++;
        }        
    }    
    iPilot = Rand(iCount);
    // End:0xC1
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xC0
        if(int(PC.GetTeamNum()) == int(GetDefendingTeam()))
        {
            iCount = iCount - 1;
            // End:0xC0
            if(iPilot == iCount)
            {
                m_pPilotController = R6PlayerController(PC);
            }
        }        
    }    
    StartRadarSignal();
    SetTimer(10.0000000, false, 'BroadcastPilotMessage');
    return;
}

function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
{
    RestartPlayer(NewPlayer, ForcedPawn);
    // End:0x44
    if(NewPlayer == m_pPilotController)
    {
        m_pObjective.SetPawnToExtract(R6Pawn(m_pPilotController.Pawn));
    }
    return;
}

function CreateInitialObjectives()
{
    m_pObjective = __NFUN_278__(Class'R6ObjectiveEscortPawn');
    m_ObjectiveManager.AddObjective(m_pObjective);
    m_pObjective.SetPawnToExtract(none);
    return;
}

function OnObjectiveFailed(R6Objective pObjective)
{
    BroadcastGameMessage(Class'R6AssassinationGameMessage', 39);
    // End:0x34
    if(!bGameEnded)
    {
        EndGame(none, "missionaborted");
    }
    return;
}

function OnObjectiveSucceeded(R6Objective pObjective)
{
    BroadcastGameMessage(Class'R6AssassinationGameMessage', 37);
    // End:0x36
    if(!bGameEnded)
    {
        EndGame(none, "missioncompleted");
    }
    return;
}

defaultproperties
{
    AssassinationGameMessageClass=Class'R6AssassinationGameMessage'
    m_szCustomTeamInfoClass[0]="R6Game.R6TeamAttackDefendBInfo"
    m_szCustomTeamInfoClass[1]="R6Game.R6TeamAttackDefendAInfo"
    GameDescription="ONE TEAM LEADS A VIP TO EXTRACTION, WHILE THE OTHER TEAM ATTEMPTS TO ASSASSINATE THE VIP."
    GameName="ASSASSINATION"
}