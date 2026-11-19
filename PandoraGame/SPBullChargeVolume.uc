class SPBullChargeVolume extends SPWingBuffetVolume
    native;

struct native SPBullChargeScreenScratch
{
    var() Material materialName;
    var() SoundCue scratchSound;
    var() name SocketName;
    var() int xOffset;
    var() int yOffset;
    var() float Duration;
    var() float FadeTime;
    var() SPPawn.EHSDamageValidationType DamageType;
    var() SPPawn.EHSDamageDirectionType facingDamageDir;
    var() ScreenShakeStruct ScreenShake;
    var() name HitDOFEffectName;
    var() name HitMaterialEffectName;
    var() float HitEffectFadeTime;
    var transient MaterialInstanceConstant HitEffectMaterialInstance;
    var MaterialEffect HitMaterialEffect;
    var DOFAndBloomEffect HitDOFEffect;
    var() bool bValid;

    structdefaultproperties
    {
        materialName=none
        scratchSound=none
        SocketName="None"
        xOffset=0
        yOffset=0
        Duration=0.0000000
        FadeTime=0.0000000
        DamageType=edvtSwipe
        facingDamageDir=eddtNone
        ScreenShake=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None")
        HitDOFEffectName="None"
        HitMaterialEffectName="None"
        HitEffectFadeTime=0.0000000
        HitEffectMaterialInstance=none
        HitMaterialEffect=none
        HitDOFEffect=none
        bValid=false
    }
};

struct native SPBullChargeVolumeProperties
{
    var float m_damage;
    var class<DamageType> m_damageType;
    var float m_zoneVelocity;
    var float m_targetVelocity;
    var float m_chargeOffset;
    var float m_radius;
    var float m_height;
    var bool m_showDebug;
    var SPBullChargeScreenScratch m_screenScratch;

    structdefaultproperties
    {
        m_damage=1.0000000
        m_damageType=Class'SPDamageTypeGriffon'
        m_zoneVelocity=1000.0000000
        m_targetVelocity=1000.0000000
        m_chargeOffset=300.0000000
        m_radius=250.0000000
        m_height=300.0000000
        m_showDebug=false
        m_screenScratch=(materialName=none,scratchSound=none,SocketName="None",xOffset=0,yOffset=0,Duration=0.0000000,FadeTime=0.0000000,DamageType=edvtSwipe,facingDamageDir=eddtNone,ScreenShake=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None"),HitDOFEffectName="None",HitMaterialEffectName="None",HitEffectFadeTime=0.0000000,HitEffectMaterialInstance=none,HitMaterialEffect=none,HitDOFEffect=none,bValid=false)
    }
};

var float m_chargeOffset;
var SPAIController m_myController;
var float m_damage;
var class<DamageType> m_damageType;
var float m_zoneVelocity;
var float m_targetVelocity;
var array<Actor> m_previoslyTouching;
var bool m_bEnabled;
var transient bool m_showDebug;
var transient SPBullChargeScreenScratch m_screenScratch;
var Vector spTargetVelocity;
var export editinline CylinderComponent m_cylinderComponent;
//var delegate<TouchActorCallback> __TouchActorCallback__Delegate;
//var delegate<CanTouchActorCallback> __CanTouchActorCallback__Delegate;

delegate TouchActorCallback(Actor Other, Vector Loc)
{
    //return;    
}

delegate bool CanTouchActorCallback(Actor Other)
{
    //return ReturnValue;    
}

// Export USPBullChargeVolume::execUpdateChargeVolume(FFrame&, void* const)
native final function UpdateChargeVolume(float DeltaTime);

// Export USPBullChargeVolume::execTouchActor(FFrame&, void* const)
native function TouchActor(Actor Touched, Vector HitLocation);

// Export USPBullChargeVolume::execSetup(FFrame&, void* const)
native function Setup(out SPBullChargeVolumeProperties Params, Pawn Pawn);

// Export USPBullChargeVolume::execDestroySelf(FFrame&, void* const)
native function DestroySelf();

event OnTouchActor(Actor Other, Vector Loc)
{
    TouchActorCallback(Other, Loc);
    //return;    
}

function bool DefaultCanTouchActorCallback(Actor Other)
{
    return true;
    //return ReturnValue;    
}

event bool CanTouchActor(Actor Other)
{
    return CanTouchActorCallback(Other);
    //return ReturnValue;    
}

static function SPBullChargeVolume CreateVolume(out SPBullChargeVolumeProperties Params, Pawn Pawn)
{
    local SPBullChargeVolume Volume;

    Volume = Pawn.Spawn(Class'SPBullChargeVolume', Pawn,, Pawn.Location, Pawn.Rotation,, true);
    Volume.Setup(Params, Pawn);
    return Volume;
    //return ReturnValue;    
}

function Enabled(bool bEnable)
{
    m_bEnabled = bEnable;
    //return;    
}

event Tick(float DeltaTime)
{
    UpdateChargeVolume(DeltaTime);
    //return;    
}

event LoadPostProcessMaterialEffect(LocalPlayer Player)
{
    m_screenScratch.HitMaterialEffect = MaterialEffect(Player.PlayerPostProcess.FindPostProcessEffect(m_screenScratch.HitMaterialEffectName));
    // End:0xF2
    if(m_screenScratch.HitMaterialEffect != none)
    {
        m_screenScratch.HitEffectMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
        m_screenScratch.HitEffectMaterialInstance.SetParent(m_screenScratch.HitMaterialEffect.Material);
        m_screenScratch.HitMaterialEffect.Material = m_screenScratch.HitEffectMaterialInstance;
        m_screenScratch.HitMaterialEffect.bShowInGame = false;
    }
    //return;    
}

event LoadPostProcessDOFEffect(LocalPlayer Player)
{
    m_screenScratch.HitDOFEffect = DOFAndBloomEffect(Player.PlayerPostProcess.FindPostProcessEffect(m_screenScratch.HitDOFEffectName));
    // End:0x73
    if(m_screenScratch.HitDOFEffect != none)
    {
        m_screenScratch.HitDOFEffect.bShowInGame = false;
    }
    //return;    
}
