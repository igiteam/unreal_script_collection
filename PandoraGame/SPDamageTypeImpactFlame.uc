class SPDamageTypeImpactFlame extends SPDamageTypeImpactAny;

defaultproperties
{
    shakeInfo=(TimeDuration=0.1000000,RotAmplitude=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000))
    DeathString="%k ha matado a %o ."
    FemaleSuicide="%o se ha suicidado."
    MaleSuicide="%o se ha suicidado."
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeImpactFlame.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeImpactFlame.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
    PreventDamageToClassType=/* Array type was not detected. */
}