class PKDmgType_SoulReaperMelee extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_SoulReaper_Base'
    DamageWeaponFireMode=4
    DeathString="`o dismissed by `k's Soulcatcher"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_SoulReaperMelee
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulReaperMelee.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_SoulReaperMelee.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}