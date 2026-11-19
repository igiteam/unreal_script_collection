class MOHAPlayerReplicationInfo extends PlayerReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

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

enum EMatchAwards
{
    MATCH_AWARD_MOST_ACCURATE,      // 0
    MATCH_AWARD_DEADLIEST,          // 1
    MATCH_AWARD_HEADSHOTS,          // 2
    MATCH_AWARD_KILLSTREAK,         // 3
    MATCH_AWARD_RIFLE,              // 4
    MATCH_AWARD_SMG,                // 5
    MATCH_AWARD_AUTORIFLE,          // 6
    MATCH_AWARD_SNIPER,             // 7
    MATCH_AWARD_ANTITANK,           // 8
    MATCH_AWARD_MG,                 // 9
    MATCH_AWARD_BANDAGES,           // 10
    MATCH_AWARD_SHARED_KILL,        // 11
    MATCH_AWARD_OBJECTIVE,          // 12
    MATCH_AWARD_BEST_DROP,          // 13
    MATCH_AWARD_DROP_KILLS,         // 14
    MATCH_AWARD_AA_KILLS,           // 15
    MATCH_AWARD_MATCH_RIVALRY_1,    // 16
    MATCH_AWARD_MATCH_RIVALRY_2,    // 17
    MATCH_AWARD_PLAYER_RIVALRY_1,   // 18
    MATCH_AWARD_PLAYER_RIVALRY_2,   // 19
    MATCH_AWARD_MOST_USELESS,       // 20
    MATCH_AWARD_MOST_DEATHS,        // 21
    MATCH_AWARD_DEATH_STREAK,       // 22
    MATCH_AWARD_SUICIDAL,           // 23
    MATCH_AWARD_COUNT,              // 24
    MATCH_AWARD_MAX                 // 25
};

enum eWeaponLevel
{
    WEAPON_LEVEL_NoSkill,           // 0
    WEAPON_LEVEL_Marksman,          // 1
    WEAPON_LEVEL_Sharpshooter,      // 2
    WEAPON_LEVEL_Expert,            // 3
    WEAPON_LEVEL_MAX                // 4
};

enum EMPWeapons
{
    MPWEAPON_GARAND,                // 0
    MPWEAPON_K98K,                  // 1
    MPWEAPON_THOMPSON,              // 2
    MPWEAPON_MP40,                  // 3
    MPWEAPON_BAR,                   // 4
    MPWEAPON_STG44,                 // 5
    MPWEAPON_SPRINGFIELD,           // 6
    MPWEAPON_G43,                   // 7
    MPWEAPON_BAZOOKA,               // 8
    MPWEAPON_PANZER,                // 9
    MPWEAPON_M1911,                 // 10
    MPWEAPON_MAUSER,                // 11
    MPWEAPON_MAX                    // 12
};

struct native EndOfGameScore
{
    var int Score;
    var int Kills;
    var int Deaths;
    var int TeamPoints;
    var int ObjectivePoints;
    var int TempRoundStatus;
    var int TempLastRoundWinningTeam;
    var bool bValid;

    structdefaultproperties
    {
        Score=0
        Kills=0
        Deaths=0
        TeamPoints=0
        ObjectivePoints=0
        TempRoundStatus=0
        TempLastRoundWinningTeam=0
        bValid=false
    }
};

struct native EndOfGameAwardStatInfo
{
    var int AwardStatPlayerID;
    var int AwardStatValue;

    structdefaultproperties
    {
        AwardStatPlayerID=0
        AwardStatValue=0
    }
};

struct native MPWeaponStats
{
    var float Time;
    var int Hits;
    var int Shots;
    var int Kills;
    var byte MeleeKills;
    var byte Deaths;
    var byte MeleeDeaths;

    structdefaultproperties
    {
        Time=0.0000000
        Hits=0
        Shots=0
        Kills=0
        MeleeKills=0
        Deaths=0
        MeleeDeaths=0
    }
};

