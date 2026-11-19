class MOHAPlayerStatsComponent extends ActorComponent
    native
    config(Player);

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

struct native SKillInfo
{
    var float TimeSeconds;
    var MOHAIncludeClass.EWeaponType WeaponType;
    var class<DamageType> DamageType;

    structdefaultproperties
    {
        TimeSeconds=0.0000000
        WeaponType=0
        DamageType=none
    }
};

var array<SKillInfo> KillInfo;
var float LastNotificationTime[8];
var float ConsecutiveKillTimeLimit;
var transient float ConsecutiveKillTimer;
var transient int ConsecutiveKillCount;
var transient int ConsecutiveHeadShots;
var export editinline MOHAWeaponExperienceComponent CurrentExpComponent;
var export editinline array<export editinline MOHAWeaponExperienceComponent> ExperienceComponents;
var MOHAPlayerController PlayerController;
var MOHAPlayerReplicationInfo PRI;
var config float KillTypeHeadExp;
var config float KillTypeBodyExp;
var config float KillTypeMeleeExp;
var config float KillTypeGrenadeExp;
var config float KillTypeTripleKillExp;
var config float KillTypeFiveInARowExp;
var config float KillTypeVehicle;
var config int MissionRatingPointsLevel1;
var config int MissionRatingPointsLevel2;
var config int MissionRatingPointsLevel3;
var config int MissionRatingPointsLevel4;
var config int MissionRatingPointsLevel5;
var Vector vOldLocation;

// Export UMOHAPlayerStatsComponent::execGetCurrentMission(FFrame&, void* const)
native function int GetCurrentMission();

// Export UMOHAPlayerStatsComponent::execGetShotsFired(FFrame&, void* const)
native function int GetShotsFired();

// Export UMOHAPlayerStatsComponent::execGetShotsHit(FFrame&, void* const)
native function int GetShotsHit();

// Export UMOHAPlayerStatsComponent::execGetKills(FFrame&, void* const)
native function int GetKills();

// Export UMOHAPlayerStatsComponent::execGetMissionRating(FFrame&, void* const)
native function int GetMissionRating();

// Export UMOHAPlayerStatsComponent::execGetMissionCompleteAchievement(FFrame&, void* const)
native function string GetMissionCompleteAchievement(int Mission);

// Export UMOHAPlayerStatsComponent::execTick(FFrame&, void* const)
native simulated function Tick(float DeltaTime);

// Export UMOHAPlayerStatsComponent::execUpdateDistanceTravelled(FFrame&, void* const)
native simulated function UpdateDistanceTravelled(float DeltaTime);

// Export UMOHAPlayerStatsComponent::execOnWeaponFire(FFrame&, void* const)
native simulated function OnWeaponFire(MOHAIncludeClass.EWeaponType WeaponType, MOHAIncludeClass.eWeaponClass WeaponClass, optional int NumShots);

// Export UMOHAPlayerStatsComponent::execOnWeaponHit(FFrame&, void* const)
native simulated function OnWeaponHit(MOHAIncludeClass.EWeaponType WeaponType, name BoneName, Pawn HitPawn, class<DamageType> HitDamageType, bool FatalHit);

// Export UMOHAPlayerStatsComponent::execOnKill(FFrame&, void* const)
native simulated function OnKill(MOHAIncludeClass.EWeaponType WeaponType, int CurrentMission, float ExpGiven, class<DamageType> KillDamageType, optional bool bExplosiveKill);

// Export UMOHAPlayerStatsComponent::execOnHitAlly(FFrame&, void* const)
native simulated function OnHitAlly(MOHAIncludeClass.EWeaponType WeaponType, MOHAAIPawn HitPawn);

// Export UMOHAPlayerStatsComponent::execOnExplosiveKill(FFrame&, void* const)
native simulated function OnExplosiveKill(MOHAIncludeClass.EWeaponType WeaponType, class<DamageType> KillDamageType);

// Export UMOHAPlayerStatsComponent::execOnMeleeKill(FFrame&, void* const)
native simulated function OnMeleeKill(MOHAIncludeClass.EWeaponType WeaponType, MOHAIncludeClass.eWeaponClass WeaponClass, class<DamageType> KillDamageType);

// Export UMOHAPlayerStatsComponent::execOnPlayerDeath(FFrame&, void* const)
native simulated function OnPlayerDeath();

// Export UMOHAPlayerStatsComponent::execCalculateMissionRating(FFrame&, void* const)
native simulated function CalculateMissionRating();

// Export UMOHAPlayerStatsComponent::execOnLanding(FFrame&, void* const)
native simulated function OnLanding(MOHAPlayerPawn.EAirDropLandingType landingType);

