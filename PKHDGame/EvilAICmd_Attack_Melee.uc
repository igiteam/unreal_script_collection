class EvilAICmd_Attack_Melee extends EvilAICmd_SpecialMove within EvilAIController;

var Actor MeleeTarget;

function Pushed()
{
    super.Pushed();
    Outer.bDoingMeleeAttack = true;
    GotoState('Command_SpecialMove');
    //return;    
}

function Resumed(name OldCommandName)
{
    super.Resumed(OldCommandName);
    LockdownAI();
    Outer.PopCommand(self);
    //return;    
}

function Popped()
{
    Outer.bDoingMeleeAttack = false;
    super.Popped();
    //return;    
}

static function bool Melee(EvilAIController AI, optional Actor InTarget)
{
    local EvilAICmd_Attack_Melee Cmd;

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
    function bool SetupSpecialMove()
    {
        Outer.Pawn.ZeroMovementVariables();
        return true;
        //return ReturnValue;        
    }

    function bool ExecuteSpecialMove()
    {
        Outer.StartMeleeAttack();
        return true;
        //return ReturnValue;        
    }
    stop;    
}
