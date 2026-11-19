class SPDamageTypeTentacleGrab extends SPDamageTypeMeleeAny;

defaultproperties
{
    shakeInfo=(TimeDuration=0.6500000,RotAmplitude=(X=600.0000000,Y=600.0000000,Z=600.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),LocAmplitude=(X=10.0000000,Y=10.0000000,Z=10.0000000),LocFrequency=(X=50.0000000,Y=50.0000000,Z=50.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom))
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeTentacleGrab.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeTentacleGrab.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}