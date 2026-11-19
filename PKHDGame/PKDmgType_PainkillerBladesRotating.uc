class PKDmgType_PainkillerBladesRotating extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_Painkiller_Base'
    DamageWeaponFireMode=2
    DeathString="`o swirled by `k's painkiller"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Painkiller
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PainkillerBladesRotating.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PainkillerBladesRotating.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}