class PKDmgType_Stake extends PKDmgType_Base;

defaultproperties
{
    ShockPlayerDuration=0.5000000
    DeathString="`o impaled by `k's Stakegun"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Bolt
    KDeathVel=1000.0000000
    KDeathUpKick=1000.0000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Stake.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Stake.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}