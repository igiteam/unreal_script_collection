class AdvDmgType_Machete extends EvilDmgType_Melee;

defaultproperties
{
    bCausesBlood=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_Melee_Machete'
    DeathString="`k <img src='icon_knife_small'> `o"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_MeleeSharp
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Machete.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Machete.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}