class AdvDmgType_MeleeKick extends EvilDmgType_Base;

defaultproperties
{
    bThrowRagdoll=true
    DamageWeaponClass=Class'AdvWeap_MeleeKick'
    DamageCameraAnim=/* Array type was not detected. */
    DeathString="`k <img src='icon_avs36_sniper_small'> `o"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_MeleeBlunt
    KDamageImpulse=1400.0000000
    VehicleDamageScaling=0.9000000
    VehicleMomentumScaling=0.7000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_MeleeKick.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_MeleeKick.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}