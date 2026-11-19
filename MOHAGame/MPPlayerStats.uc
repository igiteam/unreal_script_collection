class MPPlayerStats extends Object
    config(Game);

const MAX_WEAPON_TYPE_SP = 25;
const MAX_SP_MISSIONS = 7;
const MAX_SP_MEDALS = 6;
const MAX_HUD_NOTIFICATIONS = 8;
const NUM_MP_MAPS = 6;
const NUM_MP_AWARDS = 19;
const NUM_WEAPON_CLASSES = 7;
const MAX_RIVALS = 8;
const NUM_WEAPON_EXP_LEVELS = 3;
const NUM_MP_MEDALS = 15;
const NUM_MP_WEAPON_UPGRADES = 4;
const MAX_MISSION_SKILL_DROPS = 5;
const MAX_UPGRADEABLE_WEAPONS_SP = 16;
const NUM_XBLACH_UPGRADED_WEAPONS = 5;
const NUM_KILL_TIMES_TO_TRACK = 5;
const NUM_CONSECUTIVE_HEADSHOT_XBLACH = 10;
const MAX_DIFFICULTIES = 3;
const MAX_HUD_RENDERMODES = 4;
const MAX_SP_CHEAT_FLAGS = 7;
const WIDESCREEN_ASPECT_RATIO = 1.7777f;
const WIDESCREEN_INVERSE_ASPECT_RATIO = 0.5625f;
const MAX_HEALTH_DROPPED_PICKUPS = 1;
const MAX_HEALTH_DROPPED_PICKUPS_MP = 10;

struct native RivalryStatInfo
{
    var int PlayerID;
    var int Kills;
    var int KilledBy;

    structdefaultproperties
    {
        PlayerID=0
        Kills=0
        KilledBy=0
    }
};

var config int MedalDistinguishedServiceCrossKillsReq;
var config int MedalDistinguishedServiceCrossObjReq;
var config int MedalDistinguishedServiceMedalKillsReq;
var config int MedalDistinguishedServiceMedalObjReq;
var config int MedalSilverStarFirstsPlacesReq;
var config int MedalLegionOfMeritObjectivePointsReq;
var config int MedalSoldiersMedalKillAssistsReq;
var config int MedalBronzeStarTopThreePlacesReq;
var config int MedalPurpleHeartMinHealthReq;
var config int MedalMeritoriousUnitCitationTeamPointsReq;
var config int MedalDistinguishedUnitCitationTeamPointsReq;
var config int MedalGoodCombatMedalStreakReq;
var config int MedalMarksmanKillsReq;
var config int MedalSharpshooterKillsReq;
var config int MedalExpertKillsReq;
var const localized string MedalMessages[19];
var config int WeaponLevelExpCap[3];
var const Texture2D MedalIcons[15];
var const Texture2D WeaponUpgradeMedalIcons[4];
var const SoundCue MedalAudio[15];
var const SoundCue WeaponUpgradeMedalAudio[4];
var config string MapNames[6];
var export editinline MOHAWeaponExperienceComponent CurrentWeaponExperience;
var array<RivalryStatInfo> Rivalry;
var int m_iDistinguishedUnitCitationsAwarded;
var bool m_bHasSwitchedTeams;
var MOHAMultiplayerController m_Controller;
var MOHAPlayerReplicationInfo PRI;

simulated function SetOwnerController(MOHAMultiplayerController Controller)
{
    m_Controller = Controller;
    PRI = MOHAPlayerReplicationInfo(m_Controller.PlayerReplicationInfo);
    //return;    
}

