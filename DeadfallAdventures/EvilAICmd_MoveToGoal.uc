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
var transient bool bDeferredSpinUpRequest;
var transient bool bDontChangeFocusOnMove;
var bool bReachedPreciseDestination;
var bool bUsingAlternativeLocation;
var bool bUnstuckFailed;
var int NavPathSearchFails;
var int MaxNavPathSearchFails;
var int LoopFailSafeCounter;
var int FailedPathMoveCounter;
var transient Vector LastGoalPos;
var Vector AdjustDstPosition;
var float LastAdjustPositionFailTime;
var EvilTypesNative.EMoveMode LastMoveMode;
var() float AlternativeMoveGoalRadius;
var Vector SavedMovePoint;
var Actor SavedMoveGoal;
var Vector BreadcrumbsPoint;
var int BreadcrumbsIdx;
var array<Vector> UnstuckLocations;
var int UnstuckLocationIndex;
var float UnstuckSearchRadius;
var Vector UnstuckSearchExtent;

static function bool MoveToGoal(EvilAIController AI, Actor InGoal, optional float InGoalDistance = 0.0000000, optional bool bInUpdateGoal = true, optional bool bInForceWalk = false, optional bool bInShiftDestination = false, optional bool bInDontChangeFocusOnMove, optional bool bInForceDirectMove)
{
    local EvilAICmd_MoveToGoal Cmd;

    // End:0x20F
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
        Cmd.bDontChangeFocusOnMove = bInDontChangeFocusOnMove;
        Cmd.bForceDirectMove = bInForceDirectMove;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool MoveToPoint(EvilAIController AI, Vector InMovePoint, optional float InGoalDistance = 0.0000000, optional bool bInForceWalk = false, optional bool bInForceDirectMove)
{
    local EvilAICmd_MoveToGoal Cmd;

    // End:0x173
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) default.Class;
        Cmd.GoalDistance = InGoalDistance;
        Cmd.bUpdateGoal = false;
        Cmd.MoveGoal = none;
        Cmd.MovePoint = InMovePoint;
        Cmd.bForceWalk = bInForceWalk;
        Cmd.bForceDirectMove = bInForceDirectMove;
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

function bool HasReachedMoveGoal(optional Actor Goal, optional bool bShouldCheckPreciseDest)
{
    local bool bRet;

    // End:0x28
    if(Outer.Pawn == none)
    {
        return true;
    }
    // End:0x4A
    if(Goal == none)
    {
        Goal = MoveGoal;
    }
    Outer.Pawn.DestinationOffset = FMax(10.0000000, GoalDistance - ReachedDestinatonThresholdAdjust);
    // End:0x16B
    if(MoveGoalIsValid())
    {
        // End:0x115
        if(NotEqual_InterfaceInterface(EvilNavPointInterface(Goal), EvilNavPointInterface(none)) && EvilNavPointInterface(Goal).UsePreciseDestination())
        {
            bRet = bReachedPreciseDestination;            
        }
        else
        {
            bRet = Outer.Pawn.ReachedDestination(Goal);
        }
        return bRet;        
    }
    else
    {
        // End:0x1CD
        if(MovePointIsValid())
        {
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

function Vector GetMoveGoalLocation()
{
    local Vector MoveGoalLocation;

    // End:0x18
    if(!GetAndCheckMoveGoalLocation(MoveGoalLocation))
    {
    }
    return MoveGoalLocation;
    //return ReturnValue;    
}

function bool GetAndCheckMoveGoalLocation(optional out Vector MoveGoalLocation)
{
    local bool bResult;

    // End:0x45
    if(MoveGoalIsValid())
    {
        MoveGoalLocation = MoveGoal.Location;
        bResult = true;        
    }
    else
    {
        // End:0x72
        if(MovePointIsValid())
        {
            MoveGoalLocation = MovePoint;
            bResult = true;
        }
    }
    return bResult;
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

function bool FindNavMeshPath(optional bool bFallbackPoint, optional bool bTestAlternativeGoals, optional bool bCheckGoalLocation)
{
    local Vector TargetLocation;
    local bool bPathFound;

    bUsingAlternativeLocation = false;
    TargetLocation = GetMoveGoalLocation();
    // End:0x200
    if(bCheckGoalLocation)
    {
        // End:0x1FD
        if(!Outer.IsPointOnNavMesh(TargetLocation) || (NavPathSearchFails > 0) && int(Outer.NavigationHandle.LastPathError) == int(1))
        {
            // End:0x1FA
            if(bTestAlternativeGoals)
            {
                SavedMoveGoal = MoveGoal;
                SavedMovePoint = MovePoint;
                bPathFound = FindNavMeshPathToAlternativeLocation(TargetLocation);
                // End:0x1D1
                if(bPathFound)
                {
                    Outer.MyEvilPawn.DestinationOffset = Outer.MyEvilPawn.GetCollisionRadius();
                    GoalDistance = Outer.MyEvilPawn.DestinationOffset;
                    ReachedDestinatonThresholdAdjust = 0.0000000;
                    bUsingAlternativeLocation = true;
                    return true;                    
                }
                else
                {
                    MoveGoal = SavedMoveGoal;
                    MovePoint = SavedMovePoint;
                }                
            }            
        }        
    }
    // End:0x225
    if(MoveGoalIsValid())
    {
        bPathFound = FindNavMeshPathToActor();        
    }
    else
    {
        // End:0x248
        if(MovePointIsValid())
        {
            bPathFound = FindNavMeshPathToPoint();
        }
    }
    // End:0x2CF
    if(!bPathFound)
    {
        switch(Outer.NavigationHandle.LastPathError)
        {
            // End:0x29C
            case 0:
                // End:0x2CF
                break;
            // End:0x2A4
            case 1:
                // End:0x2CF
                break;
            // End:0x2AC
            case 2:
                // End:0x2CF
                break;
            // End:0x2B4
            case 3:
                // End:0x2CF
                break;
            // End:0x2BC
            case 4:
                // End:0x2CF
                break;
            // End:0x2C4
            case 5:
                // End:0x2CF
                break;
            // End:0x2CC
            case 6:
                // End:0x2CF
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return bPathFound;
        //return ReturnValue;        
    }
}

function bool FindNavMeshPathToAlternativeLocation(Vector TargetLocation)
{
    local bool bPathFound;
    local array<Vector> ValidPositions;
    local int TriesCount, MaxTriesCount;
    local bool bFoundAltenariveLocation;
    local float ExtentRadiusStep;

    MaxTriesCount = 15;
    AlternativeMoveGoalRadius = 300.0000000;
    ExtentRadiusStep = 70.0000000;
    bPathFound = false;
    TriesCount = 0;
    J0x41:

    // End:0x12B [Loop If]
    if(!bFoundAltenariveLocation && TriesCount < MaxTriesCount)
    {
        Outer.NavigationHandle.GetValidPositionsForBox(TargetLocation, AlternativeMoveGoalRadius, Outer.MyEvilPawn.GetCollisionExtent(), false, ValidPositions, 15);
        bFoundAltenariveLocation = ValidPositions.Length > 0;
        AlternativeMoveGoalRadius += ExtentRadiusStep;
        TriesCount++;
        // [Loop Continue]
        goto J0x41;
    }
    // End:0x13F
    if(!bFoundAltenariveLocation)
    {
        return false;        
    }
    else
    {
        J0x13F:

        // End:0x1C3 [Loop If]
        if((ValidPositions.Length > 0) && !bPathFound)
        {
            MovePoint = ValidPositions[Rand(ValidPositions.Length)];
            MoveGoal = none;
            // End:0x1AA
            if(FindNavMeshPath(,, false, false))
            {
                bPathFound = true;                
            }
            else
            {
                ValidPositions.RemoveItem(MovePoint);                
            }
            // [Loop Continue]
            goto J0x13F;
        }
        return bPathFound;
    }
    //return ReturnValue;    
}

function bool FindNavMeshPathToActor()
{
    Outer.NavigationHandle.ClearConstraints();
    Class'Engine.NavMeshPath_Toward'.static.TowardGoal(Outer.NavigationHandle, MoveGoal);
    Class'Engine.NavMeshGoal_At'.static.AtActor(Outer.NavigationHandle, MoveGoal, Outer.Pawn.DestinationOffset, bUsePartialNavMeshPath);
    return Outer.NavigationHandle.FindPath();
    //return ReturnValue;    
}

function bool FindNavMeshPathToPoint()
{
    Outer.NavigationHandle.ClearConstraints();
    // End:0x16F
    if(Outer.MyEvilPawn.bMovingToCover && !Outer.IsCoveringForced())
    {
        Class'Engine.NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist(Outer.NavigationHandle, float(Max(int(((Outer.Enemy != none) ? VSize(Outer.Enemy.Location - Outer.Pawn.Location) : 2000.0000000)), 1024)), false);
    }
    Class'Engine.NavMeshPath_Toward'.static.TowardPoint(Outer.NavigationHandle, MovePoint);
    Class'Engine.NavMeshGoal_At'.static.AtLocation(Outer.NavigationHandle, MovePoint, Outer.Pawn.DestinationOffset, bUsePartialNavMeshPath);
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
    // End:0x689
    if(ShouldUpdateBreadCrumbs())
    {
        Outer.NavigationHandle.UpdateBreadCrumbs(Outer.Pawn.Location);
    }
    Outer.NavigationHandle.DrawBreadCrumbs();
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
    GotoState('MoveToGoalState');
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.ClearTimer('CheckMoveMode', self);
    CheckMoveModeToMaster(true);
    Outer.NavigationHandle.PathCache_Empty();
    MoveGoal = none;
    // End:0x18A
    if(Outer.MyEvilPawn != none)
    {
        Outer.MyEvilPawn.WalkSlowAnimIndex = OldWalkSlowAnimIndex;
        Outer.MyEvilPawn.bIsWalking = ((bForceWalk) ? Outer.MyEvilPawn.default.bIsWalking : Outer.MyEvilPawn.bIsWalking);
    }
    Outer.bPreciseDestination = false;
    //return;    
}

function Paused(GameAICommand NewCommand)
{
    super(GameAICommand).Paused(NewCommand);
    Outer.PauseTimer(true, 'CheckMoveMode', self);
    CheckMoveModeToMaster(true);
    // End:0x118
    if(Outer.MyEvilPawn != none)
    {
        // End:0x118
        if((!MoveGoalIsValid() || EvilNavPoint(MoveGoal) == none) || EvilNavPoint(MoveGoal).bCanSlowDown)
        {
            // End:0x118
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
    // End:0xE5
    if(ChildStatus == 'Success')
    {
        bReevaluatePath = true;
        Outer.MyEvilPawn.DestinationOffset = FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust);
        // End:0xA1
        if(HasReachedMoveGoal())
        {
            ExitWithSuccess();            
        }
        else
        {
            Outer.PauseTimer(false, 'CheckMoveMode', self);
            // End:0xE2
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

function ReachedPreciseDestination()
{
    super.ReachedPreciseDestination();
    bReachedPreciseDestination = true;
    //return;    
}

function bool SetAlternativeNearGoalLocation()
{
    local Vector AltDest;

    // End:0x5E
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

function bool ShouldUpdateBreadCrumbs()
{
    // End:0x14
    if(!bForceDirectMove)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
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

    function bool StopMovingToAlternativeLocation()
    {
        // End:0x50
        if(SavedMoveGoal != none)
        {
            return Outer.IsPointOnNavMesh(SavedMoveGoal.Location);            
        }
        else
        {
            // End:0x92
            if(MovePointIsValid(SavedMovePoint))
            {
                return Outer.IsPointOnNavMesh(SavedMovePoint);                
            }
            else
            {
                return false;
            }
        }
        //return ReturnValue;        
    }

    simulated function bool CheckRotateTransition(Vector InFocalPoint, float DistanceSq, optional bool InWithFastSpinUp = true)
    {
        local Rotator DesRot;
        local int YawDelta;
        local bool bShouldRotate;
        local EvilTypes.ESpinUpQueryResult SUQR;

        bDontChangeFocusOnMove = bDontChangeFocusOnMove && (int(Outer.MyEvilPawn.SupremeMoveMode) <= int(1)) || Outer.MyEvilPawn.bIsWalking;
        // End:0x72A
        if(!bDontChangeFocusOnMove)
        {
            // End:0x30B
            if((bSmoothTurnsFlag && MoveGoal != none) && InWithFastSpinUp)
            {
                // End:0x134
                if(!Outer.NavigationHandle.PointReachable(MoveGoal.Location))
                {
                    bAccelTurnActive = false;
                }
                // End:0x30B
                if(!bAccelTurnActive)
                {
                    // End:0x25B
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
            // End:0x72A
            if(!bAccelTurnActive)
            {
                // End:0x72A
                if((int(Outer.MyEvilPawn.PawnAction) == 0) || !Outer.MyEvilPawn.PawnActions[int(Outer.MyEvilPawn.PawnAction)].bLockPawnRotation)
                {
                    Outer.Focus = none;
                    Outer.SetFocalPoint(InFocalPoint);
                    // End:0x72A
                    if(ShouldRotateTransition(InFocalPoint, DesRot, YawDelta))
                    {
                        YawDelta = Class'EvilAnim_TurnInPlace'.static.CheckYawDelta(Outer.MyEvilPawn, Rotator(InFocalPoint - Outer.MyEvilPawn.Location).Yaw);
                        // End:0x5CF
                        if(InWithFastSpinUp)
                        {
                            SUQR = Outer.CanFastSpinUp(YawDelta, DistanceSq);
                            // End:0x5CF
                            if((int(SUQR) == int(1)) && Outer.MyEvilPawn.CanTurnInPlace())
                            {
                                SUQR = Outer.CanFastSpinUp(0, DistanceSq);
                                // End:0x5CF
                                if(int(SUQR) == int(0))
                                {
                                    bDeferredSpinUpRequest = true;
                                }
                            }
                        }
                        // End:0x694
                        if(int(SUQR) == int(0))
                        {
                            // End:0x646
                            if(bDeferredSpinUpRequest)
                            {
                                Outer.StopLatentExecution();
                                Outer.Pawn.ZeroMovementVariables();                                
                            }
                            else
                            {
                                Outer.MyEvilPawn.RequestFastSpinUp(YawDelta);
                            }
                            bShouldRotate = true;                            
                        }
                        else
                        {
                            // End:0x72A
                            if(Outer.MyEvilPawn.CanTurnInPlace())
                            {
                                Outer.StopLatentExecution();
                                Outer.Pawn.ZeroMovementVariables();
                                bShouldRotate = true;
                            }
                        }
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
    Outer.MyEvilPawn.UnregisterNavmeshObstacle();
CheckMove:


    // End:0x94
    if(HasReachedMoveGoal(,, true))
    {
        Outer.InvalidateCover(,, true, true);
        TryToRun2Cover(false, true);
        goto 'ReachedGoal';
    }
    // End:0xAB
    if(ShouldInterruptActiveCommand())
    {
        goto 'End';
    }
DoMove:


    // End:0xC5
    if(!GetAndCheckMoveGoalLocation())
    {
        goto 'End';
    }
    Outer.NavMeshPath_SearchExtent_Modifier = Outer.default.NavMeshPath_SearchExtent_Modifier;
    // End:0x934
    if(bForceDirectMove || MoveGoalIsReachable())
    {
DirectMove:


        // End:0x12F
        if(bForceDirectMove)
        {            
        }
        StartingMove(true, MoveGoal);
        FailedPathMoveCounter = 0;
        // End:0x1C0
        if(CheckRotateTransition(GetMoveGoalLocation(), VSizeSq(Outer.Pawn.Location - (GetMoveGoalLocation()))))
        {
            Outer.FinishRotation();
        }
        // End:0x210
        if(bDeferredSpinUpRequest)
        {
            Outer.MyEvilPawn.RequestFastSpinUp(0);
            bDeferredSpinUpRequest = false;
        }
        LoopFailSafeCounter = 0;
        J0x21B:

        Outer.bMoveFailed = false;
        // End:0x267
        if(!MoveGoalIsReachable() && !bForceDirectMove)
        {
            goto 'CheckMove';
        }
        // End:0x48E
        if(MoveGoalIsValid())
        {
            // End:0x41F
            if(NotEqual_InterfaceInterface(EvilNavPointInterface(MoveGoal), EvilNavPointInterface(none)) && EvilNavPointInterface(MoveGoal).UsePreciseDestination())
            {
                Outer.MyEvilPawn.DestinationOffset = -Outer.MyEvilPawn.GetCollisionRadius() + 5.0000000;
                Outer.SetDestinationPosition(MoveGoal.Location);
                bReachedPreciseDestination = false;
                Outer.bPreciseDestination = true;
                Outer.MoveTo(MoveGoal.Location,, -Outer.MyEvilPawn.GetCollisionRadius() + 5.0000000);                
            }
            else
            {
                Outer.MoveToward(MoveGoal, ((bDontChangeFocusOnMove) ? Outer.Focus : none), FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust));
            }            
        }
        else
        {
            // End:0x507
            if(MovePointIsValid())
            {
                Outer.MoveTo(MovePoint, ((bDontChangeFocusOnMove) ? Outer.Focus : none), FMax(0.0000000, GoalDistance - ReachedDestinatonThresholdAdjust));
            }
        }
        TryToRun2Cover(true);
        // End:0x567
        if(LoopFailSafeCounter > MaxMovetowardTries)
        {
            Outer.Sleep(RandRange(0.3000000, 0.8000000));
            GotoState('Unstuck');            
        }
        else
        {
            // End:0x59A
            if(((LoopFailSafeCounter + 1) % 5) == 0)
            {
                Outer.Sleep(0.1000000);
            }
        }
        // End:0x5CA
        if(Outer.bMoveFailed)
        {
            LoopFailSafeCounter++;            
        }
        else
        {
            bUnstuckFailed = false;
        }
        // End:0x21B
        if(!((HasReachedMoveGoal()) || !GetAndCheckMoveGoalLocation()))
            goto J0x21B;
        // End:0x927
        if((((HasReachedMoveGoal()) && MoveGoalIsValid()) && NotEqual_InterfaceInterface(EvilNavPointInterface(MoveGoal), EvilNavPointInterface(none))) && EvilNavPointInterface(MoveGoal).UsePreciseDestination())
        {
            Outer.MyEvilPawn.Mesh.RootMotionMode = 2;
            Outer.MyEvilPawn.DestinationOffset = -Outer.MyEvilPawn.GetCollisionRadius() + 0.1000000;
            Outer.SetDestinationPosition(MoveGoal.Location);
            bReachedPreciseDestination = false;
            Outer.bPreciseDestination = true;
            J0x795:

            Outer.Sleep(0.1000000);
            // End:0x795
            if(!(bReachedPreciseDestination))
                goto J0x795;
            Outer.bPreciseDestination = false;
            Outer.MyEvilPawn.Mesh.RootMotionMode = Outer.MyEvilPawn.Mesh.default.RootMotionMode;
            Outer.Focus = none;
            Outer.SetFocalPoint(Outer.MyEvilPawn.Location + (Normal(Vector(MoveGoal.Rotation)) * 100.0000000));
            Outer.FinishRotation();
        }
        goto 'CheckMove';        
    }
    else
    {
        // End:0x999
        if(!Outer.IsPointOnNavMesh(Outer.MyEvilPawn.Location))
        {
            GotoState('Fallback_Breadcrumbs');
        }
        // End:0xBC4
        if(!FindNavMeshPath(,, true, true))
        {
            // End:0xBB7
            if(!Outer.MyEvilPawn.bMovingToCover || Outer.IsCoveringForced())
            {
                NavPathSearchFails++;
                // End:0xA7C
                if(int(Outer.NavigationHandle.LastPathError) == int(0))
                {
                    Outer.Sleep(0.1000000);
                    GotoState('Fallback_Breadcrumbs');
                }
                // End:0xADE
                if(Outer.NavigationHandle.IsAnchorInescapable())
                {
                    Outer.Sleep(0.1000000);
                    GotoState('Fallback_Breadcrumbs');
                }
                // End:0xB70
                if(NavPathSearchFails > MaxNavPathSearchFails)
                {
                    // End:0xB33
                    if(Outer.bNavmeshFailForceDirectMove)
                    {
                        ForceDirectMove(3.0000000);
                        goto 'DoMove';                        
                    }
                    else
                    {
                        Outer.Sleep(RandRange(0.3000000, 0.8000000));
                        GotoState('Unstuck');
                    }                    
                }
                else
                {
                    Outer.NavMeshPath_SearchExtent_Modifier += (vect(-1.0000000, -1.0000000, 0.0000000) * float(NavPathSearchFails));
                    goto 'NeedRepath';
                }                
            }
            else
            {
                goto 'End';
            }            
        }
        J0xBC4:

        // End:0xC17
        if(Outer.NavigationHandle.GetPathCacheLength() == 0)
        {
            ForceDirectMove(1.0000000);
            goto 'DoMove';
        }
        NavPathSearchFails = 0;
        StartingMove(false, MoveGoal);
        Outer.NavigationHandle.SetFinalDestination(GetMoveGoalLocation());
        // End:0xD3A
        if((Outer.NavigationHandle.GetPathCacheLength() > 0) && Outer.ShouldTeleportToGoal(GetMoveGoalLocation()))
        {
            // End:0xD16
            if(bUsingAlternativeLocation)
            {
                Outer.TeleportToGoal(MovePoint);                
            }
            else
            {
                Outer.TeleportToGoal();
            }            
        }
        J0xD3A:

        // End:0x12A5 [Loop If]
        if(!HasReachedMoveGoal())
        {
            // End:0xD79
            if(Outer.Pawn == none)
            {
                goto 'CriticalFailure';
            }
            // End:0xDCF
            if(bUsingAlternativeLocation)
            {
                // End:0xDCF
                if(StopMovingToAlternativeLocation())
                {
                    MovePoint = SavedMovePoint;
                    MoveGoal = SavedMoveGoal;
                    bUsingAlternativeLocation = false;
                    goto 'CheckMove';
                }
            }
            // End:0xDEA
            if(MoveGoalIsReachable())
            {
                goto 'CheckMove';                
            }
            else
            {
                // End:0xE31
                if(Outer.NavigationHandle.GetPathCacheLength() == 0)
                {
                    goto 'NeedRepath';                    
                }
                else
                {
                    // End:0x1275
                    if(Outer.NavigationHandle.GetNextMoveLocation(TempDest, Outer.Pawn.GetCollisionRadius()))
                    {
                        bGetNextMoveLocationFailedLastTime = false;
                        // End:0x1272
                        if(!Outer.NavigationHandle.SuggestMovePreparation(TempDest, Outer))
                        {
                            // End:0xF15
                            if(HasReachedMoveGoal())
                            {
                                goto 'CheckMove';
                            }
                            // End:0xFCD
                            if(VSize2D(TempDest - Outer.Pawn.Location) < (Outer.Pawn.GetCollisionRadius() * 1.4000000))
                            {
                                Outer.NavMeshPath_SearchExtent_Modifier += vect(8.0000000, 8.0000000, 0.0000000);                                
                            }
                            else
                            {
                                Outer.NavMeshPath_SearchExtent_Modifier = Outer.default.NavMeshPath_SearchExtent_Modifier;
                            }
                            StartingMove(false, MoveGoal, true);
                            // End:0x110F
                            if(CheckRotateTransition(TempDest, VSizeSq(Outer.Pawn.Location - (GetMoveGoalLocation())) * (1.0000000 + (float(Outer.NavigationHandle.GetPathCacheLength()) * 0.0500000)), int(Outer.MyEvilPawn.CurrentMoveMode) == int(0)))
                            {
                                Outer.FinishRotation();
                            }
                            // End:0x115F
                            if(bDeferredSpinUpRequest)
                            {
                                Outer.MyEvilPawn.RequestFastSpinUp(0);
                                bDeferredSpinUpRequest = false;
                            }
                            Outer.bMoveFailed = false;
                            Outer.MoveTo(TempDest, ((bDontChangeFocusOnMove) ? Outer.Focus : none));
                            TryToRun2Cover(false);
                            // End:0x1264
                            if(Outer.bMoveFailed)
                            {
                                FailedPathMoveCounter++;
                                Outer.Sleep(RandRange(0.3000000, 0.8000000));
                                // End:0x1253
                                if(FailedPathMoveCounter <= 3)
                                {
                                    goto 'CheckMove';                                    
                                }
                                else
                                {
                                    GotoState('Unstuck');
                                }                                
                            }
                            else
                            {
                                FailedPathMoveCounter = 0;
                            }                            
                        }                        
                    }
                    else
                    {
                        // End:0x128C
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
            goto J0xD3A;
        }
    }
    // End:0x12BC
    if(CheckGoalMoved())
    {
        goto 'CheckMove';
    }
End:


    // End:0x12D8
    if(HasReachedMoveGoal())
    {
        goto 'ReachedGoal';        
    }
    else
    {
        // End:0x136A
        if((MoveGoal != none) && EvilNavPoint(MoveGoal) != none)
        {
            // End:0x136A
            if(!Outer.ExposedToPlayer())
            {
                // End:0x136A
                if(Outer.TeleportToGoal(,, MoveGoal))
                {
                    // End:0x136A
                    if(HasReachedMoveGoal())
                    {
                        goto 'ReachedGoal';
                    }
                }
            }
        }
        ExitWithFailure();
    }
    J0x1374:

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

    // End:0x23
    if(bUnstuckFailed)
    {
        GotoState('MoveToGoalState', 'End');
    }
    UnstuckSearchRadius = 200.0000000;
    UnstuckLocationIndex = 0;
    // End:0x66
    if(UnstuckLocations.Length > 0)
    {
        UnstuckLocations.Remove(0, UnstuckLocations.Length - 1);        
    }
GetLocations:


    UnstuckSearchExtent = Outer.Pawn.GetCollisionExtent();
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(Outer.Pawn.Location, UnstuckSearchRadius, UnstuckSearchExtent, true, UnstuckLocations, 15);
    // End:0x1B5
    if(UnstuckLocations.Length <= 0)
    {
        Outer.GetValidPositionsNearLocation(Outer.Pawn.Location, Outer.Pawn.GetCollisionExtent(), UnstuckLocations);
    }
Update:


    // End:0x353
    if(UnstuckLocations.Length > 0)
    {
        TempDest = UnstuckLocations[Rand(UnstuckLocations.Length)];
        UnstuckLocations.RemoveItem(TempDest);        
        Outer.SetUnstuckSeartStart(true, TempDest);
        // End:0x2A0
        if(MoveGoalIsReachable())
        {
            bUnstuckFailed = false;
            Outer.SetUnstuckSeartStart(false);
            Outer.MoveTo(TempDest, none, 1.0000000, true);
            GotoState('MoveToGoalState', 'DirectMove');            
        }
        else
        {
            // End:0x31E
            if(FindNavMeshPath(,, false, false))
            {
                Outer.SetUnstuckSeartStart(false);
                Outer.MoveTo(TempDest, none, 1.0000000, true);
                GotoState('MoveToGoalState', 'FoundPath');
                bUnstuckFailed = false;                
            }
            else
            {
                UnstuckLocationIndex++;
                Outer.Sleep(1.0000000);
                goto 'Update';
            }
        }        
    }
    else
    {
UnstuckFailed:


        bUnstuckFailed = true;
        ForceDirectMove(3.0000000);
    }
    Outer.SetUnstuckSeartStart(false);
    GotoState('MoveToGoalState', 'CheckMove');
    stop;            
}

state Fallback_Breadcrumbs
{
    function bool ShouldUpdateBreadCrumbs()
    {
        return false;
        //return ReturnValue;        
    }

    function bool HandlePathObstruction(Actor BlockedBy)
    {
        Outer.MoveTimer = -1.0000000;
        GotoState('Fallback_Breadcrumbs', 'Begin');
        return true;
        //return ReturnValue;        
    }
Begin:

    BreadcrumbsIdx = 0;
    J0x0B:

    // End:0x53 [Loop If]
    if(BreadcrumbsIdx < Outer.NavigationHandle.10)
    {
        BreadcrumbsIdx++;
        // [Loop Continue]
        goto J0x0B;
    }
Loop:


    // End:0x18F
    if(Outer.NavigationHandle.GetNextBreadCrumb(BreadcrumbsPoint))
    {
        Outer.MoveToDirectNonPathPos(BreadcrumbsPoint);
        // End:0x165
        if(!Outer.NavigationHandle.IsAnchorInescapable())
        {
            // End:0x14F
            if(Outer.IsPointOnNavMesh(Outer.Pawn.Location))
            {                
            }
            GotoState('MoveToGoalState', 'CheckMove');
        }
        Outer.Sleep(0.1000000);
        goto 'Loop';        
    }
    else
    {
        // End:0x1D9
        if(!Outer.NavigationHandle.IsAnchorInescapable())
        {
            GotoState('Unstuck');            
        }
        else
        {
            GotoState('Unstuck');
        }
    }
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
    MaxMovetowardTries=6
    LastForcedDirectMoveTime=-1.0000000
    bUsePathNotFound=true
    MaxNavPathSearchFails=3
    LastAdjustPositionFailTime=-999.0000000
    AlternativeMoveGoalRadius=300.0000000
    bDelayedExit=false
}