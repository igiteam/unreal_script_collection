class R6TeamDeathmatchGame extends R6DeathmatchGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

const MAX_TEAM = 2;

var string m_szDefaultTeamInfoClass;
var string m_szCustomTeamInfoClass[2];
var R6TeamInfo m_Teams[2];
var array<R6TeamSpawnZone> m_arrSpawnZones;
var config bool m_bBalanceTeams;
var config bool m_bLockTeams;
var config bool m_bAllowTeamRespawn;
var byte m_byKillScore;
var byte m_byKillTeamScore;

// Export UR6TeamDeathmatchGame::execInitSpawnZones(FFrame&, void* const)
native function InitSpawnZones();

// Export UR6TeamDeathmatchGame::execFindClosestZone(FFrame&, void* const)
native function R6TeamSpawnZone FindClosestZone(R6PlayerStart pStart);

event InitGame(string Options, out string ErrorMessage)
{
    InitGame(Options, ErrorMessage);
    m_bBalanceTeams = true;
    m_bLockTeams = GetBoolOption(Options, "LT", m_bLockTeams);
    m_bAllowTeamRespawn = GetBoolOption(Options, "TR", m_bAllowTeamRespawn);
    // End:0x64
    if(m_bAllowTeamRespawn)
    {
        m_bAllowRespawn = true;
    }
    InitSpawnZones();
    return;
}

event PreBeginPlay()
{
    local int iTeam, iTeamSize, iMaxPlayersAllowed;

    PreBeginPlay();
    iMaxPlayersAllowed = GetMaxPlayers();
    iTeam = 0;
    J0x1B:

    // End:0x76 [Loop If]
    if(iTeam < 2)
    {
        iTeamSize = Ceil(float(iMaxPlayersAllowed) / float(2 - iTeam));
        iMaxPlayersAllowed = iMaxPlayersAllowed - iTeamSize;
        CreateTeam(byte(iTeam), iTeamSize);
        ++iTeam;
        // [Loop Continue]
        goto J0x1B;
    }
    return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    GetServerDetails(ServerState);
    AddServerDetail(ServerState, "BT", string(m_bBalanceTeams));
    AddServerDetail(ServerState, "LT", string(m_bLockTeams));
    AddServerDetail(ServerState, "TR", string(m_bAllowTeamRespawn));
    return;
}

function bool CheckLives(PlayerReplicationInfo Scorer)
{
    local R6PlayerController PC;
    local PlayerReplicationInfo Living;
    local bool bNobodyLeft;

    // End:0x2C
    if((Scorer != none) && !Scorer.bOutOfLives)
    {
        Living = Scorer;
    }
    bNobodyLeft = true;
    // End:0x121
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0x120
        if((((PC != none) && PC.PlayerReplicationInfo != none) && !PC.PlayerReplicationInfo.bOutOfLives) && !PC.PlayerReplicationInfo.bOnlySpectator)
        {
            // End:0xD1
            if(Living == none)
            {
                Living = PC.PlayerReplicationInfo;
                // End:0x120
                continue;
            }
            // End:0x120
            if((PC.PlayerReplicationInfo != Living) && PC.PlayerReplicationInfo.Team != Living.Team)
            {
                bNobodyLeft = false;
                // End:0x121
                break;
            }
        }        
    }    
    // End:0x178
    if(!bGameEnded && bNobodyLeft)
    {
        // End:0x15E
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

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x11
    if(CheckLives(Scorer))
    {
        return false;
    }
    // End:0x100
    if((Scorer != none) && Scorer.Team != none)
    {
        // End:0x9C
        if((m_bAllowRespawn && m_iGoalKills > 0) && R6TeamInfo(Scorer.Team).m_iKills >= m_iGoalKills)
        {
            // End:0x99
            if(!bGameEnded)
            {
                EndGame(Scorer, "teamkillslimit");
                return true;
            }            
        }
        else
        {
            // End:0x100
            if((m_bAllowRespawn && GoalScore > 0) && Scorer.Team.Score >= float(GoalScore))
            {
                // End:0x100
                if(!bGameEnded)
                {
                    EndGame(Scorer, "teamscorelimit");
                    return true;
                }
            }
        }
    }
    return false;
    return;
}

