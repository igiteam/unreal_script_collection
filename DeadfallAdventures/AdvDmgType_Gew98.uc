class AdvDmgType_Gew98 extends EvilDmgType_Base;

defaultproperties
{
    bCausesBlood=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_Gew98_Base'
    DeathString="`k <img src='icon_gew06p_small'> `o"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Rifle
    KDamageImpulse=700.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Gew98.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Gew98.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}