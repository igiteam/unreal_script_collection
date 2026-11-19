class SkyAirVehicle_RocketPackThrust extends SkyAirVehicle
    native
    config(Game);

var() float ExitDeceleration;
var bool bExitBraking;
var() bool bUseDriverMeshForWeaponSkts;
var(HitReactions) protected float MaximumDelayBetweenDamage;
var(HitReactions) protected float StumbleProbability;
var(HitReactions) protected float Stumble_DamageAmount;
var transient float StumbleAccumulatedDamage;
var transient float StumbleResetDamageTimer;
var int PawnKillingDmg;
var(Health) float LowHealthPercentForWarning;
var(Health) editconst export editinline AudioComponent WarningLoopSound;

// Export USkyAirVehicle_RocketPackThrust::execTriggerVehicleEffect(FFrame&, void* const)
native simulated function TriggerVehicleEffect(name TriggerName);

// Export USkyAirVehicle_RocketPackThrust::execEnterCriticalState(FFrame&, void* const)
native function EnterCriticalState();

// Export USkyAirVehicle_RocketPackThrust::execExitCriticalState(FFrame&, void* const)
native function ExitCriticalState();

// Export USkyAirVehicle_RocketPackThrust::execHitZeroFuel(FFrame&, void* const)
native function HitZeroFuel();

// Export USkyAirVehicle_RocketPackThrust::execThrowDriver(FFrame&, void* const)
native function ThrowDriver();

// Export USkyAirVehicle_RocketPackThrust::execCheckForStumbleReaction(FFrame&, void* const)
native final function CheckForStumbleReaction(int DamageAmount, Vector Momentum, Actor DamageCauser, Controller EventInstigator);

simulated function StopWarningLoopSound()
{
    // End:0x30
    if((WarningLoopSound != none) && WarningLoopSound.bWasPlaying)
    {
        WarningLoopSound.Stop();
    }
    //return;    
}

// Export USkyAirVehicle_RocketPackThrust::execSitDriver(FFrame&, void* const)
native simulated function SitDriver(SkyPawnBase UTP, int SeatIndex);

simulated function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local SkyPawn SP;

    SP = SkyPawn(Driver);
    // End:0x50
    if((SP != none) && SP.RocketPack != none)
    {
        SP.RocketPack.StopAllAudio();
    }
    StopWarningLoopSound();
    // End:0x73
    if(DamageType == CollisionDmgType)
    {
        ThrowDriver();
    }
    // End:0x11E
    if((Driver != none) && Driver.Health > 0)
    {
        Driver.Health = 0;
        // End:0xDD
        if(DamageType == Class'SkyDmgType_ForceField')
        {
            SP.AddEffectVisualEffect(SP.ForceFieldVisualEffects, Killer);
        }
        SkyPawn(Driver).DeathReaction = 'RPDeath';
        Driver.Died(Killer, DamageType, HitLocation);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function Vector GetCameraLocation()
{
    // End:0x2A
    if(SkyPawn(Driver) != none)
    {
        return SkyPawn(Driver).GetCameraLocation();
    }
    return super.GetCameraLocation();
    //return ReturnValue;    
}

// Export USkyAirVehicle_RocketPackThrust::execReducedDamageByDifficulty(FFrame&, void* const)
native function int ReducedDamageByDifficulty(int Damage);

// Export USkyAirVehicle_RocketPackThrust::execTakeDamage(FFrame&, void* const)
native simulated function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyAirVehicle_RocketPackThrust::execShouldHideDriverOnDeath(FFrame&, void* const)
native function bool ShouldHideDriverOnDeath(class<DamageType> dmgType);

// Export USkyAirVehicle_RocketPackThrust::execGetBarrelLocationAndRotation(FFrame&, void* const)
native simulated function GetBarrelLocationAndRotation(int SeatIndex, out Vector SocketLocation, optional out Rotator SocketRotation);

// Export USkyAirVehicle_RocketPackThrust::execGetWeaponAim(FFrame&, void* const)
native function Rotator GetWeaponAim(SkyVehicleWeapon VWeapon);
