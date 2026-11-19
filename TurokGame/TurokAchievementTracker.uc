class TurokAchievementTracker extends Object
    transient
    native
    config(Game);

enum eShotgunTrackingState
{
    STS_Disabled,                   // 0
    STS_HasUsedShotgun,             // 1
    STS_HasNotUsedShotgun,          // 2
    STS_MAX                         // 3
};

var protected transient @NULL mSessionStats;
var protected transient @NULL mLifetimeStats;
var protected transient @NULL mProfile;
var protected transient @NULL mAchievements;
var transient @NULL mPlayer;
var config int TripleKill_MaxKillCombo;
var config int ThornInSide_FlagCarriersKilled;
var config int HometownHero_FlagsRecovered;
var config int ArchNemisis_MaxConsecutiveVictimKills;
var config int CrackShot_HeadshotKills;
var config int Miscellaneous_CreaturesKilled;
var config int Miscellaneous_PlayersKilled;
var config int Miscellaneous_TeammatesKilled;
var config int Miscellaneous_Suicides;
var config int DinoHunter_DinosKilled;
var config int Exterminator_BugsKilled;
var config int CounterVehicle_VehiclesKilled;
var config int Retribution_RivalsStealthKilled;
var config int MedalOfCitation_PlayersKilled;
var config int MedalOfCommendation_PlayersKilled;
var config int Boomstick_DilosKilled;
var config int Arsenal_NumWeaponKills;
var config int PracticallyCanadian_DefendFlagPoints;
var config int CoopMap_NumPlayed;
var config int Accuracy_Accuracy;
var config int Accuracy_ShotsFired;
var config int GreatRound_BattleRating;
var config int Unbreakable_Deaths;
var config int Pacifist_ShotsFired;
var config int Pacifist_Kills;
var config int Pacifist_FlagsCaptured;
var config int Resurrection_Kills;
var config int Resurrection_Deaths;
var config int Gamesman_GamesPlayed;
var config int Primitive_ShotsFired;
var config int Primitive_GrenadesUsed;
var config int Primitive_Kills;
var config int AllPurpose_GamesWon;
var config int MassiveBattle_NumPlayers;
var config int BuddyBlowout_NumPlayers;
var config int MPFirstClass_Accuracy;
var config int MPFirstClass_Kills;
var config int MPMasterClass_LimbShots;
var config int MPMasterClass_BodyShots;
var config int MPMasterClass_Kills;
var config int DinoDominance_Kills;
var config int HeadShot_Kills;
var config int TurokDefenceForce_Mauls;
var config int ItsATrap_Lures;
var config int Pincushion_Pins;
var config int ManOrAnimal_Kills;
var config int Collectables_TeethPerClass;
var config int LoudLove_MaxFragCombo;
var config int Boom_MaxRocketCombo;
var config int Impaler_MGArrowPins;
var config int BigGame_ScarfaceFights;
var config int Angler_WaterBossKills;
var config int SellYourShotguns_ShotgunlessRuns;
var config int ServiceRibbon_Completed;
var config int CampaignRibbon_Completed;
var class<Class> mTrackedDamageType;
var int mKilledMGTotal;
var byte mShotgunTrackingState;

// Export UTurokAchievementTracker::execInit(FFrame&, void* const)
native simulated function Init(@NULL SessionStats, @NULL Profile, @NULL Player);

// Export UTurokAchievementTracker::execUnInit(FFrame&, void* const)
native function UnInit();

// Export UTurokAchievementTracker::execCheckAchievements(FFrame&, void* const)
native simulated function CheckAchievements();

// Export UTurokAchievementTracker::execCheckEndOfRoundAchievements(FFrame&, void* const)
native simulated function CheckEndOfRoundAchievements(bool GameCompleted);

// Export UTurokAchievementTracker::execReloadLifetimeStats(FFrame&, void* const)
native simulated function ReloadLifetimeStats();

// Export UTurokAchievementTracker::execFoughtOffMommaScarface(FFrame&, void* const)
native static function FoughtOffMommaScarface();

// Export UTurokAchievementTracker::execKilledWaterBoss(FFrame&, void* const)
native static function KilledWaterBoss();

// Export UTurokAchievementTracker::execFinishedLevelNoShotgun(FFrame&, void* const)
native static function FinishedLevelNoShotgun();

// Export UTurokAchievementTracker::execFinishedGame(FFrame&, void* const)
native static function FinishedGame();

// Export UTurokAchievementTracker::execFinishedGameHighDifficulty(FFrame&, void* const)
native static function FinishedGameHighDifficulty();

// Export UTurokAchievementTracker::execBeginExplosion(FFrame&, void* const)
native static function BeginExplosion(class<Class> DamageType);

// Export UTurokAchievementTracker::execprivBeginExplosion(FFrame&, void* const)
private native final function privBeginExplosion(class<Class> DamageType);

// Export UTurokAchievementTracker::execMGKilled(FFrame&, void* const)
native static function MGKilled();

// Export UTurokAchievementTracker::execprivMGKilled(FFrame&, void* const)
private native final function privMGKilled();

// Export UTurokAchievementTracker::execEndExplosion(FFrame&, void* const)
native static function EndExplosion();

// Export UTurokAchievementTracker::execprivEndExplosion(FFrame&, void* const)
private native final function privEndExplosion();

// Export UTurokAchievementTracker::execBeginTrackingShotgunUse(FFrame&, void* const)
native static function BeginTrackingShotgunUse();

// Export UTurokAchievementTracker::execprivBeginTrackingShotgunUse(FFrame&, void* const)
private native final function privBeginTrackingShotgunUse();

// Export UTurokAchievementTracker::execEndTrackingShotgunUse(FFrame&, void* const)
native static function EndTrackingShotgunUse();

// Export UTurokAchievementTracker::execprivEndTrackingShotgunUse(FFrame&, void* const)
private native final function privEndTrackingShotgunUse();

// Export UTurokAchievementTracker::execShotgunUsed(FFrame&, void* const)
native static function ShotgunUsed();

// Export UTurokAchievementTracker::execprivShotgunUsed(FFrame&, void* const)
private native final function privShotgunUsed();

static function PredatorKilledMG()
{
    // End:0x47
    if(SelfInstance() != none)
    {
        // End:0x47
        if(SelfInstance().mPlayer != none)
        {
            SelfInstance().mPlayer.RecordStat(28, 1.0000000, 1);
        }
    }
    //return;    
}

// Export UTurokAchievementTracker::execInitializeTracking(FFrame&, void* const)
native simulated function InitializeTracking();

// Export UTurokAchievementTracker::execSafelyUnlockSP(FFrame&, void* const)
private native static final function SafelyUnlockSP(int AchievementId);

// Export UTurokAchievementTracker::execSelfInstance(FFrame&, void* const)
private native static final function @NULL SelfInstance();

// Export UTurokAchievementTracker::execSafeConstruct(FFrame&, void* const)
native static function @NULL SafeConstruct();

// Export UTurokAchievementTracker::execUnlockAchievement(FFrame&, void* const)
private native final simulated function UnlockAchievement(int AchievementId);

// Export UTurokAchievementTracker::execIsLocked(FFrame&, void* const)
private native final simulated function bool IsLocked(int AchievementId);
