class PKDmgType_Painkiller extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_Painkiller_Base'
    DeathString="`o shredded by `k's painkiller"
    ImpactTypeBallisticID=EImpactTypeBallistic.ITB_Painkiller
    KDeathUpKick=200.0000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Painkiller.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Painkiller.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}