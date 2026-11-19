class PKDmgType_Rocket extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponClass=Class'PKWeap_Chaingun_Base'
    DeathString="`o swallowed `k's rocket"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Rocket
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Rocket.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Rocket.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}