struct native MPWeaponClassStats
{
    var MOHAPlayerReplicationInfo.eWeaponLevel Level;
    var int UpgradeLevel;

    structdefaultproperties
    {
        Level=0
        UpgradeLevel=0
    }
};

struct native ITPSeatInfo
{
    var int ITPPlaneNum;
    var int ITPSeatNum;

    structdefaultproperties
    {
        ITPPlaneNum=0
        ITPSeatNum=0
    }
};

struct native MissionRatingByDifficulty
{
    var int iRating[3];

    structdefaultproperties
    {
        iRating[0]=0
        iRating[1]=0
        iRating[2]=0
    }
};

struct native SkillDropLanding
{
    var bool bLandedMe;

    structdefaultproperties
    {
        bLandedMe=false
    }
};

struct native SPGlobalStats
{
    var int iKills;
    var int iDeaths;
    var int iHits;
    var int iShotsFired;
    var int iMeleeKills;
    var int iGrenadeKills;
    var float fTimePlayed;
    var int iDistanceTravelled;
    var int iThreeInARows;
    var int iFiveInARows;
    var int iHitHead;
    var int iHitTorso;
    var int iHitArms;
    var int iHitLegs;
    var int iHitGroin;
    var int iHitAlly;
    var int iGrenadeKicks;
    var int iAirDrops;
    var int iBotchedLandings;
    var int iFlaredLandings;
    var int iGreasedLandings;
    var int iSkillDropLandings;
    var MissionRatingByDifficulty MissionRatingStats[7];

    structdefaultproperties
    {
        iKills=0
        iDeaths=0
        iHits=0
        iShotsFired=0
        iMeleeKills=0
        iGrenadeKills=0
        fTimePlayed=0.0000000
        iDistanceTravelled=0
        iThreeInARows=0
        iFiveInARows=0
        iHitHead=0
        iHitTorso=0
        iHitArms=0
        iHitLegs=0
        iHitGroin=0
        iHitAlly=0
        iGrenadeKicks=0
        iAirDrops=0
        iBotchedLandings=0
        iFlaredLandings=0
        iGreasedLandings=0
        iSkillDropLandings=0
        MissionRatingStats[0]=(iRating=0,iRating[1]=0,iRating[2]=0)
        MissionRatingStats[1]=(iRating=0,iRating[1]=0,iRating[2]=0)
        MissionRatingStats[2]=(iRating=0,iRating[1]=0,iRating[2]=0)
        MissionRatingStats[3]=(iRating=0,iRating[1]=0,iRating[2]=0)
        MissionRatingStats[4]=(iRating=0,iRating[1]=0,iRating[2]=0)
        MissionRatingStats[5]=(iRating=0,iRating[1]=0,iRating[2]=0)
        MissionRatingStats[6]=(iRating=0,iRating[1]=0,iRating[2]=0)
    }
};

struct native SPWeaponStats
{
    var int iKills;
    var int iHits;
    var int iShotsFired;
    var int iMeleeKills;
    var int iHitHead;
    var int iHitTorso;
    var int iHitArms;
    var int iHitLegs;
    var int iHitGroin;
    var bool bFound;
    var bool bFullyUpgraded;

    structdefaultproperties
    {
        iKills=0
        iHits=0
        iShotsFired=0
        iMeleeKills=0
        iHitHead=0
        iHitTorso=0
        iHitArms=0
        iHitLegs=0
        iHitGroin=0
        bFound=false
        bFullyUpgraded=false
    }
};

