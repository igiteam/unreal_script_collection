class AdvDmgType_MG34 extends EvilDmgType_Base;

defaultproperties
{
    bCausesBlood=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_MG34_Base'
    DeathString="`k <img src='icon_MG34_small'> `o"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_MG
    KDamageImpulse=500.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_MG34.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_MG34.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}