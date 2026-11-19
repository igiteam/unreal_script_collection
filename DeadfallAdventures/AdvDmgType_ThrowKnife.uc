class AdvDmgType_ThrowKnife extends EvilDmgType_Base;

defaultproperties
{
    bCausesBlood=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_ThrowKnife_Base'
    DeathString="`k <img src='icon_knife_small'> `o"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_MeleeSharp
    KDamageImpulse=1000.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_ThrowKnife.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_ThrowKnife.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}