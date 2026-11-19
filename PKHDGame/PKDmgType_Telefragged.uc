class PKDmgType_Telefragged extends PKDmgType_Base;

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
    //return;    
}

defaultproperties
{
    bAlwaysGibs=true
    DeathString="`k skillfully telefragged `o"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Rocket
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Telefragged.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Telefragged.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}