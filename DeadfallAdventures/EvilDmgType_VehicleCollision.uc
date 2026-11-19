class EvilDmgType_VehicleCollision extends EvilDmgType_Base
    abstract;

defaultproperties
{
    DamageOverlayTime=0.0000000
    bLocationalHit=false
    bArmorStops=false
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_VehicleCollision.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_VehicleCollision.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}