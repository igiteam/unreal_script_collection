class PKDmgType_LabCommandoGun extends PKDmgType_Base;

defaultproperties
{
    bCanDoPartialGibs=true
    DamageWeaponClass=Class'PKWeap_LabCommandoGun_Base'
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_SMG
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_LabCommandoGun.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_LabCommandoGun.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}