class AdvDmgType_TrapLight extends AdvDmgType_Trap_Base;

defaultproperties
{
    bIsLightDmgType=true
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_TrapLight.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_TrapLight.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}