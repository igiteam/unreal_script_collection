class R6CooperativeGame extends R6MultiPlayerGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

struct CfgScoreTerroKilled
{
    var int m_iPourcentageReached;
    var int m_iScore;

    structdefaultproperties
    {
        m_iPourcentageReached=0
        m_iScore=0
    }
};

var R6TeamInfo m_Team;
var string m_szDefaultTeamInfoClass;
var R6PlayerController m_CoopLeader;
var Vector m_vecCenterPos;
var int m_PawnCount;
var array<R6PlayerController> m_arrPlayersToRelocate;
var config float m_LeaderAssignmentZoneRadiusInM;
var config float m_RelocWarningDistFromLeaderInM;
var config float m_RelocDistFromLeaderInM;
var config float m_fLeashingScreenFadeTimeInSec;
var config bool m_bUseCoopLeashing;
var float m_SquaredAssZoneRadiusInUnits;
var float m_SquaredRelocWarningDistInUnits;
var float m_SquaredRelocDistInUnits;
var int m_iStatsNbTerroKilled;
var int m_iStatsNbCiviliansWounded;
var int m_iStatsNbCiviliansKilled;
var int m_iStatsTimePlayed;
var int m_iScoreTerroKilled;
var int m_iScoreCiviliansWounded;
var int m_iScoreCiviliansKilled;
var int m_iScoreTimePlayed;
var int m_iScoreDifficulty;
var int m_iScoreTotalScore;
var array<CfgScoreTerroKilled> m_aCfgScoreTerroKilled;
var int m_iCfgScoreCiviliansWounded;
var int m_iCfgScoreCiviliansCasualities;
var int m_fCfgScoreOpTimeMaxScore;
var int m_fCfgScoreOpTimeMin;
var int m_fCfgScoreOpTimeMax;
var int m_iCfgScoreDiffNormal;

// Export UR6CooperativeGame::execSortPreferredPlayerStartLocation(FFrame&, void* const)
native function SortPreferredPlayerStartLocation(out array<R6PlayerController> arrPlayers);

// Export UR6CooperativeGame::execFindPlayerStartLocation(FFrame&, void* const)
native function bool FindPlayerStartLocation(Controller NewPlayer, out Vector vLocation, out Rotator rRotation, bool bForceFindLocation);

// Export UR6CooperativeGame::execGetRelocationCoordinates(FFrame&, void* const)
native function bool GetRelocationCoordinates(R6PlayerController playerToBeRelocated, R6PlayerController coopLeader, out Vector vLocation, out Rotator rRotation);

event InitGame(string Options, out string ErrorMessage)
{
    InitGame(Options, ErrorMessage);
    m_byMaxReservedPlaces = byte(Clamp(int(m_byMaxReservedPlaces), 0, GetMaxPlayers()));
    m_SquaredAssZoneRadiusInUnits = ((m_LeaderAssignmentZoneRadiusInM * float(100)) * m_LeaderAssignmentZoneRadiusInM) * float(100);
    m_SquaredRelocWarningDistInUnits = ((m_RelocWarningDistFromLeaderInM * float(100)) * m_RelocWarningDistFromLeaderInM) * float(100);
    m_SquaredRelocDistInUnits = ((m_RelocDistFromLeaderInM * float(100)) * m_RelocDistFromLeaderInM) * float(100);
    m_iRounds = 1;
    return;
}

event PreBeginPlay()
{
    PreBeginPlay();
    CreateTeam();
    return;
}

function CreateTeam()
{
    local class<R6TeamInfo> teamClass;

    teamClass = class<R6TeamInfo>(DynamicLoadObject(m_szDefaultTeamInfoClass, Class'Core.Class'));
    m_Team = __NFUN_278__(teamClass);
    m_Team.Init(0, MaxPlayersAllowed);
    m_Team.SetDeleteOnReset(false);
    GameReplicationInfo.Teams[0] = m_Team;
    return;
}

function bool ChangeTeam(Controller other, int num, bool bNewTeam)
{
    local TeamInfo PreviousTeam;

    // End:0x0B
    if(bNewTeam)
    {
        return false;
    }
    // End:0x21
    if(!other.bIsPlayer)
    {
        return false;
    }
    // End:0x57
    if(other.PlayerReplicationInfo.bOnlySpectator)
    {
        other.PlayerReplicationInfo.Team = none;
        return true;
    }
    PreviousTeam = other.PlayerReplicationInfo.Team;
    // End:0x85
    if(PreviousTeam == m_Team)
    {
        return false;
    }
    other.StartSpot = none;
    // End:0xB5
    if(m_Team != none)
    {
        m_Team.AddToTeam(other);
    }
    return true;
    return;
}

