class PKDmgType_Bolt extends PKDmgType_Base;

defaultproperties
{
    ShockPlayerDuration=0.5000000
    DamageWeaponClass=Class'PKWeap_Boltgun_Base'
    DeathString="`o bolt-skewered by `k"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Bolt
    KDeathVel=1500.0000000
    KDeathUpKick=500.0000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Bolt.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Bolt.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}