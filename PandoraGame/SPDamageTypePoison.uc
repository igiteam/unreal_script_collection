class SPDamageTypePoison extends PandoraDamageType;

defaultproperties
{
    shakeInfo=(TimeDuration=0.0000000,RotAmplitude=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotFrequency=(X=0.0000000,Y=0.0000000,Z=0.0000000),FOVAmplitude=1.0000000,FOVFrequency=0.0000000)
    DeathString="%k ha matado a %o ."
    FemaleSuicide="%o se ha suicidado."
    MaleSuicide="%o se ha suicidado."
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypePoison.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypePoison.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}