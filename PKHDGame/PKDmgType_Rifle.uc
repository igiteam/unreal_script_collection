class PKDmgType_Rifle extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_Rifle_Base'
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_SMG
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Rifle.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Rifle.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}