class PKDmgType_CrossbowBolt extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_Crossbow_Base'
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Bolt
    KDeathVel=1000.0000000
    KDeathUpKick=10.0000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_CrossbowBolt.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_CrossbowBolt.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}