class EvilAICmd_Attack_Charge extends EvilAICmd_SpecialMove within EvilAIController;

var Actor MeleeTarget;

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

static function bool Charge(EvilAIController AI, optional Actor InTarget)
{
    local EvilAICmd_Attack_Charge Cmd;

    // End:0x126
    if(AI != none)
    {
        Cmd = new (AI) default.Class;
        // End:0xD8
        if(Cmd != none)
        {
            // End:0x79
            if(InTarget != none)
            {
                Cmd.MeleeTarget = InTarget;                
            }
            else
            {
                // End:0xD8
                if(AI.HasValidEnemy())
                {
                    Cmd.MeleeTarget = AI.Enemy;
                }
            }
        }
        // End:0x126
        if(Cmd.MeleeTarget != none)
        {
            AI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
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
        Outer.StartChargeAttack();
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
