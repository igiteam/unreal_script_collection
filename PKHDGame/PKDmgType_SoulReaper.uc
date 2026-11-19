class PKDmgType_SoulReaper extends PKDmgType_Base;

defaultproperties
{
    bCausesBlood=false
    DamageWeaponClass=Class'PKWeap_SoulReaper_Base'
    DamageWeaponFireMode=1
    DeathString="`o sucked by `k's Soulcatcher"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_SoulReaper
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulReaper.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulReaper.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}