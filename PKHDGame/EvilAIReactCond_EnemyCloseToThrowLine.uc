class EvilAIReactCond_EnemyCloseToThrowLine extends EvilAIReactConditionConduit within EvilAIController;

var() float AimEpsilon;
var() float IntervalToActivate;
var transient float StartIntervalActivationTime;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local Actor Obstacle;

    // End:0x2DF
    if((((((super.ShouldActivate(InInstigator, OriginatingChannel) && Outer.Enemy != none) && !Outer.MyEvilPawn.bPlayingTurnTransition) && Outer.HasValidEnemy()) && VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge ** float(2))) && VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) < (Outer.EnemyDistance_Shoot ** float(2))) && Outer.ClearFireLineToEnemy(Obstacle, true))
    {
        // End:0x2DF
        if((Outer.WorldInfo.TimeSeconds - StartIntervalActivationTime) > IntervalToActivate)
        {
            // End:0x2A2
            if((Outer.WorldInfo.TimeSeconds - StartIntervalActivationTime) < (IntervalToActivate + 1.0000000))
            {
                return true;                
            }
            else
            {
                StartIntervalActivationTime = Outer.WorldInfo.TimeSeconds;
            }
        }
    }
    return false;
    //return ReturnValue;    
}
