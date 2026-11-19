class EvilAICmd_Dodge extends EvilAICmd_SpecialMove within EvilAIController;

var EvilTypesNative.EAnimationSetType AST;

function Pushed()
{
    super.Pushed();
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
    super.Popped();
    //return;    
}

static function bool Dodge(EvilAIController AI, optional EvilTypesNative.EAnimationSetType InAST = 89)
{
    local EvilAICmd_Dodge Cmd;

    // End:0x96
    if(AI != none)
    {
        Cmd = new (AI) default.Class;
        // End:0x96
        if(Cmd != none)
        {
            Cmd.AST = InAST;
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
        // End:0x27
        if(Outer.StartDodge())
        {
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }
    stop;    
}
