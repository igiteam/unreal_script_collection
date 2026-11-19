class AdvDmgType_M37Trenchgun extends EvilDmgType_Base;

defaultproperties
{
    bCausesBlood=true
    bThrowRagdoll=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_M37Trenchgun_Base'
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Shotgun
    KDamageImpulse=300.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_M37Trenchgun.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_M37Trenchgun.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}