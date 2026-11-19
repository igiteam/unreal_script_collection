class SkyPawn_Adept extends SkyPawnPlayerCharacter
    native
    config(Pawn);

enum EhbenBladeState
{
    EHBEN_Sheathed,                 // 0
    EHBEN_Drawing,                  // 1
    EHBEN_Drawn,                    // 2
    EHBEN_Sheathing,                // 3
    EHBEN_MAX                       // 4
};

struct native AdeptPowerLevels
{
    var() float EnergyRequired;
    var() float EnergyPerUse;
    var() float Radius;
    var(Offense) float BlindDuration;
    var(Offense) float RealDamage;
    var(Offense) float WatcherDamage;
    var(Offense) float EnergyGainedPerWatcherKill;
    var(Defense) float InitialHealthGain;
    var(Defense) float RegenRate;
    var(Defense) float OvershieldPercent;
    var(Effects) float DomeExpandTime;
    var(Effects) float DomeFadeStartDelay;
    var(Effects) float DomeFadeTime;
    var(Effects) float DomeFinalScale;
    var(Effects) ParticleSystem EffectTemplate;
    var(Effects) name EffectSocket;
    var export editinline ParticleSystemComponent EffectRef;

    structdefaultproperties
    {
        EnergyRequired=0.0000000
        EnergyPerUse=0.0000000
        Radius=0.0000000
        BlindDuration=0.0000000
        RealDamage=0.0000000
        WatcherDamage=0.0000000
        EnergyGainedPerWatcherKill=0.0000000
        InitialHealthGain=0.0000000
        RegenRate=0.0000000
        OvershieldPercent=0.0000000
        DomeExpandTime=0.0000000
        DomeFadeStartDelay=0.0000000
        DomeFadeTime=0.0000000
        DomeFinalScale=0.0000000
        EffectTemplate=none
        EffectSocket="None"
        EffectRef=none
    }
};

var deprecated bool bHasEhbenBlade;
var export editinline deprecated SkeletalMeshComponent BladeMesh;
var deprecated name BladeSocket;
var deprecated SkyPawn_Adept.EhbenBladeState CurrentEhbenBladeState;
var deprecated ParticleSystem BladeIdleEffect;
var deprecated ParticleSystem BladeImpactEffect;
var export editinline deprecated ParticleSystemComponent BladeIdleRef;
var export editinline deprecated ParticleSystemComponent BladeImpactRef;
var deprecated name BladeIdleSocket;
var deprecated name BladeImpactSocket;

simulated function PostBeginPlay()
{
    super(SkyPawnCoverUser).PostBeginPlay();
    //return;    
}

simulated function AttachEhbenBlade()
{
    //return;    
}

simulated event SetEhbenBladeState(SkyPawn_Adept.EhbenBladeState NewState)
{
    //return;    
}

simulated function ToggleEhbenBladeState(bool Draw)
{
    //return;    
}

simulated function EhbenBladeImpact()
{
    //return;    
}
