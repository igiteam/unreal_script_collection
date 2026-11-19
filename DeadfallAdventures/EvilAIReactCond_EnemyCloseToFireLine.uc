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
    local bool bResult;

    // End:0x32E
    if((((((super.ShouldActivate(InInstigator, OriginatingChannel) && Outer.Enemy != none) && Outer.Enemy == InInstigator) && !Outer.MyEvilPawn.bPlayingTurnTransition) && Outer.HasValidEnemy()) && VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) <= (Outer.EnemyDistance_Shoot ** float(2))) && Outer.ClearFireLineToActor(((Outer.Enemy.DrivenVehicle == none) ? Outer.Enemy : Outer.Enemy.DrivenVehicle),,, Obstacle,, true, true, true, Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone)))
    {
        // End:0x32B
        if((Outer.WorldInfo.TimeSeconds - StartIntervalActivationTime) > IntervalToActivate)
        {
            bResult = true;
            StartIntervalActivationTime = Outer.WorldInfo.TimeSeconds;
        }        
    }
    else
    {
        switch(Outer.MyEvilPawn.RequestedAimZone)
        {
            // End:0x3A9
            case 1:
                Outer.MyEvilPawn.RequestedAimZone = 2;
                // End:0x3EA
                break;
            // End:0x3E7
            case 2:
                Outer.MyEvilPawn.RequestedAimZone = 1;
                // End:0x3EA
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    AimEpsilon=0.5000000
    AutoSubscribedChannels[0]="Sight"
    AutoSubscribedChannels[1]="SightPlayer"
}