struct native SPMissionStats
{
    var int iKills;
    var int iDeaths;
    var int iHits;
    var int iShotsFired;
    var int iMeleeKills;
    var int iGrenadeKills;
    var float fTimePlayed;
    var int iDistanceTravelled;
    var int iThreeInARows;
    var int iFiveInARows;
    var int iHitHead;
    var int iHitTorso;
    var int iHitArms;
    var int iHitLegs;
    var int iHitGroin;
    var int iHitAlly;
    var int iGrenadeKicks;
    var int iAirDrops;
    var int iBotchedLandings;
    var int iFlaredLandings;
    var int iGreasedLandings;
    var int iSkillDropLandings;
    var SkillDropLanding SkillDropLandings[5];
    var MOHAIncludeClass.EDropBadgeType eDropBadge;
    var bool bCompleted;
    var SPWeaponStats MissionWeaponStats[25];

    structdefaultproperties
    {
        iKills=0
        iDeaths=0
        iHits=0
        iShotsFired=0
        iMeleeKills=0
        iGrenadeKills=0
        fTimePlayed=0.0000000
        iDistanceTravelled=0
        iThreeInARows=0
        iFiveInARows=0
        iHitHead=0
        iHitTorso=0
        iHitArms=0
        iHitLegs=0
        iHitGroin=0
        iHitAlly=0
        iGrenadeKicks=0
        iAirDrops=0
        iBotchedLandings=0
        iFlaredLandings=0
        iGreasedLandings=0
        iSkillDropLandings=0
        SkillDropLandings[0]=(bLandedMe=false)
        SkillDropLandings[1]=(bLandedMe=false)
        SkillDropLandings[2]=(bLandedMe=false)
        SkillDropLandings[3]=(bLandedMe=false)
        SkillDropLandings[4]=(bLandedMe=false)
        eDropBadge=0
        bCompleted=false
        MissionWeaponStats[0]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[1]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[2]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[3]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[4]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[5]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[6]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[7]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[8]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[9]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[10]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[11]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[12]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[13]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[14]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[15]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[16]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[17]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[18]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[19]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[20]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[21]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[22]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[23]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
        MissionWeaponStats[24]=(iKills=0,iHits=0,iShotsFired=0,iMeleeKills=0,iHitHead=0,iHitTorso=0,iHitArms=0,iHitLegs=0,iHitGroin=0,bFound=false,bFullyUpgraded=false)
    }
};

struct native SPMedalStats
{
    var MOHAIncludeClass.EMedalTypeSP eType;
    var bool bHasMedal;

    structdefaultproperties
    {
        eType=0
        bHasMedal=false
    }
};

struct native SPCheatFlag
{
    var bool bIsActive;

    structdefaultproperties
    {
        bIsActive=false
    }
};