// Export UMOHAPlayerStatsComponent::execOnMissionComplete(FFrame&, void* const)
native simulated function OnMissionComplete(SeqAct_MissionComplete Action);

// Export UMOHAPlayerStatsComponent::execAllMissionsComplete(FFrame&, void* const)
native simulated function bool AllMissionsComplete(int Difficulty);

// Export UMOHAPlayerStatsComponent::execGiveMedal(FFrame&, void* const)
native simulated function GiveMedal(MOHAIncludeClass.EMedalTypeSP MedalType);

// Export UMOHAPlayerStatsComponent::execOnAddInventory(FFrame&, void* const)
native simulated function OnAddInventory(Inventory NewItem);

// Export UMOHAPlayerStatsComponent::execOnWeaponUpgrade(FFrame&, void* const)
native simulated function OnWeaponUpgrade(MOHAIncludeClass.EWeaponType WeaponType, int UpgradeLevel, int MaxUpgradeLevel);

// Export UMOHAPlayerStatsComponent::execOnPlayerAirDrop(FFrame&, void* const)
native simulated function OnPlayerAirDrop();

// Export UMOHAPlayerStatsComponent::execOnKickGrenade(FFrame&, void* const)
native simulated function OnKickGrenade();

// Export UMOHAPlayerStatsComponent::execOnSkillDropLanding(FFrame&, void* const)
native simulated function OnSkillDropLanding(int SkillDropId);

// Export UMOHAPlayerStatsComponent::execRecordKillInfo(FFrame&, void* const)
native simulated function RecordKillInfo(MOHAIncludeClass.EWeaponType WeaponType, class<DamageType> KillDamageType);

// Export UMOHAPlayerStatsComponent::execUpdateConsecutiveKills(FFrame&, void* const)
native simulated function UpdateConsecutiveKills(float dt);

// Export UMOHAPlayerStatsComponent::execEarnedRatingInAllMissions(FFrame&, void* const)
native simulated function bool EarnedRatingInAllMissions(int Rating, int Difficulty);

// Export UMOHAPlayerStatsComponent::execGiveTripleCookedKillAchievement(FFrame&, void* const)
native simulated function bool GiveTripleCookedKillAchievement();

simulated function BindStatsDataProvider()
{
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAPlayerStats StatsDataStore;
    local LocalPlayer LP;

    LP = LocalPlayer(PlayerController.Player);
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x107
    if(DataStoreManager != none)
    {
        StatsDataStore = UIDataStore_MOHAPlayerStats(DataStoreManager.FindDataStore('MOHAPlayerStats', LP));
        // End:0x107
        if(StatsDataStore != none)
        {
            StatsDataStore.GlobalStatsProvider.BindDataProvider(self);
            StatsDataStore.MissionStatsProvider.BindDataProvider(self);
            StatsDataStore.GlobalMPStatsProvider.BindDataProvider(Class'Plasma.Plasma'.static.GetPlasma());
            StatsDataStore.MissionMPStatsProvider.BindDataProvider(Class'Plasma.Plasma'.static.GetPlasma());            
        }
    }
    //return;    
}

simulated event GiveWeaponExperience(float ExpGiven, MOHAIncludeClass.EWeaponType WeaponType, bool bExplosiveExperience)
{
    local editinline MOHAWeaponExperienceComponent Comp;

    // End:0x6A
    if(bExplosiveExperience || int(CurrentExpComponent.WeaponClass.default.WeaponType) != int(WeaponType))
    {
        Comp = GetWeaponExpComponentByType(WeaponType);
        // End:0x68
        if(Comp != none)
        {
            Comp.AddExperiencePoints(ExpGiven);
        }
        return;
    }
    // End:0x8D
    if(CurrentExpComponent != none)
    {
        CurrentExpComponent.AddExperiencePoints(ExpGiven);
    }
    Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 6, "Gameplay", "ExperienceEarned", string(WeaponType), 0, ExpGiven, "", PlayerController.Pawn.Location);
    //return;    
}

simulated function ResetExperienceComponents()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3A [Loop If]
    if(I < ExperienceComponents.Length)
    {
        ExperienceComponents[I].ResetExperience();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function LogGlobalStats()
{
    local SPGlobalStats SPStatsGlobal;

    PRI.GetSPGlobalStats(SPStatsGlobal);
    //return;    
}

simulated function Init(MOHAPlayerController PC)
{
    // DebugMode: 0
    assert(25 == 24);
    PlayerController = PC;
    PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);
    //return;    
}

