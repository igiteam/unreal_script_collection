class EvilAICmd_FlyToGoal extends EvilAICmd_MoveToGoal within EvilAIController;

static function bool MoveToGoal(EvilAIController AI, Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal = true, optional bool bInForceWalk = false, optional bool bInShiftDestination = false)
{
    local EvilAICmd_MoveToGoal Cmd;

    // End:0x1B9
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_FlyToGoal';
        Cmd.GoalDistance = InGoalDistance;
        Cmd.SavedGoalDistance = InGoalDistance;
        Cmd.bUpdateGoal = bInUpdateGoal;
        Cmd.MovePoint = vect(0.0000000, 0.0000000, 0.0000000);
        Cmd.MoveGoal = InGoal;
        Cmd.bForceWalk = bInForceWalk;
        Cmd.bShiftDestination = bInShiftDestination;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool MoveToPoint(EvilAIController AI, Vector InMovePoint, optional float InGoalDistance = 0.0000000, optional bool bInForceWalk = false)
{
    local EvilAICmd_MoveToGoal Cmd;

    // End:0x148
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_FlyToGoal';
        Cmd.GoalDistance = InGoalDistance;
        Cmd.bUpdateGoal = false;
        Cmd.MoveGoal = none;
        Cmd.MovePoint = InMovePoint;
        Cmd.bForceWalk = bInForceWalk;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool MoveGoalIsReachable(optional Actor Goal)
{
    return true;
    //return ReturnValue;    
}

state MoveToGoalState
{Begin:

    Outer.MoveTo(MovePoint, none, FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust));
    goto 'ReachedGoal';
    stop;                
}
