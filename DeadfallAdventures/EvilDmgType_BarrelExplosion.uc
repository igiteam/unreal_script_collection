class EvilDmgType_BarrelExplosion extends EvilDmgType_Fire
    abstract;

defaultproperties
{
    bThrowRagdoll=true
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Grenade
    KDeathVel=500.0000000
    KDeathUpKick=20.0000000
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_BarrelExplosion.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_BarrelExplosion.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}