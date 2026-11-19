class R6PlayerReplicationInfo extends PlayerReplicationInfo
    native
    nativereplication
    hidecategories(lighting,Movement,Collision);

var bool m_bInputReady;
var bool m_bHost;
var bool m_bHasVoice;
var repnotify bool m_bInvulnerable;
var bool m_bInitialPoolComplete;
var bool m_bPauseRespawnDelay;
var int m_iKills;
var int m_iPingValue;
var repnotify byte m_byWaitDelay;
var R6GameEnums.EPlayerClass m_ePlayerClass;
var R6EngineEnums.EHealthStates m_eHealthState;
var R6EngineEnums.EVisionMode m_eCurrentVisionMode;
var byte m_byChatterId;
var R6GameEnums.ECarriedObjectType m_eCarriedObject;
var byte m_byShoulderArmorStyle;
var byte m_byArmArmorStyle;
var byte m_byLegArmorStyle;
var byte m_byGender;
var byte m_byPenaltyCount;
var byte m_byPenaltyWarningCount;
var R6PlayerTeamInfo m_PlayerTeamInfo;
var int m_iRank;
var string m_xnaddr;
var int m_iStatsPlayerID;
var float m_fInvulnerabilityDelay;
var float m_fRespawnDelay;
var R6CarriedObject m_pCarriedObject;
var string m_szMissionDescription;
var string m_szGameStatusTextMsg;
var SoundCue m_sndGameStatusVoiceMsg;
var int m_iTerroristsKilled;
var int m_iCiviliansWounded;
var int m_iCiviliansKilled;
var int m_iTimePlayed;
var int m_iScoreTerroKilled;
var int m_iScoreCiviliansWounded;
var int m_iScoreCiviliansKilled;
var int m_iScoreTimePlayed;
var int m_iScoreDifficulty;
var int m_iScoreTotalScore;
var string m_sPrefixTag;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_PlayerTeamInfo, m_bHasVoice, 
        m_bHost, m_bInputReady, 
        m_byArmArmorStyle, m_byChatterId, 
        m_byGender, m_byLegArmorStyle, 
        m_byShoulderArmorStyle, m_eCurrentVisionMode, 
        m_eHealthState, m_ePlayerClass, 
        m_iCiviliansKilled, m_iCiviliansWounded, 
        m_iKills, m_iPingValue, 
        m_iRank, m_iScoreCiviliansKilled, 
        m_iScoreCiviliansWounded, m_iScoreDifficulty, 
        m_iScoreTerroKilled, m_iScoreTimePlayed, 
        m_iScoreTotalScore, m_iTerroristsKilled, 
        m_iTimePlayed, m_sPrefixTag, 
        m_xnaddr;

    // Pos:0x018
    if((bNetDirty && bNetOwner) && int(Role) == int(ROLE_Authority))
        m_bInvulnerable, m_bPauseRespawnDelay, 
        m_byWaitDelay, m_eCarriedObject;
}

// Export UR6PlayerReplicationInfo::execOnTick(FFrame&, void* const)
native event OnTick(float fDeltaTime);

// Export UR6PlayerReplicationInfo::execResetInfo(FFrame&, void* const)
native function ResetInfo();

// Export UR6PlayerReplicationInfo::execSetCarriedObject(FFrame&, void* const)
native function SetCarriedObject(R6CarriedObject pObj);

// Export UR6PlayerReplicationInfo::execGetCarriedObject(FFrame&, void* const)
native function R6CarriedObject GetCarriedObject();

// Export UR6PlayerReplicationInfo::execIsAlive(FFrame&, void* const)
native function bool IsAlive();

// Export UR6PlayerReplicationInfo::execIsAnExcessiveTeamKiller(FFrame&, void* const)
native function bool IsAnExcessiveTeamKiller();

// Export UR6PlayerReplicationInfo::execGetMissionDescription(FFrame&, void* const)
native function string GetMissionDescription();

function Reset()
{
    ResetInfo();
    return;
}

function ResetStats()
{
    Score = 0.0000000;
    Deaths = 0.0000000;
    Kills = 0;
    m_iKills = 0;
    return;
}

simulated event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    UpdateMissionDescription();
    OnTick(DeltaTime);
    return;
}

simulated function byte GetTeamNum()
{
    return byte(((Team != none) ? Team.TeamIndex : 255));
    return;
}

simulated event byte GetTeamID()
{
    return GetTeamNum();
    return;
}

reliable server function ServerSetRank(int iRank)
{
    m_iRank = iRank;
    return;
}

reliable server function ServerSetPecInformation(byte byShoulderArmorStyle, byte byArmArmorStyle, byte byLegArmorStyle, byte byGender)
{
    m_byShoulderArmorStyle = byShoulderArmorStyle;
    m_byArmArmorStyle = byArmArmorStyle;
    m_byLegArmorStyle = byLegArmorStyle;
    m_byGender = byGender;
    return;
}

unreliable server function ServerSetPlayerReady(bool bReady)
{
    bReadyToPlay = bReady;
    return;
}

