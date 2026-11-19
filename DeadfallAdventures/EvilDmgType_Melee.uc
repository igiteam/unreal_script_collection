class EvilDmgType_Melee extends EvilDmgType_Base;

defaultproperties
{
    bAlwaysGibs=true
    bThrowRagdoll=true
    DamageWeaponClass=Class'EvilWeap_Melee_Base'
    DamageCameraAnim[0]=CameraAnim'an_PlayerHit.Hit1'
    DamageCameraAnim[1]=CameraAnim'an_PlayerHit.Hit2'
    DamageCameraAnim[2]=CameraAnim'an_PlayerHit.Hit3'
    DamageCameraAnim[3]=CameraAnim'an_PlayerHit.Hit4'
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Melee
    KDamageImpulse=1000.0000000
    VehicleDamageScaling=0.9000000
    VehicleMomentumScaling=0.7000000
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Melee.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Melee.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}