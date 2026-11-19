class EvilDmgType_VehicleExplosion extends EvilDmgType_Base
    abstract;

defaultproperties
{
    bThrowRagdoll=true
    GibPerterbation=0.1500000
    KDamageImpulse=1000.0000000
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_VehicleExplosion.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_VehicleExplosion.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}