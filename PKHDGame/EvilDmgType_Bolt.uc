class EvilDmgType_Bolt extends EvilDmgType_Base;

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
    //return;    
}

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Bolt.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Bolt.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}