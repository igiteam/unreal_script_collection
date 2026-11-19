class EvilDmgType_Bullet extends EvilDmgType_Base;

defaultproperties
{
    bLeaveBodyEffect=true
    KDamageImpulse=5000.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Bullet.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Bullet.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}