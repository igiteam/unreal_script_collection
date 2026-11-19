class PKDmgType_SoulSawCombo extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_SoulReaper_Base'
    DamageWeaponFireMode=2
    DeathString="`o doomed by `k's Soulcatcher"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_SoulSawCombo
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulSawCombo.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulSawCombo.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}