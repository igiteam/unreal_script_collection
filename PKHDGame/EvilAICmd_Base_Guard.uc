class EvilAICmd_Base_Guard extends EvilAICmd_Base_Combat within EvilAIController;

var Vector PatrolLocation;

function Pushed()
{
    super.Pushed();
    Outer.ReactionManager.SuppressChannel('TriggerStrafe');
    Outer.PossessLocation = Outer.Pawn.Location;
    Outer.Focus = none;
    GotoState('Guard');
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.EnemyDistance_Shoot = Outer.default.EnemyDistance_Shoot;
    Outer.ReactionManager.UnSuppressChannel('TriggerStrafe');
    //return;    
}

function bool ShouldReturnToIdle()
{
    return false;
    //return ReturnValue;    
}

state Guard
{Begin:

    // End:0x14C
    if((Outer.GuardRadius > Outer.Pawn.GetCollisionRadius()) && VSizeSq(Outer.PossessLocation - Outer.Pawn.Location) > (Outer.GuardRadius ** float(2)))
    {
        Outer.SetMovePoint(Outer.PossessLocation, Outer.Pawn.GetCollisionRadius(), true);        
    }
    else
    {
        PatrolLocation = Outer.GetRandomLocation(Outer.GuardRadius);
        // End:0x24C
        if((FRand() < 0.1000000) && !IsZero(PatrolLocation - Outer.Pawn.Location))
        {
            Outer.SetMovePoint(PatrolLocation, Outer.Pawn.GetCollisionRadius() * float(2), true);
        }
    }
    // End:0x2DB
    if(Outer.Enemy != none)
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        Outer.FinishRotation();
    }
    Outer.Sleep(RandRange(1.0000000, 2.0000000));
    goto 'Begin';
    stop;            
}
