class AdvDmgType_TrapFell extends AdvDmgType_Trap_Base;

defaultproperties
{
    bLocationalHit=false
    bCausedByWorld=true
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_TrapFell.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_TrapFell.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}