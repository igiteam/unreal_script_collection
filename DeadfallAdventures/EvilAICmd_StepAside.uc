class EvilAICmd_StepAside extends EvilAICommand within EvilAIController;

var BasedPosition PreStepAsideLocation;
var bool bDelayStep;
var Vector BumpHitNormal;

static function bool StepAside(EvilAIController AI, Pawn NewStepAsideGoal, bool inbDelayStep, Vector HitNormal)
{
    local EvilAICmd_StepAside Cmd;

    // End:0x119
    if(((AI != none) && AI.StepAsideGoal == none) && NewStepAsideGoal != none)
    {
        Cmd = new (AI) Class'EvilAICmd_StepAside';
        // End:0x119
        if(Cmd != none)
        {
            AI.StepAsideGoal = NewStepAsideGoal;
            Cmd.bDelayStep = inbDelayStep;
            Cmd.BumpHitNormal = HitNormal;
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
    // End:0x144
    if(EvilPawn(Outer.Pawn) != none)
    {
        EvilPawn(Outer.Pawn).ForceLimitedMoveMode(1);
    }
    // End:0x162
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
    // End:0xEC
    if(EvilPawn(Outer.Pawn) != none)
    {
        EvilPawn(Outer.Pawn).RollbackLimitedMoveMode();
    }
    //return;    
}

state Command_StepAside
{
    function bool IsValidLocation(Vector LocationToCheck)
    {
        local Actor TraceToGoalHit, TraceToPointHit;
        local Vector HitLocation, HitNormal;

        // End:0xCB
        if(Outer.MoveGoal != none)
        {
            TraceToGoalHit = Outer.Trace(HitLocation, HitNormal, Outer.MoveGoal.Location, LocationToCheck, true, Outer.MyEvilPawn.GetCollisionExtent());
        }
        TraceToPointHit = Outer.Trace(HitLocation, HitNormal, LocationToCheck, Outer.Pawn.Location, true, Outer.MyEvilPawn.GetCollisionExtent());
        return (TraceToPointHit == none) && (TraceToGoalHit == none) || TraceToGoalHit == Outer.MoveGoal;
        //return ReturnValue;        
    }

    function Vector GetStepAsideLocation()
    {
        local array<Vector> Locations;
        local Vector collisionExtent;
        local int LocationsCount, LocationIndex;
        local Vector TempLocation;
        local float StepAsideDirection;
        local Vector CrossVector;

        LocationsCount = 10;
        collisionExtent = Outer.MyEvilPawn.GetCollisionExtent();
        CrossVector = Normal(BumpHitNormal Cross vect(0.0000000, 0.0000000, 1.0000000));
        StepAsideDirection = ((Rand(2) == 1) ? 1.0000000 : -1.0000000);
        TempLocation = Outer.Pawn.Location + (CrossVector * (100.0000000 * StepAsideDirection));
        // End:0x138
        if(Outer.IsPointOnNavMesh(TempLocation) && IsValidLocation(TempLocation))
        {
            return TempLocation;            
        }
        else
        {
            TempLocation = Outer.Pawn.Location + (Normal(CrossVector) * (-100.0000000 * StepAsideDirection));
            // End:0x1E1
            if(Outer.IsPointOnNavMesh(TempLocation) && IsValidLocation(TempLocation))
            {
                return TempLocation;
            }
        }
        Outer.NavigationHandle.GetValidPositionsForBox(Outer.Pawn.Location, 500.0000000, collisionExtent, false, Locations, LocationsCount);
        // End:0x2E4
        if(Locations.Length > 0)
        {
            // End:0x2B7
            foreach Locations(TempLocation)
            {
                // End:0x2B6
                if(IsValidLocation(TempLocation))
                {                    
                    return TempLocation;                    
                }                
            }            
            LocationIndex = Rand(LocationsCount);
            return Locations[LocationIndex];            
        }
        else
        {
            return Outer.Pawn.Location;
        }
        //return ReturnValue;        
    }

    function bool IsTouchingStepAsideGoal()
    {
        return Outer.Pawn.Touching.Find(Outer.StepAsideGoal) != ;        
        //return ReturnValue;        
    }

    function Actor StepAside_GetMoveFocus()
    {
        local Actor FocusActor;

        // End:0x4F
        if(Outer.ShotTarget != none)
        {
            FocusActor = Outer.ShotTarget;            
        }
        else
        {
            // End:0x9E
            if(Outer.Focus != none)
            {
                FocusActor = Outer.Focus;                
            }
            else
            {
                // End:0xEA
                if(Outer.MoveGoal != none)
                {
                    FocusActor = Outer.MoveGoal;
                }
            }
        }
        return FocusActor;
        //return ReturnValue;        
    }
Begin:

    // End:0x26B
    if(Outer.StepAsideGoal != none)
    {
        // End:0xC7
        if(EvilPawn(Outer.StepAsideGoal) != none)
        {
            // End:0xC7
            if(!Outer.MyEvilPawn.bNavMeshRegistered)
            {
                EvilPawn(Outer.StepAsideGoal).RegisterNavMeshObstacle();
            }
        }
        Outer.MoveTo(GetStepAsideLocation(), StepAside_GetMoveFocus(), -Outer.MyEvilPawn.GetCollisionRadius() + 5.0000000, Outer.Pawn.bIsWalking);
        // End:0x240
        if(((Outer.StepAsideGoal != none) && Outer.StepAsideGoal != Outer.Pawn) && IsTouchingStepAsideGoal())
        {
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
    bIgnoreStepAside=true
}