class PKDmgType_Electro extends PKDmgType_Base;

defaultproperties
{
    ShockPlayerDuration=0.5000000
    bCausesBlood=false
    bNeverGibs=true
    DamageWeaponClass=Class'PKWeap_Electrodriver_Base'
    DamageWeaponFireMode=1
    DeathString="`o roasted by `k's electro"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Electro
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Electro.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Electro.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}