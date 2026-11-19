class EvilAICmd_MoveToGoal extends EvilAICommand within EvilAIController;

var const int MaxMovetowardTries;
var transient float GoalDistance;
var transient float SavedGoalDistance;
var transient float ReachedDestinatonThresholdAdjust;
var transient Actor MoveGoal;
var transient Vector MovePoint;
var transient Vector TempDest;
var transient Vector CheckPos;
var transient Vector LocationBeforeForcedDirectMove;
var transient float LastForcedDirectMoveTime;
var int OldWalkSlowAnimIndex;
var bool bNavMeshFailedLastTime;
var bool bGetNextMoveLocationFailedLastTime;
var bool bUsePartialNavMeshPath;
var bool bIsDirectMove;
var transient bool bUpdateGoal;
var bool bUsePathNotFound;
var transient bool bForceWalk;
var bool bShiftDestination;
var bool bAccelTurnActive;
var bool bSmoothTurnsFlag;
var bool bForceDirectMove;
var int NavPathSearchFails;
var int MaxNavPathSearchFails;
var int LoopFailSafeCounter;
var int FailedUnstuckCounter;
var transient Vector LastGoalPos;
var Vector AdjustDstPosition;
var float LastAdjustPositionFailTime;
var EvilTypesNative.EMoveMode LastMoveMode;
var() float AlternativeMoveGoalRadius;

static function bool MoveToGoal(EvilAIController AI, Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal = true, optional bool bInForceWalk = false, optional bool bInShiftDestination = false)
{
    local EvilAICmd_MoveToGoal Cmd;

    // End:0x1B9
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) default.Class;
        Cmd.GoalDistance = InGoalDistance;
        Cmd.SavedGoalDistance = InGoalDistance;
        Cmd.bUpdateGoal = bInUpdateGoal;
        Cmd.MovePoint = vect(0.0000000, 0.0000000, 0.0000000);
        Cmd.MoveGoal = InGoal;
        Cmd.bForceWalk = bInForceWalk;
        Cmd.bShiftDestination = bInShiftDestination;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool MoveToPoint(EvilAIController AI, Vector InMovePoint, optional float InGoalDistance = 0.0000000, optional bool bInForceWalk = false)
{
    local EvilAICmd_MoveToGoal Cmd;

    // End:0x148
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) default.Class;
        Cmd.GoalDistance = InGoalDistance;
        Cmd.bUpdateGoal = false;
        Cmd.MoveGoal = none;
        Cmd.MovePoint = InMovePoint;
        Cmd.bForceWalk = bInForceWalk;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function PathNotFound()
{
    //return;    
}

function bool MoveGoalIsValid()
{
    return MoveGoal != none;
    //return ReturnValue;    
}

function bool MovePointIsValid(optional Vector Point)
{
    // End:0x23
    if(IsZero(Point))
    {
        Point = MovePoint;
    }
    return !IsZero(Point);
    //return ReturnValue;    
}

