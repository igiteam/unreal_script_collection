class SkyRadar extends Object
    native;

enum RadarBlipClass
{
    RBC_InAir,                      // 0
    RBC_OnGround,                   // 1
    RBC_MAX                         // 2
};

struct native RadarObject
{
    var Actor TargetActor;
    var float TimeRemaining;

    structdefaultproperties
    {
        TargetActor=none
        TimeRemaining=0.0000000
    }
};

struct native RadarBlip
{
    var Vector Location;
    var float TargetType;
    var float ZDifference;
    var float Alpha;
    var Actor Target;
    var SkyRadar.RadarBlipClass BlipClass;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TargetType=0.0000000
        ZDifference=0.0000000
        Alpha=0.0000000
        Target=none
        BlipClass=RBC_InAir
    }
};

var() float RadarUpdateDelay;
var() float RadarRangeHandHeldRadar;
var() float AirRadarRangeHandHeldRadar;
var() float RadarRangeVehicleRadar;
var() float AirRadarRangeVehicleRadar;
var() float GroundToAirTransitionTime;
var transient float GroundToAirTransition;
var() float GatherRange;
var transient int UpgradeLevel;
var() float PersistTime;
var() float FadeTime;
var transient bool bInitialized;
var transient SkyHUD SH;
var transient array<RadarObject> RadarObjects;
var transient array<RadarBlip> BlipLocations;

function Init(SkyHUD SkyHUD)
{
    local SkyPlayerControllerBase PC;
    local OnlineProfileSettings Settings;

    SH = SkyHUD;
    // End:0x20
    if(SH == none)
    {
        bInitialized = false;
        return;
    }
    PC = SkyPlayerControllerBase(SH.PlayerOwner);
    // End:0x91
    if(PC != none)
    {
        Settings = PC.GetProfileSettings();
        // End:0x91
        if(Settings != none)
        {
            // End:0x91
            if(Settings.GetProfileSettingValueInt(67, UpgradeLevel))
            {
                UpgradeLevel += 2;
            }
        }
    }
    SH.SetTimer(RadarUpdateDelay, true, 'UpdateRadar', self);
    bInitialized = true;
    //return;    
}

// Export USkyRadar::execUpdateRadar(FFrame&, void* const)
native function UpdateRadar();

// Export USkyRadar::execAddObject(FFrame&, void* const)
native function AddObject(Actor Obj);
