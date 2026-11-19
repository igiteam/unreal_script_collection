class PKDmgType_Base extends EvilDmgType_Base;

var float ShockPlayerDuration;
var float ShockPlayerSpeedReductionScale;

defaultproperties
{
    ShockPlayerSpeedReductionScale=1.0000000
    bThrowRagdoll=true
    bLeaveBodyEffect=true
    DamageWeaponClass=Class'PKWeap_Stakegun_Base'
    DeathString="`o killed by `k"
    SuicideString1="`o fought gravity and lost"
    SuicideString2="`o has left the building"
    SuicideString3="`o forgot which way the barrel goes"
    SuicideString4="`o has proven that life is short"
    KDamageImpulse=100.0000000
    KDeathVel=300.0000000
    KDeathUpKick=20.0000000
    VehicleDamageScaling=0.8000000
    VehicleMomentumScaling=0.1000000
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}