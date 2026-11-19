class R6ConquestGame extends R6TeamDeathmatchGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var array<R6InteractiveSatellite> m_arrSatellite;
var float m_fTotalControlWinTime;
var float m_fTotalControlEndTime;
var float m_fScoreToWin;
var float m_fScoreIncrement[4];
var float m_fUpdateScoreTime;
var float m_fUpdateScoreFrequency;

function UpdateScore()
{
    return;
}

function UpdateNumberOfControlledSatellites()
{
    local int iTeam;
    local R6GameReplicationInfo pR6GameRepInfo;

    pR6GameRepInfo = R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
    iTeam = 0;
    J0x29:

    // End:0x62 [Loop If]
    if(iTeam < 2)
    {
        pR6GameRepInfo.m_iConquestSatellite[iTeam] = GetNumberOfControlledSatellites(byte(iTeam));
        iTeam++;
        // [Loop Continue]
        goto J0x29;
    }
    return;
}

function AddControlledSatellite(PlayerReplicationInfo Scorer)
{
    UpdateNumberOfControlledSatellites();
    GetGameManager().m_StatisticsManager.IncrementMRICaptured(R6PlayerReplicationInfo(Scorer).m_iStatsPlayerID);
    return;
}

function int GetNumberOfControlledSatellites(R6GameEnums.ETEAMIDENTITY eTeam)
{
    local int iSatelliteIndex, iTotal;

    iSatelliteIndex = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(iSatelliteIndex < m_arrSatellite.Length)
    {
        // End:0x3C
        if(m_arrSatellite[iSatelliteIndex].IsControlledBy(eTeam))
        {
            iTotal++;
        }
        ++iSatelliteIndex;
        // [Loop Continue]
        goto J0x07;
    }
    return iTotal;
    return;
}

function bool IsTeamInTotalControl(R6GameEnums.ETEAMIDENTITY eTeam)
{
    return (GetNumberOfControlledSatellites(eTeam)) == m_arrSatellite.Length;
    return;
}

function CheckWinningConditions()
{
    local int iTeam;
    local R6GameReplicationInfo pR6GameRepInfo;

    pR6GameRepInfo = R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
    // End:0x7E
    if((pR6GameRepInfo != none) && pR6GameRepInfo.m_bConquestCountdownEnabled)
    {
        // End:0x7E
        if(WorldInfo.TimeSeconds >= m_fTotalControlEndTime)
        {
            // End:0x7E
            if(!bGameEnded)
            {
                EndGame(none, "missioncompleted");
            }
        }
    }
    // End:0xF0
    if(GoalScore > 0)
    {
        iTeam = 0;
        J0x90:

        // End:0xF0 [Loop If]
        if(iTeam < 2)
        {
            // End:0xE6
            if((m_Teams[iTeam].Score + 0.0010000) >= float(GoalScore))
            {
                // End:0xE6
                if(!bGameEnded)
                {
                    EndGame(none, "teamscorelimit");
                }
            }
            iTeam++;
            // [Loop Continue]
            goto J0x90;
        }
    }
    return;
}

event InitGame(string Options, out string ErrorMessage)
{
    m_iTimeLimitSeconds = 0;
    InitGame(Options, ErrorMessage);
    m_iTimeLimitSeconds = 0;
    return;
}

function MatchStarting()
{
    local R6InteractiveSatellite pSatellite;
    local int iIndex, iTotal, iRandom;
    local array<R6InteractiveSatellite> arrSatellite;

    // End:0x89
    foreach AllActors(Class'R6InteractiveSatellite', pSatellite)
    {
        iIndex = 0;
        J0x17:

        // End:0x5F [Loop If]
        if(iIndex < arrSatellite.Length)
        {
            // End:0x55
            if(int(arrSatellite[iIndex].m_eSatelliteIdentifier) == int(pSatellite.m_eSatelliteIdentifier))
            {
                // [Explicit Break]
                goto J0x5F;
            }
            ++iIndex;
            // [Loop Continue]
            goto J0x17;
        }
        J0x5F:

        // End:0x76
        if(iIndex == arrSatellite.Length)
        {
            iTotal++;
        }
        arrSatellite[arrSatellite.Length] = pSatellite;        
    }    
    m_arrSatellite.Remove(0, m_arrSatellite.Length);
    J0x97:

    // End:0x156 [Loop If]
    if(m_arrSatellite.Length < iTotal)
    {
        iRandom = Rand(arrSatellite.Length);
        pSatellite = arrSatellite[iRandom];
        iIndex = 0;
        J0xCD:

        // End:0x115 [Loop If]
        if(iIndex < m_arrSatellite.Length)
        {
            // End:0x10B
            if(int(m_arrSatellite[iIndex].m_eSatelliteIdentifier) == int(pSatellite.m_eSatelliteIdentifier))
            {
                // [Explicit Break]
                goto J0x115;
            }
            ++iIndex;
            // [Loop Continue]
            goto J0xCD;
        }
        J0x115:

        // End:0x153
        if(iIndex == m_arrSatellite.Length)
        {
            m_arrSatellite[m_arrSatellite.Length] = pSatellite;
            pSatellite.EnableSatellite();
            arrSatellite.Remove(iRandom, 1);
        }
        // [Loop Continue]
        goto J0x97;
    }
    iIndex = 0;
    J0x15D:

    // End:0x18D [Loop If]
    if(iIndex < arrSatellite.Length)
    {
        arrSatellite[iIndex].DisableSatellite();
        ++iIndex;
        // [Loop Continue]
        goto J0x15D;
    }
    UpdateNumberOfControlledSatellites();
    MatchStarting();
    return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return;
}

