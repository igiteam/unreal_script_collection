class PKDmgType_InstantGib extends EvilDmgType_InstantGib;

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
    //return;    
}

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_InstantGib.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilDmgType_InstantGib.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_InstantGib.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilDmgType_InstantGib.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}