class PKAIcmd_Action_Idle extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

var float LastAmbientTime;
var float AmbientsFreq;

function Pushed()
{
    super.Pushed();
    // End:0x3D
    if(Outer.bGuardStill)
    {
        GotoState('GuardStill');        
    }
    else
    {
        GotoState('IdleWalking');
    }
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
    // End:0x43
    if(bForced || FRand() <= Outer.StopAfterWalkingChance)
    {
        GotoState('GuardStill');
    }
    //return;    
}

state GuardStill
{
    function BeginState(name PreviousStateName)
    {
        local float TimeChangeStillToFalse;

        super(Object).BeginState(PreviousStateName);
        TimeChangeStillToFalse = RandRange(Outer.StopAfterWalkingTimeMin, Outer.StopAfterWalkingTimeMax);
        // End:0xBB
        if((TimeChangeStillToFalse > 0.0000000) && PreviousStateName == 'IdleWalking')
        {
            Outer.SetTimer(TimeChangeStillToFalse, false, 'GotoIdleWalking', self);
        }
        // End:0x118
        if(Outer.GetRemainingTimeForTimer('ChangingRotationDelay', self) > 0.0000000)
        {
            Outer.PauseTimer(false, 'ChangingRotationDelay', self);
        }
        //return;        
    }

    function EndState(name NewStateName)
    {
        // End:0x56
        if(Outer.IsTimerActive('ChangingRotationDelay', self))
        {
            Outer.PauseTimer(true, 'ChangingRotationDelay', self);
        }
        Outer.ClearTimer('GotoIdleWalking', self);
        //return;        
    }
Begin:

    // End:0xBF
    if(Outer.bAlwaysSee)
    {
        // End:0xBC
        if(FRand() < 0.2000000)
        {
            Outer.SetDesiredRotation(Rotator(Normal(Outer.Enemy.Location - Outer.MyEvilPawn.Location)));
        }        
    }
    else
    {
        // End:0x16A
        if((LastAmbientTime + 1.0000000) < Outer.WorldInfo.TimeSeconds)
        {
            LastAmbientTime = Outer.WorldInfo.TimeSeconds;
            // End:0x16A
            if(FRand() < AmbientsFreq)
            {
                GotoState('IdleWalking', 'DelayedBegin');
            }
        }
        // End:0x238
        if(Outer.bRotate180AfterEndWalking)
        {
            Outer.bRotate180AfterEndWalking = false;
            Outer.SetDesiredRotation(Normalize(Outer.MyEvilPawn.Rotation + MakeRotator(0, int(RandRange(150.0000000, 210.0000000) * 182.0444000), 0)));
        }
        // End:0x4FB
        if(!Outer.IsTimerActive('ChangingRotationDelay', self))
        {
            // End:0x316
            if(Outer.bUseGuardAngleRandom)
            {
                Outer.SetDesiredRotation(Normalize(Outer.MyEvilPawn.Rotation + MakeRotator(0, int(RandRange(-60.0000000, 60.0000000) * 182.0444000), 0)));                
            }
            else
            {
                // End:0x3D7
                if(Outer.GuardAngleMax > 0.0000000)
                {
                    Outer.SetDesiredRotation(Outer.PossessRotation + MakeRotator(0, int(RandRange(-Outer.GuardAngleMax, Outer.GuardAngleMax)), 0));
                }
            }
            // End:0x4AC
            if((Outer.GuardChangeRotationDelayMin > float(0)) && Outer.GuardChangeRotationDelayMax > Outer.GuardChangeRotationDelayMin)
            {
                Outer.SetTimer(RandRange(Outer.GuardChangeRotationDelayMin, Outer.GuardChangeRotationDelayMax), false, 'ChangingRotationDelay', self);                
            }
            else
            {
                Outer.SetTimer(RandRange(0.0000000, 1.0000000), false, 'ChangingRotationDelay', self);
            }
            Outer.FinishRotation();
        }
    }
    Outer.Sleep(0.0500000);
    goto 'Begin';
    stop;        
}

state IdleWalking
{Begin:

    // End:0xEC
    if(Outer.HasWalkArea())
    {
        Outer.SetMovePoint(((Outer.bWalkAreaRandom) ? Outer.GetRandomLocationInWalkArea() : Outer.GetNextLocationInWalkArea()), Outer.Pawn.GetCollisionRadius() * float(2));
        TryStopAfterWalking();        
    }
    else
    {
        // End:0x212
        if(VSizeSq(Outer.MyEvilPawn.Location - Outer.PossessLocation) > (Outer.GuardRange ** float(2)))
        {
            Outer.SetMovePoint(Outer.GetRandomLocation(Outer.GuardRange * 0.5000000), Outer.Pawn.GetCollisionRadius());
            TryStopAfterWalking(true);            
        }
        else
        {
            Outer.SetMovePoint(Outer.GetRandomLocation(Outer.GuardRange * 2.0000000), Outer.Pawn.GetCollisionRadius());
            TryStopAfterWalking();
        }
    }
    Outer.Sleep(0.0500000);
    goto 'Begin';
DelayedBegin:


    Outer.Sleep(1.0000000);
    goto 'Begin';
    stop;            
}

defaultproperties
{
    LastAmbientTime=-100.0000000
    AmbientsFreq=0.2500000
    InitPriority=0.0100000
}