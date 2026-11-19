class EvilDmgType_InstantGib extends EvilDmgType_Base;

defaultproperties
{
    bAlwaysGibs=true
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Rocket
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_InstantGib.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_InstantGib.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}