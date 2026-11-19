class PKDmgType_ClownSpell extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_ClownSpell_Base'
    DamageWeaponFireMode=1
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_ClownSpell
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_ClownSpell.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_ClownSpell.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}