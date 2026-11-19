class AdvDmgType_Dynamite extends AdvDmgType_Explosive_Base;

defaultproperties
{
    bCausesBlood=true
    bThrowRagdoll=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'AdvWeap_Throw_Dynamite_Base'
    DeathString="`k <img src='icon_tnt_small'> `o"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_SmallBomb
    KDamageImpulse=500.0000000
    KDeathVel=500.0000000
    KDeathUpKick=20.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Dynamite.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Dynamite.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}