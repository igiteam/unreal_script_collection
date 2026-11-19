class EvilAICmd_MoveToEnemy extends EvilAICommand within EvilAIController;

var int MoveTriesRemaining;
var float GoalDistance;
var bool bShiftDestination;
var transient bool bForceWalk;
var bool bUpdateGoal;
var bool bStopWhenSeeEnemy;
var transient bool bDontChangeFocusOnMove;

function Pushed()
{
    super.Pushed();
    // End:0x3F
    if(bStopWhenSeeEnemy)
    {
        Outer.SetTimer(0.5000000, false, 'UnBlockAbortMovingOnEnemyCloseAndVisible', self);
    }
    GotoState('Moving');
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.ClearTimer('UnBlockAbortMovingOnEnemyCloseAndVisible', self);
    // End:0x4A
    if(bStopWhenSeeEnemy)
    {
        BlockAbortMovingOnEnemyCloseAndVisible();
    }
    //return;    
}

function Resumed(name OldCommandName)
{
    // End:0x46
    if(bStopWhenSeeEnemy && ChildStatus == 'Aborted')
    {
        Outer.PopCommand(self);
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

static function bool MoveToEnemy(EvilAIController AI, optional float InGoalDistance = 0.0000000, optional bool bInShiftDestination = false, optional float InTimedOut = -1.0000000, optional bool bInUpdateGoal = true, optional bool bInForceWalk = false, optional bool bInStopWhenSeeEnemy = false, optional bool bInDontChangeFocusOnMove)
{
    local EvilAICmd_MoveToEnemy Cmd;

    // End:0x1C8
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_MoveToEnemy';
        Cmd.GoalDistance = InGoalDistance;
        Cmd.bShiftDestination = bInShiftDestination;
        Cmd.bUpdateGoal = bInUpdateGoal;
        Cmd.TimedOut = InTimedOut;
        Cmd.bForceWalk = bInForceWalk;
        Cmd.bStopWhenSeeEnemy = bInStopWhenSeeEnemy;
        Cmd.bDontChangeFocusOnMove = bInDontChangeFocusOnMove;
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

function UnBlockAbortMovingOnEnemyCloseAndVisible()
{
    Outer.ReactionManager.NudgeChannel(Outer, 'UnBlockAbortMovingOnEnemyCloseAndVisible');
    //return;    
}

function BlockAbortMovingOnEnemyCloseAndVisible()
{
    Outer.ReactionManager.NudgeChannel(Outer, 'BlockAbortMovingOnEnemyCloseAndVisible');
    //return;    
}

state Moving
{Begin:

    // End:0xDE
    if(Outer.HasValidEnemy())
    {
        Outer.SetMoveGoal(Outer.Enemy, GetRealAproachDistance(Outer.Enemy, GoalDistance), bUpdateGoal, bForceWalk, bShiftDestination, bDontChangeFocusOnMove);
        // End:0xDE
        if(ChildStatus == 'Success')
        {
            GotoState('DelaySuccess');
        }
    }
    // End:0xFD
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
    bIgnoreStepAside=true
}