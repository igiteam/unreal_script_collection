class SPTuneManager extends Actor
    native
    notplaceable;

struct native SPTuneDataDifficulty
{
    var SPGameDifficultyTuneGriffon GriffonGD;
    var SPGameDifficultyTuneSoldier CouncilGD;
    var SPGameDifficultyTuneSoldier BlackOrderGD;
    var SPGameDifficultyTuneSoldier BlackOrderOfficerGD;
    var SPGameDifficultyTuneSoldier BlackOrderHeavyRocketLauncherGD;
    var SPGameDifficultyTuneSoldier BlackOrderHeavySawGD;
    var SPGameDifficultyTuneSoldier BlackOrderHeavyFlameThrowerGD;
    var SPGameDifficultyTuneSoldier CivilianGD;
    var SPGameDifficultyTuneNari NariGD;
    var SPGameDifficultyTuneWerewolf WereWolfGD;
    var SPGameDifficultyTuneWeakWerewolf WeakWereWolfGD;
    var SPGameDifficultyTuneMinotaur MinotaurGD;
    var SPGameDifficultyTuneFireDrake FireDrakeGD;
    var SPGameDifficultyTuneTentacle TentacleGD;
    var SPGameDifficultyTuneKraken KrakenGD;
    var SPGameDifficultyTuneWeapons WeaponGD;
    var SPGameDifficultyTuneBloodTick BloodTickGD;
    var SPGameDifficultyTunePlayer PlayerGD;
    var SPGameDifficultyTuneGamePlay GameplayGD;

    structdefaultproperties
    {
        GriffonGD=SPGameDifficultyTuneGriffon'SPGameDifficultyTuneData.Griffon'
        CouncilGD=SPGameDifficultyTuneSoldier'SPGameDifficultyTuneData.Council'
        BlackOrderGD=SPGameDifficultyTuneSoldier'SPGameDifficultyTuneData.BlackOrder'
        BlackOrderOfficerGD=SPGameDifficultyTuneSoldier'SPGameDifficultyTuneData.BlackOrderOfficer'
        BlackOrderHeavyRocketLauncherGD=SPGameDifficultyTuneSoldier'SPGameDifficultyTuneData.BlackOrderHeavyRocket'
        BlackOrderHeavySawGD=SPGameDifficultyTuneSoldier'SPGameDifficultyTuneData.BlackOrderHeavySaw'
        BlackOrderHeavyFlameThrowerGD=SPGameDifficultyTuneSoldier'SPGameDifficultyTuneData.BlackOrderHeavyFlameThrower'
        CivilianGD=SPGameDifficultyTuneSoldier'SPGameDifficultyTuneData.Civilian'
        NariGD=SPGameDifficultyTuneNari'SPGameDifficultyTuneData.Nari'
        WereWolfGD=SPGameDifficultyTuneWerewolf'SPGameDifficultyTuneData.Werewolf'
        WeakWereWolfGD=SPGameDifficultyTuneWeakWerewolf'SPGameDifficultyTuneData.WeakWerewolf'
        MinotaurGD=SPGameDifficultyTuneMinotaur'SPGameDifficultyTuneData.Minotaur'
        FireDrakeGD=SPGameDifficultyTuneFireDrake'SPGameDifficultyTuneData.FireDrake'
        TentacleGD=SPGameDifficultyTuneTentacle'SPGameDifficultyTuneData.Tentacle'
        KrakenGD=SPGameDifficultyTuneKraken'SPGameDifficultyTuneData.Kraken'
        WeaponGD=SPGameDifficultyTuneWeapons'SPGameDifficultyTuneData.Weapon'
        BloodTickGD=SPGameDifficultyTuneBloodTick'SPGameDifficultyTuneData.BloodTick'
        PlayerGD=SPGameDifficultyTunePlayer'SPGDTD_Player.Player'
        GameplayGD=SPGameDifficultyTuneGamePlay'SPGameDifficultyTuneData.Gameplay'
    }
};

struct native SPTuneDataDifficultyMP
{
    var SPGameDifficultyTuneWeapons WeaponGD;
    var SPGameDifficultyTuneWerewolf WereWolfGD;
    var SPGameDifficultyTuneWeakWerewolf WeakWereWolfGD;
    var SPGameDifficultyTunePlayer PlayerGD;

    structdefaultproperties
    {
        WeaponGD=SPGameDifficultyTuneWeapons'SPGameDifficultyTuneDataMP.Weapon'
        WereWolfGD=SPGameDifficultyTuneWerewolf'SPGameDifficultyTuneDataMP.Werewolf'
        WeakWereWolfGD=SPGameDifficultyTuneWeakWerewolf'SPGameDifficultyTuneDataMP.WeakWerewolf'
        PlayerGD=SPGameDifficultyTunePlayer'SPGDTD_PlayerMP.Player'
    }
};

