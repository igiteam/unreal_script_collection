class EvilDmgType_Fell extends EvilDmgType_Base;

defaultproperties
{
    bLocationalHit=false
    bCausedByWorld=true
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Fell.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Fell.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}