function ScoreKill(Controller Killer, Controller other)
{
    local PlayerReplicationInfo pKillerInfo;

    // End:0x1F
    if(Killer != none)
    {
        pKillerInfo = Killer.PlayerReplicationInfo;
    }
    // End:0x27C
    if(other.bIsPlayer)
    {
        // End:0x1BA
        if(((Killer == none) || Killer == other) || WorldInfo.GRI.OnSameTeam(other, Killer))
        {
            // End:0x191
            if(((Killer != none) && pKillerInfo != none) && pKillerInfo.Team != none)
            {
                // End:0x127
                if(Killer.PlayerReplicationInfo.Kills > 0)
                {
                    pKillerInfo.Kills--;
                    R6PlayerReplicationInfo(pKillerInfo).m_iKills = pKillerInfo.Kills;
                    R6TeamInfo(pKillerInfo.Team).m_iKills--;
                    ModifyPlayerScore(pKillerInfo, float(-int(m_byKillScore)));
                }
                // End:0x191
                if(pKillerInfo.Team.Score > float(0))
                {
                    pKillerInfo.Team.Score -= float(m_byKillTeamScore);
                    pKillerInfo.Team.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
                }
            }
            // End:0x1B7
            if(m_bFriendlyFire && Killer != other)
            {
                ApplyPlayerPenalty(pKillerInfo);
            }            
        }
        else
        {
            // End:0x27C
            if(pKillerInfo != none)
            {
                Killer.PlayerReplicationInfo.Kills++;
                R6PlayerReplicationInfo(pKillerInfo).m_iKills = pKillerInfo.Kills;
                R6TeamInfo(pKillerInfo.Team).m_iKills++;
                ModifyPlayerScore(pKillerInfo, float(m_byKillScore));
                pKillerInfo.Team.Score += float(m_byKillTeamScore);
                pKillerInfo.Team.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            }
        }
    }
    // End:0x2A7
    if((Killer != none) && other.bIsPlayer)
    {
        CheckScore(pKillerInfo);
    }
    // End:0x2D2
    if(!bGameEnded && other.bIsPlayer)
    {
        CheckLives(pKillerInfo);
    }
    return;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
    local R6PlayerStart Start, BestStart;
    local int BestRating, NewRating;
    local byte Team;
    local R6TeamSpawnZone pSpawnZone;
    local int iZone, iStart;
    local array<R6PlayerStart> BestStartPointsList, ValidStartPointsList;
    local array<float> ValidStartPointsListRatings;
    local int I;

    // End:0x37
    if((Player != none) && Player.StartSpot != none)
    {
        m_LastPlayerStartSpot = Player.StartSpot;
    }
    Start = R6PlayerStart(FindModifiedPlayerStart(Player, InTeam, incomingName));
    // End:0x69
    if(Start != none)
    {
        return Start;
    }
    // End:0xE0
    if((Player != none) && Player.PlayerReplicationInfo != none)
    {
        // End:0xD2
        if(Player.PlayerReplicationInfo.Team != none)
        {
            Team = byte(Player.PlayerReplicationInfo.Team.TeamIndex);            
        }
        else
        {
            Team = InTeam;
        }        
    }
    else
    {
        Team = InTeam;
    }
    // End:0x1F9
    if((((Player != none) && Player.PlayerReplicationInfo != none) && R6PlayerReplicationInfo(Player.PlayerReplicationInfo) != none) && R6PlayerReplicationInfo(Player.PlayerReplicationInfo).m_PlayerTeamInfo != none)
    {
        pSpawnZone = R6PlayerReplicationInfo(Player.PlayerReplicationInfo).m_PlayerTeamInfo.m_SpawnZone;
        // End:0x1F9
        if((pSpawnZone != none) && !pSpawnZone.IsAvailable() || !WorldInfo.GRI.OnSameTeam(pSpawnZone, Player.PlayerReplicationInfo))
        {
            R6PlayerReplicationInfo(Player.PlayerReplicationInfo).m_PlayerTeamInfo.m_SpawnZone = none;
            pSpawnZone = none;
        }
    }
    iZone = 0;
    J0x200:

    // End:0x292 [Loop If]
    if((iZone < m_arrSpawnZones.Length) && pSpawnZone == none)
    {
        // End:0x288
        if((m_arrSpawnZones[iZone].m_bPrimaryZone && m_arrSpawnZones[iZone].IsAvailable()) && int(m_arrSpawnZones[iZone].m_eTeamNumber) == int(Team))
        {
            pSpawnZone = m_arrSpawnZones[iZone];
            // [Explicit Break]
            goto J0x292;
        }
        ++iZone;
        // [Loop Continue]
        goto J0x200;
    }
    J0x292:

    BestRating = 0;
    // End:0x36A
    if((pSpawnZone != none) && pSpawnZone.IsAvailable())
    {
        iStart = 0;
        J0x2C0:

        // End:0x36A [Loop If]
        if(iStart < pSpawnZone.m_arrPlayerStarts.Length)
        {
            Start = pSpawnZone.m_arrPlayerStarts[iStart];
            NewRating = int(RatePlayerStart(Start, Team, Player));
            // End:0x360
            if(NewRating != m_iRatingForInvalidPoints)
            {
                ValidStartPointsList[ValidStartPointsList.Length] = Start;
                ValidStartPointsListRatings[ValidStartPointsListRatings.Length] = float(NewRating);
                // End:0x360
                if(NewRating > BestRating)
                {
                    BestRating = NewRating;
                }
            }
            ++iStart;
            // [Loop Continue]
            goto J0x2C0;
        }
    }
    I = 0;
    J0x371:

    // End:0x3BA [Loop If]
    if(I < ValidStartPointsList.Length)
    {
        // End:0x3B0
        if(ValidStartPointsListRatings[I] == float(BestRating))
        {
            BestStartPointsList[BestStartPointsList.Length] = ValidStartPointsList[I];
        }
        I++;
        // [Loop Continue]
        goto J0x371;
    }
    // End:0x3D6
    if(BestStartPointsList.Length == 1)
    {
        BestStart = BestStartPointsList[0];        
    }
    else
    {
        // End:0x3F6
        if(BestStartPointsList.Length > 1)
        {
            BestStart = BestStartPointsList[Rand(BestStartPointsList.Length)];
        }
    }
    // End:0x422
    if(BestStart == none)
    {
        BestStart = R6PlayerStart(FindPlayerStart(Player, InTeam, incomingName));
    }
    return BestStart;
    return;
}

