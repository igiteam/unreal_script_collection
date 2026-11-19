class AdvDmgType_Browning extends EvilDmgType_Base;

defaultproperties
{
    bCausesBlood=true
    bThrowRagdoll=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_Browning_Base'
    DeathString="`k <img src='icon_fn_auto_small-5'> `o"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Pistol
    KDamageImpulse=300.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Browning.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Browning.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}