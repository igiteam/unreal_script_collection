class PKDmgType_Grenade extends PKDmgType_Base;

defaultproperties
{
    DamageWeaponFireMode=1
    DeathString="`o hugged `k's grenade"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Grenade
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Grenade.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Grenade.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}