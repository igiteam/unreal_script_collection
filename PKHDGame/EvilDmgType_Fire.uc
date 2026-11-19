class EvilDmgType_Fire extends EvilDmgType_Base;

var float TotalDamageTime;
var float DamageTimeInterval;
var float DamageAmount;

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
    // End:0x5F
    if(EvilPawn(DamagedPawn) != none)
    {
        EvilPawn(DamagedPawn).Burn(default.TotalDamageTime, default.DamageTimeInterval, default.DamageAmount);
    }
    //return;    
}

defaultproperties
{
    TotalDamageTime=10.0000000
    DamageTimeInterval=1.0000000
    DamageAmount=15.0000000
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Fire.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Fire.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}