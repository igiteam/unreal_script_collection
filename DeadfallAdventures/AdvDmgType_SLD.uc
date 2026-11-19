class AdvDmgType_SLD extends EvilDmgType_Base;

defaultproperties
{
    bCausesBlood=true
    bThrowRagdoll=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_SLD_Base'
    DeathString="`k <img src='icon_sld_small'> `o"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Pistol
    KDamageImpulse=300.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_SLD.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_SLD.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}