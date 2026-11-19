class R6CoopTerroristHuntGame extends R6CooperativeGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var R6ObjectiveTerroristHunt m_pObjective;

event InitGame(string Options, out string ErrorMessage)
{
    local int iDensity;

    InitGame(Options, ErrorMessage);
    m_bAllowRespawn = false;
    MaxLives = 1;
    iDensity = int(FMax(0.0000000, float(GetIntOption(Options, "HD", int(Class'R6ObjectiveTerroristHunt'.default.m_eTerroDensity)))));
    m_pObjective.m_eTerroDensity = byte(iDensity);
    return;
}

function CreateInitialObjectives()
{
    m_pObjective = __NFUN_278__(Class'R6ObjectiveTerroristHunt');
    // End:0x34
    if(m_pObjective != none)
    {
        m_ObjectiveManager.AddObjective(m_pObjective);
    }
    return;
}

event PostLogin(PlayerController NewPlayer)
{
    PostLogin(NewPlayer);
    // End:0x63
    if(NewPlayer != none)
    {
        // End:0x63
        if(int(GetGameStatus()) == int(5))
        {
            // End:0x63
            if((m_pObjective != none) && m_pObjective.AllTerroristsEliminated())
            {
                NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
            }
        }
    }
    return;
}

function OnObjectiveSucceeded(R6Objective pObjective)
{
    // End:0x11
    if(pObjective != m_pObjective)
    {
        return;
    }
    // End:0x36
    if(!bGameEnded)
    {
        EndGame(none, "missioncompleted");
    }
    return;
}

state s_MatchInProgress
{
    function Timer()
    {
        Timer();
        return;
    }

    function Tick(float fDeltaTime)
    {
        Tick(fDeltaTime);
        return;
    }
    stop;
}

state s_MatchBetweenRound
{
    function BeginState(name NextStateName)
    {
        BeginState(NextStateName);
        m_pObjective.ResetTerrorists(true);
        return;
    }
    stop;
}

defaultproperties
{
    m_bAllowRespawn=true
    m_iTimeBetweenRound=10
    GameDescription="FIND AND ELIMINATE ALL TERRORISTS IN THE MISSION AREA"
    GameName="COOP TERRORIST HUNT"
    MaxLives=0
}