function CreateTeam(R6GameEnums.ETEAMIDENTITY TeamIndex, int iMaxTeamSize)
{
    local class<R6TeamInfo> teamClass;

    // End:0x3B
    if(m_szCustomTeamInfoClass[int(TeamIndex)] != "")
    {
        teamClass = class<R6TeamInfo>(DynamicLoadObject(m_szCustomTeamInfoClass[int(TeamIndex)], Class'Core.Class'));        
    }
    else
    {
        teamClass = class<R6TeamInfo>(DynamicLoadObject(m_szDefaultTeamInfoClass, Class'Core.Class'));
    }
    m_Teams[int(TeamIndex)] = __NFUN_278__(teamClass);
    m_Teams[int(TeamIndex)].Init(int(TeamIndex), iMaxTeamSize);
    m_Teams[int(TeamIndex)].SetDeleteOnReset(false);
    GameReplicationInfo.Teams[int(TeamIndex)] = m_Teams[int(TeamIndex)];
    return;
}

function byte PickTeam(byte num, Controller C)
{
    local R6TeamInfo SmallTeam, BigTeam, newTeam;

    SmallTeam = m_Teams[0];
    BigTeam = m_Teams[1];
    // End:0x55
    if(SmallTeam.Size > BigTeam.Size)
    {
        SmallTeam = m_Teams[1];
        BigTeam = m_Teams[0];
    }
    // End:0x76
    if(int(num) < 2)
    {
        newTeam = m_Teams[int(num)];
    }
    // End:0x8F
    if(newTeam == none)
    {
        newTeam = SmallTeam;        
    }
    else
    {
        // End:0xD1
        if(m_bBalanceTeams && C != none)
        {
            // End:0xD1
            if(SmallTeam.Size < BigTeam.Size)
            {
                newTeam = SmallTeam;
            }
        }
    }
    return byte(newTeam.TeamIndex);
    return;
}

