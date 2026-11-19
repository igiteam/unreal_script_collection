class SkyProj_SecondaryItem extends SkyProj_SecondaryItemBase
    native;

struct native ExplodeEffectInfo
{
    var() ParticleSystem Effect;
    var() ParticleSystem PCEffect;
    var() name Material;
    var() MaterialInterface DecalMaterial;
    var float DecalWidth;
    var float DecalHeight;
    var() float DecalMinSize;
    var() float DecalMaxSize;
    var float DecalRotation;
    var() float DecalMinRotation;
    var() float DecalMaxRotation;
    var int SubImageIndex;
    var() int SubImages_Horizontal;
    var() int SubImages_Vertical;
    var() int SubImageMinIndex;
    var() int SubImageMaxIndex;

    structdefaultproperties
    {
        Effect=none
        PCEffect=none
        Material="None"
        DecalMaterial=none
        DecalWidth=0.0000000
        DecalHeight=0.0000000
        DecalMinSize=10.0000000
        DecalMaxSize=10.0000000
        DecalRotation=0.0000000
        DecalMinRotation=0.0000000
        DecalMaxRotation=360.0000000
        SubImageIndex=0
        SubImages_Horizontal=1
        SubImages_Vertical=1
        SubImageMinIndex=0
        SubImageMaxIndex=0
    }
};

var(Effects) name SparkSocket;
var(Effects) ExplodeEffectInfo DefaultExplodeMaterialEffect;
var(Effects) array<ExplodeEffectInfo> ExpoldeMaterialEffects;
var Emitter ProjExplosionImpactEffect;
var(Effects) bool bUseExplodeLocalEffect;
var deprecated SkyLocalEffect ExplodeLocalEffect;
var(Effects) editinline SkyLocalEffectSettings ExplodeLocalEffectSettings;
var deprecated float ExplosionShakeRange;
var deprecated SoundCue PullSound;
var(Sounds) export editinline AudioComponent LiteSound;
var deprecated SoundCue WarningCue;
var(Projectile) float WarningLength;
var float WarningStartTime;
var float DecalDepth;
var deprecated SkyAvoidMarker FearMarker;
var Vector AudioOffsetLocation;

// Export USkyProj_SecondaryItem::execInit(FFrame&, void* const)
native function Init(Vector Direction);

// Export USkyProj_SecondaryItem::execReset(FFrame&, void* const)
native simulated function Reset();

function PlayWarningSound()
{
    WarningStartTime = WorldInfo.TimeSeconds;
    //return;    
}

// Export USkyProj_SecondaryItem::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

simulated event ReplicatedEvent(name VarName)
{
    super(Actor).ReplicatedEvent(VarName);
    // End:0x5C
    if(VarName == 'LaunchReq')
    {
        launch(LaunchReq.Location, LaunchReq.Rotation, Normal(LaunchReq.Direction));
    }
    //return;    
}

// Export USkyProj_SecondaryItem::execSpawnFlightEffects(FFrame&, void* const)
native simulated function SpawnFlightEffects();

simulated event DetonateTimer()
{
    super.DetonateTimer();
    // End:0x21
    if(LiteSound != none)
    {
        LiteSound.Stop();
    }
    //return;    
}

// Export USkyProj_SecondaryItem::execGetExplodeEffect(FFrame&, void* const)
native simulated function ExplodeEffectInfo GetExplodeEffect(PhysicalMaterial HitMaterial);

// Export USkyProj_SecondaryItem::execSpawnExplosionEffects(FFrame&, void* const)
native simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal, optional Actor Other);

// Export USkyProj_SecondaryItem::execExplode(FFrame&, void* const)
native simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor Other, optional bool bContinueAfterExplosion);

function PickEffectAndSound(name physmatname)
{
    //return;    
}

function Vector GetAudioOffset()
{
    return AudioOffsetLocation;
    //return ReturnValue;    
}
