class EvilAICmd_Strafe extends EvilAICommand within EvilAIController;

var Vector StrafePoint;
var bool bGenerateStrafePoint;

static function bool Strafe(EvilAIController AI, optional bool _bGenerateStrafePoint = true, optional Vector Point)
{
    local EvilAICmd_Strafe Cmd;

    // End:0xD7
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_Strafe';
        Cmd.StrafePoint = Point;
        Cmd.bGenerateStrafePoint = _bGenerateStrafePoint;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    // End:0x7C
    if(int(Outer.Pawn.Physics) == int(0))
    {
        Outer.Pawn.SetMovementPhysics();
    }
    GotoState('GoStrafe');
    //return;    
}

function Paused(GameAICommand AICommand)
{
    super(GameAICommand).Paused(AICommand);
    Outer.MyEvilPawn.bIsWalking = false;
    Outer.MyEvilPawn.bStrafing = false;
    //return;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    ExitWithFailure();
    //return;    
}

function Popped()
{
    Outer.MyEvilPawn.bIsWalking = false;
    Outer.MyEvilPawn.bStrafing = false;
    Outer.LastStrafeTime = Outer.WorldInfo.TimeSeconds;
    super(GameAICommand).Popped();
    //return;    
}

static function bool GetStrafePoint(EvilAIController AI, out Vector Point)
{
    local Vector RightDir, pointleft, pointright;
    local bool bPointLeftReachable, bPointRightReachable;

    RightDir = AI.Pawn.GetRotatorAxis(AI.MyEvilPawn.DesiredRotation, 1);
    pointright = AI.Pawn.Location + (RandRange(200.0000000, 300.0000000) * RightDir);
    pointleft = AI.Pawn.Location - (RandRange(200.0000000, 300.0000000) * RightDir);
    bPointLeftReachable = AI.CanStrafe(pointleft);
    bPointRightReachable = AI.CanStrafe(pointright);
    // End:0x1E8
    if(bPointRightReachable && bPointLeftReachable)
    {
        // End:0x1D2
        if(FRand() < 0.5000000)
        {
            Point = pointright;            
        }
        else
        {
            Point = pointleft;
        }        
    }
    else
    {
        // End:0x20B
        if(bPointRightReachable)
        {
            Point = pointright;            
        }
        else
        {
            // End:0x22E
            if(bPointLeftReachable)
            {
                Point = pointleft;                
            }
            else
            {
                return false;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

state GoStrafe
{Begin:

    // End:0x420
    if(!bGenerateStrafePoint || GetStrafePoint(Outer, StrafePoint))
    {
        Outer.MyEvilPawn.UnregisterNavmeshObstacle();
        // End:0x124
        if(int(Outer.MyEvilPawn.CoverType) != int(0))
        {
            Outer.InvalidateCoverAction();
            Outer.InvalidateCover();
            J0xE3:

            Outer.Sleep(0.1000000);
            // End:0xE3
            if(!(!Outer.IsTransitioning()))
                goto J0xE3;
        }
        Outer.MyEvilPawn.bStrafing = true;
        // End:0x23B
        if(Outer.MyEvilPawn.bHasDirectionalMoveAnims)
        {
            Outer.MyEvilPawn.bIsWalking = true;
            Outer.MyEvilPawn.RequestDefaultMovementMode();
            Outer.Focus = Outer.Enemy;            
        }
        else
        {
            Outer.SetDesiredRotation(Rotator(Normal(StrafePoint - Outer.MyEvilPawn.Location)),, true);
        }
        Outer.FinishRotation();
        // End:0x3BF
        if(Outer.MyEvilPawn.bHasDirectionalMoveAnims)
        {
            Outer.MoveTo(StrafePoint, Outer.Enemy, 0.0000000, true);
            Outer.MyEvilPawn.bIsWalking = false;
            Outer.SetFocalPoint(Outer.Enemy.Location);            
        }
        else
        {
            Outer.MoveTo(StrafePoint,, 0.0000000);
        }
        Outer.MyEvilPawn.bStrafing = false;        
    }
    else
    {
        ExitWithFailure();
    }
    ExitWithSuccess();
    stop;                
}
