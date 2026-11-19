class PKDmgType_NunSpell extends PKDmgType_Base;

defaultproperties
{
    bCausesBlood=false
    bLeaveBodyEffect=false
    DamageWeaponClass=Class'PKWeap_NunSpell_Base'
    DamageWeaponFireMode=1
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_NunSpell
    VehicleDamageScaling=0.0000000
    VehicleMomentumScaling=0.0000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_NunSpell.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_NunSpell.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}