struct native SPTuneDataSet
{
    var SPTuneDataGriffon Griffon;
    var SPTuneDataSoldier Council;
    var SPTuneDataSoldier BlackOrder;
    var SPTuneDataSoldier Civilian;
    var SPTuneDataNari Nari;
    var SPTuneDataWerewolf Werewolf;
    var SPTuneDataWerewolf WeakWerewolf;
    var SPTuneDataMinotaur Minotaur;
    var SPTuneDataTentacle Tentacle;
    var SPTuneDataKraken Kraken;
    var SPTuneDataBloodTick BloodTick;
    var SPTuneDataFireDrake FireDrake;
    var SPTuneDataGameplay Gameplay;
    var SPTuneDataPlayer Player;

    structdefaultproperties
    {
        Griffon=SPTuneDataGriffon'TuneDataGriffon.Normal'
        Council=SPTuneDataSoldier'TuneDataHuman.Council.Normal'
        BlackOrder=SPTuneDataSoldier'TuneDataHuman.black_order.Normal'
        Civilian=SPTuneDataSoldier'TuneDataHuman.Civilian.Normal'
        Nari=SPTuneDataNari'TuneDataNari.Normal'
        Werewolf=SPTuneDataWerewolf'TuneDataWerewolf.Strong.Normal'
        WeakWerewolf=SPTuneDataWerewolfWeak'TuneDataWerewolf.Weak.Normal'
        Minotaur=SPTuneDataMinotaur'TuneDataMinotaur.Normal'
        Tentacle=SPTuneDataTentacle'TuneDataTentacle.Normal'
        Kraken=SPTuneDataKraken'TuneDataKraken.Normal'
        BloodTick=SPTuneDataBloodTick'TuneDataBloodTick.Normal'
        FireDrake=SPTuneDataFireDrake'TuneDataFireDrake.Normal'
        Gameplay=SPTuneDataGameplay'TuneDataGameplay.Normal'
        Player=SPTuneDataPlayer'TuneDataPlayer.Normal'
    }
};

struct native SPTuneDataSetMP
{
    var SPTuneDataWerewolf Werewolf;
    var SPTuneDataWerewolf WeakWerewolf;

    structdefaultproperties
    {
        Werewolf=SPTuneDataWerewolf'TuneDataWerewolfMP.Strong.Normal'
        WeakWerewolf=SPTuneDataWerewolfWeak'TuneDataWerewolfMP.Weak.Normal'
    }
};

var const SPTuneDataSet Data[3];
var const SPTuneDataSetMP DataMP;
var const SPTuneDataDifficulty Difficulty;
var const SPTuneDataDifficultyMP DifficultyMP;
var const int GameDifficulty_Max;

// Export USPTuneManager::execIsMultiplayerGame(FFrame&, void* const)
native static final function bool IsMultiplayerGame();

// Export USPTuneManager::execGetTuneDataGameplay(FFrame&, void* const)
native static final function SPTuneDataGameplay GetTuneDataGameplay();

// Export USPTuneManager::execGetTuneDataPlayer(FFrame&, void* const)
native static final function SPTuneDataPlayer GetTuneDataPlayer();

// Export USPTuneManager::execGetTuneDataGriffon(FFrame&, void* const)
native static final function SPTuneDataGriffon GetTuneDataGriffon();

// Export USPTuneManager::execGetTuneDataWerewolf(FFrame&, void* const)
native static final function SPTuneDataWerewolf GetTuneDataWerewolf();

// Export USPTuneManager::execGetTuneDataWeakWerewolf(FFrame&, void* const)
native static final function SPTuneDataWerewolf GetTuneDataWeakWerewolf();

// Export USPTuneManager::execGetTuneDataNari(FFrame&, void* const)
native static final function SPTuneDataNari GetTuneDataNari();

// Export USPTuneManager::execGetTuneDataFireDrake(FFrame&, void* const)
native static final function SPTuneDataFireDrake GetTuneDataFireDrake();

// Export USPTuneManager::execGetTuneDataCouncil(FFrame&, void* const)
native static final function SPTuneDataSoldier GetTuneDataCouncil();

// Export USPTuneManager::execGetTuneDataBlackOrder(FFrame&, void* const)
native static final function SPTuneDataSoldier GetTuneDataBlackOrder();

// Export USPTuneManager::execGetTuneDataCivilian(FFrame&, void* const)
native static final function SPTuneDataSoldier GetTuneDataCivilian();

