class SkySeqAct_CapitalShipGunBattery extends SeqAct_Latent
    native;

struct native CycleInfo
{
    var() array<int> ActiveGunPositions;
    var() float DurationOfCycle;
    var() float DelayAfterCycle;

    structdefaultproperties
    {
        ActiveGunPositions=none
        DurationOfCycle=0.0000000
        DelayAfterCycle=0.0000000
    }
};

struct native GunInfo
{
    var SkyVehicle_AAGun_Gatling GunIndex;
    var() Actor GunLocation;
    var() name GunSocket;
    var() float GunHealth;
    var transient float DefaultGunHealth;

    structdefaultproperties
    {
        GunIndex=none
        GunLocation=none
        GunSocket="None"
        GunHealth=0.0000000
        DefaultGunHealth=0.0000000
    }
};

var() array<CycleInfo> Cycles;
var() float ToasterSlideOutDelay;
var transient int CurrentCycle;
var transient float DurationTimer;
var transient float DelayTimer;
var() array<GunInfo> GunPositions;
var() int NumberOfActiveGuns;
var transient array<SkyVehicle_AAGun_Gatling> AvailableAAGuns;
var() SkyVehicle_AAGun_Gatling GunArchetype;
var() SkyAITurret TurretControllerArchetype;
var deprecated int NumberOfGunsDestroyedBeforeDamaged;
var transient int NumberOfGunPositionsDestroyed;
var deprecated transient bool bInitialized;
var transient bool bActivated;
var(Effects) ParticleSystem GunDeathEffect;

// Export USkySeqAct_CapitalShipGunBattery::execTakeDamage(FFrame&, void* const)
native function TakeDamage(SkyVehicle_AAGun_Gatling AAGun, int Damage, Controller InstigatedBy, Actor DamageCauser, bool bNoEffects);
