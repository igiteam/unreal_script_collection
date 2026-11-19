class AdvDmgType_MummyHands extends EvilDmgType_Melee;

defaultproperties
{
    bCausesBlood=true
    bLeaveBodyEffect=true
    DeathString="`k <img src='icon_mummy_small'> `o"
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_MummyHands.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__AdvDmgType_MummyHands.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}