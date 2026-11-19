class EvilDmgType_MeleeBlunt extends EvilDmgType_Melee;

defaultproperties
{
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_MeleeBlunt
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_MeleeBlunt.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_MeleeBlunt.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}