class MOHAHUDExpBar extends MOHAHUDObj
    native;

enum EGunIconType
{
    OUTLINE_WEAPON,                 // 0
    GREY_WEAPON,                    // 1
    COLOR_WEAPON,                   // 2
    FULL_UPGRADE,                   // 3
    EGunIconType_MAX                // 4
};

var EALAWeapon CurrentWeapon;
var int WeaponLevel;
var int UpgradeLevel;
var float ExpBarRatio;
var bool bGrenadeExperience;
var MOHAHUDImg ExperienceLevelIcon;
var MOHAHUDImg ExperienceLevelBg;
var Vector ExperienceIconUVs[3];
var int ExperienceIconOffset;

// Export UMOHAHUDExpBar::execGetUVInfo(FFrame&, void* const)
native function GetUVInfo(MOHAHUDExpBar.EGunIconType Type, out float U, out float uw);

// Export UMOHAHUDExpBar::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDExpBar::execShouldRender(FFrame&, void* const)
native function bool ShouldRender();

// Export UMOHAHUDExpBar::execOnResolutionChange(FFrame&, void* const)
native function OnResolutionChange(float resolutionScale);

event EALAWeapon GetCurrentWeapon(PlayerController LocalPlayer)
{
    local MOHAInventoryManager PawnInvManager;

    // End:0x47
    if(((LocalPlayer == none) || LocalPlayer.Pawn == none) || MOHAInventoryManager(LocalPlayer.Pawn.InvManager) == none)
    {
        return none;
    }
    PawnInvManager = MOHAInventoryManager(LocalPlayer.Pawn.InvManager);
    // End:0x89
    if(bGrenadeExperience)
    {
        return PawnInvManager.GetHUDGrenade();        
    }
    else
    {
        return PawnInvManager.GetHUDWeapon();
    }
    //return ReturnValue;    
}

event MOHAWeaponExperienceComponent GetExperienceComponent(PlayerController LocalPlayer, EALAWeapon Weapon)
{
    // End:0x68
    if(((MOHAPlayerController(LocalPlayer) != none) && MOHAPlayerController(LocalPlayer).playerStats != none) && Weapon != none)
    {
        return MOHAPlayerController(LocalPlayer).playerStats.GetWeaponExpComponent(Weapon.Class);
    }
    return none;
    //return ReturnValue;    
}

function MOHAWeaponUpgradeManager GetUpgradeManager(PlayerController LocalPlayer)
{
    // End:0x43
    if((LocalPlayer != none) && MOHAPlayerPawn(LocalPlayer.Pawn) != none)
    {
        return MOHAPlayerPawn(LocalPlayer.Pawn).WeaponUpgradeManager;
    }
    //return ReturnValue;    
}

function int GetMPUpgradeLevel(PlayerController LocalPlayer)
{
    // End:0x61
    if((LocalPlayer != none) && MOHAPlayerPawn(LocalPlayer.Pawn) != none)
    {
        return MOHAPlayerPawn(LocalPlayer.Pawn).GetUpgradeStatus(int(CurrentWeapon.Class.default.WeaponClass));
    }
    //return ReturnValue;    
}

event int GetUpgradeLevel(PlayerController LocalPlayer)
{
    local editinline MOHAWeaponUpgradeManager UpgradeMan;

    // End:0x20
    if(MOHAHUD_MP(MOHAHUD) != none)
    {
        return GetMPUpgradeLevel(LocalPlayer);
    }
    UpgradeMan = GetUpgradeManager(LocalPlayer);
    return ((UpgradeMan != none) ? UpgradeMan.GetAppliedUpgradeLevel(CurrentWeapon.Class.default.WeaponType) : 0);
    //return ReturnValue;    
}

defaultproperties
{
    ExperienceIconUVs[0]=(X=192.0000000,Y=128.0000000,Z=0.0000000)
    ExperienceIconUVs[1]=(X=256.0000000,Y=128.0000000,Z=0.0000000)
    ExperienceIconUVs[2]=(X=320.0000000,Y=128.0000000,Z=0.0000000)
    ExperienceIconOffset=27
}