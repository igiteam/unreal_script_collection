class EvilDmgType_BarrelExplosion extends EvilDmgType_Fire;

defaultproperties
{
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Grenade
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_BarrelExplosion.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Fire.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_BarrelExplosion.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Fire.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}