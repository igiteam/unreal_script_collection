class SkyGameInteraction extends SkyInteraction
    native
    editinlinenew;

enum EGeneralInteractorDescriptor
{
    GID_Default,                    // 0
    GID_StandingHorizontalCover,    // 1
    GID_CrouchingHorizontalCover,   // 2
    GID_VerticalUpCover,            // 3
    GID_VerticalDownCover,          // 4
    GID_Pilot,                      // 5
    GID_Hijacker,                   // 6
    GID_Gripper,                    // 7
    GID_Glider,                     // 8
    GID_Thruster,                   // 9
    GID_Falling,                    // 10
    GID_Jumping,                    // 11
    GID_Spider,                     // 12
    GID_Invalid,                    // 13
    GID_MAX                         // 14
};

enum EArmorCheck
{
    Armor_Irrelevant,               // 0
    Armor_MustHave,                 // 1
    Armor_MustNotHave,              // 2
    Armor_MAX                       // 3
};

var() SkyGameInteraction.EArmorCheck InstigatorHeadCheck;
var() SkyGameInteraction.EArmorCheck InstigatorBodyCheck;
var() SkyGameInteraction.EArmorCheck TargetHeadCheck;
var() SkyGameInteraction.EArmorCheck TargetBodyCheck;
var() float FOV;
var() editinline array<editinline SkyGameInteraction.EGeneralInteractorDescriptor> InstigatorGIDs;
var() editinline array<editinline SkyGameInteraction.EGeneralInteractorDescriptor> TargetGIDs;
var() bool bCheckInstigatorWeapon;
var() bool bCheckTargetWeapon;
var() bool bCheckInstigatorAmmo;
var() bool bCheckTargetAmmo;
var() bool bCheckInstigatorReload;
var() bool bCheckInstigatorVehicle;
var() array< class<Weapon> > InstigatorWeaponClasses;
var() array< class<Weapon> > TargetWeaponClasses;
var() array< class<Vehicle> > InstigatorVehicleClasses;
var(Health) float MinTargetHealthPct;
var(Health) float MaxTargetHealthPct;

// Export USkyGameInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
