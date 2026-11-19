class EvilAICmd_DropDown extends EvilAICommand within EvilAIController;

function Pushed()
{
    super.Pushed();
    GotoState('State_DropDown');
    //return;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    Outer.PopCommand(self);
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    //return;    
}

static function bool DropDown(EvilAIController AI)
{
    local EvilAICmd_DropDown Cmd;

    // End:0x68
    if(AI != none)
    {
        Cmd = new (AI) default.Class;
        // End:0x68
        if(Cmd != none)
        {
            AI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

state State_DropDown
{Begin:

    Outer.Focus = none;
    Outer.SetFocalPoint(Outer.Pawn.Location + (Vector(Outer.Pawn.Rotation) * float(100)));
    Outer.Pawn.DoJump(false);
    Outer.Pawn.Velocity = Vector(Outer.Pawn.Rotation) * float(300);
    Outer.Pawn.Velocity.Z = 100.0000000;
    Outer.Sleep(1.0000000);
    Outer.AbortMoving();
    Outer.PopCommand(self);
    stop;                    
}
