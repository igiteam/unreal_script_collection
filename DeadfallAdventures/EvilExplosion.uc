class EvilExplosion extends Object
    editinlinenew;

var() float ExploDelay;
var() float DamageDelay;
var() float Damage;
var() float DamageRadius;
var() float PlayerDamageModifier;
var() bool bDoOwnerDamage;
var() bool bAllowTeammateCringes;
var transient bool bFullDamageToAttachee;
var() bool bAttachExplosionEmitterToAttachee;
var() bool bOrientCameraShakeTowardsEpicenter;
var() bool bAutoControllerVibration;
var() bool bUsePerMaterialFogVolume;
var() bool bSuppressAudio;
var() bool bPerformRadialBlurRelevanceCheck;
var() bool bExploEnableBloom;
var() bool bExploEnableBleachBypass;
var() bool bExploEnableChromatic;
var() bool bEnableBlueWarp;
var() bool bCausesFracture;
var() deprecated bool bAllowPerMaterialFX;
var() bool bDecalMaterialIsBeingOverriddenDontUsePhysMatVersion;
var() bool bParticleSystemIsBeingOverriddenDontUsePhysMatVersion;
var() bool bSoundCueIsBeingOverridenDontUsePhysMatVersion;
var() bool bUseMapSpecificValues;
var() bool bUseOverlapCheck;
var() bool bAlwaysDoFullDamage;
var() float DamageFalloffExponent;
var transient Actor ActorToIgnoreForDamage;
var transient class<Actor> ActorClassToIgnoreForDamage;
var transient class<Actor> ActorClassToIgnoreForKnockdownsAndCringes;
var() class<EvilDmgType_Base> MyDamageType;
var() float KnockDownRadius;
var() float KnockDownStrength;
var() float KnockDownAngularFactor;
var() float ExplosionOriginShiftDown;
var() float CringeRadius;
var() float MomentumTransferScale;
var() editinline CameraShake CamShake;
var() editinline CameraShake CamShake_Left;
var() editinline CameraShake CamShake_Right;
var() editinline CameraShake CamShake_Rear;
var() float CamShakeInnerRadius;
var() float CamShakeOuterRadius;
var() float CamShakeFalloff;
var() ParticleSystem ParticleEmitterTemplate;
var() float ExplosionEmitterScale;
var() class<EmitterCameraLensEffectBase> CameraLensEffect;
var() float CameraLensEffectRadius;
var FogVolumeSphericalDensityInfo FogVolumeArchetype;
var() DecalData DecalData;
var name DecalDissolveParamName;
var Actor HitActor;
var Vector HitLocation;
var Vector HitNormal;
var() float DecalTraceDistance;
var() SoundCue ExplosionSound;
var() float ExplosionStunFXStrengthMoodifier;
var() float ExplosionStunFXRadius;
var() export editinline PointLightComponent ExploLight;
var() float ExploLightFadeOutTime;
var() export editinline RadialBlurComponent ExploRadialBlur;
var() float ExploRadialBlurFadeOutTime;
var() float ExploRadialBlurMaxBlur;
var() float ExploBloomScale;
var() float ExploBloomThreshold;
var() Color ExploBloomTint;
var() float ExploBloomFadeOutTime;
var() float ExploBloomRadius;
var() float ExploBleachBypassMaxOpacity;
var() float ExploMaxChromaticScale;
var() float BlueWarpDuration;
var() float BlueWarpDistortScale;
var() LinearColor BlueWarpColor;
var() float BlueWarpRadius;
var() float FractureMeshRadius;
var() float FracturePartVel;
var() Actor Attachee;
var() Controller AttacheeController;

defaultproperties
{
    PlayerDamageModifier=1.0000000
    bDoOwnerDamage=true
    bExploEnableBloom=true
    bExploEnableBleachBypass=true
    bCausesFracture=true
    bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=true
    bSoundCueIsBeingOverridenDontUsePhysMatVersion=true
    MyDamageType=Class'EvilDmgType_Base'
    KnockDownStrength=100.0000000
    MomentumTransferScale=1.0000000
    ExplosionEmitterScale=1.0000000
    CameraLensEffectRadius=100.0000000
    DecalData=(bIsValid=false,DecalMaterial=none,ClipDecalsUsingFastPath=false,Width=6.0000000,Height=6.0000000,Thickness=10.0000000,bRandomizeRotation=true,RandomScalingRange=(X=1.0000000,Y=1.2000000),RandomRadiusOffset=0.0000000,LifeSpan=15.0000000,BlendRange=(X=70.0000000,Y=89.5000000))
    DecalDissolveParamName="DissolveAmount"
    DecalTraceDistance=48.0000000
    ExplosionStunFXStrengthMoodifier=0.7000000
    ExplosionStunFXRadius=1200.0000000
    ExploLightFadeOutTime=0.2000000
    ExploRadialBlurFadeOutTime=0.7000000
    ExploRadialBlurMaxBlur=0.7500000
    ExploBloomScale=20.0000000
    ExploBloomThreshold=-40.0000000
    ExploBloomTint=(R=255,G=235,B=85,A=0)
    ExploBloomFadeOutTime=1.0000000
    ExploBloomRadius=1000.0000000
    ExploBleachBypassMaxOpacity=1.0000000
    ExploMaxChromaticScale=2.5000000
    BlueWarpDuration=1.0000000
    BlueWarpDistortScale=0.5000000
    BlueWarpColor=(R=1.0000000,G=1.0000000,B=3.0000000,A=1.0000000)
    BlueWarpRadius=1800.0000000
}