function bool SetInitialTeam(Controller other, int num)
{
    return ChangeTeam(other, num, false);
    return;
}

function bool ShouldRotateMap()
{
    local R6GameReplicationInfo pR6PRI;

    pR6PRI = R6GameReplicationInfo(GameReplicationInfo);
    // End:0x4F
    if(((pR6PRI != none) && pR6PRI.m_bCoopWon) && Len(GetGameManager().GetNextMissionURL()) > 0)
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

function bool CheckLives(PlayerReplicationInfo Scorer)
{
    local R6GameReplicationInfo r6RepInfo;
    local R6PlayerController PC;
    local bool bNobobyLeft;
    local int iOldNetVersion;

    bNobobyLeft = true;
    // End:0x6F
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0x6E
        if(((PC != none) && PC.Pawn != none) && PC.Pawn.IsAlive())
        {
            bNobobyLeft = false;
            // End:0x6F
            break;
        }        
    }    
    // End:0x11E
    if(!bGameEnded && bNobobyLeft)
    {
        r6RepInfo = R6GameReplicationInfo(GameReplicationInfo);
        // End:0x101
        if(r6RepInfo != none)
        {
            iOldNetVersion = r6RepInfo.m_MissionFailMessage.m_iNetVersion;
            r6RepInfo.m_MissionFailMessage.m_strFailureReason = "";
            r6RepInfo.m_MissionFailMessage.m_bPlayerDied = true;
            r6RepInfo.m_MissionFailMessage.m_iNetVersion = ++iOldNetVersion;
        }
        EndGame(none, "playerseliminated");
        return true;
    }
    return false;
    return;
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local R6PlayerController PC;

    // End:0xC0
    if(((((Reason ~= "quitgame") || Reason ~= "timelimit") || Reason ~= "missioncompleted") || Reason ~= "missionaborted") || Reason ~= "playerseliminated")
    {
        EndGame(Winner, Reason);
        // End:0xC0
        if(bGameEnded)
        {
            // End:0xB6
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
    // End:0x138
    if(Reason ~= "missioncompleted")
    {
        // End:0x137
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0x136
            if(PC != none)
            {
                // End:0x126
                if(int(GetGameMode()) == int(7))
                {
                    PC.bGodMode = true;
                }
                PC.ClientOnMissionComplete();
            }            
        }        
    }
    return;
}

function ScoreKill(Controller Killer, Controller other)
{
    local PlayerReplicationInfo pKillerInfo;
    local R6Pawn pVictimPawn, pKillerPawn;

    // End:0x1F
    if(Killer != none)
    {
        pKillerInfo = Killer.PlayerReplicationInfo;
    }
    // End:0x7E
    if(other.bIsPlayer)
    {
        // End:0x7B
        if(WorldInfo.GRI.OnSameTeam(other, Killer))
        {
            // End:0x7B
            if(m_bFriendlyFire)
            {
                // End:0x7B
                if(Killer != other)
                {
                    ApplyPlayerPenalty(pKillerInfo);
                }
            }
        }        
    }
    else
    {
        // End:0x1B6
        if((((Killer != none) && Killer.bIsPlayer) && other != none) && !other.bIsPlayer)
        {
            pKillerPawn = R6Pawn(Killer.Pawn);
            pVictimPawn = R6Pawn(other.Pawn);
            // End:0x1B6
            if((pKillerPawn != none) && pVictimPawn != none)
            {
                // End:0x1B6
                if(int(pVictimPawn.CheckAlliance(pKillerPawn)) == int(2))
                {
                    // End:0x1B6
                    if(Killer.PlayerReplicationInfo != none)
                    {
                        Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
                        Killer.PlayerReplicationInfo.Kills += 1;
                        R6PlayerReplicationInfo(Killer.PlayerReplicationInfo).m_iKills = Killer.PlayerReplicationInfo.Kills;
                    }
                }
            }
        }
    }
    // End:0x1E1
    if(!bGameEnded && other.bIsPlayer)
    {
        CheckLives(pKillerInfo);
    }
    return;
}

function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
{
    DoRestartPlayer(NewPlayer, true, ForcedPawn);
    return;
}

function DoRestartPlayer(Controller NewPlayer, bool bForceFindLocation, optional Pawn ForcedPawn)
{
    local R6PlayerController PC;
    local Vector vSpawnLocation;
    local Rotator rSpawnRotation;

    // End:0x1A0
    if((NewPlayer != none) && NewPlayer.bIsPlayer)
    {
        // End:0x7F
        if(FindPlayerStartLocation(NewPlayer, vSpawnLocation, rSpawnRotation, bForceFindLocation))
        {
            // End:0x7F
            if(NewPlayer.Pawn == none)
            {
                NewPlayer.Pawn = __NFUN_278__(GetDefaultPlayerClass(NewPlayer),,, vSpawnLocation, rSpawnRotation,, true);
            }
        }
        // End:0xAA
        if(NewPlayer.Pawn == none)
        {
            // End:0xA7
            if(int(GetGameStatus()) == int(5))
            {
                return;
            }            
        }
        else
        {
            NewPlayer.StartSpot = none;
            PC = R6PlayerController(NewPlayer);
            // End:0xE9
            if(PC != none)
            {
                PC.TimeMargin = -0.1000000;
            }
            NewPlayer.Pawn.m_bIsNPCPawn = false;
            NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
            NewPlayer.Possess(NewPlayer.Pawn, false);
            NewPlayer.Pawn.PlayTeleportEffect(true, true);
            // End:0x17E
            if(PC != none)
            {
                PC.InitPlayerLocAndRot();
            }
            AddDefaultInventory(NewPlayer.Pawn);
            ResetRespawnValuesOnRestart(NewPlayer);
            return;
        }
    }
    RestartPlayer(NewPlayer, ForcedPawn);
    return;
}

function ResetStats()
{
    ResetStats();
    m_Team.ResetStats();
    return;
}

function GetPlayersAveragePosition(out Vector vecCenter, out int pawnCount)
{
    local R6PlayerController P;

    vecCenter.X = 0.0000000;
    vecCenter.Y = 0.0000000;
    vecCenter.Z = 0.0000000;
    pawnCount = 0;
    // End:0xE7
    foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
    {
        // End:0xE6
        if(P.Pawn != none)
        {
            ++pawnCount;
            vecCenter.X += P.Pawn.Location.X;
            vecCenter.Y += P.Pawn.Location.Y;
            vecCenter.Z += P.Pawn.Location.Z;
        }        
    }    
    // End:0x12F
    if(pawnCount > 0)
    {
        vecCenter.X /= float(pawnCount);
        vecCenter.Y /= float(pawnCount);
        vecCenter.Z /= float(pawnCount);        
    }
    else
    {
        vecCenter.X = 0.0000000;
        vecCenter.Y = 0.0000000;
        vecCenter.Z = 0.0000000;
    }
    return;
}

function Relocate(R6PlayerController P, Vector vPosition, Rotator rRotation)
{
    local FadeParams FadeParams;

    // End:0x129
    if(P.Pawn != none)
    {
        FadeParams.m_fFadeDuration = m_fLeashingScreenFadeTimeInSec;
        FadeParams.m_fBlockInputsTime = m_fLeashingScreenFadeTimeInSec;
        FadeParams.m_fPauseHudTime = m_fLeashingScreenFadeTimeInSec;
        FadeParams.m_cStartColor = MakeColor(0, 0, 0, byte(255));
        FadeParams.m_cEndColor = MakeColor(0, 0, 0, 0);
        // End:0xA2
        if(P.LocalPlayerController())
        {
            P.FadeScreen(FadeParams);            
        }
        else
        {
            P.ClientFadeScreen(FadeParams);
        }
        P.Pawn.SetLocation(vPosition);
        P.Pawn.SetRotation(rRotation);
        P.Pawn.SetViewRotation(rRotation);
        P.Pawn.ClientSetRotation(rRotation);
    }
    return;
}

function UpdateCOOPLeashing()
{
    local R6PlayerController P;
    local bool bAllPlayersInZone;
    local float distToLeader;
    local Vector vRelocationPos;
    local Rotator rRelocationRot;
    local R6Pawn pPawn, pLeaderPawn;

    // End:0x89
    if((m_CoopLeader == none) && m_PawnCount > 1)
    {
        // End:0x85
        foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
        {
            // End:0x84
            if(P.Pawn != none)
            {
                // End:0x84
                if(VSizeSq(P.Pawn.Location - m_vecCenterPos) > m_SquaredAssZoneRadiusInUnits)
                {
                    m_CoopLeader = P;
                    // End:0x85
                    break;
                }
            }            
        }                
    }
    else
    {
        // End:0x2FE
        if(m_PawnCount > 1)
        {
            bAllPlayersInZone = true;
            // End:0x106
            foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
            {
                // End:0x105
                if(P.Pawn != none)
                {
                    // End:0x105
                    if(VSizeSq(P.Pawn.Location - m_vecCenterPos) > m_SquaredAssZoneRadiusInUnits)
                    {
                        bAllPlayersInZone = false;
                        // End:0x106
                        break;
                    }
                }                
            }            
            // End:0x119
            if(bAllPlayersInZone)
            {
                m_CoopLeader = none;
                return;
            }
            // End:0x13D
            if(m_CoopLeader != none)
            {
                pLeaderPawn = R6Pawn(m_CoopLeader.Pawn);
            }
            // End:0x2FD
            foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
            {
                // End:0x2FC
                if((P != m_CoopLeader) && P.Pawn != none)
                {
                    distToLeader = VSizeSq(P.Pawn.Location - m_CoopLeader.Pawn.Location);
                    // End:0x29E
                    if(distToLeader > m_SquaredRelocDistInUnits)
                    {
                        pPawn = R6Pawn(P.Pawn);
                        // End:0x29B
                        if((((((P.IsInState('PlayerWalking') && pPawn != none) && pPawn.m_pInteracting == none) && m_CoopLeader.IsInState('PlayerWalking')) && pLeaderPawn != none) && pLeaderPawn.m_pInteracting == none) && GetRelocationCoordinates(P, m_CoopLeader, vRelocationPos, rRelocationRot))
                        {
                            P.m_bHasBeenWarned = false;
                            Relocate(P, vRelocationPos, rRelocationRot);
                        }
                        // End:0x2FC
                        continue;
                    }
                    // End:0x2EB
                    if(distToLeader > m_SquaredRelocWarningDistInUnits)
                    {
                        // End:0x2E8
                        if(!P.m_bHasBeenWarned)
                        {
                            SendGameMessage(Class'R6CoopLeashingGameMessage', P, 46);
                            P.m_bHasBeenWarned = true;
                        }
                        // End:0x2FC
                        continue;
                    }
                    P.m_bHasBeenWarned = false;
                }                
            }            
        }
    }
    GetPlayersAveragePosition(m_vecCenterPos, m_PawnCount);
    return;
}

event R6Pawn GetTeamMember(int iIndex)
{
    local R6PlayerController P;

    // End:0x87
    foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
    {
        // End:0x86
        if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == m_Team) && P.PlayerReplicationInfo.TeamID == iIndex)
        {            
            return P.m_R6Pawn;
        }        
    }    
    return none;
    return;
}

