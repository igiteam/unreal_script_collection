class PKDmgType_SoulSaw extends PKDmgType_Base;

defaultproperties
{
    bCanDoPartialGibs=true
    DamageWeaponClass=Class'PKWeap_SoulReaper_Base'
    DeathString="`o divided by `k's Soulcatcher"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_SoulSaw
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulSaw.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulSaw.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}