simulated function ResetStatsPerMatch()
{
    local int I;

    // End:0x17
    if(Rivalry.Length < 8)
    {
        SetupRivalryData();
    }
    I = 0;
    J0x1E:

    // End:0x79 [Loop If]
    if(I < 8)
    {
        Rivalry[I].PlayerID = 0;
        Rivalry[I].Kills = 0;
        Rivalry[I].KilledBy = 0;
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    //return;    
}

simulated function AwardMedal(MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS Medal)
{
    // End:0x20
    if(int(PRI.m_MedalsAwardedArray[int(Medal)]) > 0)
    {
        return;
    }
    // End:0x90
    if(((((!PRI.m_bInRankedGame && int(Medal) != int(6)) && int(Medal) != int(13)) && int(Medal) != int(16)) && int(Medal) != int(18)) && int(Medal) != int(12))
    {
        return;
    }
    PRI.m_MedalsAwardedArray[int(Medal)] = 1;
    // End:0xC8
    if(int(Medal) <= int(15))
    {
        ShowAwardMedalMessage(Medal);
    }
    m_Controller.ClientGrantPlasmaAward(Medal);
    //return;    
}

simulated function string GetAwardMedalMessageText(MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS Medal)
{
    return MedalMessages[int(Medal)];
    //return ReturnValue;    
}

simulated function ShowAwardMedalMessage(MOHAMultiplayerGameInfo.E_MPSTATS_MEDAL_AWARDS Medal)
{
    m_Controller.ShowPopup(Medal, m_Controller.PlayerReplicationInfo.PlayerName, MedalIcons[int(Medal)], MedalAudio[int(Medal)]);
    //return;    
}

reliable server function StatAddSuicide()
{
    PRI.MP_Suicides++;
    StatAddDeath(false);
    //return;    
}

simulated function StatAddAAKill()
{
    PRI.MP_KillsAA++;
    AwardMedal(13);
    //return;    
}

simulated function StatAddHit()
{
    PRI.MPStatsWeapons[GetMPWeaponIndexFromController()].Hits++;
    //return;    
}

simulated function StatAddShotFired()
{
    PRI.MPStatsWeapons[GetMPWeaponIndexFromController()].Shots++;
    //return;    
}

simulated function bool IsControllerHoldingGrenade()
{
    local int WeaponType;

    // End:0x66
    if(m_Controller.Pawn.Weapon != none)
    {
        WeaponType = int(EALAWeapon(m_Controller.Pawn.Weapon).WeaponType);
        // End:0x66
        if((WeaponType == 2) || WeaponType == 11)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function int GetMPWeaponIndexFromController()
{
    local int WeaponType;

    // End:0x65
    if(m_Controller.Pawn.Weapon != none)
    {
        WeaponType = int(EALAWeapon(m_Controller.Pawn.Weapon).WeaponType);
        return int(m_Controller.GetMPWeaponIndex(WeaponType));
    }
    return -1;
    //return ReturnValue;    
}

simulated function MOHAIncludeClass.eWeaponClass GetWeaponClass(int MPIndex)
{
    switch(MPIndex)
    {
        // End:0x0B
        case 0:
        // End:0x12
        case 1:
            return 2;
        // End:0x17
        case 2:
        // End:0x1F
        case 3:
            return 3;
        // End:0x24
        case 4:
        // End:0x2C
        case 5:
            return 8;
        // End:0x31
        case 6:
        // End:0x39
        case 7:
            return 4;
        // End:0x3E
        case 8:
        // End:0x46
        case 9:
            return 5;
        // End:0x4B
        case 10:
        // End:0x53
        case 11:
            return 1;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

function StatAddGrenadeThrow()
{
    PRI.MP_GrenadesThrown++;
    //return;    
}

function StatAddGrenadeAirborneKill()
{
    PRI.MP_GrenadesAirborneKills++;
    AwardMedal(18);
    //return;    
}

function StatAddHitLocation(MOHAPawn.EHitLocation HitLoc)
{
    local int WeaponIndex;

    WeaponIndex = GetMPWeaponIndexFromController();
    switch(HitLoc)
    {
        // End:0x45
        case 0:
            PRI.MP_HitsHead++;
            PRI.MP_Weapon_HitsHead[WeaponIndex]++;
            // End:0x15C
            break;
        // End:0x73
        case 1:
            PRI.MP_HitsRArm++;
            PRI.MP_Weapon_HitsRArm[WeaponIndex]++;
            // End:0x15C
            break;
        // End:0xA1
        case 2:
            PRI.MP_HitsLArm++;
            PRI.MP_Weapon_HitsLArm[WeaponIndex]++;
            // End:0x15C
            break;
        // End:0xCF
        case 3:
            PRI.MP_HitsTorso++;
            PRI.MP_Weapon_HitsTorso[WeaponIndex]++;
            // End:0x15C
            break;
        // End:0xFD
        case 4:
            PRI.MP_HitsCrotch++;
            PRI.MP_Weapon_HitsCrotch[WeaponIndex]++;
            // End:0x15C
            break;
        // End:0x12B
        case 5:
            PRI.MP_HitsLLeg++;
            PRI.MP_Weapon_HitsLLeg[WeaponIndex]++;
            // End:0x15C
            break;
        // End:0x159
        case 6:
            PRI.MP_HitsRLeg++;
            PRI.MP_Weapon_HitsRLeg[WeaponIndex]++;
            // End:0x15C
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function StatAddTeamKill()
{
    PRI.MP_TeamKills++;
    PRI.CalculateScoreAndMarkStatsDirty();
    //return;    
}

function StatAddAirborneMelee()
{
    PRI.MP_AirborneMelees++;
    AwardMedal(12);
    //return;    
}

function StatAddKill(bool bMeleeKill, bool bGrenadeKill)
{
    local int WeaponIndex;

    PRI.m_oStatsLifeTime.Kills++;
    CheckMedalDistinguishedServiceCross();
    CheckMedalDistinguishedServiceMedal();
    WeaponIndex = GetMPWeaponIndexFromController();
    // End:0x85
    if(bGrenadeKill || m_Controller.Pawn.Weapon.IsA('EALAGrenade'))
    {
        PRI.MP_GrenadesKills++;        
    }
    else
    {
        // End:0x12C
        if(WeaponIndex != -1)
        {
            PRI.MPStatsWeapons[WeaponIndex].Kills++;
            CheckAndSetForWeaponUpgrade(WeaponIndex);
            UpdateWeaponExperience();
            // End:0x12C
            if(bMeleeKill)
            {
                PRI.MPStatsWeapons[WeaponIndex].MeleeKills++;
                // End:0x12C
                if(m_Controller.Pawn.Weapon.IsA('MOHAPistol'))
                {
                    AwardMedal(16);
                }
            }
        }
    }
    PRI.MP_KillStreakCurrent++;
    // End:0x15D
    if(PRI.MP_KillStreakCurrent > PRI.MP_KillStreak)
    {
    }
    PRI.MP_KillStreak = PRI.MP_KillStreakCurrent;
    PRI.MP_DeathStreakCurrent = 0;
    CheckMedalWeapons(WeaponIndex);
    PRI.CalculateScoreAndMarkStatsDirty();
    //return;    
}

simulated function int GetUpgradeLevelByType(MOHAIncludeClass.EWeaponType WeaponType)
{
    local int WeaponLevel;

    switch(WeaponType)
    {
        // End:0x0C
        case 1:
        // End:0x3A
        case 3:
            WeaponLevel = Clamp(PRI.MPStatsWeaponClass[3].UpgradeLevel, 0, 3);
            // End:0x110
            break;
        // End:0x3F
        case 13:
        // End:0x6D
        case 18:
            WeaponLevel = Clamp(PRI.MPStatsWeaponClass[8].UpgradeLevel, 0, 3);
            // End:0x110
            break;
        // End:0x72
        case 7:
        // End:0xA0
        case 8:
            WeaponLevel = Clamp(PRI.MPStatsWeaponClass[2].UpgradeLevel, 0, 3);
            // End:0x110
            break;
        // End:0xA5
        case 14:
        // End:0xD3
        case 20:
            WeaponLevel = Clamp(PRI.MPStatsWeaponClass[5].UpgradeLevel, 0, 3);
            // End:0x110
            break;
        // End:0xD8
        case 4:
        // End:0x106
        case 17:
            WeaponLevel = Clamp(PRI.MPStatsWeaponClass[4].UpgradeLevel, 0, 3);
            // End:0x110
            break;
        // End:0xFFFF
        default:
            WeaponLevel = 0;
            break;
    }
    return WeaponLevel;
    //return ReturnValue;    
}

function CheckAndSetForWeaponUpgrade(int WeaponIndex, optional bool bInitialStatGathering = false)
{
    local MOHAIncludeClass.eWeaponClass wclass;
    local int I, NewLevel;

    // End:0x28
    if(!bInitialStatGathering && !PRI.m_bInRankedGame)
    {
        return;
    }
    wclass = GetWeaponClass(WeaponIndex);
    // End:0x4F
    if(int(wclass) == int(1))
    {
        return;
    }
    NewLevel = 0;
    I = 0;
    J0x5D:

    // End:0xAA [Loop If]
    if(I < 3)
    {
        // End:0xA0
        if(PRI.GetWeaponClassScore(wclass, true) >= WeaponLevelExpCap[I])
        {
            NewLevel = I + 1;
        }
        I++;
        // [Loop Continue]
        goto J0x5D;
    }
    // End:0x149
    if((NewLevel > PRI.MPStatsWeaponClass[int(wclass)].UpgradeLevel) && !bInitialStatGathering)
    {
        PRI.MPStatsWeaponClass[int(wclass)].UpgradeLevel = NewLevel;
        m_Controller.ShowPopup(15, m_Controller.PlayerReplicationInfo.PlayerName, WeaponUpgradeMedalIcons[NewLevel], WeaponUpgradeMedalAudio[NewLevel]);
    }
    // End:0x178
    if(bInitialStatGathering)
    {
        PRI.MPStatsWeaponClass[int(wclass)].UpgradeLevel = NewLevel;
    }
    // End:0x236
    if(((((PRI.MPStatsWeaponClass[2].UpgradeLevel >= 3) && PRI.MPStatsWeaponClass[3].UpgradeLevel >= 3) && PRI.MPStatsWeaponClass[4].UpgradeLevel >= 3) && PRI.MPStatsWeaponClass[5].UpgradeLevel >= 3) && PRI.MPStatsWeaponClass[8].UpgradeLevel >= 3)
    {
        AwardMedal(17);
    }
    //return;    
}

function StatAddKillAssist()
{
    PRI.MP_KillAssists++;
    PRI.m_oStatsLifeTime.KillAssists++;
    CheckMedalSoldiersMedal();
    //return;    
}

function StatAddDeath(bool bMeleeKill)
{
    local int WeaponIndex;
    local EALAGrenade locGrenade;

    WeaponIndex = GetMPWeaponIndexFromController();
    locGrenade = EALAGrenade(m_Controller.Pawn.Weapon);
    WeaponIndex = GetMPWeaponIndexFromController();
    // End:0x60
    if(locGrenade != none)
    {
        PRI.MP_GrenadesDeaths++;        
    }
    else
    {
        // End:0xB8
        if(WeaponIndex != -1)
        {
            PRI.MPStatsWeapons[WeaponIndex].Deaths++;
            // End:0xB8
            if(bMeleeKill)
            {
                PRI.MPStatsWeapons[WeaponIndex].MeleeDeaths++;
            }
        }
    }
    // End:0xD1
    if(bMeleeKill)
    {
        PRI.MP_MeleeDeaths++;
    }
    PRI.MP_DeathStreakCurrent++;
    // End:0x102
    if(PRI.MP_DeathStreakCurrent > PRI.MP_DeathStreak)
    {
    }
    PRI.MP_DeathStreak = PRI.MP_DeathStreakCurrent;
    PRI.MP_KillStreakCurrent = 0;
    PRI.CalculateScoreAndMarkStatsDirty();
    //return;    
}

function StatAddTeamPoint(optional int NumTeamPoints = 1)
{
    PRI.m_iTeamPoints += NumTeamPoints;
    PRI.CalculateScoreAndMarkStatsDirty();
    //return;    
}

function StatAddObjectivePoint(optional int NumObjPoints = 1)
{
    PRI.m_iObjectivePoints += NumObjPoints;
    PRI.m_oStatsLifeTime.ObjectivePoints += NumObjPoints;
    CheckMedalDistinguishedServiceCross();
    CheckMedalDistinguishedServiceMedal();
    CheckMedalLegionOfMerit();
    PRI.CalculateScoreAndMarkStatsDirty();
    //return;    
}

function int GetMapIndex()
{
    local string MapName;
    local int I;

    MapName = MOHAGameReplicationInfo(m_Controller.WorldInfo.GRI).GetMapAbbr();
    I = 0;
    J0x37:

    // End:0x68 [Loop If]
    if(I < 6)
    {
        // End:0x5E
        if(MapNames[I] == MapName)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x37;
    }
    return 255;
    //return ReturnValue;    
}

simulated function AddEndOfRoundStats(bool bOnWinningTeam, int iPosition)
{
    local int MapIndex;

    MapIndex = GetMapIndex();
    StatAddPlace(bOnWinningTeam, iPosition, MapIndex);
    // End:0x5B
    if(PRI.MP_TeamKills == 0)
    {
        PRI.m_oStatsLifeTime.ActiveGoodConductStreak++;        
    }
    else
    {
        PRI.m_oStatsLifeTime.ActiveGoodConductStreak = 0;
    }
    CheckEndOfRoundMedals();
    //return;    
}

simulated function StatAddPlace(bool OnWinningTeam, int iPosition, int MapIndex)
{
    // End:0x0E
    if(MapIndex == 255)
    {
        return;
    }
    // End:0x49
    if(OnWinningTeam && m_bHasSwitchedTeams == false)
    {
        PRI.m_oStatsLifeTime.MapProgress[MapIndex] = 2;        
    }
    else
    {
        // End:0x93
        if(int(PRI.m_oStatsLifeTime.MapProgress[MapIndex]) == int(0))
        {
            PRI.m_oStatsLifeTime.MapProgress[MapIndex] = 1;
        }
    }
    // End:0xFF
    if(iPosition <= 3)
    {
        PRI.m_oStatsLifeTime.TopThrees++;
        // End:0xFF
        if(iPosition == 1)
        {
            PRI.m_oStatsLifeTime.MapFirstPlace[MapIndex] = 1;
            PRI.m_oStatsLifeTime.FirstPlaces++;
        }
    }
    //return;    
}

simulated function CheckMedalDistinguishedServiceCross()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    // End:0x68
    if((PRI.m_oStatsLifeTime.Kills >= MedalDistinguishedServiceCrossKillsReq) && PRI.m_oStatsLifeTime.ObjectivePoints >= MedalDistinguishedServiceCrossObjReq)
    {
        AwardMedal(0);
    }
    //return;    
}

simulated function CheckMedalDistinguishedServiceMedal()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    // End:0x68
    if((PRI.m_oStatsLifeTime.Kills >= MedalDistinguishedServiceMedalKillsReq) && PRI.m_oStatsLifeTime.ObjectivePoints >= MedalDistinguishedServiceMedalObjReq)
    {
        AwardMedal(1);
    }
    //return;    
}

simulated function CheckMedalLegionOfMerit()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    // End:0x3A
    if(PRI.m_iObjectivePoints >= MedalLegionOfMeritObjectivePointsReq)
    {
        AwardMedal(3);
    }
    //return;    
}

simulated function CheckMedalSoldiersMedal()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    // End:0x44
    if(PRI.m_oStatsLifeTime.KillAssists >= MedalSoldiersMedalKillAssistsReq)
    {
        AwardMedal(4);
    }
    //return;    
}

simulated function AwardDistinguishedCitation()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    AwardMedal(14);
    //return;    
}

simulated function AwardMeritoriousUnitCitation()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    AwardMedal(11);
    //return;    
}

simulated function CheckMedalWeapons(int WeaponIndex)
{
    //return;    
}

simulated function CheckMedalPurpleHeart(int LowestHealthThisLife)
{
    // End:0x1B
    if(LowestHealthThisLife <= MedalPurpleHeartMinHealthReq)
    {
        AwardMedal(6);
    }
    //return;    
}

simulated function CheckEndOfRoundMedals()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    CheckSilverStar();
    CheckBronzeStar();
    CheckWW2VictoryMedal();
    CheckAmericanCampaignMedal();
    CheckEuroArfMidEastCampaignMedal();
    CheckGoodConductMedal();
    //return;    
}