state s_MatchStarting
{
    function BeginState(name PreviousStateName)
    {
        local R6PlayerController PC;

        BeginState(PreviousStateName);
        // End:0x45
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0x44
            if(PC != none)
            {
                PC.bGodMode = false;
            }            
        }        
        LaunchGame();
        return;
    }

    function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
    {
        local int iPlayerStartCount;
        local R6PlayerStart pR6Ps;

        // End:0x19
        foreach DynamicActors(Class'R6PlayerStart', pR6Ps)
        {
            iPlayerStartCount++;            
        }        
        // End:0x40
        if(iPlayerStartCount >= (GetNumPlayers()))
        {
            DoRestartPlayer(NewPlayer, false, ForcedPawn);            
        }
        else
        {
            DoRestartPlayer(NewPlayer, true, ForcedPawn);
        }
        return;
    }
    stop;
}

state s_MatchBetweenRound
{
    function EndState(name NextStateName)
    {
        local R6PlayerController PC;

        // End:0x56
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0x55
            if(PC != none)
            {
                // End:0x55
                if(PC.PlayerReplicationInfo != none)
                {
                    PC.PlayerReplicationInfo.bReadyToPlay = true;
                }
            }            
        }        
        EndState(NextStateName);
        return;
    }
    stop;
}

state s_MatchInProgress
{
    function Timer()
    {
        Timer();
        // End:0x17
        if(m_bUseCoopLeashing)
        {
            UpdateCOOPLeashing();
        }
        return;
    }
    stop;
}

defaultproperties
{
    m_szDefaultTeamInfoClass="R6Game.R6TeamInfo"
    m_LeaderAssignmentZoneRadiusInM=5.0000000
    m_RelocWarningDistFromLeaderInM=20.0000000
    m_RelocDistFromLeaderInM=30.0000000
    m_fLeashingScreenFadeTimeInSec=0.5000000
    m_aCfgScoreTerroKilled[0]=(m_iPourcentageReached=100,m_iScore=5000)
    m_aCfgScoreTerroKilled[1]=(m_iPourcentageReached=75,m_iScore=2500)
    m_aCfgScoreTerroKilled[2]=(m_iPourcentageReached=25,m_iScore=1750)
    m_aCfgScoreTerroKilled[3]=(m_iPourcentageReached=10,m_iScore=500)
    m_iCfgScoreCiviliansWounded=-250
    m_iCfgScoreCiviliansCasualities=-2500
    m_fCfgScoreOpTimeMaxScore=10000
    m_fCfgScoreOpTimeMax=2400
    m_iCfgScoreDiffNormal=2500
    bTeamGame=true
    bDelayedStart=true
    MaxPlayersAllowed=4
}