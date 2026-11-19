class PKDmgType_Poison extends PKDmgType_Base;

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
    super(EvilDmgType_Base).HandleDamagedPawn(DamagedPawn, Instigator, DamageAmt, Momentum);
    // End:0x6F
    if(PKPawn(DamagedPawn) != none)
    {
        PKPawn(DamagedPawn).DoPoisonDamage(true);
    }
    //return;    
}

defaultproperties
{
    bCausesBlood=false
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Poison.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Poison.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}