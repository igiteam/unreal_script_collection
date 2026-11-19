class PKDmgType_Shotgun extends PKDmgType_Base;

defaultproperties
{
    ShockPlayerDuration=0.5000000
    bCanDoPartialGibs=true
    DamageWeaponClass=Class'PKWeap_Shotgun_Base'
    DeathString="`o ventilated with `k's shotgun"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Shotgun
    KDeathVel=800.0000000
    KDeathUpKick=200.0000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Shotgun.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Shotgun.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}