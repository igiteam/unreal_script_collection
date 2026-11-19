class R6TerroristHuntGame extends R6SinglePlayerGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

const SETTING_TEAMTYPE = "TT";

var R6ObjectiveTerroristHunt m_pMainObjective;
var bool m_bPecDirty;

event InitGame(string Options, out string ErrorMessage)
{
    local int iDensity, iPlayWithTeammates;
    local R6PlayerStart PlayerStart;

    InitGame(Options, ErrorMessage);
    iDensity = int(FMax(0.0000000, float(GetIntOption(Options, "HD", int(Class'R6ObjectiveTerroristHunt'.default.m_eTerroDensity)))));
    m_pMainObjective.m_eTerroDensity = byte(iDensity);
    iPlayWithTeammates = int(FMax(0.0000000, float(GetIntOption(Options, "TT", 0))));
    // End:0xBD
    if(int(byte(iPlayWithTeammates)) == int(1))
    {
        // End:0xBC
        foreach DynamicActors(Class'R6PlayerStart', PlayerStart)
        {
            PlayerStart.m_TeammateStarts.Remove(0, PlayerStart.m_TeammateStarts.Length);            
        }        
    }
    return;
}

function PostBeginPlay()
{
    PostBeginPlay();
    return;
}

function CreateInitialObjectives()
{
    CreateInitialObjectives();
    m_pMainObjective = __NFUN_278__(Class'R6ObjectiveTerroristHunt');
    // End:0x3B
    if(m_pMainObjective != none)
    {
        m_ObjectiveManager.AddObjective(m_pMainObjective);
    }
    return;
}

function OnObjectiveSucceeded(R6Objective pObjective)
{
    SendStatistics();
    PushState('BetweenMatchAndResult');
    return;
}

function DisplaySucceededScreen()
{
    local R6PlayerController pR6PC;

    // End:0x5C
    if(!m_ObjectiveManager.IsMissionFailed())
    {
        pR6PC = R6PlayerController(GetGameManager().GetLocalPlayer());
        // End:0x5C
        if(pR6PC != none)
        {
            pR6PC.ShowMissionSuccess();
            pR6PC.OnMissionComplete();
        }
    }
    // End:0x8B
    if(GetGameManager().m_StatisticsManager != none)
    {
        GetGameManager().m_StatisticsManager.Reset();
    }
    return;
}

event OnObjectiveFailed(R6Objective pObjective)
{
    OnObjectiveFailed(pObjective);
    SendStatistics();
    // End:0x42
    if(GetGameManager().m_StatisticsManager != none)
    {
        GetGameManager().m_StatisticsManager.Reset();
    }
    return;
}

function StartMatch()
{
    local R6PlayerController PC;
    local R6PECAssetManager AssMan;

    AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
    // End:0xA1
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0xA0
        if(PC != none)
        {
            // End:0x6A
            if(m_bPecDirty)
            {
                PC.UpdatePecInformation();
                PC.StartPoolVolatilePECAssets();
            }
            AddPlayersToStatistics();
            // End:0xA0
            if(GetGameManager().m_StatisticsManager != none)
            {
                GetGameManager().m_StatisticsManager.StartRound();
            }
        }        
    }    
    // End:0xE3
    if(m_bPecDirty)
    {
        AssMan.BeginSynchronization();
        AssMan.LoadInGameAssets();
        AssMan.EndSynchronization();
        m_bPecDirty = false;
    }
    m_pMainObjective.ResetTerrorists(true);
    StartMatch();
    return;
}

function AddPlayersToStatistics()
{
    local R6PlayerReplicationInfo r6RepInfo;
    local R6PlayerController PC;
    local int iCounter;

    iCounter = 1;
    // End:0x1E
    if(GetGameManager().m_StatisticsManager == none)
    {
        return;
    }
    // End:0x13C
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        r6RepInfo = R6PlayerReplicationInfo(PC.PlayerReplicationInfo);
        // End:0x8A
        if(Len(r6RepInfo.m_xuid) == 0)
        {
            r6RepInfo.m_xuid = "" @ string(iCounter);
            iCounter++;
        }
        // End:0x13B
        if(!GetGameManager().m_StatisticsManager.DoesPlayerExist(r6RepInfo.m_xuid))
        {
            r6RepInfo.m_iStatsPlayerID = GetGameManager().m_StatisticsManager.AddPlayer(r6RepInfo.m_xuid, r6RepInfo.PlayerName);
            GetGameManager().m_StatisticsManager.ChangedWeapon(r6RepInfo.m_iStatsPlayerID, PC.m_R6Pawn.Weapon);
        }        
    }    
    return;
}

function SendStatistics()
{
    // End:0x17
    if(GetGameManager().m_StatisticsManager == none)
    {
        return;
    }
    GetGameManager().m_StatisticsManager.EndRound();
    return;
}

function InitCharacterTemplateFromStartSpot(Pawn PawnToInit, NavigationPoint StartSpot)
{
    return;
}

state BetweenMatchAndResult
{Begin:

    Sleep(2.0000000);
    DisplaySucceededScreen();
    PopState();
    stop;    
}

defaultproperties
{
    m_bPecDirty=true
    GameDescription="FIND AND ELIMINATE ALL TERRORISTS IN THE MISSION AREA"
    DefaultPawnClass=Class'R6PlayerPawn'
    GameName="TERRORIST HUNT"
}