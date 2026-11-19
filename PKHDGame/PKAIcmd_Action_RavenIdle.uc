class PKAIcmd_Action_RavenIdle extends PKAICmd_Base_UtilitySelectedCmd within PKAI_Raven;

var float LastAmbientTime;
var float AmbientsFreq;

function Pushed()
{
    super.Pushed();
    GotoState('FlyUp');
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.ClearAllTimers(self);
    //return;    
}

function ChangingRotationDelay()
{
    //return;    
}

function GotoIdleWalking()
{
    GotoState('IdleWalking');
    //return;    
}

function TryStopAfterWalking(optional bool bForced)
{
    // End:0x6E
    if(Outer.GetAltitude() > RandRange(Outer.FlyHeightDown, Outer.FlyHeightUp))
    {        
    }
    else
    {
        Outer.MyPKPawn.bIsWalking = false;
        Outer.MyPKPawn.ChangeMoveMode(2);
    }
    //return;    
}

state FlyUp
{Begin:

    Outer.LastLandingTime = Outer.WorldInfo.TimeSeconds;
    Outer.MyEvilPawn.PlaySoundFromArchetypeByChance(4);
    Outer.MyPKPawn.SetPhysics(4);
    Outer.MoveTo(((Outer.PossessLocation + ((vect(0.0000000, 0.0000000, 1.0000000) * Outer.FlyHeightDown) * RandRange(0.9000000, 1.0000000))) + ((float(((FRand() < 0.5000000) ? 1 : -1)) * vect(0.0000000, 1.0000000, 0.0000000)) * RandRange(100.0000000, 200.0000000))) + ((float(((FRand() < 0.5000000) ? 1 : -1)) * vect(1.0000000, 0.0000000, 0.0000000)) * RandRange(100.0000000, 200.0000000)),, Outer.Pawn.GetCollisionRadius() * float(4));
    GotoState('IdleWalking');
    stop;                
}

state IdleWalking
{Begin:

    // End:0xBA
    if(int(Outer.MyPKPawn.Physics) != int(4))
    {
        Outer.StopLatentExecution();
        Outer.MyPKPawn.ChangeMoveMode(0);
        Outer.WaitForLanding();
        goto 'DelayedBegin';        
    }
    else
    {
        // End:0x1A0
        if(Outer.HasWalkArea())
        {
            Outer.MoveTo(((Outer.bWalkAreaRandom) ? Outer.GetRandomLocationInWalkArea() : Outer.GetNextLocationInWalkArea()),, Outer.Pawn.GetCollisionRadius() * float(4));
            TryStopAfterWalking();            
        }
        else
        {
            // End:0x2C6
            if(VSizeSq(Outer.MyEvilPawn.Location - Outer.PossessLocation) > (Outer.GuardRange ** float(2)))
            {
                Outer.MoveTo(Outer.GetRandomLocation(Outer.GuardRange * 0.5000000),, Outer.Pawn.GetCollisionRadius() * float(4));
                TryStopAfterWalking(true);                
            }
            else
            {
                Outer.MoveTo(Outer.GetRandomLocation(Outer.GuardRange * 0.8000000),, Outer.Pawn.GetCollisionRadius() * float(4));
                TryStopAfterWalking();
            }
        }
    }
    goto 'Begin';
DelayedBegin:


    Outer.Sleep(2.0000000);
    GotoState('FlyUp');
    goto 'Begin';
    stop;        
}

defaultproperties
{
    LastAmbientTime=-100.0000000
    AmbientsFreq=0.2500000
    InitPriority=0.0100000
}