function bool IsValidSatellite(Actor pActor)
{
    local R6InteractiveSatellite pSatellite;

    pSatellite = R6InteractiveSatellite(pActor);
    return !pActor.m_bShutdown && (pSatellite != none) && pSatellite.m_bSatelliteEnabled;
    return;
}

function Interacted(R6InteractiveActor pActor, Pawn pPawn, bool bSuccess)
{
    local R6GameReplicationInfo pR6GameRepInfo;

    pR6GameRepInfo = R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
    // End:0x36
    if(int(GetGameStatus()) != int(5))
    {
        return;
    }
    // End:0x43
    if(!bSuccess)
    {
        return;
    }
    // End:0x56
    if(!IsValidSatellite(pActor))
    {
        return;
    }
    // End:0x138
    if((pPawn != none) && pPawn.PlayerReplicationInfo != none)
    {
        AddControlledSatellite(pPawn.PlayerReplicationInfo);
        // End:0x109
        if(IsTeamInTotalControl(pPawn.GetTeamNum()))
        {
            m_fTotalControlEndTime = m_fTotalControlWinTime + WorldInfo.TimeSeconds;
            pR6GameRepInfo.m_iConquestCountdown = int(m_fTotalControlWinTime);
            BroadcastGameMessage(Class'R6ConquestGameMessage', 35, pPawn.PlayerReplicationInfo);
            pR6GameRepInfo.m_bConquestCountdownEnabled = false;            
        }
        else
        {
            BroadcastGameMessage(Class'R6ConquestGameMessage', 34, pPawn.PlayerReplicationInfo);
            pR6GameRepInfo.m_bConquestCountdownEnabled = false;
        }
    }
    CheckWinningConditions();
    return;
}

state s_MatchInProgress
{
    function BeginState(name PreviousStateName)
    {
        m_iTimeLimitSeconds = 0;
        BeginState(PreviousStateName);
        m_iTimeLimitSeconds = 0;
        m_fUpdateScoreTime = WorldInfo.TimeSeconds;
        return;
    }

    function UpdateScore()
    {
        local int iNumSatellites, iTeam;

        iTeam = 0;
        J0x07:

        // End:0xC1 [Loop If]
        if(iTeam < 2)
        {
            iNumSatellites = GetNumberOfControlledSatellites(byte(iTeam));
            // End:0xB7
            if(iNumSatellites > 0)
            {
                m_Teams[iTeam].Score += m_fScoreIncrement[iNumSatellites];
                // End:0x8F
                if(m_Teams[iTeam].Score > float(GoalScore))
                {
                    m_Teams[iTeam].Score = float(GoalScore);
                }
                m_Teams[iTeam].NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            }
            iTeam++;
            // [Loop Continue]
            goto J0x07;
        }
        m_fUpdateScoreTime = m_fUpdateScoreTime + m_fUpdateScoreFrequency;
        return;
    }

    function Tick(float DeltaTime)
    {
        local R6GameReplicationInfo pR6GameRepInfo;

        pR6GameRepInfo = R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
        // End:0x92
        if((pR6GameRepInfo != none) && pR6GameRepInfo.m_bConquestCountdownEnabled)
        {
            pR6GameRepInfo.m_iConquestCountdown = int(m_fTotalControlEndTime - WorldInfo.TimeSeconds);
            // End:0x8B
            if(pR6GameRepInfo.m_iConquestCountdown < 0)
            {
                pR6GameRepInfo.m_iConquestCountdown = 0;
            }
            CheckWinningConditions();
        }
        // End:0xB8
        if(m_fUpdateScoreTime < WorldInfo.TimeSeconds)
        {
            UpdateScore();
            CheckWinningConditions();
        }
        Tick(DeltaTime);
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x4A
        if(R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo).m_bConquestCountdownEnabled = false;
        }
        EndState(NextStateName);
        return;
    }

    function bool TimeHasExpired()
    {
        return false;
        return;
    }
    stop;
}

defaultproperties
{
    m_fTotalControlWinTime=20.0000000
    m_fScoreIncrement[1]=5.0000000
    m_fScoreIncrement[2]=15.0000000
    m_fScoreIncrement[3]=25.0000000
    m_fUpdateScoreFrequency=1.0000000
    m_byKillTeamScore=0
    GameDescription="TO WIN, YOUR TEAM MUST CAPTURE AND HOLD UP TO THREE MOBILE RADAR INSTALLATIONS UNTIL THE MAXIMUM NUMBER OF UPLINK POINTS IS REACHED."
    GameName="CONQUEST"
}