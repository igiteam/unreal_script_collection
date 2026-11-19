class PKDmgType_BagBaby extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_Melee_BagBaby'
    DamageWeaponFireMode=1
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Grenade
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_BagBaby.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_BagBaby.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}