var bool m_bHasSwitchedTeams;
var bool m_bInRankedGame;
var bool bUniqueIdInitialized;
var bool StatsDirty;
var bool bStatNetDirty;
var MOHAIncludeClass.MilitaryRank m_eMilitaryRank;
var byte m_MedalsAwardedArray[19];
var repnotify int m_iTeamPoints;
var repnotify int m_iObjectivePoints;
var int m_ElapsedTime;
var repnotify UniqueNetId xuid;
var repnotify native EndOfGameScore m_oEndgameScore;
var repnotify native EndOfGameAwardStatInfo m_oEndgameMatchAwards[24];
var int m_oEndgameMatchAwards_TempScoreBuffer[24];
var int MP_Suicides;
var int MP_TeamKills;
var int MP_KillAssists;
var int MP_KillsAA;
var int MP_AirborneMelees;
var int MP_MeleeDeaths;
var int MP_GrenadesThrown;
var int MP_GrenadesKills;
var int MP_GrenadesAirborneKills;
var int MP_GrenadesDeaths;
var repnotify int MP_KillStreak;
var int MP_KillStreakCurrent;
var int MP_DeathStreak;
var int MP_DeathStreakCurrent;
var int MP_HitsHead;
var int MP_HitsRArm;
var int MP_HitsLArm;
var int MP_HitsTorso;
var int MP_HitsCrotch;
var int MP_HitsLLeg;
var int MP_HitsRLeg;
var int MP_Weapon_HitsHead[EMPWeapons];
var int MP_Weapon_HitsRArm[EMPWeapons];
var int MP_Weapon_HitsLArm[EMPWeapons];
var int MP_Weapon_HitsTorso[EMPWeapons];
var int MP_Weapon_HitsCrotch[EMPWeapons];
var int MP_Weapon_HitsLLeg[EMPWeapons];
var int MP_Weapon_HitsRLeg[EMPWeapons];
var MPWeaponStats MPStatsWeapons[EMPWeapons];
var MPWeaponClassStats MPStatsWeaponClass[9];
var StatsLifeTime m_oStatsLifeTime;
var transient int tempPosition;
var repnotify native ITPSeatInfo m_oITPSeatInfo;
var SPGlobalStats SPStatsGlobal;
var SPWeaponStats SPStatsWeapon[25];
var SPMissionStats SPStatsMission[7];
var SPMedalStats SPStatsMedal[6];
var SPCheatFlag SPCheatFlags[7];

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        m_bHasSwitchedTeams, xuid;

    // Pos:0x018
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        m_eMilitaryRank, m_iObjectivePoints, 
        m_iTeamPoints, m_oEndgameScore;

    // Pos:0x030
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        m_oEndgameMatchAwards;

    // Pos:0x048
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        m_oITPSeatInfo;

    // Pos:0x060
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        MPStatsWeaponClass, MPStatsWeapons, 
        MP_AirborneMelees, MP_DeathStreak, 
        MP_GrenadesDeaths, MP_GrenadesKills, 
        MP_GrenadesThrown, MP_HitsCrotch, 
        MP_HitsHead, MP_HitsLArm, 
        MP_HitsLLeg, MP_HitsRArm, 
        MP_HitsRLeg, MP_HitsTorso, 
        MP_KillAssists, MP_KillStreak, 
        MP_MeleeDeaths, MP_Suicides, 
        MP_TeamKills, MP_Weapon_HitsCrotch, 
        MP_Weapon_HitsHead, MP_Weapon_HitsLArm, 
        MP_Weapon_HitsLLeg, MP_Weapon_HitsRArm, 
        MP_Weapon_HitsRLeg, MP_Weapon_HitsTorso, 
        m_ElapsedTime;
}

// Export UMOHAPlayerReplicationInfo::execGetPRIFromID(FFrame&, void* const)
native static final function PlayerReplicationInfo GetPRIFromID(int InPlayerID);

// Export UMOHAPlayerReplicationInfo::execGetPawnFromID(FFrame&, void* const)
native static final function Pawn GetPawnFromID(int InPlayerID);

// Export UMOHAPlayerReplicationInfo::execHasUniqueIdBeenSet(FFrame&, void* const)
native function bool HasUniqueIdBeenSet();

function PlasmaPlayerRef GetPlasmaPlayerRef()
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    return P.GetGame().GetPlayerByUserId(UniqueId).GetPlayerRef();
    //return ReturnValue;    
}

function SetFinalScore()
{
    local MOHAMultiplayerController mpc;

    CalculateScoreAndMarkStatsDirty();
    m_oEndgameScore.Score = int(Score);
    m_oEndgameScore.Kills = Kills;
    m_oEndgameScore.Deaths = int(Deaths);
    m_oEndgameScore.TeamPoints = m_iTeamPoints;
    m_oEndgameScore.ObjectivePoints = m_iObjectivePoints;
    m_oEndgameScore.TempRoundStatus = MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus;
    m_oEndgameScore.TempLastRoundWinningTeam = MOHAGameReplicationInfo(WorldInfo.GRI).LastRoundWinningTeam;
    m_oEndgameScore.bValid = true;
    bNetDirty = true;
    mpc = MOHAMultiplayerController(Owner);
    // End:0x132
    if((mpc != none) && int(WorldInfo.NetMode) != int(NM_Client))
    {
        mpc.ShowFinalScoreBoard();
    }
    //return;    
}

