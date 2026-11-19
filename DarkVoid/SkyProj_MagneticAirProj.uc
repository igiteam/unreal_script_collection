class SkyProj_MagneticAirProj extends SkyProjectile
    native;

var(Magnetic) bool LockOnTeammates;
var(DamageVolume) bool bUseDamageVolume;
var(DamageVolume) bool DamageVolumeHurtsPlayer;
var bool bDamageVolumeActive;
var bool bDamageVolumeGrowing;
var(Effects_Burst) bool UseBurstEffects;
var(Effects_Burst) bool BEUseSmartRandom;
var(Effects_Burst) bool BEUseScalingDistance;
var() bool bIgnoreMovingLevels;
var transient bool bSearchForMagneticTargetLockedOut;
var(Magnetic) float MagneticRange;
var(Magnetic) float MagneticStrength;
var(Magnetic) float MaxAngleForNewTarget;
var(Magnetic) float AquireBonusCurrentTarget;
var(Magnetic) float AquireBonusDistance;
var(Magnetic) float AquireBonusAngle;
var(EMP) float ChanceToFlatSpinBots;
var(EMP) float ChanceToFlatSpinPlayer;
var(EMP) float ChanceToFlatSpinPlayerAtZeroFuel;
var(EMP) float FuelDrainToPlayer;
var Vehicle CurrentLockedTarget;
var Vector AimOffset;
var float AimOffsetLength;
var(Collision) export editinline StaticMeshComponent AirVehicleCollision;
var(DamageVolume) float DamageVolumeStartDelay;
var(DamageVolume) float DamageVolumeGrowthDuration;
var(DamageVolume) float DamageVolumeHoldDuration;
var(DamageVolume) float DamageVolumeStartSize;
var(DamageVolume) float DamageVolumeEndSize;
var(DamageVolume) float DamageVolumeDamagePerSecond;
var float DamageVolumeTimer;
var(Effects_Burst) float BEDistance;
var(Effects_Burst) float BEStartDelay;
var(Effects_Burst) float BEDuration;
var(Effects_Burst) int BECount;
var(Effects_Burst) array<ParticleSystem> BETemplates;
var int RemainingBE;

simulated event PostBeginPlay()
{
    AimOffset.X = FRand() * 0.5000000;
    AimOffset.Y = FRand() * 0.5000000;
    AimOffset.Z = FRand() * 0.5000000;
    AimOffset = Normal(AimOffset);
    AimOffsetLength = FRand();
    super.PostBeginPlay();
    //return;    
}

// Export USkyProj_MagneticAirProj::execGetSeekingTargetLocation(FFrame&, void* const)
native function Vector GetSeekingTargetLocation(Pawn P);

simulated function Tick(float DeltaTime)
{
    // End:0x11
    if(!CanTick())
    {
        return;
    }
    // End:0x29
    if(bDamageVolumeActive)
    {
        UpdateDamageVolume(DeltaTime);
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

// Export USkyProj_MagneticAirProj::execGetTargetRating(FFrame&, void* const)
native function float GetTargetRating(Pawn Target, Vector OldVelNorm);

// Export USkyProj_MagneticAirProj::execUpdateHomingRotation(FFrame&, void* const)
native function UpdateHomingRotation(Pawn Target, float DeltaTime);

simulated function SearchForMagneticTargetLockedOut()
{
    bSearchForMagneticTargetLockedOut = false;
    //return;    
}

// Export USkyProj_MagneticAirProj::execUpdateMagneticPull(FFrame&, void* const)
native final function UpdateMagneticPull(float DeltaTime);

simulated function UpdateDamageVolume(float DeltaTime)
{
    local float DVDistance;
    local Vehicle V;

    // End:0x7E
    if(bDamageVolumeGrowing)
    {
        DVDistance = DamageVolumeStartSize + ((float(1) - (DamageVolumeTimer / DamageVolumeGrowthDuration)) * (DamageVolumeEndSize - DamageVolumeStartSize));
        DamageVolumeTimer -= DeltaTime;
        // End:0x7B
        if(DamageVolumeTimer <= float(0))
        {
            // End:0x71
            if(DamageVolumeHoldDuration > float(0))
            {
                DamageVolumeTimer = DamageVolumeHoldDuration;
                bDamageVolumeGrowing = false;                
            }
            else
            {
                DamageVolumeEnd();
            }
        }        
    }
    else
    {
        DVDistance = DamageVolumeEndSize;
        DamageVolumeTimer -= DeltaTime;
        // End:0xAC
        if(DamageVolumeTimer <= float(0))
        {
            DamageVolumeEnd();
        }
    }
    // End:0x129
    if(bDamageVolumeActive)
    {
        // End:0x128
        foreach VisibleCollidingActors(Class'Engine.Vehicle', V, DVDistance, Location)
        {
            // End:0xE5
            if(V == Instigator)
            {
                continue;                
            }
            V.TakeDamage(int(DeltaTime * DamageVolumeDamagePerSecond), Instigator.Controller, Location, Velocity, MyDamageType);            
        }        
    }
    //return;    
}

// Export USkyProj_MagneticAirProj::execReset(FFrame&, void* const)
native simulated function Reset();

// Export USkyProj_MagneticAirProj::execInit(FFrame&, void* const)
native function Init(Vector Direction);

// Export USkyProj_MagneticAirProj::execHitWall(FFrame&, void* const)
native simulated function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp, optional int Item);

// Export USkyProj_MagneticAirProj::execExplode(FFrame&, void* const)
native simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor Other, optional bool bContinueAfterExplosion);

// Export USkyProj_MagneticAirProj::execBurstEffectsStart(FFrame&, void* const)
native simulated function BurstEffectsStart();

// Export USkyProj_MagneticAirProj::execBurstEffectsEnd(FFrame&, void* const)
native simulated function BurstEffectsEnd();

// Export USkyProj_MagneticAirProj::execFireBurstEffect(FFrame&, void* const)
native simulated function FireBurstEffect(optional bool ForceFinish);

// Export USkyProj_MagneticAirProj::execDamageVolumeStart(FFrame&, void* const)
native simulated function DamageVolumeStart();

// Export USkyProj_MagneticAirProj::execDamageVolumeEnd(FFrame&, void* const)
native simulated function DamageVolumeEnd();

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x41
    if(bIgnoreMovingLevels && ((SkyDynamicSMActor(Other) != none) || SkeletalMeshActor(Other) != none) || SkyVehicle_AAGun_Gatling(Other) != none)
    {
        return;
    }
    super.ProcessTouch(Other, HitLocation, HitNormal);
    //return;    
}