unreliable server function ServerSetPlayerSpawnZone(R6TeamSpawnZone PZone)
{
    local bool bSpawnZoneAccepted;
    local NavigationPoint pNewStart;

    // End:0x115
    if(m_PlayerTeamInfo != none)
    {
        bSpawnZoneAccepted = ((PZone != none) && PZone.IsAvailable()) && WorldInfo.GRI.OnSameTeam(PZone, self);
        // End:0x115
        if(bSpawnZoneAccepted)
        {
            m_PlayerTeamInfo.m_SpawnZone = PZone;
            // End:0x115
            if((WorldInfo.Game != none) && Controller(Owner) != none)
            {
                pNewStart = WorldInfo.Game.FindPlayerStart(Controller(Owner), GetTeamNum());
                // End:0x115
                if(pNewStart != none)
                {
                    Controller(Owner).SetLocation(pNewStart.Location);
                    Controller(Owner).ClientSetRotation(pNewStart.Rotation);
                }
            }
        }
    }
    return;
}

unreliable server function ServerSetPlayerClass(byte eClass)
{
    m_ePlayerClass = eClass;
    return;
}

simulated function UpdateMissionDescription()
{
    local R6GameReplicationInfo pGRI;
    local class<GameInfo> pGameClass;
    local bool bTeamGame;

    pGameClass = WorldInfo.GetGameClass();
    // End:0x42
    if(pGameClass != none)
    {
        bTeamGame = WorldInfo.static.GetGameClass().default.bTeamGame;
    }
    // End:0x6F
    if(WorldInfo.GRI != none)
    {
        pGRI = R6GameReplicationInfo(WorldInfo.GRI);
    }
    // End:0x11C
    if((pGRI != none) && pGRI.m_MissionType != none)
    {
        // End:0xFC
        if(bTeamGame)
        {
            switch(GetTeamNum())
            {
                // End:0xA7
                case 0:
                // End:0xD6
                case 1:
                    m_szMissionDescription = pGRI.m_MissionType.default.m_szTeamDescription[int(static.GetTeamNum())];
                    // End:0xF9
                    break;
                // End:0xFFFF
                default:
                    m_szMissionDescription = pGRI.m_MissionType.default.m_szDescription;
                    // End:0xF9
                    break;
                    break;
            }            
        }
        else
        {
            m_szMissionDescription = pGRI.m_MissionType.default.m_szDescription;
        }        
    }
    else
    {
        // End:0x140
        if(pGameClass != none)
        {
            m_szMissionDescription = class<R6GameInfo>(pGameClass).default.GameDescription;
        }
    }
    return;
}

simulated function SaveGameStatus(string szTextMsg, SoundCue sndVoiceMsg)
{
    m_szGameStatusTextMsg = szTextMsg;
    m_sndGameStatusVoiceMsg = sndVoiceMsg;
    return;
}

simulated event string GetGameStatusTextMsg()
{
    return m_szGameStatusTextMsg;
    return;
}

simulated event SoundCue GetGameStatusVoiceMsg()
{
    return m_sndGameStatusVoiceMsg;
    return;
}

simulated function ClientInitialize(Controller C)
{
    local R6PlayerController PC;

    ClientInitialize(C);
    PC = R6PlayerController(C);
    // End:0x37
    if(PC != none)
    {
        PC.UpdatePecInformation();
    }
    return;
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
    DisplayDebug(HUD, YL, YPos);
    YPos += YL;
    HUD.Canvas.SetPos(4.0000000, YPos);
    HUD.Canvas.Font = Class'Engine.Engine'.default.TinyFont;
    HUD.Canvas.SetDrawColor(128, 128, byte(255));
    HUD.Canvas.__NFUN_465__((("m_bHost:" @ string(m_bHost)) @ "m_bHasVoice:") @ string(m_bHasVoice));
    YPos += YL;
    HUD.Canvas.SetPos(4.0000000, YPos);
    HUD.Canvas.__NFUN_465__((("m_bInvulnerable:" @ string(m_bInvulnerable)) @ "m_fInvulnerabilityDelay:") @ string(m_fInvulnerabilityDelay));
    YPos += YL;
    HUD.Canvas.SetPos(4.0000000, YPos);
    HUD.Canvas.__NFUN_465__((((("m_byPenaltyCount:" @ string(m_byPenaltyCount)) @ "m_byWaitDelay:") @ string(m_byWaitDelay)) @ "m_fRespawnDelay:") @ string(m_fRespawnDelay));
    YPos += YL;
    HUD.Canvas.SetPos(4.0000000, YPos);
    HUD.Canvas.__NFUN_465__((((("m_ePlayerClass:" @ string(m_ePlayerClass)) @ "m_eHealthState:") @ string(m_eHealthState)) @ "m_eCurrentVisionMode:") @ string(m_eCurrentVisionMode));
    YPos += YL;
    HUD.Canvas.SetPos(4.0000000, YPos);
    return;
}

event SetPrefixTag(coerce string S)
{
    m_sPrefixTag = S;
    return;
}

state s_Leaving
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        bReadyToPlay = false;
        return;
    }
    stop;
}

defaultproperties
{
    m_iPingValue=-1
    GameMessageClass=Class'R6GameMessage'
    m_bDeleteOnReset=false
}