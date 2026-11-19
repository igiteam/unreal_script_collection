class MOHAWeaponExperienceComponent extends ActorComponent
    native;

var class<EALAWeapon> WeaponClass;
var float ExperiencePoints;
var int ExperienceLevel;
var int MaxExperienceLevel;
var float ExperienceLevelPoints[4];
var MOHAPlayerController PlayerController;

// Export UMOHAWeaponExperienceComponent::execAddExperiencePoints(FFrame&, void* const)
native function AddExperiencePoints(float Points);

// Export UMOHAWeaponExperienceComponent::execGetPointScaling(FFrame&, void* const)
native function int GetPointScaling();

function Init(class<EALAWeapon> wepClass, MOHAPlayerController PC)
{
    WeaponClass = wepClass;
    MaxExperienceLevel = WeaponClass.default.NumExpLevels;
    ExperienceLevelPoints[0] = WeaponClass.default.ExpPointsLevel1;
    ExperienceLevelPoints[1] = WeaponClass.default.ExpPointsLevel2;
    ExperienceLevelPoints[2] = WeaponClass.default.ExpPointsLevel3;
    ExperienceLevelPoints[3] = WeaponClass.default.ExpPointsLevel4;
    PlayerController = PC;
    //return;    
}

function ResetExperience()
{
    ExperienceLevel = 0;
    ExperiencePoints = 0.0000000;
    //return;    
}

simulated function RestoreExperience(int ExpPoints)
{
    local EALAWeapon UpgradeWeapon;
    local MOHAInventoryManager MOHAInvMgr;
    local editinline MOHAWeaponUpgradeManager UpgradeMgr;
    local UIInteraction UIController;
    local UIDataStore_MOHAGameResource DataStore;

    ExperienceLevel = 0;
    ExperiencePoints = float(ExpPoints);
    UpgradeMgr = MOHAPlayerPawn(PlayerController.Pawn).WeaponUpgradeManager;
    MOHAInvMgr = MOHAInventoryManager(PlayerController.Pawn.InvManager);
    UpgradeWeapon = MOHAInvMgr.GetWeaponOfType(WeaponClass.default.WeaponType);
    J0x7F:

    // End:0xEB [Loop If]
    if(((ExperienceLevel < MaxExperienceLevel) && ExperienceLevel < 4) && ExperiencePoints >= ExperienceLevelPoints[ExperienceLevel])
    {
        ExperienceLevel++;
        UpgradeMgr.upgrade(WeaponClass.default.WeaponType, ExperienceLevel - 1, UpgradeWeapon);
        // [Loop Continue]
        goto J0x7F;
    }
    UIController = PlayerController.GetUIController();
    // End:0x17F
    if(UIController != none)
    {
        // End:0x17F
        if(UIController.DataStoreManager != none)
        {
            DataStore = UIDataStore_MOHAGameResource(UIController.DataStoreManager.FindDataStore('MOHAGameResources'));
            // End:0x17F
            if(DataStore != none)
            {
                DataStore.UpdateWeaponStats(int(WeaponClass.default.WeaponType), ExperienceLevel);
            }
        }
    }
    //return;    
}