function bool ChangeTeam(Controller other, int num, bool bNewTeam)
{
    local R6TeamInfo newTeam;
    local TeamInfo PreviousTeam;
    local Actor pActor;
    local bool bAddedToNewTeam;

    // End:0x16
    if(bNewTeam && m_bLockTeams)
    {
        return false;
    }
    // End:0x61
    if(other.IsA('PlayerController') && other.PlayerReplicationInfo.bOnlySpectator)
    {
        other.PlayerReplicationInfo.Team = none;
        return true;
    }
    // End:0x91
    if(num < 255)
    {
        newTeam = m_Teams[int(PickTeam(byte(num), other))];        
    }
    else
    {
        newTeam = none;
    }
    PreviousTeam = other.PlayerReplicationInfo.Team;
    // End:0xC6
    if(PreviousTeam == newTeam)
    {
        return false;
    }
    other.StartSpot = none;
    // End:0xFD
    if(newTeam != none)
    {
        bAddedToNewTeam = newTeam.AddToTeam(other);
    }
    // End:0x180
    if(bAddedToNewTeam)
    {
        // End:0x126
        if(PreviousTeam != none)
        {
            PreviousTeam.RemoveFromTeam(other);
        }
        // End:0x180
        if((newTeam != none) && (PlayerController(other) == none) || PlayerController(other).Player != none)
        {
            BroadcastGameMessage(GameMessageClass, 3, other.PlayerReplicationInfo, none, newTeam);
        }
    }
    // End:0x1B2
    if((PlayerController(other) == none) || LocalPlayer(PlayerController(other).Player) == none)
    {
        return true;
    }
    // End:0x1D3
    foreach AllActors(Class'Engine.Actor', pActor)
    {
        pActor.NotifyLocalPlayerTeamReceived();        
    }    
    return true;
    return;
}

function bool SetInitialTeam(Controller other, int num)
{
    local R6TeamInfo newTeam;
    local TeamInfo PreviousTeam;
    local Actor pActor;
    local bool bAddedToNewTeam;

    // End:0x4B
    if(other.IsA('PlayerController') && other.PlayerReplicationInfo.bOnlySpectator)
    {
        other.PlayerReplicationInfo.Team = none;
        return true;
    }
    // End:0xAA
    if(num < 255)
    {
        // End:0x8A
        if(num == -1)
        {
            newTeam = m_Teams[int(PickTeam(byte(num), other))];            
        }
        else
        {
            newTeam = m_Teams[int(PickTeam(byte(num), none))];
        }        
    }
    else
    {
        newTeam = none;
    }
    PreviousTeam = other.PlayerReplicationInfo.Team;
    // End:0xDF
    if(PreviousTeam == newTeam)
    {
        return false;
    }
    other.StartSpot = none;
    // End:0x116
    if(newTeam != none)
    {
        bAddedToNewTeam = newTeam.AddToTeam(other);
    }
    // End:0x199
    if(bAddedToNewTeam)
    {
        // End:0x13F
        if(PreviousTeam != none)
        {
            PreviousTeam.RemoveFromTeam(other);
        }
        // End:0x199
        if((newTeam != none) && (PlayerController(other) == none) || PlayerController(other).Player != none)
        {
            BroadcastGameMessage(GameMessageClass, 3, other.PlayerReplicationInfo, none, newTeam);
        }
    }
    // End:0x1CB
    if((PlayerController(other) == none) || LocalPlayer(PlayerController(other).Player) == none)
    {
        return true;
    }
    // End:0x1EC
    foreach AllActors(Class'Engine.Actor', pActor)
    {
        pActor.NotifyLocalPlayerTeamReceived();        
    }    
    return true;
    return;
}

function bool RespawnPlayer(R6PlayerController Player)
{
    // End:0x26
    if(RespawnPlayer(Player))
    {
        // End:0x24
        if(m_bAllowTeamRespawn)
        {
            RespawnTeammates(Player);
        }
        return true;
    }
    return false;
    return;
}

