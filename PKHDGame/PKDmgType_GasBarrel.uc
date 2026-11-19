class PKDmgType_GasBarrel extends PKDmgType_Base;

defaultproperties
{
    bNeverGibs=true
    DamageWeaponClass=Class'PKWeap_SMG_Base'
    DamageWeaponFireMode=2
    DeathString="`o dismembered by `k's burning barrel"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_GasBarrel
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_GasBarrel.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_GasBarrel.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}