class PKDmgType_ElectroSaw extends PKDmgType_Base;

defaultproperties
{
    ShockPlayerDuration=0.5000000
    DamageWeaponClass=Class'PKWeap_Electrodriver_Base'
    DamageWeaponFireMode=3
    DeathString="`o shocked by `k's electro mine"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_ElectroSaw
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_ElectroSaw.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_ElectroSaw.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}