function bool HasReachedMoveGoal(optional Actor Goal)
{
    local bool bRet;

    // End:0x27
    if(Outer.Pawn == none)
    {
        return true;
    }
    // End:0x49
    if(Goal == none)
    {
        Goal = MoveGoal;
    }
    Outer.Pawn.DestinationOffset = FMax(10.0000000, GoalDistance - ReachedDestinatonThresholdAdjust);
    // End:0xFB
    if(MoveGoalIsValid())
    {
        bRet = Outer.Pawn.ReachedDestination(Goal);
        return bRet;        
    }
    else
    {
        // End:0x256
        if(MovePointIsValid())
        {
            // End:0x202
            if((VSize2D(MovePoint - Outer.Pawn.Location) < GoalDistance) && Abs(MovePoint.Z - Outer.Pawn.Location.Z) < Outer.Pawn.GetCollisionHeight())
            {
                return true;
            }
            bRet = Outer.Pawn.ReachedPoint(MovePoint, none);
            return bRet;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool MoveGoalIsReachable(optional Actor Goal)
{
    // End:0x23
    if(Goal == none)
    {
        Goal = MoveGoal;
    }
    // End:0x71
    if(MoveGoalIsValid())
    {
        return Outer.NavigationHandle.ActorReachable(Goal);        
    }
    else
    {
        // End:0xBF
        if(MovePointIsValid())
        {
            return Outer.NavigationHandle.PointReachable(MovePoint);
        }
    }
    return false;
    //return ReturnValue;    
}

function Vector GetMoveGoalLocation(optional Actor Goal)
{
    // End:0x23
    if(Goal == none)
    {
        Goal = MoveGoal;
    }
    // End:0x52
    if(MoveGoalIsValid())
    {
        return Goal.Location;        
    }
    else
    {
        // End:0x6A
        if(MovePointIsValid())
        {
            return MovePoint;
        }
    }
    return vect(0.0000000, 0.0000000, 0.0000000);
    //return ReturnValue;    
}

function bool TargetCanBeReached(out Vector OutTargetLocation)
{
    // End:0x38
    if(MoveGoalIsValid())
    {
        OutTargetLocation = MoveGoal.Location;        
    }
    else
    {
        // End:0x59
        if(MovePointIsValid())
        {
            OutTargetLocation = MovePoint;
        }
    }
    return Outer.NavigationHandle.GetPylonFromPos(OutTargetLocation) != none;
    //return ReturnValue;    
}

function bool FindNavMeshPath(optional bool bFallbackPoint, optional bool bTestAlternativeGoals)
{
    local Vector TargetLocation;
    local bool bPathFound;
    local array<Vector> ValidPositions;
    local float GoalHeight, GoalWidth;
    local Vector SavedMovePoint;
    local Actor SavedMoveGoal;
    local float SavedMoveDistSq, MoveDistSq;

    // End:0x43A
    if(!TargetCanBeReached(TargetLocation) && bTestAlternativeGoals)
    {
        // End:0x69
        if(MoveGoal != none)
        {
            MoveGoal.GetBoundingCylinder(GoalHeight, GoalWidth);
        }
        Outer.NavigationHandle.GetValidPositionsForBox(TargetLocation, AlternativeMoveGoalRadius, Outer.MyEvilPawn.GetCollisionExtent(), false, ValidPositions, 5, FMin(AlternativeMoveGoalRadius, ((MoveGoal != none) ? GoalWidth + Outer.MyEvilPawn.GetCollisionRadius() : Outer.MyEvilPawn.GetCollisionRadius())));
        SavedMoveDistSq = VSizeSq((GetMoveGoalLocation()) - Outer.MyEvilPawn.Location);
        SavedMoveGoal = MoveGoal;
        SavedMovePoint = MovePoint;
        J0x1F1:

        // End:0x34E [Loop If]
        if(ValidPositions.Length > 0)
        {
            MovePoint = ValidPositions[Rand(ValidPositions.Length)];
            MoveGoal = none;
            MoveDistSq = VSizeSq(MovePoint - Outer.MyEvilPawn.Location);
            // End:0x335
            if((((MoveDistSq + Square(Outer.MyEvilPawn.GetCollisionRadius())) < SavedMoveDistSq) && MoveDistSq > Square(Outer.MyEvilPawn.GetCollisionRadius() * 4.0000000)) && FindNavMeshPath())
            {
                bPathFound = true;
                // [Explicit Break]
                goto J0x34E;                
            }
            else
            {
                ValidPositions.RemoveItem(MovePoint);
            }
            // [Loop Continue]
            goto J0x1F1;
        }
        J0x34E:

        // End:0x414
        if(bPathFound)
        {
            Outer.MyEvilPawn.DestinationOffset = Outer.MyEvilPawn.GetCollisionRadius();
            GoalDistance = Outer.MyEvilPawn.DestinationOffset;
            ReachedDestinatonThresholdAdjust = 0.0000000;
            return true;            
        }
        else
        {
            MoveGoal = SavedMoveGoal;
            MovePoint = SavedMovePoint;
        }
    }
    // End:0x45F
    if(MoveGoalIsValid())
    {
        bPathFound = FindNavMeshPathToActor();        
    }
    else
    {
        // End:0x482
        if(MovePointIsValid())
        {
            bPathFound = FindNavMeshPathToPoint();
        }
    }
    return bPathFound;
    //return ReturnValue;    
}

function bool FindNavMeshPathToActor()
{
    Outer.NavigationHandle.ClearConstraints();
    Class'Engine.NavMeshPath_Toward'.static.TowardGoal(Outer.NavigationHandle, MoveGoal);
    Class'Engine.NavMeshGoal_At'.static.AtActor(Outer.NavigationHandle, MoveGoal,, bUsePartialNavMeshPath);
    return Outer.NavigationHandle.FindPath();
    //return ReturnValue;    
}

function bool FindNavMeshPathToPoint()
{
    Outer.NavigationHandle.ClearConstraints();
    Class'Engine.NavMeshPath_Toward'.static.TowardPoint(Outer.NavigationHandle, MovePoint);
    Class'Engine.NavMeshGoal_At'.static.AtLocation(Outer.NavigationHandle, MovePoint,, bUsePartialNavMeshPath);
    return Outer.NavigationHandle.FindPath();
    //return ReturnValue;    
}

function bool AccelTurnLegal()
{
    local float AngleDiff, CurrentAngle;
    local Vector LastPos, DestPos;

    // End:0x6B
    if(Outer.NavigationHandle.ActorReachable(MoveGoal))
    {
        DestPos = MoveGoal.Location;        
    }
    else
    {
        DestPos = TempDest;
    }
    AngleDiff = FindDeltaAngle(float(Rotator(DestPos - Outer.Pawn.Location).Yaw) * 0.0000959, float(Outer.Pawn.Rotation.Yaw) * 0.0000959);
    // End:0x1DB
    if((VSize(DestPos - Outer.Pawn.Location) < (Outer.Pawn.GetCollisionRadius() * float(15))) || (Abs(AngleDiff) * 57.2957800) < float(15))
    {
        return false;
    }
    CurrentAngle = 0.0000000;
    LastPos = Outer.Pawn.Location;
    J0x227:

    // End:0x737 [Loop If]
    if(Abs(CurrentAngle) < Abs(AngleDiff))
    {
        // End:0x3FA
        if(AngleDiff < float(0))
        {
            CheckPos.X = LastPos.X + ((Outer.Pawn.GroundSpeed / float(5)) * Cos((float(Outer.Pawn.Rotation.Yaw) * 0.0000959) + CurrentAngle));
            CheckPos.Y = LastPos.Y + ((Outer.Pawn.GroundSpeed / float(5)) * Sin((float(Outer.Pawn.Rotation.Yaw) * 0.0000959) + CurrentAngle));            
        }
        else
        {
            CheckPos.X = LastPos.X + ((Outer.Pawn.GroundSpeed / float(5)) * Cos((float(Outer.Pawn.Rotation.Yaw) * 0.0000959) - CurrentAngle));
            CheckPos.Y = LastPos.Y + ((Outer.Pawn.GroundSpeed / float(5)) * Sin((float(Outer.Pawn.Rotation.Yaw) * 0.0000959) - CurrentAngle));
        }
        CheckPos.Z = (Outer.Pawn.Location.Z + DestPos.Z) / float(2);
        CurrentAngle += ((float(Outer.MyEvilPawn.default.RotationRate.Yaw) * 0.0000959) / float(6));
        // End:0x721
        if(!Outer.NavigationHandle.PointReachable(CheckPos, LastPos) || !Outer.NavigationHandle.PointReachable(DestPos, CheckPos))
        {
            return false;
        }
        LastPos = CheckPos;
        // [Loop Continue]
        goto J0x227;
    }
    return true;
    //return ReturnValue;    
}

function bool ShouldRotateTransition(Vector InFocalPoint, optional out Rotator DesRot, optional out int OutYawDelta)
{
    local float YawAbsDelta;

    // End:0x9A
    if((int(Outer.MyEvilPawn.CurrentMoveMode) == int(0)) && (!MoveGoalIsValid() || EvilNavPoint(MoveGoal) == none) || EvilNavPoint(MoveGoal).bCanSlowDown)
    {
        return true;
    }
    DesRot = Rotator(Normal(InFocalPoint - Outer.MyEvilPawn.Location));
    YawAbsDelta = Abs(float(Outer.MyEvilPawn.TurnInPlaceNode.CheckYawDelta(Outer.MyEvilPawn, DesRot.Yaw)));
    return YawAbsDelta > Outer.MyEvilPawn.TurnInPlaceWhileMovingYawThreshold;
    //return ReturnValue;    
}

function StartingMove(bool DirectMove, Actor Dest, optional bool NormalMoveOnPath = false)
{
    //return;    
}

function TryToRun2Cover(bool bDirectMove, optional bool bForce = false)
{
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Rotator DesRot;
    local int OutYawDelta;

    super(GameAICommand).Tick(DeltaTime);
    DesRot = Normalize(Rotator(Normal(Outer.GetFocalPoint() - Outer.MyEvilPawn.Location)));
    // End:0x147
    if(Outer.MyEvilPawn.CanTurnInPlace())
    {
        OutYawDelta = Outer.MyEvilPawn.TurnInPlaceNode.CheckYawDelta(Outer.MyEvilPawn, DesRot.Yaw);        
    }
    else
    {
        OutYawDelta = 0;
    }
    // End:0x526
    if(!bSmoothTurnsFlag)
    {
        // End:0x523
        if(RSize(Outer.MyEvilPawn.RotationRate) > 0.0000000)
        {
            // End:0x222
            if(Outer.MyEvilPawn.bFastSpinUp || int(Outer.MyEvilPawn.CurrentMoveMode) == int(3))
            {                
            }
            else
            {
                // End:0x32C
                if(Abs(float(OutYawDelta)) > float(16384))
                {
                    Outer.MyEvilPawn.RotationRate.Yaw = int(Lerp(float(Outer.MyEvilPawn.RotationRate.Yaw), float(Outer.MyEvilPawn.default.RotationRate.Yaw * 2), DeltaTime * float(50)));                    
                }
                else
                {
                    // End:0x439
                    if(Abs(float(OutYawDelta)) > float(8192))
                    {
                        Outer.MyEvilPawn.RotationRate.Yaw = int(Lerp(float(Outer.MyEvilPawn.RotationRate.Yaw), float(Outer.MyEvilPawn.default.RotationRate.Yaw) * 1.5000000, DeltaTime * float(50)));                        
                    }
                    else
                    {
                        Outer.MyEvilPawn.RotationRate.Yaw = int(Lerp(float(Outer.MyEvilPawn.RotationRate.Yaw), float(Outer.MyEvilPawn.default.RotationRate.Yaw), DeltaTime * float(50)));
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x5A9
        if(bAccelTurnActive && Abs(float(OutYawDelta)) < (float(15) * 182.0444000))
        {
            Outer.Pawn.Mesh.RootMotionMode = 1;
            bAccelTurnActive = false;
        }
    }
    // End:0x615
    if(Outer.MyEvilPawn.CanSlowDown(self))
    {
        Outer.MyEvilPawn.RequestSlowDown();
    }
    //return;    
}

function Pushed()
{
    local float MoveGoalCollisionRadius, MoveGoalCollisionHeight;
    local EvilPawn MoveGoalPawn;
    local float DistanceToGoal;

    super.Pushed();
    LastForcedDirectMoveTime = -1.0000000;
    OldWalkSlowAnimIndex = Outer.MyEvilPawn.WalkSlowAnimIndex;
    // End:0xC8
    if(int(Outer.Pawn.Physics) == int(0))
    {
        Outer.Pawn.SetMovementPhysics();
    }
    // End:0x186
    if(bForceWalk)
    {
        Outer.MyEvilPawn.WalkSlowAnimIndex = 0;
        // End:0x150
        if(Outer.Pawn.bIsWalking)
        {
            bForceWalk = false;            
        }
        else
        {
            Outer.Pawn.bIsWalking = true;
        }
    }
    // End:0x4C5
    if(MoveGoalIsValid())
    {
        MoveGoalPawn = EvilPawn(MoveGoal);
        DistanceToGoal = VSize(MoveGoal.Location - Outer.MyEvilPawn.Location);
        // End:0x364
        if(MoveGoalPawn != none)
        {
            ReachedDestinatonThresholdAdjust = ((float(Min(int(1.5000000 * MoveGoalPawn.GetCollisionRadius()), int(MoveGoalPawn.MeleeRange))) + Outer.MyEvilPawn.GetCollisionRadius()) + MoveGoalPawn.GetCollisionRadius()) + (DistanceToGoal - Sqrt(Square(DistanceToGoal) - Square(MoveGoalPawn.Location.Z - Outer.MyEvilPawn.Location.Z)));            
        }
        else
        {
            MoveGoal.GetBoundingCylinder(MoveGoalCollisionRadius, MoveGoalCollisionHeight);
            ReachedDestinatonThresholdAdjust = ((float(Min(int(1.5000000 * MoveGoalCollisionRadius), int(Outer.MyEvilPawn.MeleeRange))) + Outer.MyEvilPawn.GetCollisionRadius()) + MoveGoalCollisionRadius) + (DistanceToGoal - Sqrt(Square(DistanceToGoal) - Square(MoveGoal.Location.Z - Outer.MyEvilPawn.Location.Z)));
        }        
    }
    else
    {
        ReachedDestinatonThresholdAdjust = Outer.Pawn.GetCollisionRadius();
    }
    // End:0x567
    if(((MoveGoalIsValid()) && EvilNavPoint(MoveGoal) != none) && !EvilNavPoint(MoveGoal).bCanSlowDown)
    {
        SetDelayedExit(false);        
    }
    else
    {
        Outer.StopLatentExecution();
        Outer.Pawn.ZeroMovementVariables();
    }
    CheckMoveModeToMaster();
    CheckMoveToGoalTimeOut(true);
    GotoState('MoveToGoalState');
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.ClearTimer('MoveToGoalTimedOut', self);
    Outer.ClearTimer('CheckMoveToGoalTimeOut', self);
    Outer.ClearTimer('CheckMoveMode', self);
    CheckMoveModeToMaster(true);
    Outer.NavigationHandle.PathCache_Empty();
    MoveGoal = none;
    // End:0x1DC
    if(Outer.MyEvilPawn != none)
    {
        Outer.MyEvilPawn.WalkSlowAnimIndex = OldWalkSlowAnimIndex;
        Outer.MyEvilPawn.bIsWalking = ((bForceWalk) ? Outer.MyEvilPawn.default.bIsWalking : Outer.MyEvilPawn.bIsWalking);
    }
    //return;    
}

function Paused(GameAICommand NewCommand)
{
    super(GameAICommand).Paused(NewCommand);
    Outer.PauseTimer(true, 'MoveToGoalTimedOut', self);
    Outer.PauseTimer(true, 'CheckMoveToGoalTimeOut', self);
    Outer.PauseTimer(true, 'CheckMoveMode', self);
    // End:0x161
    if(Outer.MyEvilPawn != none)
    {
        // End:0x161
        if((!MoveGoalIsValid() || EvilNavPoint(MoveGoal) == none) || EvilNavPoint(MoveGoal).bCanSlowDown)
        {
            // End:0x161
            if(Outer.ShouldStopOnMoveToGoalPause())
            {
                Outer.MyEvilPawn.ZeroMovementVariables();
            }
        }
    }
    //return;    
}

function Resumed(name OldCommandName)
{
    local bool bReevaluatePath;

    super(GameAICommand).Resumed(OldCommandName);
    // End:0x138
    if(ChildStatus == 'Success')
    {
        bReevaluatePath = true;
        Outer.MyEvilPawn.DestinationOffset = FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust);
        // End:0xA0
        if(HasReachedMoveGoal())
        {
            ExitWithSuccess();            
        }
        else
        {
            Outer.PauseTimer(false, 'MoveToGoalTimedOut', self);
            Outer.PauseTimer(false, 'CheckMoveToGoalTimeOut', self);
            Outer.PauseTimer(false, 'CheckMoveMode', self);
            // End:0x135
            if(bReevaluatePath)
            {
                ReEvaluatePath();
            }
        }        
    }
    else
    {
        Status = 'Aborted';
        Outer.PopCommand(self);
    }
    //return;    
}

function bool ShouldReEvaluatePath()
{
    return true;
    //return ReturnValue;    
}

function ReEvaluatePath()
{
    GotoState('MoveToGoalState', 'Begin');
    //return;    
}

function MoveToGoalTimedOut()
{
    Outer.AbortCommand(self);
    //return;    
}

function CheckMoveToGoalTimeOut(optional bool bInit)
{
    // End:0xFC
    if(bUpdateGoal)
    {
        // End:0xBE
        if(!bInit)
        {
            // End:0xBE
            if(Outer.IsTimerActive('MoveToGoalTimedOut', self) && VSizeSq((GetMoveGoalLocation()) - LastGoalPos) > 64.0000000)
            {
                Outer.SetTimer(Outer.GetMoveTimeOutDuration(GetMoveGoalLocation()), false, 'MoveToGoalTimedOut', self);                
            }
        }
        LastGoalPos = GetMoveGoalLocation();
        Outer.SetTimer(1.0000000, false, GetFuncName(), self);
    }
    //return;    
}

function bool CheckGoalMoved()
{
    // End:0x99
    if(bUpdateGoal && VSizeSq(MoveGoal.Location - Outer.BP2Vect(Outer.NavigationHandle.FinalDestination)) > (GoalDistance ** float(2)))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ForceDirectMove(float inTime)
{
    bForceDirectMove = true;
    Outer.SetTimer(inTime, false, 'ResetDirectMove', self);
    LocationBeforeForcedDirectMove = Outer.Pawn.Location;
    LastForcedDirectMoveTime = Outer.WorldInfo.TimeSeconds;
    //return;    
}

function ResetDirectMove()
{
    bForceDirectMove = false;
    //return;    
}

function bool SetAlternativeNearGoalLocation()
{
    local Vector AltDest;

    // End:0x5F
    if(Outer.GetNearGoalLocation(GoalDistance, GetMoveGoalLocation(), AltDest))
    {
        MoveGoal = none;
        MovePoint = AltDest;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CheckMoveModeToMaster(optional bool bReset)
{
    // End:0xE5
    if(((((MoveGoal == none) || Outer.Master == none) || Outer.Master.MyEvilPawn == none) || MoveGoal != Outer.Master.MyEvilPawn) || EvilAICmd_Base_ScriptedMove(Outer.CommandList) != none)
    {
        return;
    }
    // End:0x7E9
    if(!bReset)
    {
        // End:0x464
        if((!Outer.MyEvilPawn.bStrafing && !(Outer.Master.MyEvilPawn.IsSprinting && bIsDirectMove) && Outer.IsPawnOnTheSameCourse(Outer.Master.MyEvilPawn, 0.9500000)) && VSizeSq(Outer.Master.MyEvilPawn.Location - Outer.MyEvilPawn.Location) < (Outer.MasterDistance_FollowRun * Outer.MasterDistance_FollowRun))
        {
            // End:0x461
            if(((Outer.WorldInfo.TimeSeconds - Outer.LastRunTimeToMaster) > Outer.TimeBetweenWalkAndRun) && (int(Outer.MyEvilPawn.CurrentMoveMode) < int(2)) || int(Outer.MyEvilPawn.CurrentMoveMode) == int(4))
            {
                Outer.MyEvilPawn.ForceLimitedMoveMode(1);
                Outer.MyEvilPawn.bShouldWalkFast = false;
                Outer.LastWalkTimeToMaster = Outer.WorldInfo.TimeSeconds;
            }            
        }
        else
        {
            // End:0x510
            if((Outer.WorldInfo.TimeSeconds - Outer.LastWalkTimeToMaster) > Outer.TimeBetweenWalkAndRun)
            {
                Outer.MyEvilPawn.ForceLimitedMoveMode(6);
            }
        }
        // End:0x7BD
        if(bIsDirectMove)
        {
            // End:0x5B1
            if((int(Outer.MyEvilPawn.CurrentMoveMode) < int(2)) || int(Outer.MyEvilPawn.CurrentMoveMode) == int(4))
            {
                GoalDistance = SavedGoalDistance;                
            }
            else
            {
                // End:0x6D3
                if(VSizeSq(Outer.Master.MyEvilPawn.Velocity) >= VSizeSq(Outer.MyEvilPawn.Velocity))
                {
                    GoalDistance = FMax(Outer.Master.MyEvilPawn.GetCollisionRadius() + Outer.MyEvilPawn.GetCollisionRadius(), SavedGoalDistance * 0.1000000);                    
                }
                else
                {
                    GoalDistance = FMax(Outer.Master.MyEvilPawn.GetCollisionRadius() + Outer.MyEvilPawn.GetCollisionRadius(), SavedGoalDistance * 0.5000000);
                }
            }
            Outer.MyEvilPawn.DestinationOffset = FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust);
        }
        Outer.SetTimer(0.5000000, false, GetFuncName(), self);        
    }
    else
    {
        // End:0x840
        if(Outer.IsTimerActive(GetFuncName(), self))
        {
            Outer.ClearTimer(GetFuncName(), self);
        }
        Outer.MyEvilPawn.ForceLimitedMoveMode(6);
    }
    //return;    
}

state MoveToGoalState
{
    event BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    event EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    event PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    event PausedState()
    {
        super(Object).PausedState();
        //return;        
    }

    event ContinuedState()
    {
        super(Object).ContinuedState();
        //return;        
    }

    event PoppedState()
    {
        super(Object).PoppedState();
        // End:0x94
        if((!MoveGoalIsValid() || EvilNavPoint(MoveGoal) == none) || EvilNavPoint(MoveGoal).bCanSlowDown)
        {
            Outer.Pawn.ZeroMovementVariables();
        }
        //return;        
    }

    simulated function bool CheckRotateTransition(Vector InFocalPoint, float DistanceSq, optional bool InWithFastSpinUp = true)
    {
        local Rotator DesRot;
        local int YawDelta;
        local bool bShouldRotate;

        // End:0x26E
        if((bSmoothTurnsFlag && MoveGoal != none) && InWithFastSpinUp)
        {
            // End:0x97
            if(!Outer.NavigationHandle.PointReachable(MoveGoal.Location))
            {
                bAccelTurnActive = false;
            }
            // End:0x26E
            if(!bAccelTurnActive)
            {
                // End:0x1BE
                if(AccelTurnLegal())
                {
                    Outer.Pawn.Mesh.RootMotionMode = 3;
                    Outer.MyEvilPawn.RotationRate.Yaw = Outer.MyEvilPawn.default.RotationRate.Yaw;
                    bAccelTurnActive = true;
                    Outer.MaxMoveTowardPawnTargetTime = 0.5000000;                    
                }
                else
                {
                    Outer.SetFocalPoint(InFocalPoint);
                    Outer.Pawn.Mesh.RootMotionMode = 1;
                    bAccelTurnActive = false;
                    bShouldRotate = true;
                    Outer.MaxMoveTowardPawnTargetTime = 6.0000000;
                }
            }
        }
        // End:0x582
        if(!bAccelTurnActive)
        {
            // End:0x582
            if((int(Outer.MyEvilPawn.PawnAction) == 0) || !Outer.MyEvilPawn.PawnActions[int(Outer.MyEvilPawn.PawnAction)].bLockPawnRotation)
            {
                Outer.Focus = none;
                Outer.SetFocalPoint(InFocalPoint);
                YawDelta = Class'EvilAnim_TurnInPlace'.static.CheckYawDelta(Outer.MyEvilPawn, Rotator(InFocalPoint - Outer.MyEvilPawn.Location).Yaw);
                // End:0x4C2
                if((InWithFastSpinUp && Outer.CanFastSpinUp(YawDelta)) && DistanceSq > float(200 * 200))
                {
                    Outer.MyEvilPawn.RequestFastSpinUp(YawDelta);
                    bShouldRotate = true;                    
                }
                else
                {
                    // End:0x582
                    if(Outer.MyEvilPawn.CanTurnInPlace() && ShouldRotateTransition(InFocalPoint, DesRot, YawDelta))
                    {
                        Outer.StopLatentExecution();
                        Outer.Pawn.ZeroMovementVariables();
                        bShouldRotate = true;
                    }
                }
            }
        }
        return bShouldRotate;
        //return ReturnValue;        
    }

    function bool GetShiftedApreachDestination(Actor InTarget, out Vector DstPos)
    {
        local Vector DirToMover, DirLeft;

        DirToMover = Normal(Outer.Pawn.Location - InTarget.Location);
        DirLeft = Normal(DirToMover Cross vect(0.0000000, 0.0000000, 1.0000000));
        // End:0xA1
        if(FRand() < 0.5000000)
        {
            DirLeft *= float(-1);
        }
        DstPos = (InTarget.Location + ((DirToMover * float(500)) * RandRange(0.8000000, 1.1000000))) + ((DirLeft * float(100)) * RandRange(0.1000000, 1.0000000));
        // End:0x19D
        if(!Outer.NavigationHandle.PointReachable(DstPos))
        {
            LastAdjustPositionFailTime = Outer.WorldInfo.TimeSeconds;
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    function CheckIfReachable()
    {
        // End:0x43
        if(Outer.NavigationHandle.ActorReachable(MoveGoal))
        {            
        }
        else
        {
            Outer.SetTimer(0.1000000, false, 'CheckIfReachable', self);
        }
        //return;        
    }
Begin:

    Outer.WaitForLanding();
    // End:0xA8
    if(Outer.bMoveToGoalByNavMesh_TryToUnstuck && !Outer.IsPointOnNavMesh(Outer.MyEvilPawn.Location))
    {
        PushState('Unstuck');
    }
    // End:0x10E
    if(Outer.bMoveToGoalByNavMesh_TryAlternativeLocation && !Outer.IsPointOnNavMesh(GetMoveGoalLocation()))
    {
        // End:0x10B
        if(SetAlternativeNearGoalLocation())
        {            
        }        
    }
    J0x10E:

    // End:0x132
    if(HasReachedMoveGoal())
    {
        TryToRun2Cover(false, true);
        goto 'ReachedGoal';
    }
    // End:0x149
    if(ShouldInterruptActiveCommand())
    {
        goto 'End';
    }
DoMove:


    bNavMeshFailedLastTime = false;
    // End:0x1A1
    if(FailedUnstuckCounter <= 0)
    {
        Outer.NavMeshPath_SearchExtent_Modifier = Outer.default.NavMeshPath_SearchExtent_Modifier;
    }
    // End:0x4C0
    if(bForceDirectMove || MoveGoalIsReachable())
    {
        StartingMove(true, MoveGoal);
        // End:0x246
        if(CheckRotateTransition(GetMoveGoalLocation(), VSizeSq(Outer.Pawn.Location - (GetMoveGoalLocation()))))
        {
            Outer.FinishRotation();
        }
        Outer.SetTimer(Outer.GetMoveTimeOutDuration(GetMoveGoalLocation()), false, 'MoveToGoalTimedOut', self);
        LoopFailSafeCounter = 0;
        J0x29F:

        Outer.bMoveFailed = false;
        // End:0x30F
        if(MoveGoalIsValid())
        {
            Outer.MoveToward(MoveGoal, none, FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust));            
        }
        else
        {
            // End:0x35B
            if(MovePointIsValid())
            {
                Outer.MoveTo(MovePoint, none, FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust));
            }
        }
        TryToRun2Cover(true);
        // End:0x3B4
        if(LoopFailSafeCounter > 6)
        {
            Outer.Sleep(RandRange(0.3000000, 0.8000000));
            GotoState('Unstuck');            
        }
        else
        {
            // End:0x3E7
            if(((LoopFailSafeCounter + 1) % 5) == 0)
            {
                Outer.Sleep(0.1000000);
            }
        }
        // End:0x29F
        if(!(((HasReachedMoveGoal()) || !MoveGoalIsReachable() && !bForceDirectMove) || LoopFailSafeCounter++ > MaxMovetowardTries))
            goto J0x29F;
        Outer.ClearTimer('MoveToGoalTimedOut', self);
        // End:0x4B3
        if(LoopFailSafeCounter > MaxMovetowardTries)
        {
            Outer.Sleep(RandRange(0.3000000, 0.8000000));
            PushState('Unstuck');
        }
        goto 'CheckMove';        
    }
    else
    {
        // End:0x6BE
        if(!FindNavMeshPath(,, true))
        {
            NavPathSearchFails++;
            bNavMeshFailedLastTime = true;
            // End:0x532
            if((NavPathSearchFails > MaxNavPathSearchFails) && !Outer.bNavmeshFailForceDirectMove)
            {
                goto 'End';                
            }
            else
            {
                // End:0x6B4
                if(Outer.NavigationHandle.IsAnchorInescapable() || NavPathSearchFails > MaxNavPathSearchFails)
                {
                    // End:0x67A
                    if(MoveGoalIsValid())
                    {
                        // End:0x65E
                        if(((Outer.WorldInfo.TimeSeconds - LastForcedDirectMoveTime) < float(5)) && VSizeSq(LocationBeforeForcedDirectMove - Outer.Pawn.Location) < float(100))
                        {
                            Outer.Sleep(RandRange(0.3000000, 0.8000000));
                            GotoState('Unstuck');                            
                        }
                        else
                        {
                            ForceDirectMove(3.0000000);
                            goto 'DoMove';
                        }                        
                    }
                    else
                    {
                        Outer.Sleep(RandRange(0.3000000, 0.8000000));
                        GotoState('Unstuck');
                    }
                }
                goto 'NeedRepath';
            }
        }
        // End:0x711
        if(Outer.NavigationHandle.GetPathCacheLength() == 0)
        {
            ForceDirectMove(1.0000000);
            goto 'DoMove';
        }
        Outer.ClearTimer('MoveToGoalTimedOut', self);
        NavPathSearchFails = 0;
        StartingMove(false, MoveGoal);
        Outer.NavigationHandle.SetFinalDestination(GetMoveGoalLocation());
        J0x799:

        // End:0xC43 [Loop If]
        if(!HasReachedMoveGoal())
        {
            // End:0x7D7
            if(Outer.Pawn == none)
            {
                goto 'CriticalFailure';
            }
            // End:0x7F2
            if(MoveGoalIsReachable())
            {
                goto 'CheckMove';                
            }
            else
            {
                // End:0x839
                if(Outer.NavigationHandle.GetPathCacheLength() == 0)
                {
                    goto 'NeedRepath';                    
                }
                else
                {
                    // End:0xC13
                    if(Outer.NavigationHandle.GetNextMoveLocation(TempDest, Outer.Pawn.GetCollisionRadius()))
                    {
                        bGetNextMoveLocationFailedLastTime = false;
                        // End:0xC10
                        if(!Outer.NavigationHandle.SuggestMovePreparation(TempDest, Outer))
                        {
                            // End:0x91C
                            if(HasReachedMoveGoal())
                            {
                                goto 'CheckMove';
                            }
                            // End:0x9D4
                            if(VSize2D(TempDest - Outer.Pawn.Location) < (Outer.Pawn.GetCollisionRadius() * 1.4000000))
                            {
                                Outer.NavMeshPath_SearchExtent_Modifier += vect(5.0000000, 5.0000000, 0.0000000);                                
                            }
                            else
                            {
                                Outer.NavMeshPath_SearchExtent_Modifier = Outer.default.NavMeshPath_SearchExtent_Modifier;
                            }
                            StartingMove(false, MoveGoal, true);
                            // End:0xB17
                            if(CheckRotateTransition(TempDest, VSizeSq(Outer.Pawn.Location - (GetMoveGoalLocation())) * (1.0000000 + (float(Outer.NavigationHandle.GetPathCacheLength()) * 0.0500000)), int(Outer.MyEvilPawn.CurrentMoveMode) == int(0)))
                            {
                                Outer.FinishRotation();
                            }
                            Outer.SetTimer(Outer.GetMoveTimeOutDuration(TempDest), false, 'MoveToGoalTimedOut', self);
                            Outer.bMoveFailed = false;
                            Outer.MoveTo(TempDest);
                            TryToRun2Cover(false);
                            // End:0xC10
                            if(Outer.bMoveFailed)
                            {
                                Outer.Sleep(RandRange(0.3000000, 0.8000000));
                                GotoState('Unstuck');
                            }
                        }                        
                    }
                    else
                    {
                        // End:0xC2A
                        if(bGetNextMoveLocationFailedLastTime)
                        {
                            goto 'End';
                        }
                        bGetNextMoveLocationFailedLastTime = true;
                        goto 'NeedRepath';
                    }
                }
            }
            // [Loop Continue]
            goto J0x799;
        }
    }
    // End:0xC5A
    if(CheckGoalMoved())
    {
        goto 'CheckMove';
    }
End:


    // End:0xC75
    if(HasReachedMoveGoal())
    {
        goto 'ReachedGoal';        
    }
    else
    {
        ExitWithFailure();
    }
    J0xC7F:

    ExitWithFailure();
NeedRepath:


    Outer.Sleep(0.2000000);
    goto 'DoMove';
ReachedGoal:


    ExitWithSuccess();
    stop;        
}

state Unstuck
{Begin:

    FailedUnstuckCounter = 0;
Update:


    // End:0xA7
    if(Outer.GetUnstuckLocation(300.0000000, TempDest, GetMoveGoalLocation(), true, 100.0000000))
    {
        Outer.MoveTo(TempDest, none, Outer.Pawn.GetCollisionRadius());        
    }
    else
    {
        FailedUnstuckCounter++;
        // End:0xE9
        if(FailedUnstuckCounter < 3)
        {
            Outer.Sleep(0.3000000);
            goto 'Update';
        }
        ForceDirectMove(1.0000000);
    }
    FailedUnstuckCounter = 0;
    GotoState('MoveToGoalState', 'CheckMove');
    stop;            
}

state RotateToFocusWithoutAnim
{Begin:

    Outer.MyEvilPawn.bCanDoTurnInPlaceAnim = false;
    Outer.FinishRotation();
    Outer.MyEvilPawn.bCanDoTurnInPlaceAnim = Outer.MyEvilPawn.default.bCanDoTurnInPlaceAnim;
    PopState();
    stop;        
}

defaultproperties
{
    MaxMovetowardTries=50
    LastForcedDirectMoveTime=-1.0000000
    bUsePathNotFound=true
    MaxNavPathSearchFails=3
    LastAdjustPositionFailTime=-999.0000000
    AlternativeMoveGoalRadius=300.0000000
    bDelayedExit=false
}