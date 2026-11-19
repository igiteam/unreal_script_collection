class PKDmgType_Explosion extends PKDmgType_Base;

defaultproperties
{
    DeathString="`o exploded by `k"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_ElectroSaw
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Explosion.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Explosion.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}