class PKDmgType_StakeBurning extends PKDmgType_Stake;

defaultproperties
{
    DeathString="`o smashed by `k's Stakegun"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_BoltBurning
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_StakeBurning.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Stake.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_StakeBurning.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Stake.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}