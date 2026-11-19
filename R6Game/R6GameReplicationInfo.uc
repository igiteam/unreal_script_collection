class R6GameReplicationInfo extends GameReplicationInfo
    native
    nativereplication
    config(Game)
    hidecategories(lighting,Movement,Collision);

const MAX_KIT_RESTRICTIONS = 5;

var bool m_bTeamGame;
var bool m_bAllowRespawn;
var bool m_bAllowTeamRespawn;
var bool m_bAllowTeamKillerPenalty;
var bool m_bAllowIncapacitation;
var bool m_bBalanceTeams;
var bool m_bPunkBuster;
var bool m_bLockTeams;
var bool m_bFriendlyFire;
var bool m_bDedicatedServer;
var bool m_bPrivateServer;
var bool m_bRankedMatch;
var bool m_bCoopWon;
var bool m_bFinishedRanked;
var bool m_bConquestCountdownEnabled;
var class<R6ObjectiveBasicMP> m_MissionType;
var int m_iTimeLimitSeconds;
var int m_iTimeMatchStarting;
var R6EngineEnums.EGameMode m_eCurrentGameMode;
var R6EngineEnums.EGameType m_eCurrentGameType;
var repnotify R6EngineEnums.EGameStatus m_eCurrentGameStatus;
var R6EngineEnums.EGameStatus m_eLastGameStatus;
var byte m_byTeamKillerPenaltyMax;
var byte m_byMaxPlayers;
var byte m_byMaxRespawn;
var R6EngineEnums.EAllowVoiceMode m_eAllowVoice;
var R6EngineEnums.EGameDifficulty m_eGameDifficulty;
var R6EngineEnums.EGameHostileDensity m_eHostileDensity;
var int m_iRounds;
var int m_iCurrentRound;
var int m_iTimeBetweenRound;
var string m_fstrMapList;
var repnotify int m_iKitRestrictionIDs[5];
var string m_fstrPassword;
var int m_iHostiles;
var int m_iConquestCountdown;
var int m_iConquestSatellite[2];
var() array<PlayerReplicationInfo> m_StartPRIArray;
var R6MissionFailedInfo m_MissionFailMessage;
var R6MPBriefing m_pMPBriefing;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_bAllowIncapacitation, m_bAllowRespawn, 
        m_bCoopWon, m_bDedicatedServer, 
        m_bFinishedRanked, m_bPrivateServer, 
        m_bPunkBuster, m_bRankedMatch, 
        m_bTeamGame, m_byMaxPlayers, 
        m_byMaxRespawn, m_eAllowVoice, 
        m_eCurrentGameMode, m_eCurrentGameStatus, 
        m_eCurrentGameType, m_eGameDifficulty, 
        m_fstrMapList, m_iCurrentRound, 
        m_iKitRestrictionIDs, m_iRounds, 
        m_iTimeBetweenRound, m_iTimeLimitSeconds, 
        m_iTimeMatchStarting;

    // Pos:0x018
    if((m_bTeamGame && bNetDirty) && int(Role) == int(ROLE_Authority))
        m_bAllowTeamKillerPenalty, m_bFriendlyFire, 
        m_byTeamKillerPenaltyMax;

    // Pos:0x03B
    if(((m_bTeamGame && int(m_eCurrentGameType) == int(4)) && bNetDirty) && int(Role) == int(ROLE_Authority))
        m_MissionType, m_bAllowTeamRespawn, 
        m_bBalanceTeams, m_bLockTeams;

    // Pos:0x070
    if((bNetDirty && int(m_eCurrentGameMode) == int(8)) && int(Role) == int(ROLE_Authority))
        m_eHostileDensity, m_iHostiles;

    // Pos:0x09A
    if((bNetDirty && int(Role) == int(ROLE_Authority)) && int(m_eCurrentGameMode) == int(7))
        m_MissionFailMessage;

    // Pos:0x0C4
    if((bNetDirty && int(m_eCurrentGameMode) == int(15)) && int(Role) == int(ROLE_Authority))
        m_bConquestCountdownEnabled, m_iConquestSatellite;

    // Pos:0x0EE
    if(((bNetDirty && int(m_eCurrentGameMode) == int(15)) && int(Role) == int(ROLE_Authority)) && m_bConquestCountdownEnabled)
        m_iConquestCountdown;
}

// Export UR6GameReplicationInfo::execIsAWinner(FFrame&, void* const)
native function bool IsAWinner(PlayerController pPlayer);

