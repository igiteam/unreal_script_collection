class AdvAICmd_Attack_Finisher extends EvilAICmd_SpecialMove within EvilAIController;

var Actor MeleeTarget;
var AdvAIController AdvController;

function Pushed()
{
    super.Pushed();
    Outer.bDoingMeleeAttack = true;
    GotoState('Command_SpecialMove');
    //return;    
}

function Popped()
{
    Outer.bDoingMeleeAttack = false;
    super.Popped();
    //return;    
}

static function bool Finish(EvilAIController AI, optional Actor InTarget)
{
    local AdvAICmd_Attack_Finisher Cmd;

    // End:0x157
    if(AI != none)
    {
        Cmd = new (AI) default.Class;
        Cmd.AdvController = AdvAIController(AI);
        // End:0x109
        if(Cmd != none)
        {
            // End:0xAA
            if(InTarget != none)
            {
                Cmd.MeleeTarget = InTarget;                
            }
            else
            {
                // End:0x109
                if(AI.HasValidEnemy())
                {
                    Cmd.MeleeTarget = AI.Enemy;
                }
            }
        }
        // End:0x157
        if(Cmd.MeleeTarget != none)
        {
            AI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function AdjustEnemyRating(out float out_Rating, EvilPawn EnemyPawn)
{
    // End:0x29
    if(EnemyPawn == MeleeTarget)
    {
        out_Rating = 1.0000000;        
    }
    else
    {
        out_Rating = 0.0000000;
    }
    //return;    
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
        Outer.Pawn.ZeroMovementVariables();
        return true;
        //return ReturnValue;        
    }

    function bool ExecuteSpecialMove()
    {
        AdvController.StartFinisherAttack();
        PawnAction = GetPawnAction();
        return true;
        //return ReturnValue;        
    }

    function bool IsSpecialMoveComplete()
    {
        return int(Outer.MyEvilPawn.PawnAction) != int(PawnAction);
        //return ReturnValue;        
    }
    stop;    
}
