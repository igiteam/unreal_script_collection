class PKDmgType_PainkillerBeam extends PKDmgType_Base;

defaultproperties
{
    bNeverGibs=true
    DamageWeaponClass=Class'PKWeap_Painkiller_Base'
    DamageWeaponFireMode=1
    DeathString="`o surprised by `k's painkiller"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_PainkillerBeam
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PainkillerBeam.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PainkillerBeam.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}