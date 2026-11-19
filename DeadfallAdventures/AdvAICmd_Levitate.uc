class AdvAICmd_Levitate extends EvilAICmd_Jump within AdvAIController;

var float FloorZ;

static function bool InitJump(EvilAIController AI)
{
    local AdvAICmd_Levitate Cmd;
    local AdvAIController AdvAI;

    // End:0xAA
    if(AI != none)
    {
        AdvAI = AdvAIController(AI);
        // End:0xAA
        if((AdvAI != none) && AI.Pawn != none)
        {
            Cmd = new (AdvAI) Class'AdvAICmd_Levitate';
            AI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    SetupJumpInfo();
    super.Pushed();
    //return;    
}

function SetupJumpInfo()
{
    Outer.MyEvilPawn.CurrentJumpArchetypeIndex = 0;
    Outer.MyEvilPawn.JumpImpulseFromKismet = vect(0.0000000, 0.0000000, 1.0000000) * 1000.0000000;
    Outer.MyEvilPawn.bInheritJumpVelocityFromMotionDelta = true;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x1F8
    if(((Outer.MyEvilPawn.Location.Z - FloorZ) > 400.0000000) || Outer.ShouldStopLevitating())
    {
        Outer.MyEvilPawn.CustomGravityScaling = 1.0000000;
        // End:0x1F5
        if(Outer.MyEvilPawn.Velocity.Z > 0.0000000)
        {
            Outer.MyEvilPawn.Velocity.Z = Outer.MyEvilPawn.Velocity.Z - (DeltaTime * ((Outer.MyEvilPawn.Velocity.Z + 1000.0000000) / float(2)));
        }        
    }
    else
    {
        // End:0x3AB
        if(Outer.MyEvilPawn.Velocity.Z < 0.0000000)
        {
            Outer.MyEvilPawn.CustomGravityScaling = 0.0000000;
            // End:0x3AB
            if(Outer.MyEvilPawn.CustomGravityScaling <= 0.0000000)
            {
                Outer.MyEvilPawn.Velocity.Z = Outer.MyEvilPawn.Velocity.Z - (DeltaTime * ((Outer.MyEvilPawn.Velocity.Z - 1000.0000000) / float(2)));
            }
        }
    }
    super(GameAICommand).Tick(DeltaTime);
    //return;    
}

auto state Jumping
{Begin:

    FloorZ = Outer.MyEvilPawn.Location.Z;
    Outer.MyEvilPawn.ServerDoPawnAction(26, true,, Outer.MyEvilPawn.CurrentJumpArchetypeIndex);
    Outer.MyEvilPawn.Velocity = vect(0.0000000, 0.0000000, 1.0000000) * 500.0000000;
    goto 'Falling';
    stop;        
}
