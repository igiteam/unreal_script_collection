class SkyPawnPlayerCharacter extends SkyPawnCoverUser
    abstract
    native
    config(Pawn);

var deprecated float ReducedDamageInVehicles;
var deprecated float ReducedDamageOnFoot;
var(PlayerCharacter) float EasyReducedDamageInVehicles;
var(PlayerCharacter) float EasyReducedDamageRocketpacking;
var(PlayerCharacter) float EasyReducedDamageInAAGun;
var(PlayerCharacter) float EasyReducedDamageOnFoot;
var(PlayerCharacter) float MediumReducedDamageInVehicles;
var(PlayerCharacter) float MediumReducedDamageRocketpacking;
var(PlayerCharacter) float MediumReducedDamageInAAGun;
var(PlayerCharacter) float MediumReducedDamageOnFoot;
var(PlayerCharacter) float HardReducedDamageInVehicles;
var(PlayerCharacter) float HardReducedDamageRocketpacking;
var(PlayerCharacter) float HardReducedDamageInAAGun;
var(PlayerCharacter) float HardReducedDamageOnFoot;
var bool bFailedUse;
var bool bCameraRelativeAudio;
var() float FailedUseDuration;
var name FailedUseTimer;
var Vector OldAudioPosition;
var float TotalAudioPositionBlendTime;
var(Sound) editconst config float AudioPositionBlendTime;

// Export USkyPawnPlayerCharacter::execSetPawnAudioPosition(FFrame&, void* const)
native function SetPawnAudioPosition(bool bSetCameraRelativeAudio);

// Export USkyPawnPlayerCharacter::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

function FailedUseAction()
{
    // End:0x120
    if(((((((((!IsInteracting() && !IsSprinting()) && !bFailedUse) && !IsGripping()) && (PrimaryWSM == none) || !PrimaryWSM.IsSwapping() && !PrimaryWSM.IsReloading()) && int(GetCoverState()) == int(0)) && !UsingSecondaryItem()) && (int(GetCoverState()) != int(0)) || Base != none) && int(GetCoverMacroState()) != int(1)) && int(GetCoverMacroState()) != int(4))
    {
        bFailedUse = true;
        SetTimer(FailedUseDuration, false, FailedUseTimer);
        CachedTarget = none;
        InteractionInstigator = none;
    }
    //return;    
}

function FailedUseComplete()
{
    bFailedUse = false;
    PrimaryWSM.TryDraw();
    //return;    
}

// Export USkyPawnPlayerCharacter::execCanPrimaryWeaponFire(FFrame&, void* const)
native function bool CanPrimaryWeaponFire(optional bool bIgnoreReload, optional bool bCheckingForTargeting);

event bool CanSecondaryItemFire()
{
    return super.CanSecondaryItemFire() && !bFailedUse;
    //return ReturnValue;    
}
