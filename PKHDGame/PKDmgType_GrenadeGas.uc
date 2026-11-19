class PKDmgType_GrenadeGas extends PKDmgType_Grenade;

defaultproperties
{
    DeathString="`o impaled with `k's stake grenade"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_GrenadeGas
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_GrenadeGas.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Grenade.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_GrenadeGas.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Grenade.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}