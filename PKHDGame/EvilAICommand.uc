class EvilAICommand extends GameAICommand within EvilAIController;

var bool bDelayedExit;
var EvilTypes.EBehaviorMode ForcedBehavior;
var float TimedOut;

function Pushed()
{
    local EvilAICommand ParentCommand;

    super.Pushed();
    // End:0x78
    if((int(ForcedBehavior) != int(0)) && int(Outer.CurrentBehaviorMode) != int(ForcedBehavior))
    {
        Outer.ChangeBehaviorMode(ForcedBehavior);
    }
    ParentCommand = GetParent();
    bDelayedExit = ((bDelayedExit) ? (ParentCommand != none) && !ParentCommand.DisableChildDelay() : bDelayedExit);
    // End:0x11F
    if(TimedOut > float(0))
    {
        Outer.SetTimer(TimedOut, false, 'TimedOut_T', self);
    }
    //return;    
}

function TimedOut_T()
{
    Status = 'Aborted';
    Outer.AbortCommand(self);
    //return;    
}

function AdjustEnemyRating(out float out_Rating, EvilPawn EnemyPawn)
{
    // End:0x63
    if((ChildCommand != none) && EvilAICommand(ChildCommand) != none)
    {
        EvilAICommand(ChildCommand).AdjustEnemyRating(out_Rating, EnemyPawn);
    }
    //return;    
}

function bool ShouldInterruptActiveCommand()
{
    // End:0x31
    if((GetParent()) != none)
    {
        return GetParent().ShouldInterruptActiveCommand();
    }
    return false;
    //return ReturnValue;    
}

function ReadyToFire(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    local bool bShouldThrow;

    bShouldThrow = ((OrigChannel.ChannelName == 'EnemyCloseToThrowLine') ? true : false);
    // End:0x7C
    if(Outer.IsLongDistanceChargeActive())
    {
        Outer.OnLongDistanceChargeAbort();
    }
    // End:0x110
    if(Outer.MyEvilPawn.CanAim() && !Outer.IsAiming())
    {
        Outer.MyEvilPawn.StartAim();        
    }
    else
    {
        // End:0x166
        if(bShouldThrow)
        {
            Outer.ReactionManager.NudgeChannel(EventInstigator, 'ForceThrow');            
        }
        else
        {
            Outer.ReactionManager.NudgeChannel(EventInstigator, 'ForceFire');
        }
    }
    //return;    
}

function bool ShouldReturnToIdle()
{
    return true;
    //return ReturnValue;    
}

function AgrressionLevelChanged(EvilTypes.EAggressionLevel InNewLevel, EvilTypes.EAggressionLevel InOldLevel)
{
    // End:0x63
    if((ChildCommand != none) && EvilAICommand(ChildCommand) != none)
    {
        EvilAICommand(ChildCommand).AgrressionLevelChanged(InNewLevel, InOldLevel);
    }
    //return;    
}

function ReachedPreciseDestination()
{
    // End:0x51
    if((ChildCommand != none) && EvilAICommand(ChildCommand) != none)
    {
        EvilAICommand(ChildCommand).ReachedPreciseDestination();
    }
    //return;    
}

function bool AllowPushOfDefaultCommandForPawnAction(byte PA)
{
    return true;
    //return ReturnValue;    
}

event string GetDumpString()
{
    return ((ChildCommand != none) ? ChildCommand.GetDumpString() : super.GetDumpString());
    //return ReturnValue;    
}

function EvilAICommand GetParent()
{
    local EvilAICommand Command;

    // End:0x64
    foreach Outer.AllCommands(Class'EvilAICommand', Command)
    {
        // End:0x63
        if(Command.ChildCommand == self)
        {            
            return Command;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function bool DisableChildDelay()
{
    return false;
    //return ReturnValue;    
}

function SetDelayedExit(optional bool bInDelayedExit = true)
{
    bDelayedExit = bInDelayedExit;
    //return;    
}

function ExitWithFailure()
{
    // End:0x24
    if(bDelayedExit)
    {
        PushState('DelayFailure');        
    }
    else
    {
        Status = 'Failure';
        Outer.PopCommand(self);
    }
    //return;    
}

function ExitWithSuccess()
{
    // End:0x24
    if(bDelayedExit)
    {
        PushState('DelaySuccess');        
    }
    else
    {
        Status = 'Success';
        Outer.PopCommand(self);
    }
    //return;    
}

state DelayFailure
{Begin:

    Outer.Sleep(0.2000000);
    Status = 'Failure';
    Outer.PopCommand(self);
    stop;                
}

state DelaySuccess
{Begin:

    Outer.Sleep(0.1000000);
    Status = 'Success';
    Outer.PopCommand(self);
    stop;                
}

state RotateToEnemy
{Begin:

    // End:0x2F
    if(!Outer.HasValidEnemy())
    {
        PopState();
    }
    Outer.StopLatentExecution();
    Outer.Pawn.ZeroMovementVariables();
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.FinishRotation();
    PopState();
    stop;                
}

defaultproperties
{
    bDelayedExit=true
    TimedOut=-1.0000000
}