class PKDmgType_Demon extends PKDmgType_Base;

defaultproperties
{
    DeathString="`o shredded by `k's in demon fever"
    KDamageImpulse=500.0000000
    KDeathVel=2000.0000000
    KDeathUpKick=100.0000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Demon.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Demon.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}