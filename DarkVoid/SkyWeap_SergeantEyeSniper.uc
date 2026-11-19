class SkyWeap_SergeantEyeSniper extends SkyWeapon
    native
    config(Game);

var() SEffectInfo SniperBeam;
var() float LockingOnDeviationYaw;
var() float LockingOnDeviationPitch;
var() float LockingOnDeviationFreq;
var() float LockedOnTargetDuration;
var transient Rotator LockedAimRotation;

// Export USkyWeap_SergeantEyeSniper::execGetPhysicalFireStartLoc(FFrame&, void* const)
native simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir);

// Export USkyWeap_SergeantEyeSniper::execGetAdjustedAim(FFrame&, void* const)
native simulated function Rotator GetAdjustedAim(Vector StartFireLoc);

function HolderDied()
{
    super(Weapon).HolderDied();
    // End:0x68
    if((SniperBeam.Emitter != none) && SniperBeam.Emitter.ParticleSystemComponent != none)
    {
        SniperBeam.Emitter.Destroy();
        SniperBeam.Emitter = none;
    }
    //return;    
}
