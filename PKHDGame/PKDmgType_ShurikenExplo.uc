class PKDmgType_ShurikenExplo extends PKDmgType_Shuriken;

defaultproperties
{
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_ShurikenExplo
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_ShurikenExplo.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Shuriken.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_ShurikenExplo.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Shuriken.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}