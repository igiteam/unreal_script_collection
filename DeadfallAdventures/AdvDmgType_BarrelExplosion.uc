class AdvDmgType_BarrelExplosion extends EvilDmgType_BarrelExplosion;

defaultproperties
{
    DeathString="`k <img src='icon_explosion_small'> `o"
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_BarrelExplosion.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_BarrelExplosion.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}