function CopyProperties(PlayerReplicationInfo PRI)
{
    local MOHAPlayerReplicationInfo mPRI;
    local int I;

    super.CopyProperties(PRI);
    mPRI = MOHAPlayerReplicationInfo(PRI);
    // End:0x299
    if(mPRI != none)
    {
        mPRI.m_iObjectivePoints = m_iObjectivePoints;
        mPRI.m_iTeamPoints = m_iTeamPoints;
        mPRI.xuid = xuid;
        mPRI.m_eMilitaryRank = m_eMilitaryRank;
        mPRI.m_ElapsedTime = m_ElapsedTime;
        mPRI.MP_Suicides = MP_Suicides;
        mPRI.MP_TeamKills = MP_TeamKills;
        mPRI.MP_KillAssists = MP_KillAssists;
        mPRI.MP_KillsAA = MP_KillsAA;
        mPRI.MP_AirborneMelees = MP_AirborneMelees;
        mPRI.MP_MeleeDeaths = MP_MeleeDeaths;
        mPRI.MP_GrenadesThrown = MP_GrenadesThrown;
        mPRI.MP_GrenadesKills = MP_GrenadesKills;
        mPRI.MP_GrenadesAirborneKills = MP_GrenadesAirborneKills;
        mPRI.MP_GrenadesDeaths = MP_GrenadesDeaths;
        mPRI.MP_KillStreak = MP_KillStreak;
        mPRI.MP_DeathStreak = MP_DeathStreak;
        I = 0;
        J0x181:

        // End:0x299 [Loop If]
        if(I < int(12))
        {
            mPRI.MP_Weapon_HitsHead[I] = MP_Weapon_HitsHead[I];
            mPRI.MP_Weapon_HitsRArm[I] = MP_Weapon_HitsRArm[I];
            mPRI.MP_Weapon_HitsLArm[I] = MP_Weapon_HitsLArm[I];
            mPRI.MP_Weapon_HitsTorso[I] = MP_Weapon_HitsTorso[I];
            mPRI.MP_Weapon_HitsCrotch[I] = MP_Weapon_HitsCrotch[I];
            mPRI.MP_Weapon_HitsLLeg[I] = MP_Weapon_HitsLLeg[I];
            mPRI.MP_Weapon_HitsRLeg[I] = MP_Weapon_HitsRLeg[I];
            mPRI.MPStatsWeapons[I] = MPStatsWeapons[I];
            I++;
            // [Loop Continue]
            goto J0x181;
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local MOHAMultiplayerController mpc;
    local PlayerController PC;

    // End:0x126
    if(VarName == 'm_oEndgameScore')
    {
        // End:0x123
        if(m_oEndgameScore.bValid)
        {
            Score = float(m_oEndgameScore.Score);
            Kills = m_oEndgameScore.Kills;
            Deaths = float(m_oEndgameScore.Deaths);
            m_iTeamPoints = m_oEndgameScore.TeamPoints;
            m_iObjectivePoints = m_oEndgameScore.ObjectivePoints;
            CalculateScoreAndMarkStatsDirty();
            mpc = MOHAMultiplayerController(Owner);
            // End:0x123
            if(mpc != none)
            {
                MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus = m_oEndgameScore.TempRoundStatus;
                MOHAGameReplicationInfo(WorldInfo.GRI).LastRoundWinningTeam = m_oEndgameScore.TempLastRoundWinningTeam;
                mpc.ShowFinalScoreBoard();
            }
        }        
    }
    else
    {
        // End:0x1E0
        if(VarName == 'm_oITPSeatInfo')
        {
            // End:0x1DC
            foreach LocalPlayerControllers(PC)
            {
                mpc = MOHAMultiplayerController(PC);
                // End:0x1DB
                if(mpc != none)
                {
                    // End:0x1AA
                    if(mpc.PlayerReplicationInfo == self)
                    {
                        mpc.SetITPMeshIndices(m_oITPSeatInfo.ITPPlaneNum, m_oITPSeatInfo.ITPSeatNum);
                        // End:0x1DB
                        continue;
                    }
                    mpc.UpdateITPVisibility(m_oITPSeatInfo.ITPPlaneNum, m_oITPSeatInfo.ITPSeatNum);
                }                
            }                        
        }
        else
        {
            // End:0x230
            if(VarName == 'Kills')
            {
                mpc = MOHAMultiplayerController(Owner);
                // End:0x222
                if(mpc != none)
                {
                    mpc.SetCurrentExperience();
                }
                super.ReplicatedEvent(VarName);                
            }
            else
            {
                super.ReplicatedEvent(VarName);
            }
        }
    }
    //return;    
}

function SetITPMeshIndices(int ITPPlaneIndex, int ITPSeatIndex)
{
    m_oITPSeatInfo.ITPPlaneNum = ITPPlaneIndex;
    m_oITPSeatInfo.ITPSeatNum = ITPSeatIndex;
    bNetDirty = true;
    //return;    
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x35
    if((bStatNetDirty == true) && StatsDirty == true)
    {
        bStatNetDirty = false;
        StatsDirty = false;
    }
    //return;    
}

simulated function CalculateScoreAndMarkStatsDirty()
{
    Score = ((2.0000000 * float(Kills)) + float(m_iTeamPoints)) + float(m_iObjectivePoints);
    bStatNetDirty = true;
    //return;    
}

function ClearStatsForServerRestart()
{
    local int I;

    Kills = 0;
    Deaths = 0.0000000;
    m_iTeamPoints = 0;
    m_iObjectivePoints = 0;
    MP_Suicides = 0;
    MP_TeamKills = 0;
    MP_KillAssists = 0;
    MP_KillsAA = 0;
    MP_AirborneMelees = 0;
    MP_MeleeDeaths = 0;
    MP_GrenadesThrown = 0;
    MP_GrenadesKills = 0;
    MP_GrenadesAirborneKills = 0;
    MP_GrenadesDeaths = 0;
    MP_KillStreak = 0;
    MP_KillStreakCurrent = 0;
    MP_DeathStreak = 0;
    MP_DeathStreakCurrent = 0;
    MP_HitsHead = 0;
    MP_HitsRArm = 0;
    MP_HitsLArm = 0;
    MP_HitsTorso = 0;
    MP_HitsCrotch = 0;
    MP_HitsLLeg = 0;
    MP_HitsRLeg = 0;
    I = 0;
    J0xBA:

    // End:0x1D5 [Loop If]
    if(I < int(12))
    {
        MP_Weapon_HitsHead[I] = 0;
        MP_Weapon_HitsRArm[I] = 0;
        MP_Weapon_HitsLArm[I] = 0;
        MP_Weapon_HitsTorso[I] = 0;
        MP_Weapon_HitsCrotch[I] = 0;
        MP_Weapon_HitsLLeg[I] = 0;
        MP_Weapon_HitsRLeg[I] = 0;
        MPStatsWeapons[I].Time = 0.0000000;
        MPStatsWeapons[I].Hits = 0;
        MPStatsWeapons[I].Shots = 0;
        MPStatsWeapons[I].Kills = 0;
        MPStatsWeapons[I].MeleeKills = 0;
        MPStatsWeapons[I].Deaths = 0;
        MPStatsWeapons[I].MeleeDeaths = 0;
        I++;
        // [Loop Continue]
        goto J0xBA;
    }
    CalculateScoreAndMarkStatsDirty();
    //return;    
}

function Reset()
{
    m_ElapsedTime += WorldInfo.GRI.ElapsedTime;
    m_oEndgameScore.bValid = false;
    m_bHasSwitchedTeams = false;
    m_oITPSeatInfo.ITPPlaneNum = -1;
    m_oITPSeatInfo.ITPSeatNum = 0;
    //return;    
}

simulated event PostBeginPlay()
{
    m_oITPSeatInfo.ITPPlaneNum = -1;
    m_oITPSeatInfo.ITPSeatNum = 0;
    super.PostBeginPlay();
    //return;    
}

simulated function SetXUID()
{
    local Plasma P;
    local PlasmaUserManager PUM;
    local PlasmaUser User;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x92
    if(P != none)
    {
        PUM = P.GetPlasmaUserManager();
        // End:0x8F
        if(PUM != none)
        {
            User = PUM.GetById(UniqueId);
            // End:0x8C
            if(User != none)
            {
                User.GetXuid(xuid);                
            }            
        }        
    }
    //return;    
}

reliable server function SetRank(MOHAIncludeClass.MilitaryRank R)
{
    m_eMilitaryRank = R;
    //return;    
}

private final simulated function MPWeaponStats GetWeaponClassTotals(MOHAIncludeClass.eWeaponClass C)
{
    local int w1, w2;
    local MPWeaponStats totals;

    switch(C)
    {
        // End:0x1F
        case 1:
            w1 = 10;
            w2 = 11;
            // End:0x9E
            break;
        // End:0x35
        case 2:
            w1 = 0;
            w2 = 1;
            // End:0x9E
            break;
        // End:0x4D
        case 3:
            w1 = 2;
            w2 = 3;
            // End:0x9E
            break;
        // End:0x65
        case 4:
            w1 = 6;
            w2 = 7;
            // End:0x9E
            break;
        // End:0x7D
        case 5:
            w1 = 8;
            w2 = 9;
            // End:0x9E
            break;
        // End:0x95
        case 8:
            w1 = 4;
            w2 = 5;
            // End:0x9E
            break;
        // End:0xFFFF
        default:
            return totals;
            break;
    }
    totals.Time = MPStatsWeapons[w1].Time + MPStatsWeapons[w2].Time;
    totals.Shots = MPStatsWeapons[w1].Shots + MPStatsWeapons[w2].Shots;
    totals.Hits = MPStatsWeapons[w1].Hits + MPStatsWeapons[w2].Hits;
    totals.Kills = MPStatsWeapons[w1].Kills + MPStatsWeapons[w2].Kills;
    totals.MeleeKills = byte(int(MPStatsWeapons[w1].MeleeKills) + int(MPStatsWeapons[w2].MeleeKills));
    totals.Deaths = byte(int(MPStatsWeapons[w1].Deaths) + int(MPStatsWeapons[w2].Deaths));
    totals.MeleeDeaths = byte(int(MPStatsWeapons[w1].MeleeDeaths) + int(MPStatsWeapons[w2].MeleeDeaths));
    return totals;
    //return ReturnValue;    
}

simulated function int GetWeaponLifeTimeClassScore(MOHAIncludeClass.eWeaponClass C)
{
    local int SessionScore;

    switch(C)
    {
        // End:0x25
        case 2:
            SessionScore += m_oStatsLifeTime.WC_RIFLE_EXP;
            // End:0xA0
            break;
        // End:0x43
        case 3:
            SessionScore += m_oStatsLifeTime.WC_SMG_EXP;
            // End:0xA0
            break;
        // End:0x61
        case 4:
            SessionScore += m_oStatsLifeTime.WC_SNIPER_EXP;
            // End:0xA0
            break;
        // End:0x7F
        case 5:
            SessionScore += m_oStatsLifeTime.WC_ATANK_EXP;
            // End:0xA0
            break;
        // End:0x9D
        case 8:
            SessionScore += m_oStatsLifeTime.WC_AUTO_EXP;
            // End:0xA0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return SessionScore;
    //return ReturnValue;    
}

simulated function int GetWeaponClassScore(MOHAIncludeClass.eWeaponClass C, bool bIncludeLifeTimeVars)
{
    local int SessionScore;

    SessionScore = GetWeaponClassTotals(C).Kills;
    // End:0xC4
    if(bIncludeLifeTimeVars)
    {
        switch(C)
        {
            // End:0x49
            case 2:
                SessionScore += m_oStatsLifeTime.WC_RIFLE_EXP;
                // End:0xC4
                break;
            // End:0x67
            case 3:
                SessionScore += m_oStatsLifeTime.WC_SMG_EXP;
                // End:0xC4
                break;
            // End:0x85
            case 4:
                SessionScore += m_oStatsLifeTime.WC_SNIPER_EXP;
                // End:0xC4
                break;
            // End:0xA3
            case 5:
                SessionScore += m_oStatsLifeTime.WC_ATANK_EXP;
                // End:0xC4
                break;
            // End:0xC1
            case 8:
                SessionScore += m_oStatsLifeTime.WC_AUTO_EXP;
                // End:0xC4
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return SessionScore;
        //return ReturnValue;        
    }
}

private final simulated function MPWeaponStats GetWeaponTotals()
{
    local int I;
    local MPWeaponStats totals;

    I = 0;
    J0x07:

    // End:0x127 [Loop If]
    if(I < 12)
    {
        totals.Time += MPStatsWeapons[I].Time;
        totals.Shots += MPStatsWeapons[I].Shots;
        totals.Hits += MPStatsWeapons[I].Hits;
        totals.Kills += MPStatsWeapons[I].Kills;
        totals.MeleeKills += MPStatsWeapons[I].MeleeKills;
        totals.Deaths += MPStatsWeapons[I].Deaths;
        totals.MeleeDeaths += MPStatsWeapons[I].MeleeDeaths;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return totals;
    //return ReturnValue;    
}

simulated function int StatsGetShotsFired()
{
    return GetWeaponTotals().Shots;
    //return ReturnValue;    
}

simulated function int StatsGetHits()
{
    return GetWeaponTotals().Hits;
    //return ReturnValue;    
}

function GetSPGlobalStats(out SPGlobalStats out_SPStatsGlobal)
{
    out_SPStatsGlobal = SPStatsGlobal;
    //return;    
}

function GetSPMissionStats(int CurrentMission, out SPMissionStats out_SPStatsMission)
{
    out_SPStatsMission = SPStatsMission[CurrentMission];
    //return;    
}

function GetSPWeaponStats(MOHAIncludeClass.EWeaponType WeaponType, out SPWeaponStats out_SPStatsWeapon)
{
    out_SPStatsWeapon = SPStatsWeapon[int(WeaponType)];
    //return;    
}

function GetSPMedalStats(MOHAIncludeClass.EMedalTypeSP MedalType, out SPMedalStats out_SPStatsMedal)
{
    out_SPStatsMedal = SPStatsMedal[int(MedalType)];
    //return;    
}

function PutSPGlobalStats(SPGlobalStats in_SPStatsGlobal)
{
    SPStatsGlobal = in_SPStatsGlobal;
    //return;    
}

function PutSPMissionStats(int CurrentMission, SPMissionStats in_SPStatsMission)
{
    SPStatsMission[CurrentMission] = in_SPStatsMission;
    //return;    
}

function PutSPWeaponStats(MOHAIncludeClass.EWeaponType WeaponType, SPWeaponStats in_SPStatsWeapon)
{
    SPStatsWeapon[int(WeaponType)] = in_SPStatsWeapon;
    //return;    
}

function PutSPMedalStats(MOHAIncludeClass.EMedalTypeSP MedalType, SPMedalStats in_SPStatsMedal)
{
    SPStatsMedal[int(MedalType)] = in_SPStatsMedal;
    //return;    
}

function ClearCheatFlags()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x35 [Loop If]
    if(I < 7)
    {
        SPCheatFlags[I].bIsActive = false;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

defaultproperties
{
    GameMessageClass=Class'MOHAGameMessage'
}