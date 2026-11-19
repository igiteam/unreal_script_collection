class AdvDmgType_Fire extends EvilDmgType_Fire;

defaultproperties
{
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Fire
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Fire.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Fire.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}