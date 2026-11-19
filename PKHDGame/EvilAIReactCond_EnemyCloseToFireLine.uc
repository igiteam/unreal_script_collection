class EvilAIReactCond_EnemyCloseToFireLine extends EvilAIReactConditionConduit within EvilAIController;

var() float AimEpsilon;
var() float IntervalToActivate;
var transient float StartIntervalActivationTime;

function Initialize()
{
    super(EvilAIReactCondition).Initialize();
    MinTimeBetweenActivations = FMin(0.5000000, Outer.MinTimeBetweenFireBurst);
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local Actor Obstacle;

    // End:0x1B5
    if((((super.ShouldActivate(InInstigator, OriginatingChannel) && Outer.Enemy != none) && !Outer.MyEvilPawn.bPlayingTurnTransition) && Outer.HasValidEnemy()) && Outer.ClearFireLineToEnemy(Obstacle, true, true))
    {
        // End:0x1B5
        if((Outer.WorldInfo.TimeSeconds - StartIntervalActivationTime) > IntervalToActivate)
        {
            // End:0x178
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

defaultproperties
{
    AimEpsilon=0.5000000
    AutoSubscribedChannels[0]="Sight"
}