class SPAnimNotify_HudScratch extends AnimNotify
    native
    editinlinenew
    collapsecategories;

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
var DOFAndBloomEffect HitDOFEffect;
var() name HitMaterialEffectName;
var MaterialEffect HitMaterialEffect;
var transient MaterialInstanceConstant HitEffectMaterialInstance;
var() float HitEffectFadeTime;

event LoadPostProcessMaterialEffect(LocalPlayer Player)
{
    HitMaterialEffect = MaterialEffect(Player.PlayerPostProcess.FindPostProcessEffect(HitMaterialEffectName));
    // End:0x8F
    if(HitMaterialEffect != none)
    {
        HitEffectMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
        HitEffectMaterialInstance.SetParent(HitMaterialEffect.Material);
        HitMaterialEffect.Material = HitEffectMaterialInstance;
        HitMaterialEffect.bShowInGame = false;
    }
    //return;    
}

event LoadPostProcessDOFEffect(LocalPlayer Player)
{
    HitDOFEffect = DOFAndBloomEffect(Player.PlayerPostProcess.FindPostProcessEffect(HitDOFEffectName));
    // End:0x47
    if(HitDOFEffect != none)
    {
        HitDOFEffect.bShowInGame = false;
    }
    //return;    
}

defaultproperties
{
    xOffset=128
    yOffset=128
    Duration=1.0000000
    FadeTime=0.5000000
    ScreenShake=(TimeToGo=0.0000000,TimeDuration=0.0000000,RotAmplitude=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotFrequency=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocFrequency=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=0.0000000,FOVFrequency=0.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None")
    HitEffectFadeTime=1.0000000
}