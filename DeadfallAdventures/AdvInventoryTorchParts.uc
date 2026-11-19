class AdvInventoryTorchParts extends Object
    config(Weapon);

var ParticleSystem FLBeamTemplate;
var() config float FocusSpeed;
var() config Vector2D PowerBlinkRange;
var() config int PowerBlinkChance;
var() config float PowerDrainRate;
var() config float PowerRecoveryRate;
var() config float PowerRiseLevel;
var() config float FocusSizeMultiplier;
var() config float SpotlightConeSizeBias;
var() config Color LowBatteryLightColour;
var() config float LowBatteryLightBrightness;
var() config float FocusLightBrightness;
var() config Vector2D LightFadePowerRange_Discharge;
var() config Vector2D LightFadePowerRange_Recharge;
var() config float OuterConeScaleExponent;
var() config float OuterConeScaleBias;
var() config float ConeScaleExponent;
var() config float InnerConeFocusScale;

defaultproperties
{
    FLBeamTemplate=ParticleSystem'wp_flashlight_01.Effects.P_WP_FlashLight_Beam'
    FocusSpeed=2.0000000
    PowerBlinkRange=(X=0.0200000,Y=0.2200000)
    PowerBlinkChance=10
    PowerDrainRate=0.3500000
    PowerRecoveryRate=0.5000000
    PowerRiseLevel=0.5000000
    FocusSizeMultiplier=0.8000000
    SpotlightConeSizeBias=0.3000000
    LowBatteryLightColour=(R=220,G=190,B=160,A=255)
    LowBatteryLightBrightness=0.3000000
    FocusLightBrightness=4.0000000
    LightFadePowerRange_Discharge=(X=0.0000000,Y=0.4200000)
    LightFadePowerRange_Recharge=(X=0.6000000,Y=1.0000000)
    OuterConeScaleExponent=3.9000000
    OuterConeScaleBias=0.4500000
    ConeScaleExponent=6.0000000
    InnerConeFocusScale=3.5000000
}