class PKDmgType_Freezer extends PKDmgType_Base;

defaultproperties
{
    ShockPlayerDuration=1.5000000
    ShockPlayerSpeedReductionScale=0.5000000
    DamageWeaponClass=Class'PKWeap_Shotgun_Base'
    DamageWeaponFireMode=1
    DeathString="`o cooled down by `k's freezer"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Freezer
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Freezer.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Freezer.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}