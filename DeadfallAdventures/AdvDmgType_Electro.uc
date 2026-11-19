class AdvDmgType_Electro extends EvilDmgType_Base;

defaultproperties
{
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Electro
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Electro.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Electro.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}