simulated function int CreateExperienceComponent(class<EALAWeapon> ExpWeapon)
{
    local int NewIndex;

    NewIndex = ExperienceComponents.Length;
    ExperienceComponents[NewIndex] = new Class'MOHAWeaponExperienceComponent';
    ExperienceComponents[NewIndex].Init(ExpWeapon, PlayerController);
    return NewIndex;
    //return ReturnValue;    
}

simulated function SetCurrentExperienceComponent(class<EALAWeapon> ExpWeapon)
{
    CurrentExpComponent = GetWeaponExpComponent(ExpWeapon);
    //return;    
}

simulated function MOHAWeaponExperienceComponent GetCurrentWeaponExpComponent()
{
    return CurrentExpComponent;
    //return ReturnValue;    
}

simulated event MOHAWeaponExperienceComponent GetWeaponExpComponent(class<EALAWeapon> ExpWeapon)
{
    local int I;
    local editinline MOHAWeaponExperienceComponent Comp;

    Comp = GetWeaponExpComponentByType(ExpWeapon.default.WeaponType);
    // End:0x4F
    if(Comp == none)
    {
        I = CreateExperienceComponent(ExpWeapon);
        Comp = ExperienceComponents[I];
    }
    return Comp;
    //return ReturnValue;    
}

simulated event MOHAWeaponExperienceComponent GetWeaponExpComponentByType(MOHAIncludeClass.EWeaponType WeaponType)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x58 [Loop If]
    if(I < ExperienceComponents.Length)
    {
        // End:0x4E
        if(int(ExperienceComponents[I].WeaponClass.default.WeaponType) == int(WeaponType))
        {
            return ExperienceComponents[I];
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    //return ReturnValue;    
}

event NotifyPlayer(MOHAIncludeClass.EHUDNotifications Type, optional bool bIsGrenadeKill = false)
{
    // End:0xB3
    if(((none != PlayerController) && none != MOHAHUD(PlayerController.myHUD)) && none != PlayerController.WorldInfo)
    {
        LastNotificationTime[int(Type)] = PlayerController.WorldInfo.TimeSeconds;
        MOHAHUD(PlayerController.myHUD).hud_medalMomentQueue.MedalMomentNotify(Type, bIsGrenadeKill);
        PlayerController.OnPlayerStatsNotify(Type);
    }
    //return;    
}

event NotifySkillDropFound(int NumFound)
{
    // End:0x8D
    if(((PlayerController != none) && MOHAHUD(PlayerController.myHUD) != none) && PlayerController.WorldInfo != none)
    {
        LastNotificationTime[8] = PlayerController.WorldInfo.TimeSeconds;
        MOHAHUD(PlayerController.myHUD).hud_messageQueue.ShowSkillDropText(NumFound, 5);
    }
    //return;    
}

event GiveXboxLiveAchievement(string AchievementName)
{
    local Plasma P;

    // End:0x24
    if(int(PlayerController.WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    // End:0x50
    if(PlayerController.IsAnyCheatActive() || PlayerController.bUsedCheat)
    {
        return;
    }
    P = Class'Plasma.Plasma'.static.GetPlasma();
    P.GrantAward(PRI.UniqueId, AchievementName);
    //return;    
}

event bool IsGrenadeKill(class<DamageType> KillDamageType)
{
    // End:0x12
    if(ClassIsChildOf(KillDamageType, Class'MOHAGrenadeDamageType'))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool IsKickedGrenadeKill(class<DamageType> KillDamageType)
{
    // End:0x33
    if(((KillDamageType == Class'MOHAMKIIKickedGrenadeDamageType') || KillDamageType == Class'MOHAGammonKickedGrenadeDamageType') || KillDamageType == Class'MOHAStickKickedGrenadeDamageType')
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool IsAirDropMeleeKill(class<DamageType> KillDamageType)
{
    // End:0x12
    if(ClassIsChildOf(KillDamageType, Class'MOHAAirdropMeleeDamageType'))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool IsCookedGrenadeKill(class<DamageType> KillDamageType)
{
    // End:0x33
    if(((KillDamageType == Class'MOHAMKIICookedGrenadeDamageType') || KillDamageType == Class'MOHAGammonCookedGrenadeDamageType') || KillDamageType == Class'MOHAStickCookedGrenadeDamageType')
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    ConsecutiveKillTimeLimit=5.2500000
    KillTypeHeadExp=2.0000000
    KillTypeBodyExp=1.0000000
    KillTypeMeleeExp=3.0000000
    KillTypeGrenadeExp=2.0000000
    KillTypeTripleKillExp=1.0000000
    KillTypeFiveInARowExp=2.0000000
    KillTypeVehicle=5.0000000
    MissionRatingPointsLevel2=40
    MissionRatingPointsLevel3=80
    MissionRatingPointsLevel4=135
    MissionRatingPointsLevel5=150
}