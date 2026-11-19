class R6DeathmatchGame extends R6MultiPlayerGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var config int m_iGoalKills;
var config int m_iTimeMatchStarting;

event InitGame(string Options, out string ErrorMessage)
{
    InitGame(Options, ErrorMessage);
    m_iGoalKills = int(FMax(0.0000000, float(GetIntOption(Options, "GKL", m_iGoalKills))));
    m_iTimeMatchStarting = int(FMax(0.0000000, float(GetIntOption(Options, "TB", m_iTimeMatchStarting))));
    return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    GetServerDetails(ServerState);
    AddServerDetail(ServerState, "GKL", string(m_iGoalKills));
    AddServerDetail(ServerState, "TB", string(m_iTimeMatchStarting));
    return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x11
    if(CheckLives(Scorer))
    {
        return false;
    }
    // End:0xCB
    if(Scorer != none)
    {
        // End:0x74
        if((m_bAllowRespawn && m_iGoalKills > 0) && Scorer.Kills >= m_iGoalKills)
        {
            // End:0x71
            if(!bGameEnded)
            {
                EndGame(Scorer, "killslimit");
                return true;
            }            
        }
        else
        {
            // End:0xCB
            if((m_bAllowRespawn && GoalScore > 0) && Scorer.Score >= float(GoalScore))
            {
                // End:0xCB
                if(!bGameEnded)
                {
                    EndGame(Scorer, "scorelimit");
                    return true;
                }
            }
        }
    }
    return false;
    return;
}

function bool CheckLives(PlayerReplicationInfo Scorer)
{
    local R6PlayerController PC;
    local PlayerReplicationInfo Living;
    local bool bNobobyLeft;

    // End:0x2C
    if((Scorer != none) && !Scorer.bOutOfLives)
    {
        Living = Scorer;
    }
    bNobobyLeft = true;
    // End:0xF5
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0xF4
        if((((PC != none) && PC.PlayerReplicationInfo != none) && !PC.PlayerReplicationInfo.bOutOfLives) && !PC.PlayerReplicationInfo.bOnlySpectator)
        {
            // End:0xD1
            if(Living == none)
            {
                Living = PC.PlayerReplicationInfo;
                // End:0xF4
                continue;
            }
            // End:0xF4
            if(PC.PlayerReplicationInfo != Living)
            {
                bNobobyLeft = false;
                // End:0xF5
                break;
            }
        }        
    }    
    // End:0x14C
    if(!bGameEnded && bNobobyLeft)
    {
        // End:0x132
        if(Living != none)
        {
            EndGame(Living, "lastplayer");            
        }
        else
        {
            EndGame(Scorer, "lastplayer");
        }
        return true;
    }
    return false;
    return;
}

function ScoreKill(Controller Killer, Controller other)
{
    local R6PlayerReplicationInfo pKillerInfo;

    // End:0x90
    if(Killer == other)
    {
        // End:0x8D
        if(Killer.PlayerReplicationInfo.Kills > 0)
        {
            Killer.PlayerReplicationInfo.Score -= float(1);
            Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            Killer.PlayerReplicationInfo.Kills -= 1;
        }        
    }
    else
    {
        // End:0x112
        if((Killer != none) && Killer.PlayerReplicationInfo != none)
        {
            Killer.PlayerReplicationInfo.Score += float(1);
            Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            Killer.PlayerReplicationInfo.Kills += 1;
        }
    }
    // End:0x136
    if(Killer != none)
    {
        pKillerInfo = R6PlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }
    // End:0x15E
    if(pKillerInfo != none)
    {
        pKillerInfo.m_iKills = pKillerInfo.Kills;
    }
    // End:0x19F
    if(((Killer != none) || MaxLives > 0) && other.bIsPlayer)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    // End:0x1CA
    if(!bGameEnded && other.bIsPlayer)
    {
        CheckLives(pKillerInfo);
    }
    return;
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    // End:0x121
    if(((((((((Reason ~= "quitgame") || Reason ~= "lastplayer") || Reason ~= "timelimit") || Reason ~= "scorelimit") || Reason ~= "killslimit") || Reason ~= "teamscorelimit") || Reason ~= "teamkillslimit") || Reason ~= "missioncompleted") || Reason ~= "missionaborted")
    {
        EndGame(Winner, Reason);
        // End:0x121
        if(bGameEnded)
        {
            // End:0x117
            if(m_iRounds > 0)
            {
                GotoState('s_MatchRoundEnd');                
            }
            else
            {
                GotoState('s_MatchEnd');
            }
        }
    }
    return;
}

function CheckForAwardDeathMatch()
{
    local R6PlayerController PC;
    local R6GameReplicationInfo pR6GameRepInfo;

    pR6GameRepInfo = R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
    // End:0x107
    if(m_bRankedGame && pR6GameRepInfo != none)
    {
        // End:0x106
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0x105
            if((PC != none) && pR6GameRepInfo.IsAWinner(PC))
            {
                // End:0xA6
                if(int(pR6GameRepInfo.m_eCurrentGameMode) == int(2))
                {
                    PC.ClientGiveAward(7);
                    // End:0x105
                    continue;
                }
                // End:0x105
                if(((int(pR6GameRepInfo.m_eCurrentGameMode) == int(3)) && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.Kills > 0)
                {
                    PC.ClientGiveAward(8);
                }
            }            
        }        
    }
    return;
}

function CheckForAwards()
{
    CheckForAwards();
    CheckForAwardDeathMatch();
    return;
}

function ReceivedInputReady(PlayerReplicationInfo pPlayerInfo)
{
    ReceivedInputReady(pPlayerInfo);
    // End:0x91
    if(pPlayerInfo != none)
    {
        // End:0x91
        if(int(GetGameStatus()) == int(4))
        {
            R6PlayerController(pPlayerInfo.Owner).SetPlayerReady(true);
            R6PlayerController(pPlayerInfo.Owner).EnterObserverMode();
            R6PlayerController(pPlayerInfo.Owner).WaitDelay = WorldInfo.TimeSeconds;
        }
    }
    return;
}

state s_MatchStarting
{
    function int GetCountDownLength()
    {
        return m_iTimeMatchStarting;
        return;
    }
    stop;
}

defaultproperties
{
    m_iTimeMatchStarting=5
    m_iRounds=3
    m_iTimeLimitSeconds=180
    m_iTimeBetweenRound=10
    GameDescription="ELIMINATE ALL THE ENEMIES."
    bDelayedStart=true
    GameName="SURVIVAL"
}