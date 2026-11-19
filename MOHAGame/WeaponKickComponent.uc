class WeaponKickComponent extends ActorComponent
    native;

enum EKickType
{
    KICK_TYPE_V,                    // 0
    KICK_TYPE_T,                    // 1
    KICK_TYPE_NONE,                 // 2
    KICK_TYPE_MAX                   // 3
};

enum EKickControlOption
{
    FREEZE_PITCH_CONTROLS,          // 0
    ALWAYS_CORRECT,                 // 1
    AUTO_CORRECT,                   // 2
    DONT_CORRECT,                   // 3
    EKickControlOption_MAX          // 4
};

var private native const Pointer pimpl_;
var EALAWeapon mWeapon;
var(EALATuning) ViewKickTuning KickParams;
var(EALATuning) WeaponKickComponent.EKickType KickType;
var(EALATuning) WeaponKickComponent.EKickControlOption PitchControlOption;

// Export UWeaponKickComponent::execOnShotFiredKick(FFrame&, void* const)
native function OnShotFiredKick();

// Export UWeaponKickComponent::execApplyKick(FFrame&, void* const)
native function ApplyKick(out Rotator Rot, float DeltaTime);

// Export UWeaponKickComponent::execApplyPush(FFrame&, void* const)
native function ApplyPush(out Vector Loc, Rotator Rot, float DeltaTime);

// Export UWeaponKickComponent::execTickInternal(FFrame&, void* const)
native function TickInternal(float DeltaTime);

// Export UWeaponKickComponent::execUpdateParams(FFrame&, void* const)
native function UpdateParams();

simulated function Tick(float DeltaTime)
{
    TickInternal(DeltaTime);
    //return;    
}

event bool IsFiring()
{
    // End:0x0D
    if(mWeapon == none)
    {
        return false;
    }
    return mWeapon.IsFiring();
    //return ReturnValue;    
}

defaultproperties
{
    PitchControlOption=2
}