class PandoraDamageType extends DamageType
    abstract
    native;

/**  
 *Damage type sample class to show how forcefeedback can be hooked in
 * //Info about how to shake the screen when it hits the player
 */
var(ScreenShake) ScreenShakeStruct shakeInfo;
var() float PercentageChanceOfBleeding;
var() int MinBloodTicksSpawned;
var() int MaxBloodTicksSpawned;
var bool bRagdollDeath;
var bool bMachineGunBullet;

defaultproperties
{
    shakeInfo=(TimeToGo=0.0000000,TimeDuration=0.2750000,RotAmplitude=(X=200.0000000,Y=200.0000000,Z=0.0000000),RotFrequency=(X=50.0000000,Y=50.0000000,Z=0.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocFrequency=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetZero,Y=ESP_OffsetZero,Z=ESP_OffsetZero,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None")
    bCausesFracture=true
    KDamageImpulse=0.0000000
    // Reference: ForceFeedbackWaveform'Default__PandoraDamageType.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0 class=Class'Engine.ForceFeedbackWaveform'
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PandoraDamageType.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1 class=Class'Engine.ForceFeedbackWaveform'
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}