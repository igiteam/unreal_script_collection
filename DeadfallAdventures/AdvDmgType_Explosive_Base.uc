class AdvDmgType_Explosive_Base extends EvilDmgType_Base
    abstract;

defaultproperties
{
    DeathString="`k <img src='icon_explosion_small'> `o"
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Explosive_Base.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_Explosive_Base.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}