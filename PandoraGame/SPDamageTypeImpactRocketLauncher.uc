class SPDamageTypeImpactRocketLauncher extends SPDamageTypeImpactAny;

defaultproperties
{
    DeathString="%k ha matado a %o ."
    FemaleSuicide="%o se ha suicidado."
    MaleSuicide="%o se ha suicidado."
    RadialDamageImpulse=5500.0000000
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeImpactRocketLauncher.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeImpactRocketLauncher.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}