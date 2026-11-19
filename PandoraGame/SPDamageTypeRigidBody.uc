class SPDamageTypeRigidBody extends SPDamageTypeImpactAny;

defaultproperties
{
    DeathString="%k ha matado a %o ."
    FemaleSuicide="%o se ha suicidado."
    MaleSuicide="%o se ha suicidado."
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeRigidBody.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__SPDamageTypeRigidBody.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}