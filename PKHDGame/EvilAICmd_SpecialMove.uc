class EvilAICmd_SpecialMove extends EvilAICommand within EvilAIController;

var byte PawnAction;
var float TerminationTime;
var float TimeOutDelaySeconds;
var bool bShouldCheckSpecialMove;
var bool bForceMoveMode;

function Pushed()
{
    local EvilAICmd_MoveToGoal MTG;

    super.Pushed();
    LockdownAI();
    // End:0x16E
    if(bForceMoveMode)
    {
        MTG = Outer.FindCommandOfClass(Class'EvilAICmd_MoveToGoal');
        // End:0x16E
        if((Outer.MyEvilPawn != none) && MTG != none)
        {
            Outer.MyEvilPawn.bForceMoveMode = true;
            Outer.MyEvilPawn.MoveModeToEnforce = ((MTG.bForceWalk) ? 1 : 2);
            Outer.MyEvilPawn.bShouldWalkFast = MTG.bForceWalk;
        }
    }
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    UnlockAI();
    // End:0x69
    if(Outer.IsTimerActive('SpecialMoveTimeout'))
    {
        Outer.ClearTimer('SpecialMoveTimeout', self);
    }
    // End:0xAC
    if(bForceMoveMode)
    {
        Outer.MyEvilPawn.bForceMoveMode = false;
    }
    //return;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    LockdownAI();
    //return;    
}

function Paused(GameAICommand NewCommand)
{
    super(GameAICommand).Paused(NewCommand);
    UnlockAI();
    //return;    
}

function LockdownAI()
{
    Outer.bPreparingMove = true;
    Outer.Pawn.ZeroMovementVariables();
    //return;    
}

function UnlockAI()
{
    Outer.bPreparingMove = false;
    //return;    
}

function SpecialMoveTimeout()
{
    //return;    
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    // End:0x38
    if(ChildCommand != none)
    {
        return ChildCommand.AllowTransitionTo(AttemptCommand);
    }
    return IsSpecialMoveComplete();
    //return ReturnValue;    
}

function bool IsSpecialMoveComplete()
{
    return true;
    //return ReturnValue;    
}

function byte GetPawnAction()
{
    //return ReturnValue;    
}

function bool AllowPushOfDefaultCommandForPawnAction(byte PA)
{
    // End:0x1E
    if(int(PA) == int(GetPawnAction()))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

state Command_SpecialMove
{
    ignores ShouldFinishRotation, ShouldFinishPostRotation, GetInteractionPawn, GetPawnActionFlags, FinishedSpecialMove, GetPostSpecialMoveSleepTime;

    function bool SetupSpecialMove()
    {
        return true;
        //return ReturnValue;        
    }

    function byte GetPawnAction()
    {
        return 0;
        //return ReturnValue;        
    }

    function bool ExecuteSpecialMove()
    {
        PawnAction = GetPawnAction();
        // End:0xD9
        if((int(PawnAction) != 0) && !bShouldCheckSpecialMove || Outer.MyEvilPawn.CanDoPawnAction(PawnAction))
        {
            Outer.MyEvilPawn.DoPawnAction(PawnAction, true, GetInteractionPawn(), GetPawnActionFlags(PawnAction));
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }

    function bool IsReady()
    {
        return true;
        //return ReturnValue;        
    }

    function bool IsSpecialMoveComplete()
    {
        // End:0x89
        if((!Outer.bPreparingMove || Outer.Pawn == none) || int(Outer.MyEvilPawn.PawnAction) == 0)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function SpecialMoveTimeout()
    {
        Status = 'Failure';
        Outer.AbortCommand(self);
        //return;        
    }
Begin:

    // End:0x19
    if(!SetupSpecialMove())
    {
        goto 'Abort';
    }
    J0x19:

    // End:0x48 [Loop If]
    if(!IsReady())
    {
        Outer.Sleep(0.1000000);
        // [Loop Continue]
        goto J0x19;
    }
    // End:0x175
    if(ExecuteSpecialMove())
    {
        Outer.SetTimer(TimeOutDelaySeconds, false, 'SpecialMoveTimeout', self);
        J0x81:

        Outer.Sleep(0.1000000);
        // End:0x81
        if(!(IsSpecialMoveComplete()))
            goto J0x81;
        FinishedSpecialMove();
        TerminationTime = Outer.WorldInfo.TimeSeconds + (GetPostSpecialMoveSleepTime());
        J0xFE:

        // End:0x15F [Loop If]
        if(TerminationTime > Outer.WorldInfo.TimeSeconds)
        {
            Outer.Sleep(0.1000000);
            // [Loop Continue]
            goto J0xFE;
        }
        Status = 'Success';        
    }
    else
    {
Abort:


        Status = 'Failure';
        Outer.Sleep(0.5000000);
    }
    Outer.PopCommand(self);
    stop;            
}

state ChangeMirrorDirection
{
    function FinishedMirroringChange()
    {
        GotoState('Command_SpecialMove');
        //return;        
    }
Begin:

    Outer.MyEvilPawn.SetMirroredSide(!Outer.MyEvilPawn.bIsMirrored);
    J0x6A:

    Outer.Sleep(0.1000000);
    // End:0x6A
    if(!(!Outer.IsTransitioning()))
        goto J0x6A;
    FinishedMirroringChange();
    stop;            
}

defaultproperties
{
    TimeOutDelaySeconds=10.0000000
}