class AdvAICmd_Move_Run2Cover extends EvilAICmd_SpecialMove within AdvAIController_Cover;

var CoverInfo CoverGoal;
var bool bReachedPreciseDestination;
var float GoalDistance;

static function bool Run2Cover(EvilAIController AI, CoverInfo InCoverGoal, optional float InGoalDistance)
{
    local AdvAICmd_Move_Run2Cover Cmd;
    local AdvAIController_Cover CoverAI;

    CoverAI = AdvAIController_Cover(AI);
    // End:0xF9
    if((CoverAI != none) && InCoverGoal.Link != none)
    {
        Cmd = new (CoverAI) Class'AdvAICmd_Move_Run2Cover';
        // End:0xF9
        if(Cmd != none)
        {
            Cmd.CoverGoal = InCoverGoal;
            Cmd.GoalDistance = InGoalDistance;
            CoverAI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    GotoState('RunToCoverGoal');
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.MyEvilPawn.bCanDoTurnInPlaceAnim = Outer.MyEvilPawn.default.bCanDoTurnInPlaceAnim;
    Outer.MyEvilPawn.bCollideWorld = true;
    Outer.MyEvilPawn.SetCollision(true, true);
    Outer.MyEvilPawn.SetPhysics(1);
    Outer.MyEvilPawn.EndPawnAction();
    // End:0x15E
    if(Status == 'Aborted')
    {
        AbortSpecialMove();
    }
    Outer.ReactionManager.UnSuppressAll();
    Outer.MyEvilPawn.ResetDesiredRotation();
    //return;    
}

function AbortSpecialMove()
{
    // End:0xAC
    if(EPA_Run2Cover(Outer.MyEvilPawn.PawnActions[int(PawnAction)]) != none)
    {
        EPA_Run2Cover(Outer.MyEvilPawn.PawnActions[int(PawnAction)]).StopAnim();
    }
    Outer.MyEvilPawn.bCanDoTurnInPlaceAnim = Outer.MyEvilPawn.default.bCanDoTurnInPlaceAnim;
    Outer.MyEvilPawn.LockDesiredRotation(false);
    //return;    
}

function ReachedPreciseDestination()
{
    bReachedPreciseDestination = true;
    //return;    
}

function Vector GetDestinationFromCoverGoal()
{
    return CoverGoal.Link.GetSlotLocation(CoverGoal.SlotIdx);
    //return ReturnValue;    
}

function bool IsReachedDestination()
{
    return Outer.Pawn.ReachedPoint(GetDestinationFromCoverGoal(), Outer.Pawn.Anchor) || (GoalDistance > 0.0000000) && VSizeSq(Outer.Pawn.Location - (GetDestinationFromCoverGoal())) < (GoalDistance ** float(2));
    //return ReturnValue;    
}

state RunToCoverGoal
{Begin:

    Outer.FinishRotation();
    Outer.MoveTo(GetDestinationFromCoverGoal(),, FMax(0.0000000, GoalDistance - Outer.MyEvilPawn.GetCollisionRadius()));
    // End:0xA0
    if(IsReachedDestination())
    {
        GotoState('Command_SpecialMove');        
    }
    else
    {
        ExitWithFailure();
    }
    stop;        
}

state Command_SpecialMove
{
    function byte GetPawnAction()
    {
        return Outer.MyEvilPawn.PawnAction;
        //return ReturnValue;        
    }

    function bool SetupSpecialMove()
    {
        Outer.ReactionManager.SuppressAll();
        Outer.MyEvilPawn.bCanDoTurnInPlaceAnim = false;
        Outer.MyEvilPawn.CurrentLink = CoverGoal.Link;
        Outer.MyEvilPawn.CurrentSlotIdx = CoverGoal.SlotIdx;
        Outer.MyEvilPawn.LeftSlotIdx = CoverGoal.Link.GetSlotIdxToLeft(Outer.MyEvilPawn.CurrentSlotIdx);
        Outer.MyEvilPawn.RightSlotIdx = CoverGoal.Link.GetSlotIdxToRight(Outer.MyEvilPawn.CurrentSlotIdx);
        Outer.MyEvilPawn.DestinationOffset = -Outer.MyEvilPawn.GetCollisionRadius();
        Outer.MyEvilPawn.SetPhysics(4);
        Outer.MyEvilPawn.bCollideWorld = false;
        Outer.MyEvilPawn.SetCollision(false, false);
        Outer.MyEvilPawn.CheckMirrorTransition(Outer.MyEvilPawn.CoverAction, false);
        Outer.MyEvilPawn.SetDesiredRotation(Rotator(-Outer.MyEvilPawn.GetCoverNormal()), true,, 0.5000000);
        return true;
        //return ReturnValue;        
    }

    function bool ExecuteSpecialMove()
    {
        Outer.MyEvilPawn.CoverAcquired(Outer.MyEvilPawn.CoverInfoToCovPosInfo(CoverGoal));
        PawnAction = GetPawnAction();
        return int(PawnAction) != 0;
        //return ReturnValue;        
    }

    function bool IsSpecialMoveComplete()
    {
        return super.IsSpecialMoveComplete() || Outer.Pawn.ReachedDesiredRotation() && bReachedPreciseDestination;
        //return ReturnValue;        
    }

    function FinishedSpecialMove()
    {
        // End:0xAC
        if(EPA_Run2Cover(Outer.MyEvilPawn.PawnActions[int(PawnAction)]) != none)
        {
            EPA_Run2Cover(Outer.MyEvilPawn.PawnActions[int(PawnAction)]).PlayStopAnim();
        }
        Outer.MyEvilPawn.bCanDoTurnInPlaceAnim = Outer.MyEvilPawn.default.bCanDoTurnInPlaceAnim;
        Outer.MyEvilPawn.LockDesiredRotation(false);
        //return;        
    }
    stop;    
}

defaultproperties
{
    bIgnoreStepAside=true
}