// Export UR6GameReplicationInfo::execIsWinningTeam(FFrame&, void* const)
native function bool IsWinningTeam(TeamInfo pTeam);

// Export UR6GameReplicationInfo::execEnumerateSpawnZones(FFrame&, void* const)
native function EnumerateSpawnZones(PlayerReplicationInfo pPlayer, out array<R6TeamSpawnZone> arrZones);

// Export UR6GameReplicationInfo::execEnumeratePlayers(FFrame&, void* const)
native function EnumeratePlayers(out array<PlayerReplicationInfo> arrPlayers, optional R6GameEnums.ETEAMIDENTITY eTeam);

// Export UR6GameReplicationInfo::execEnumerateStartPlayers(FFrame&, void* const)
native function EnumerateStartPlayers(out array<PlayerReplicationInfo> arrPlayers, optional R6GameEnums.ETEAMIDENTITY eTeam);

// Export UR6GameReplicationInfo::execGetPlayerCount(FFrame&, void* const)
native function int GetPlayerCount();

// Export UR6GameReplicationInfo::execNumPlayers(FFrame&, void* const)
native function int NumPlayers(R6GameEnums.ETEAMIDENTITY eTeam);

simulated function Timer()
{
    // End:0x48
    if(((int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_Client)) && !bStopCountDown)
    {
        ElapsedTime++;
    }
    // End:0x93
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        // End:0x80
        if((RemainingTime > 0) && !bStopCountDown)
        {
            RemainingTime--;
        }
        SetTimer(WorldInfo.TimeDilation, true);
    }
    return;
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    AddPRI(PRI);
    // End:0x3B
    if((PRI != none) && PRI.IsStarter)
    {
        AddUniqueToArray(m_StartPRIArray, PRI);
    }
    return;
}

simulated function bool OnSameTeam(Actor A, Actor B)
{
    // End:0x30
    if((!GameClass.default.bTeamGame || A == none) || B == none)
    {
        return false;
    }
    return IsSameTeam(A.GetTeamNum(), B.GetTeamNum());
    return;
}

simulated event bool IsSameTeam(byte u8TeamNumA, byte u8TeamNumB)
{
    // End:0x16
    if(!GameClass.default.bTeamGame)
    {
        return false;
    }
    // End:0x26
    if(int(u8TeamNumA) == 255)
    {
        return false;
    }
    // End:0x36
    if(int(u8TeamNumB) == 255)
    {
        return false;
    }
    // End:0x48
    if(int(u8TeamNumA) == int(2))
    {
        return true;
    }
    // End:0x5A
    if(int(u8TeamNumB) == int(2))
    {
        return true;
    }
    return int(u8TeamNumA) == int(u8TeamNumB);
    return;
}

function SetGameStatus(R6EngineEnums.EGameStatus eNewStatus)
{
    // End:0x45
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        m_eLastGameStatus = m_eCurrentGameStatus;
        m_eCurrentGameStatus = eNewStatus;
        GetGameManager().OnGameStatusChanged(m_eCurrentGameStatus);
    }
    return;
}

function Reset()
{
    Reset();
    ElapsedTime = 0;
    RemainingTime = 0;
    bStopCountDown = true;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    return;
}

simulated event InitStartPRIArray()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4B [Loop If]
    if(I < m_StartPRIArray.Length)
    {
        // End:0x41
        if(m_StartPRIArray[I].HasLeftTheGame)
        {
            m_StartPRIArray[I].Destroy();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    m_StartPRIArray.Remove(0, m_StartPRIArray.Length);
    I = 0;
    J0x5F:

    // End:0xC3 [Loop If]
    if(I < PRIArray.Length)
    {
        m_StartPRIArray.Insert(I, 1);
        m_StartPRIArray[I] = PRIArray[I];
        // End:0xB9
        if(int(Role) == int(ROLE_Authority))
        {
            PRIArray[I].IsStarter = true;
        }
        I++;
        // [Loop Continue]
        goto J0x5F;
    }
    return;
}

defaultproperties
{
    m_bBalanceTeams=true
    m_eHostileDensity=3
    m_iKitRestrictionIDs[0]=-1
    m_iKitRestrictionIDs[1]=-1
    m_iKitRestrictionIDs[2]=-1
    m_iKitRestrictionIDs[3]=-1
    m_iKitRestrictionIDs[4]=-1
    m_bDeleteOnReset=false
}