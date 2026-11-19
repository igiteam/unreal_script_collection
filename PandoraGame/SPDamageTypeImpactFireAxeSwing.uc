class SPDamageTypeImpactFireAxeSwing extends SPDamageTypeMeleeAny;

defaultproperties
{
    shakeInfo=(TimeDuration=0.2500000,RotAmplitude=(X=200.0000000,Y=200.0000000,Z=200.0000000),RotFrequency=(X=5.0000000,Y=5.0000000,Z=12.0000000),LocAmplitude=(X=5.0000000,Y=5.0000000,Z=5.0000000),LocFrequency=(X=25.0000000,Y=25.0000000,Z=25.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom))
    bRagdollDeath=true
    DeathString="%k ha matado a %o ."
    FemaleSuicide="%o se ha suicidado."
    MaleSuicide="%o se ha suicidado."
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeImpactFireAxeSwing.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeImpactFireAxeSwing.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}