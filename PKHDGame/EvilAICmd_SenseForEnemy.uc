class EvilAICmd_SenseForEnemy extends EvilAICommand within EvilAIController;

var Pawn Target;
var float DistanceToTarget;
var float MaxMoveDistance;

static function bool SenseForEnemy(EvilAIController AI, Pawn InTarget, float InMaxMoveDistance)
{
    local EvilAICmd_SenseForEnemy Cmd;

    // End:0xCF
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_SenseForEnemy';
        Cmd.Target = InTarget;
        Cmd.MaxMoveDistance = InMaxMoveDistance;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    GotoState('SensingForEnemy');
    //return;    
}

function Paused(GameAICommand NewCommand)
{
    super(GameAICommand).Paused(NewCommand);
    Outer.Pawn.ZeroMovementVariables();
    //return;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    Outer.PopCommand(self);
    //return;    
}

state SensingForEnemy
{Begin:

    Outer.StopLatentExecution();
    Outer.Pawn.ZeroMovementVariables();
    Outer.Sleep(0.5000000);
    Outer.SetFocalPoint(Target.Location);
    Outer.FinishRotation();
    Outer.Sleep(0.5000000);
    DistanceToTarget = VSize(Target.Location - Outer.Pawn.Location);
    Outer.SetMoveGoal(Target, FMax(DistanceToTarget - MaxMoveDistance, 0.0000000), false);
    Outer.PopCommand(self);
    stop;                
}
