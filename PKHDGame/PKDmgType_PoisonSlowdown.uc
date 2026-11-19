class PKDmgType_PoisonSlowdown extends PKDmgType_Base;

var float PoisonSlowdownModifier;
var float SlowdownTimeInterval;

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
    super(EvilDmgType_Base).HandleDamagedPawn(DamagedPawn, Instigator, DamageAmt, Momentum);
    // End:0x80
    if(PKPawn(DamagedPawn) != none)
    {
        PKPawn(DamagedPawn).DoPoisonSlowdown(default.PoisonSlowdownModifier, default.SlowdownTimeInterval);
    }
    //return;    
}

defaultproperties
{
    PoisonSlowdownModifier=0.2000000
    SlowdownTimeInterval=1.0000000
    bCausesBlood=false
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PoisonSlowdown.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_PoisonSlowdown.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}