// Export USPTuneManager::execGetTuneDataMinotaur(FFrame&, void* const)
native static final function SPTuneDataMinotaur GetTuneDataMinotaur();

// Export USPTuneManager::execGetTuneDataBloodTick(FFrame&, void* const)
native static final function SPTuneDataBloodTick GetTuneDataBloodTick();

// Export USPTuneManager::execGetTuneDataTentacle(FFrame&, void* const)
native static final function SPTuneDataTentacle GetTuneDataTentacle();

// Export USPTuneManager::execGetTuneDataKraken(FFrame&, void* const)
native static final function SPTuneDataKraken GetTuneDataKraken();

// Export USPTuneManager::execGetGameDifficultyTuneGameplay(FFrame&, void* const)
native static final function SPGameDifficultyTuneGamePlay GetGameDifficultyTuneGameplay();

// Export USPTuneManager::execGetGameDifficultyTunePlayer(FFrame&, void* const)
native static final function SPGameDifficultyTunePlayer GetGameDifficultyTunePlayer();

// Export USPTuneManager::execGetGameDifficultyTuneGriffon(FFrame&, void* const)
native static final function SPGameDifficultyTuneGriffon GetGameDifficultyTuneGriffon();

// Export USPTuneManager::execGetGameDifficultyTuneWerewolf(FFrame&, void* const)
native static final function SPGameDifficultyTuneWerewolf GetGameDifficultyTuneWerewolf();

// Export USPTuneManager::execGetGameDifficultyTuneWeakWerewolf(FFrame&, void* const)
native static final function SPGameDifficultyTuneWeakWerewolf GetGameDifficultyTuneWeakWerewolf();

// Export USPTuneManager::execGetGameDifficultyTuneNari(FFrame&, void* const)
native static final function SPGameDifficultyTuneNari GetGameDifficultyTuneNari();

// Export USPTuneManager::execGetGameDifficultyTuneFireDrake(FFrame&, void* const)
native static final function SPGameDifficultyTuneFireDrake GetGameDifficultyTuneFireDrake();

// Export USPTuneManager::execGetGameDifficultyTuneTentacle(FFrame&, void* const)
native static final function SPGameDifficultyTuneTentacle GetGameDifficultyTuneTentacle();

// Export USPTuneManager::execGetGameDifficultyTuneKraken(FFrame&, void* const)
native static final function SPGameDifficultyTuneKraken GetGameDifficultyTuneKraken();

// Export USPTuneManager::execGetGameDifficultyTuneWeapons(FFrame&, void* const)
native static final function SPGameDifficultyTuneWeapons GetGameDifficultyTuneWeapons();

// Export USPTuneManager::execGetGameDifficultyTuneBloodTick(FFrame&, void* const)
native static final function SPGameDifficultyTuneBloodTick GetGameDifficultyTuneBloodTick();

// Export USPTuneManager::execGetGameDifficultyTuneCouncil(FFrame&, void* const)
native static final function SPGameDifficultyTuneSoldier GetGameDifficultyTuneCouncil();

// Export USPTuneManager::execGetGameDifficultyTuneBlackOrder(FFrame&, void* const)
native static final function SPGameDifficultyTuneSoldier GetGameDifficultyTuneBlackOrder();

// Export USPTuneManager::execGetGameDifficultyTuneBlackOrderOfficer(FFrame&, void* const)
native static final function SPGameDifficultyTuneSoldier GetGameDifficultyTuneBlackOrderOfficer();

// Export USPTuneManager::execGetGameDifficultyTuneBlackOrderHeavyRocketLauncher(FFrame&, void* const)
native static final function SPGameDifficultyTuneSoldier GetGameDifficultyTuneBlackOrderHeavyRocketLauncher();

// Export USPTuneManager::execGetGameDifficultyTuneBlackOrderHeavySaw(FFrame&, void* const)
native static final function SPGameDifficultyTuneSoldier GetGameDifficultyTuneBlackOrderHeavySaw();

// Export USPTuneManager::execGetGameDifficultyTuneBlackOrderHeavyFlameThrower(FFrame&, void* const)
native static final function SPGameDifficultyTuneSoldier GetGameDifficultyTuneBlackOrderHeavyFlameThrower();

// Export USPTuneManager::execGetGameDifficultyTuneCivilian(FFrame&, void* const)
native static final function SPGameDifficultyTuneSoldier GetGameDifficultyTuneCivilian();

// Export USPTuneManager::execGetGameDifficultyTuneMinotaur(FFrame&, void* const)
native static final function SPGameDifficultyTuneMinotaur GetGameDifficultyTuneMinotaur();