function RespawnTeammates(R6PlayerController pPlayer)
{
    local R6PlayerController PC;

    // End:0x12A
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0x129
        if((((((((PC != none) && PC != pPlayer) && PC.PlayerReplicationInfo != none) && !PC.PlayerReplicationInfo.bOnlySpectator) && !PC.PlayerReplicationInfo.bOutOfLives) && PC.IsSpectating()) && PC.PlayerReplicationInfo.Team == pPlayer.PlayerReplicationInfo.Team) && int(R6PlayerReplicationInfo(PC.PlayerReplicationInfo).m_byPenaltyCount) == 0)
        {
            PC.WaitDelay = WorldInfo.TimeSeconds;
            PC.ServerRestartPlayer();
        }        
    }    
    return;
}

function ResetStats()
{
    local int iTeam;

    ResetStats();
    iTeam = 0;
    J0x0E:

    // End:0x3A [Loop If]
    if(iTeam < 2)
    {
        m_Teams[iTeam].ResetStats();
        ++iTeam;
        // [Loop Continue]
        goto J0x0E;
    }
    return;
}

function CheckForAwardDeathMatch()
{
    local R6PlayerController pR6PlayerIter, pR6PlayerLeadingKiller;
    local R6GameReplicationInfo pR6GameRepInfo;
    local R6PlayerReplicationInfo pR6PlayerRep;
    local GeneralStats stStats;
    local int iMaxKills, iKillTotal;

    pR6GameRepInfo = R6GameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
    // End:0x1BC
    if(pR6GameRepInfo != none)
    {
        // End:0x1BC
        if(m_bRankedGame)
        {
            iMaxKills = 0;
            iKillTotal = 0;
            // End:0x117
            foreach WorldInfo.AllControllers(Class'R6PlayerController', pR6PlayerIter)
            {
                // End:0x116
                if((pR6PlayerIter != none) && pR6GameRepInfo.IsAWinner(pR6PlayerIter))
                {
                    pR6PlayerRep = R6PlayerReplicationInfo(pR6PlayerIter.PlayerReplicationInfo);
                    // End:0x116
                    if(pR6PlayerRep != none)
                    {
                        GetGameManager().m_StatisticsManager.GetPlayerStats(pR6PlayerRep.m_iStatsPlayerID, stStats);
                        // End:0x105
                        if(stStats.m_iKills > iMaxKills)
                        {
                            iMaxKills = stStats.m_iKills;
                            pR6PlayerLeadingKiller = pR6PlayerIter;
                        }
                        iKillTotal += stStats.m_iKills;
                    }
                }                
            }            
            // End:0x1BC
            if((pR6PlayerLeadingKiller != none) && iMaxKills > (iKillTotal / 2))
            {
                // End:0x165
                if(int(pR6GameRepInfo.m_eCurrentGameMode) == int(4))
                {
                    pR6PlayerLeadingKiller.ClientGiveAward(9);                    
                }
                else
                {
                    // End:0x192
                    if(int(pR6GameRepInfo.m_eCurrentGameMode) == int(5))
                    {
                        pR6PlayerLeadingKiller.ClientGiveAward(10);                        
                    }
                    else
                    {
                        // End:0x1BC
                        if(int(pR6GameRepInfo.m_eCurrentGameMode) == int(1))
                        {
                            pR6PlayerLeadingKiller.ClientGiveAward(6);
                        }
                    }
                }
            }
        }
    }
    return;
}

defaultproperties
{
    m_szDefaultTeamInfoClass="R6Game.R6TeamInfo"
    m_szCustomTeamInfoClass[0]="R6Game.R6TeamAInfo"
    m_szCustomTeamInfoClass[1]="R6Game.R6TeamBInfo"
    m_bBalanceTeams=true
    m_byKillScore=1
    m_byKillTeamScore=1
    m_bAllowTeamKillerPenalty=true
    m_byTeamKillerPenaltyMax=5
    GameDescription="NEUTRALIZE THE ENEMY TEAM."
    bTeamGame=true
    GameName="TEAM SURVIVAL"
}