class PKDmgType_Chaingun extends PKDmgType_Base;

defaultproperties
{
    bCanDoPartialGibs=true
    DamageWeaponClass=Class'PKWeap_Chaingun_Base'
    DamageWeaponFireMode=1
    DeathString="`o drilled by `k's chaingun"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Chaingun
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Chaingun.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Chaingun.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}