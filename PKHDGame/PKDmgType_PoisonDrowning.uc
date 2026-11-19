class PKDmgType_PoisonDrowning extends PKDmgType_Base;

var() float TimeOut;
var() float interval;
var() float Damage;

defaultproperties
{
    TimeOut=1.5000000
    interval=0.5000000
    Damage=5.0000000
    bCausesBlood=false
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PoisonDrowning.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PoisonDrowning.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}