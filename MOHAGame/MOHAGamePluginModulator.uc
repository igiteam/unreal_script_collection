class MOHAGamePluginModulator extends Info
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var bool bEnabled;
var transient Vector Cache_PlayerViewLocation;
var transient float Cache_PlayerHealthPctg;
var transient float Cache_PlayerTrueTriggerValue;
var transient float Cache_PlayerTrueTriggerTime;
var transient bool Cache_PlayerInShellShock;
var(PluginMod_Tuning) config float DistMax;
var(PluginMod_Tuning) config float DistMin;
var(PluginMod_Tuning) config float FreqMax;
var(PluginMod_Tuning) config float FreqMin;
var(PluginMod_Tuning) config float SmoothUp;
var(PluginMod_Tuning) config float SmoothDown;
var(PluginMod_Tuning) config float AzimuthBack;
var(PluginMod_Tuning) config float AzimuthFront;
var(PluginMod_Tuning) config float HealthStartPctg;
var(PluginMod_Tuning) config float OcclusionSightTimeDelta;
var(PluginMod_Tuning) config float PercentDistance;
var(PluginMod_Tuning) config float PercentOcclusionTrigger;
var(PluginMod_Tuning) config float PercentOcclusionSight;
var(PluginMod_Tuning) config float PercentAzimuth;
var(PluginMod_Tuning) config float PercentShellShock;
var(PluginMod_Tuning) config float PercentTrueTrigger;
var(PluginMod_Tuning) config float TrueTriggerSmoothIn;
var(PluginMod_Tuning) config float TrueTriggerSmoothOut;

simulated function PostBeginPlay()
{
    Init();
    super(Actor).PostBeginPlay();
    //return;    
}

// Export UMOHAGamePluginModulator::execInit(FFrame&, void* const)
native final function Init();

// Export UMOHAGamePluginModulator::execCleanup(FFrame&, void* const)
native final function Cleanup();

// Export UMOHAGamePluginModulator::execUpdatePlayerInfo(FFrame&, void* const)
native final function UpdatePlayerInfo(MOHAPlayerPawn P);

defaultproperties
{
    bEnabled=true
    DistMax=60000.0000000
    DistMin=900.0000000
    FreqMax=24000.0000000
    FreqMin=300.0000000
    SmoothUp=3.0000000
    SmoothDown=0.5000000
    AzimuthBack=20.0000000
    AzimuthFront=80.0000000
    HealthStartPctg=0.4500000
    OcclusionSightTimeDelta=0.2500000
    PercentDistance=1.0000000
    PercentOcclusionTrigger=0.4500000
    PercentOcclusionSight=0.5450000
    PercentAzimuth=0.0750000
    PercentShellShock=0.7000000
    PercentTrueTrigger=0.8000000
    TrueTriggerSmoothIn=5.0000000
    TrueTriggerSmoothOut=10.0000000
    // Reference: SpriteComponent'Default__MOHAGamePluginModulator.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}