simulated function CheckSilverStar()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    // End:0x44
    if(PRI.m_oStatsLifeTime.FirstPlaces >= MedalSilverStarFirstsPlacesReq)
    {
        AwardMedal(2);
    }
    //return;    
}

simulated function CheckBronzeStar()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    // End:0x44
    if(PRI.m_oStatsLifeTime.TopThrees >= MedalBronzeStarTopThreePlacesReq)
    {
        AwardMedal(5);
    }
    //return;    
}

simulated function CheckGoodConductMedal()
{
    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    // End:0x44
    if(PRI.m_oStatsLifeTime.ActiveGoodConductStreak >= MedalGoodCombatMedalStreakReq)
    {
        AwardMedal(10);
    }
    //return;    
}

simulated function CheckWW2VictoryMedal()
{
    local int I;

    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    I = 0;
    J0x1D:

    // End:0x6D [Loop If]
    if(I < 6)
    {
        // End:0x63
        if(MapNames[I] != "")
        {
            // End:0x63
            if(int(PRI.m_oStatsLifeTime.MapFirstPlace[I]) != 1)
            {
                return;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1D;
    }
    AwardMedal(7);
    //return;    
}

simulated function CheckAmericanCampaignMedal()
{
    local int I;

    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    I = 0;
    J0x1D:

    // End:0x70 [Loop If]
    if(I < 6)
    {
        // End:0x66
        if(MapNames[I] != "")
        {
            // End:0x66
            if(int(PRI.m_oStatsLifeTime.MapProgress[I]) != int(2))
            {
                return;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1D;
    }
    AwardMedal(8);
    //return;    
}

simulated function CheckEuroArfMidEastCampaignMedal()
{
    local int I;

    // End:0x16
    if(!PRI.m_bInRankedGame)
    {
        return;
    }
    I = 0;
    J0x1D:

    // End:0x70 [Loop If]
    if(I < 6)
    {
        // End:0x66
        if(MapNames[I] != "")
        {
            // End:0x66
            if(int(PRI.m_oStatsLifeTime.MapProgress[I]) == int(0))
            {
                return;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x1D;
    }
    AwardMedal(9);
    //return;    
}

simulated function Init()
{
    ResetStatsPerMatch();
    SetupRivalryData();
    //return;    
}

simulated function SetupRivalryData()
{
    // End:0x16
    if(Rivalry.Length < 8)
    {
        Rivalry.Insert(0, 8);
    }
    //return;    
}

simulated function StatAddRival(int OtherID, bool bIamKiller)
{
    local int I, Index;

    Index = -1;
    I = 0;
    J0x12:

    // End:0x55 [Loop If]
    if(I < 8)
    {
        // End:0x4B
        if(Rivalry[I].PlayerID == OtherID)
        {
            Index = I;
            // [Explicit Break]
            goto J0x55;
        }
        I++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x55:

    // End:0xC5
    if(Index == -1)
    {
        I = 0;
        J0x6B:

        // End:0xC5 [Loop If]
        if(I < 8)
        {
            // End:0xBB
            if(Rivalry[I].PlayerID == 0)
            {
                Rivalry[I].PlayerID = OtherID;
                Index = I;
                // [Explicit Break]
                goto J0xC5;
            }
            I++;
            // [Loop Continue]
            goto J0x6B;
        }
    }
    J0xC5:

    // End:0xE8
    if(bIamKiller)
    {
        Rivalry[Index].Kills++;        
    }
    else
    {
        Rivalry[Index].KilledBy++;
    }
    //return;    
}

simulated function SetCurrentWeaponExperience(MOHAWeaponExperienceComponent WeaponExperience)
{
    CurrentWeaponExperience = WeaponExperience;
    UpdateWeaponExperience();
    //return;    
}

simulated function UpdateWeaponExperience()
{
    local MOHAIncludeClass.eWeaponClass ClassIndex;
    local int CurrentExp, UpgradeLevel, I;
    local MOHAGameReplicationInfo MGRI;
    local int NewLevel;

    MGRI = MOHAGameReplicationInfo(m_Controller.WorldInfo.GRI);
    // End:0x48
    if(IsControllerHoldingGrenade())
    {
        ClassIndex = 7;
        CurrentExp = 0;
        UpgradeLevel = 0;        
    }
    else
    {
        ClassIndex = GetWeaponClass(GetMPWeaponIndexFromController());
        // End:0x7C
        if(int(ClassIndex) == int(1))
        {
            CurrentExp = 0;            
        }
        else
        {
            // End:0xB0
            if(PRI.m_bInRankedGame)
            {
                CurrentExp = PRI.GetWeaponClassScore(ClassIndex, true);                
            }
            else
            {
                // End:0xEA
                if(int(MGRI.UpgradesAllowed) == int(1))
                {
                    CurrentExp = PRI.GetWeaponLifeTimeClassScore(ClassIndex);                    
                }
                else
                {
                    CurrentExp = 0;
                }
            }
        }
        NewLevel = 0;
        I = 0;
        J0xFF:

        // End:0x138 [Loop If]
        if(I < 3)
        {
            // End:0x12E
            if(CurrentExp >= WeaponLevelExpCap[I])
            {
                NewLevel = I + 1;
            }
            I++;
            // [Loop Continue]
            goto J0xFF;
        }
        UpgradeLevel = NewLevel;
    }
    // End:0x150
    if(CurrentWeaponExperience == none)
    {
        return;
    }
    CurrentWeaponExperience.ExperienceLevel = UpgradeLevel;
    I = 0;
    J0x16B:

    // End:0x1A3 [Loop If]
    if(I < 3)
    {
        CurrentWeaponExperience.ExperienceLevelPoints[I] = float(WeaponLevelExpCap[I]);
        I++;
        // [Loop Continue]
        goto J0x16B;
    }
    CurrentWeaponExperience.ExperiencePoints = float(CurrentExp);
    //return;    
}

simulated function UpdatePlasmaWithLifeTimeStats(int Position, int winningTeamIndex, int RankScore)
{
    local Plasma P;
    local MOHAGameReplicationInfo GRI;
    local string GameTypeTeamMap;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    GRI = MOHAGameReplicationInfo(m_Controller.WorldInfo.GRI);
    // End:0x513
    if(P.isRanked())
    {
        P.SetStatValue("KILLS", float(PRI.m_oStatsLifeTime.Kills));
        P.SetStatValue("KILLASST", float(PRI.m_oStatsLifeTime.KillAssists));
        P.SetStatValue("OBJPTS", float(PRI.m_oStatsLifeTime.ObjectivePoints));
        // End:0x146
        if(Position == 1)
        {
            P.SetStatValue("FINISH_FIRST", P.GetStatValue("FINISH_FIRST") + float(1));            
        }
        else
        {
            // End:0x19E
            if(Position == 2)
            {
                P.SetStatValue("FINISH_SECOND", P.GetStatValue("FINISH_SECOND") + float(1));                
            }
            else
            {
                // End:0x1F1
                if(Position == 3)
                {
                    P.SetStatValue("FINISH_THIRD", P.GetStatValue("FINISH_THIRD") + float(1));
                }
            }
        }
        P.SetStatValue("ACTIVE_NOTKS_STREAK", float(PRI.m_oStatsLifeTime.ActiveGoodConductStreak));
        P.SetStatValue("WC_RIFLE_EXP", float(PRI.GetWeaponClassScore(2, true)));
        P.SetStatValue("WC_SMG_EXP", float(PRI.GetWeaponClassScore(3, true)));
        P.SetStatValue("WC_AUTO_EXP", float(PRI.GetWeaponClassScore(8, true)));
        P.SetStatValue("WC_SNIPER_EXP", float(PRI.GetWeaponClassScore(4, true)));
        P.SetStatValue("WC_ATANK_EXP", float(PRI.GetWeaponClassScore(5, true)));
        GameTypeTeamMap = "MAP_" $ GRI.GetMapAbbr();
        P.SetStatValue(GameTypeTeamMap $ "_GAMES", P.GetStatValue(GameTypeTeamMap $ "_GAMES") + float(1));
        // End:0x420
        if(PRI.Team.TeamIndex == winningTeamIndex)
        {
            P.SetStatValue(GameTypeTeamMap $ "_WINS", P.GetStatValue(GameTypeTeamMap $ "_WINS") + float(1));
        }
        // End:0x47D
        if(P.GetStatValue(GameTypeTeamMap $ "_BESTRANK") > float(Position))
        {
            P.SetStatValue(GameTypeTeamMap $ "_BESTRANK", float(Position));
        }
        P.SetStatValue("RANK_POINTS", P.GetStatValue("RANK_POINTS") + float(RankScore));
        // End:0x513
        if(P.GetStatValue("RANK_POINTS") < float(0))
        {
            P.SetStatValue("RANK_POINTS", 0.0000000);
        }
    }
    //return;    
}

simulated function GetLifetimeStats()
{
    local Plasma P;
    local int I;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    PRI.m_oStatsLifeTime.Kills = int(P.GetStatValue("KILLS"));
    PRI.m_oStatsLifeTime.KillAssists = int(P.GetStatValue("KILLASST"));
    PRI.m_oStatsLifeTime.ObjectivePoints = int(P.GetStatValue("OBJPTS"));
    PRI.m_oStatsLifeTime.FirstPlaces = int(P.GetStatValue("FINISH_FIRST"));
    PRI.m_oStatsLifeTime.TopThrees = int((P.GetStatValue("FINISH_FIRST") + P.GetStatValue("FINISH_SECOND")) + P.GetStatValue("FINISH_THIRD"));
    PRI.m_oStatsLifeTime.ActiveGoodConductStreak = int(P.GetStatValue("ACTIVE_NOTKS_STREAK"));
    PRI.m_oStatsLifeTime.WC_RIFLE_EXP = int(P.GetStatValue("WC_RIFLE_EXP"));
    PRI.m_oStatsLifeTime.WC_SMG_EXP = int(P.GetStatValue("WC_SMG_EXP"));
    PRI.m_oStatsLifeTime.WC_AUTO_EXP = int(P.GetStatValue("WC_AUTO_EXP"));
    PRI.m_oStatsLifeTime.WC_SNIPER_EXP = int(P.GetStatValue("WC_SNIPER_EXP"));
    PRI.m_oStatsLifeTime.WC_ATANK_EXP = int(P.GetStatValue("WC_ATANK_EXP"));
    I = 0;
    J0x2EF:

    // End:0x44E [Loop If]
    if(I < 6)
    {
        // End:0x310
        if(MapNames[I] == "")
        {
            // [Explicit Continue]
            goto J0x444;
        }
        // End:0x36B
        if(P.GetStatValue(("MAP_" $ MapNames[I]) $ "_WINS") > float(0))
        {
            PRI.m_oStatsLifeTime.MapProgress[I] = 2;            
        }
        else
        {
            // End:0x3C7
            if(P.GetStatValue(("MAP_" $ MapNames[I]) $ "_GAMES") > float(0))
            {
                PRI.m_oStatsLifeTime.MapProgress[I] = 1;                
            }
            else
            {
                PRI.m_oStatsLifeTime.MapProgress[I] = 0;
            }
        }
        // End:0x444
        if(P.GetStatValue(("MAP_" $ MapNames[I]) $ "_BESTRANK") == float(1))
        {
            PRI.m_oStatsLifeTime.MapFirstPlace[I] = 1;
        }
        J0x444:

        I++;
        // [Loop Continue]
        goto J0x2EF;
    }
    // End:0x488
    if(P.IsMyAwardGranted("ACH_MP_DS_Cross"))
    {
        PRI.m_MedalsAwardedArray[0] = 1;
    }
    // End:0x4C2
    if(P.IsMyAwardGranted("ACH_MP_DS_Medal"))
    {
        PRI.m_MedalsAwardedArray[1] = 1;
    }
    // End:0x500
    if(P.IsMyAwardGranted("ACH_MP_Silver_Star"))
    {
        PRI.m_MedalsAwardedArray[2] = 1;
    }
    // End:0x53F
    if(P.IsMyAwardGranted("ACH_MP_Lgn_of_Merit"))
    {
        PRI.m_MedalsAwardedArray[3] = 1;
    }
    // End:0x580
    if(P.IsMyAwardGranted("ACH_MP_Soldiers_Medal"))
    {
        PRI.m_MedalsAwardedArray[4] = 1;
    }
    // End:0x5BE
    if(P.IsMyAwardGranted("ACH_MP_Bronze_Star"))
    {
        PRI.m_MedalsAwardedArray[5] = 1;
    }
    // End:0x5FD
    if(P.IsMyAwardGranted("ACH_MP_Purple_Heart"))
    {
        PRI.m_MedalsAwardedArray[6] = 1;
    }
    // End:0x63C
    if(P.IsMyAwardGranted("ACH_MP_WWII_Victory"))
    {
        PRI.m_MedalsAwardedArray[7] = 1;
    }
    // End:0x676
    if(P.IsMyAwardGranted("ACH_MP_US_Cmpn"))
    {
        PRI.m_MedalsAwardedArray[8] = 1;
    }
    // End:0x6B2
    if(P.IsMyAwardGranted("ACH_MP_EAME_Cmpn"))
    {
        PRI.m_MedalsAwardedArray[9] = 1;
    }
    // End:0x6F1
    if(P.IsMyAwardGranted("ACH_MP_Good_Conduct"))
    {
        PRI.m_MedalsAwardedArray[10] = 1;
    }
    // End:0x72E
    if(P.IsMyAwardGranted("ACH_MP_Merit_Unit"))
    {
        PRI.m_MedalsAwardedArray[11] = 1;
    }
    // End:0x76B
    if(P.IsMyAwardGranted("ACH_MP_Para_Badge"))
    {
        PRI.m_MedalsAwardedArray[12] = 1;
    }
    // End:0x7AA
    if(P.IsMyAwardGranted("ACH_MP_Combat_Badge"))
    {
        PRI.m_MedalsAwardedArray[13] = 1;
    }
    // End:0x7E8
    if(P.IsMyAwardGranted("ACH_MP_Pistol_Whip"))
    {
        PRI.m_MedalsAwardedArray[16] = 1;
    }
    // End:0x827
    if(P.IsMyAwardGranted("ACH_MP_LittleFriend"))
    {
        PRI.m_MedalsAwardedArray[17] = 1;
    }
    // End:0x868
    if(P.IsMyAwardGranted("ACH_MP_Human_Flak_Gun"))
    {
        PRI.m_MedalsAwardedArray[18] = 1;
    }
    PRI.m_bInRankedGame = P.isRanked();
    // End:0x90F
    if(m_Controller.IsLocalPlayerController())
    {
        m_Controller.ServerSetStatLifeTimeValues(PRI.m_oStatsLifeTime, PRI.m_MedalsAwardedArray);
        I = 0;
        J0x8D7:

        // End:0x90F [Loop If]
        if(I <= 8)
        {
            m_Controller.m_MPPlayerStats.CheckAndSetForWeaponUpgrade(I, true);
            I++;
            // [Loop Continue]
            goto J0x8D7;
        }
    }
    //return;    
}

defaultproperties
{
    MedalDistinguishedServiceCrossKillsReq=1000
    MedalDistinguishedServiceCrossObjReq=500
    MedalDistinguishedServiceMedalKillsReq=500
    MedalDistinguishedServiceMedalObjReq=250
    MedalSilverStarFirstsPlacesReq=20
    MedalLegionOfMeritObjectivePointsReq=10
    MedalSoldiersMedalKillAssistsReq=20
    MedalBronzeStarTopThreePlacesReq=20
    MedalPurpleHeartMinHealthReq=25
    MedalMeritoriousUnitCitationTeamPointsReq=10
    MedalDistinguishedUnitCitationTeamPointsReq=20
    MedalGoodCombatMedalStreakReq=20
    MedalMarksmanKillsReq=100
    MedalSharpshooterKillsReq=1000
    MedalExpertKillsReq=10000
    MedalMessages[0]="Service Cross awarded to %1"
    MedalMessages[1]="Service Medal awarded to %1"
    MedalMessages[2]="Silver Star awarded to %1"
    MedalMessages[3]="Legion of Merit awarded to %1"
    MedalMessages[4]="Soldiers Medal awarded to %1"
    MedalMessages[5]="Bronze Star awarded to %1"
    MedalMessages[6]="Purple Heart awarded to %1"
    MedalMessages[7]="WW2 Victory Medal awarded to %1"
    MedalMessages[8]="American Campaign Medal awarded to %1"
    MedalMessages[9]="EAME Campaign Medal awarded to %1"
    MedalMessages[10]="Good Conduct Medal awarded to %1"
    MedalMessages[11]="Meritorious Unit Citation awarded to %1"
    MedalMessages[12]="Paratrooper's Badge awarded to %1"
    MedalMessages[13]="Combat Infantry Badge awarded to %1"
    MedalMessages[14]="Presidential Unit Citation awarded to %1"
    MedalMessages[15]="%1 has received a weapon upgrade"
    MedalMessages[16]="%1 has performed a pistol whip"
    MedalMessages[17]="%1 has upgraded every weapon"
    MedalMessages[18]="%1 is a human flak gun"
    WeaponLevelExpCap[0]=40
    WeaponLevelExpCap[1]=150
    WeaponLevelExpCap[2]=320
    MedalIcons[0]=Texture2D'MP_UI_Medals.Md1_DistServCross'
    MedalIcons[1]=Texture2D'MP_UI_Medals.Md2_DistServMedal'
    MedalIcons[2]=Texture2D'MP_UI_Medals.Md3_SilverStar'
    MedalIcons[3]=Texture2D'MP_UI_Medals.Md4_LegionOfMerit'
    MedalIcons[4]=Texture2D'MP_UI_Medals.Md5_SoldiersMedal'
    MedalIcons[5]=Texture2D'MP_UI_Medals.Md6_BronzeStar'
    MedalIcons[6]=Texture2D'MP_UI_Medals.Md7_PurpleHeart'
    MedalIcons[7]=Texture2D'MP_UI_Medals.Md8_WW2VictoryMedal'
    MedalIcons[8]=Texture2D'MP_UI_Medals.Md9_AmCampaignMedal'
    MedalIcons[9]=Texture2D'MP_UI_Medals.Md10_EAMCampaignMedal'
    MedalIcons[10]=Texture2D'MP_UI_Medals.Md11_GoodConductMedal'
    MedalIcons[11]=Texture2D'MP_UI_Medals.Md13_MeritUnitCitation'
    MedalIcons[12]=Texture2D'MP_UI_Medals.Md15_ParaBadge'
    MedalIcons[13]=Texture2D'MP_UI_Medals.Md14_CombatInfBadge'
    MedalIcons[14]=Texture2D'MP_UI_Medals.Md12_PresUnitCitation'
    WeaponUpgradeMedalIcons[0]=Texture2D'HUD.Weapon_1'
    WeaponUpgradeMedalIcons[1]=Texture2D'HUD.Weapon_1'
    WeaponUpgradeMedalIcons[2]=Texture2D'HUD.Weapon_2'
    WeaponUpgradeMedalIcons[3]=Texture2D'HUD.Weapon_3'
    MedalAudio[0]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[1]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[2]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[3]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[4]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[5]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[6]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[7]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[8]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[9]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[10]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[11]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[12]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[13]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    MedalAudio[14]=SoundCue'Aud_MP_FakeWAV.Items.Medal'
    WeaponUpgradeMedalAudio[0]=SoundCue'Aud_MP_FakeWAV.Items.Weapon_Upgrade'
    WeaponUpgradeMedalAudio[1]=SoundCue'Aud_MP_FakeWAV.Items.Weapon_Upgrade'
    WeaponUpgradeMedalAudio[2]=SoundCue'Aud_MP_FakeWAV.Items.Weapon_Upgrade'
    WeaponUpgradeMedalAudio[3]=SoundCue'Aud_MP_FakeWAV.Items.Weapon_Upgrade'
    MapNames[0]="REM"
    MapNames[1]="HNT"
    MapNames[2]="VIL"
    MapNames[3]="HUS"
    MapNames[4]="AVA"
    MapNames[5]="NEP"
}