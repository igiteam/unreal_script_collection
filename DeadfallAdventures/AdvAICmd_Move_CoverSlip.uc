class AdvAICmd_Move_CoverSlip extends EvilAICmd_SpecialMove within AdvAIController_Cover;

var Vector SlipStart;
var Vector SlipEnd;
var Vector SidewaysDest;
var int Direction;

static function bool Coverslip(int Dir, AdvAIController_Cover AI, Vector MoveStart, Vector MoveDest)
{
    local AdvAICmd_Move_CoverSlip Cmd;

    // End:0xE0
    if(AI != none)
    {
        Cmd = new (AI) Class'AdvAICmd_Move_CoverSlip';
        // End:0xE0
        if(Cmd != none)
        {
            Cmd.SlipStart = MoveStart;
            Cmd.SlipEnd = MoveDest;
            Cmd.Direction = Dir;
            AI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

event string GetDumpString()
{
    return (((super(EvilAICommand).GetDumpString() @ "Start:") @ string(SlipStart)) @ "End:") @ string(SlipEnd);
    //return ReturnValue;    
}

private final function bool ShouldChangeMirrorDirection()
{
    // End:0x97
    if(((Direction == 2) && Outer.MyEvilPawn.bIsMirrored) || (Direction == 1) && !Outer.MyEvilPawn.bIsMirrored)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    // End:0x28
    if(ShouldChangeMirrorDirection())
    {
        GotoState('ChangeMirrorDirection');        
    }
    else
    {
        GotoState('Command_SpecialMove');
    }
    //return;    
}

function Popped()
{
    super.Popped();
    // End:0xA5
    if(Outer.MyEvilPawn != none)
    {
        Outer.MyEvilPawn.CurrentSlotDirection = 0;
        Outer.MyEvilPawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    }
    //return;    
}

function Resumed(name OldCommandName)
{
    super.Resumed(OldCommandName);
    Status = 'Failure';
    Outer.PopCommand(self);
    //return;    
}

state Command_SpecialMove
{
    function byte GetPawnAction()
    {
        return 18;
        //return ReturnValue;        
    }
    stop;    
}

state ChangeMirrorDirection
{
    function FinishedMirroringChange()
    {
        GotoState('Command_SpecialMove');
        //return;        
    }
    stop;    
}

defaultproperties
{
    bShouldCheckSpecialMove=true
    bForceMoveMode=true
    bIgnoreStepAside=true
}