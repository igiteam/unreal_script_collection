class EvilAICmd_MoveToEnemy extends EvilAICommand within EvilAIController;

var int MoveTriesRemaining;
var float GoalDistance;
var bool bShiftDestination;
var transient bool bForceWalk;
var bool bUpdateGoal;
var bool bStopWhenSeeEnemy;

function Pushed()
{
    super.Pushed();
    // End:0x5D
    if(bStopWhenSeeEnemy)
    {
        Outer.ReactionManager.NudgeChannel(Outer, 'UnBlockAbortMovingOnEnemyCloseAndVisible');
    }
    GotoState('Moving');
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    // End:0x5D
    if(bStopWhenSeeEnemy)
    {
        Outer.ReactionManager.NudgeChannel(Outer, 'BlockAbortMovingOnEnemyCloseAndVisible');
    }
    //return;    
}

function float GetRealAproachDistance(Actor inActor, float InDesiredDistance)
{
    local float Radius;

    Radius = (Outer.Pawn.GetCollisionRadius() + Outer.Enemy.GetCollisionRadius()) + 1.0000000;
    return FMax(0.0000000, GoalDistance - Radius);
    //return ReturnValue;    
}

static function bool MoveToEnemy(EvilAIController AI, optional float InGoalDistance = 0.0000000, optional bool bInShiftDestination = false, optional float InTimedOut = -1.0000000, optional bool bInUpdateGoal = true, optional bool bInForceWalk = false, optional bool bInStopWhenSeeEnemy = false)
{
    local EvilAICmd_MoveToEnemy Cmd;

    // End:0x19D
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_MoveToEnemy';
        Cmd.GoalDistance = InGoalDistance;
        Cmd.bShiftDestination = bInShiftDestination;
        Cmd.bUpdateGoal = bInUpdateGoal;
        Cmd.TimedOut = InTimedOut;
        Cmd.bForceWalk = bInForceWalk;
        Cmd.bStopWhenSeeEnemy = bInStopWhenSeeEnemy;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CheckReachEnemyTimer()
{
    //return;    
}

function bool DisableChildDelay()
{
    return super.DisableChildDelay() || EvilAICmd_MoveToGoal(ChildCommand) != none;
    //return ReturnValue;    
}

state Moving
{Begin:

    // End:0xD3
    if(Outer.HasValidEnemy())
    {
        Outer.SetMoveGoal(Outer.Enemy, GetRealAproachDistance(Outer.Enemy, GoalDistance), bUpdateGoal, bForceWalk, bShiftDestination);
        // End:0xD3
        if(ChildStatus == 'Success')
        {
            GotoState('DelaySuccess');
        }
    }
    // End:0xF2
    if(--MoveTriesRemaining < 1)
    {
        GotoState('DelayFailure');
    }
    goto 'Begin';
    stop;                
}

defaultproperties
{
    MoveTriesRemaining=1
}