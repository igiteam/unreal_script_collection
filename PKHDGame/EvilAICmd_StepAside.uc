class EvilAICmd_StepAside extends EvilAICommand within EvilAIController;

var BasedPosition PreStepAsideLocation;
var bool bDelayStep;
var Vector DebugLoc;

static function bool StepAside(EvilAIController AI, Pawn NewStepAsideGoal, bool inbDelayStep)
{
    local EvilAICmd_StepAside Cmd;

    // End:0xF1
    if(((AI != none) && AI.StepAsideGoal == none) && NewStepAsideGoal != none)
    {
        Cmd = new (AI) Class'EvilAICmd_StepAside';
        // End:0xF1
        if(Cmd != none)
        {
            AI.StepAsideGoal = NewStepAsideGoal;
            Cmd.bDelayStep = inbDelayStep;
            AI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

event string GetDumpString()
{
    return (super.GetDumpString() @ "Goal:") @ string(Outer.StepAsideGoal);
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
    Outer.SetBasedPosition(PreStepAsideLocation, Outer.Pawn.Location);
    // End:0xF6
    if(bDelayStep)
    {
        GotoState('Command_DelayStep');        
    }
    else
    {
        GotoState('Command_StepAside');
    }
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.StepAsideGoal = none;
    // End:0x82
    if(Outer.Pawn != none)
    {
        Outer.Pawn.ZeroMovementVariables();
    }
    //return;    
}

state Command_StepAside
{
    function bool IsValidMoveLocation(Vector ChkLoc)
    {
        return Outer.NavigationHandle.PointReachable(ChkLoc);
        //return ReturnValue;        
    }

    function Vector GetStepAsideLocation()
    {
        local Vector X, Y, Z;
        local array<Vector> ChkLocs;
        local int Idx;
        local float StepDist;

        // End:0x50
        if(Outer.StepAsideGoal == Outer.Pawn)
        {
            X = VRand();            
        }
        else
        {
            // End:0xCD
            if(VSizeSq(Outer.StepAsideGoal.Acceleration) > float(0))
            {
                X = Outer.StepAsideGoal.Acceleration;                
            }
            else
            {
                X = Vector(Outer.Pawn.Rotation);
            }
        }
        X.Z = 0.0000000;
        X = Normal(X);
        Z = vect(0.0000000, 0.0000000, 1.0000000);
        Y = Normal(X Cross Z);
        // End:0x20E
        if((Normal(Outer.Pawn.Location - Outer.StepAsideGoal.Location) Dot Y) < 0.0000000)
        {
            Y = -Y;
        }
        StepDist = Outer.MaxStepAsideDist;
        ChkLocs.Length = 3;
        ChkLocs[0] = (Outer.Pawn.Location + (Y * StepDist)) + ((X * StepDist) * 0.1000000);
        ChkLocs[1] = (Outer.Pawn.Location + ((X * StepDist) * 0.5000000)) + ((Y * StepDist) * 0.5000000);
        ChkLocs[2] = (Outer.Pawn.Location - (Y * StepDist)) + ((X * StepDist) * 0.1000000);
        ChkLocs[3] = (Outer.Pawn.Location + ((X * StepDist) * 0.5000000)) - ((Y * StepDist) * 0.5000000);
        ChkLocs[4] = Outer.Pawn.Location + (X * StepDist);
        Idx = 0;
        J0x47C:

        // End:0x4D6 [Loop If]
        if(Idx < ChkLocs.Length)
        {
            // End:0x4C8
            if(IsValidMoveLocation(ChkLocs[Idx]))
            {
                return ChkLocs[Idx];
            }
            Idx++;
            // [Loop Continue]
            goto J0x47C;
        }
        return Outer.Pawn.Location;
        //return ReturnValue;        
    }

    function Actor StepAside_GetMoveFocus()
    {
        // End:0x43
        if(Outer.ShotTarget != none)
        {
            return Outer.ShotTarget;
        }
        return Outer.Focus;
        return none;
        //return ReturnValue;        
    }
Begin:

    // End:0x27C
    if(Outer.StepAsideGoal != none)
    {
        DebugLoc = GetStepAsideLocation();
        Outer.MoveTo(GetStepAsideLocation(), StepAside_GetMoveFocus(),, Outer.Pawn.bIsWalking);
        // End:0x251
        if(((Outer.StepAsideGoal != none) && Outer.StepAsideGoal != Outer.Pawn) && (Outer.Pawn.Touching.Find(Outer.StepAsideGoal) != -1) || Outer.StepAsideGoal.ReachedPoint(Outer.GetBasedPosition(PreStepAsideLocation), none))
        {
            Outer.Sleep(0.5000000 + (FRand() * 1.0000000));
            Outer.SetBasedPosition(PreStepAsideLocation, Outer.Pawn.Location);
            goto 'Begin';
        }
        Outer.Sleep(0.2500000 + (FRand() * 0.5000000));        
    }
    else
    {
        Outer.Sleep(0.5000000);
    }
    Status = 'Success';
    Outer.PopCommand(self);
    stop;                
}

state Command_DelayStep
{Begin:

    // End:0x7C
    if(Outer.StepAsideGoal != none)
    {
        // End:0x7C
        if(Outer.Pawn != none)
        {
            Outer.Pawn.ZeroMovementVariables();
        }
    }
    Outer.Sleep(0.3000000 + (FRand() * 0.5000000));
    Status = 'Success';
    Outer.PopCommand(self);
    stop;                    
}

defaultproperties
{
    bReplaceActiveSameClassInstance=true
}