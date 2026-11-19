class TurokAnimLadderController extends ActorComponent
    implements(TurokAnimInterfaceGraphNotify);

enum ELadderState
{
    LADDERSTATE_Undefined,          // 0
    LADDERSTATE_ClimbUp,            // 1
    LADDERSTATE_ClimbDown,          // 2
    LADDERSTATE_ClimbOffBottom,     // 3
    LADDERSTATE_ClimbOffTop,        // 4
    LADDERSTATE_ClimbOnBottom,      // 5
    LADDERSTATE_ClimbOnTop,         // 6
    LADDERSTATE_ClimbIdle,          // 7
    LADDERSTATE_Finished,           // 8
    LADDERSTATE_MAX                 // 9
};

var transient byte mLadderState;
var transient float mClimbOffBottomVerticalMotion;
var transient float mClimbOffTopVerticalMotion;
var transient float mFrameTime;
var transient float mClimbSpeed;
var transient bool mbRightFoot;
var private transient bool mbClimbing;
var transient @NULL mCachedGraph;
var private transient @NULL mLadderClimbDownDirection;
var private transient @NULL mLadderClimbUpDirection;
var private transient @NULL mStartActionLoc;
var private transient @NULL mStartActionRot;
var private transient int mCurrentRungFromStart;
var private const transient @NULL mNormVectorBetweenRungs;

function Tick(float DeltaTime)
{
    local @NULL graph;

    // End:0x4C
    if(IsClimbing())
    {
        mFrameTime = DeltaTime;
        switch(mLadderState)
        {
            // End:0x49
            case 7:
                graph = GetNextGraphFromIdle();
                // End:0x46
                if(graph != none)
                {
                    PlayTransitionGraphs(graph);
                }
                // End:0x4C
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

function bool CanStartClimbing(@NULL Ladder)
{
    local @NULL TraceStart, TraceEnd, Unused, OtherPawn;
    local byte ExpectedClimbState;

    // End:0x0D
    if(Ladder == none)
    {
        return false;
    }
    Ladder.GetTopEdgeLocationRotation(TraceStart, Unused);
    // End:0x7A
    if(Owner.Location.Z > TraceStart.Z)
    {
        TraceEnd = TraceStart - (mNormVectorBetweenRungs * 2.0000000);
        ExpectedClimbState = 6;        
    }
    else
    {
        Ladder.GetBottomEdgeLocationRotation(TraceStart, Unused);
        TraceEnd = TraceStart + mNormVectorBetweenRungs;
        ExpectedClimbState = 5;
    }
    // End:0x127
    foreach Ladder.TouchingActors(Class'TurokPawn', OtherPawn)
    {
        // End:0xDD
        if(OtherPawn == Owner)
        {
            continue;            
        }
        // End:0x126
        if(OtherPawn.mLadderController.IsClimbing() && int(OtherPawn.mLadderController.mLadderState) == int(ExpectedClimbState))
        {            
            return false;
        }        
    }    
    TraceStart.Z += GetTurokPawn().GetCollisionHeight();
    TraceEnd.Z += GetTurokPawn().GetCollisionHeight();
    return CanMoveWithoutLadderCollision(Owner.Location, TraceStart, Ladder) && CanMoveWithoutLadderCollision(TraceStart, TraceEnd, Ladder);
    //return ReturnValue;    
}

function InitSequence()
{
    local @NULL TP, graphSet, graph, topPosition, topRotation;

    TP = GetTurokPawn();
    mLadderState = 0;
    // End:0x23
    if(GetLadder() == none)
    {        
    }
    else
    {
        graphSet = GetGraphSet();
        // End:0x3D
        if(graphSet == none)
        {            
        }
        else
        {
            mLadderClimbDownDirection = Vector(rot(40958, 0, 0) + GetLadder().WallDir);
            mLadderClimbUpDirection = Vector(rot(8191, 0, 0) + GetLadder().WallDir);
            // End:0xB4
            if(int(TP.Role) != int(ROLE_Authority))
            {
                SetClimbing(true);
                return;                
            }
            else
            {
                GetLadder().GetTopEdgeLocationRotation(topPosition, topRotation);
                // End:0x15B
                if(Owner.Location.Z > topPosition.Z)
                {
                    // End:0x136
                    if(GetLadder().mbIsVineLadder)
                    {
                        graph = graphSet.FindGraph('climbontopvine');                        
                    }
                    else
                    {
                        graph = graphSet.FindGraph('climbontop');
                    }                    
                }
                else
                {
                    graph = graphSet.FindGraph('climbonbottom');
                }
            }
            // End:0x18B
            if(graph == none)
            {                
            }
            else
            {
                PlayTransitionGraphs(graph);
                SetClimbing(true);
                return;
            }
        }
    }
    FinishLadderGracefully();
    GetTurokPawn().EndClimbing();
    return;
    //return;    
}

function bool IsClimbing()
{
    return mbClimbing;
    //return ReturnValue;    
}

function bool IsDuringEndAnimation()
{
    return (int(mLadderState) == int(4)) || int(mLadderState) == int(3);
    //return ReturnValue;    
}

function bool IsDuringStartAnimation()
{
    return (int(mLadderState) == int(6)) || int(mLadderState) == int(5);
    //return ReturnValue;    
}

simulated function SetClimbing(bool climbing)
{
    mbClimbing = climbing;
    //return;    
}

simulated function FinishLadderGracefully()
{
    local @NULL tPawn;

    tPawn = GetTurokPawn();
    // End:0x76
    if(int(tPawn.Role) == int(ROLE_Authority))
    {
        // End:0x4D
        if((IsClimbing()) && GetLadder() != none)
        {
            JumpOffLadder();            
        }
        else
        {
            // End:0x76
            if(!tPawn.SetLocation(tPawn.Location))
            {
                JumpOffLadder();
            }
        }
    }
    mCachedGraph = none;
    mLadderState = 0;
    SetClimbing(false);
    //return;    
}

simulated function JumpOffLadder()
{
    local @NULL tPawn, topPosition, topRotation, NewPos;

    tPawn = GetTurokPawn();
    GetLadder().GetTopEdgeLocationRotation(topPosition, topRotation);
    NewPos.X = -tPawn.CylinderComponent.CollisionRadius * 3.0000000;
    NewPos.Y = 0.0000000;
    NewPos.Z = 0.0000000;
    NewPos = NewPos >> GetLadder().WallDir;
    NewPos.X += topPosition.X;
    NewPos.Y += topPosition.Y;
    NewPos.Z = tPawn.Location.Z;
    tPawn.SetLocation(NewPos);
    //return;    
}

private final function @NULL GetNextGraphFromIdle()
{
    // End:0xBD
    if(IsMovingUp() && CanClimbUp())
    {
        // End:0x72
        if(CanClimbOffTop())
        {
            // End:0x51
            if(GetLadder().mbIsVineLadder)
            {
                return GetGraphSet().FindGraph('climbofftopvine');                
            }
            else
            {
                return GetGraphSet().FindGraph('climbofftop');
            }            
        }
        else
        {
            // End:0x9C
            if(mbRightFoot)
            {
                return GetGraphSet().FindGraph('climbcycleright');                
            }
            else
            {
                return GetGraphSet().FindGraph('climbcycleleft');
            }
        }        
    }
    else
    {
        // End:0x146
        if(IsMovingDown() && CanClimbDown())
        {
            // End:0xFB
            if(CanClimbOffBottom())
            {
                return GetGraphSet().FindGraph('climboffbottom');                
            }
            else
            {
                // End:0x125
                if(mbRightFoot)
                {
                    return GetGraphSet().FindGraph('climbcycledownright');                    
                }
                else
                {
                    return GetGraphSet().FindGraph('climbcycledownleft');
                }
            }            
        }
        else
        {
            return none;
        }
    }
    //return ReturnValue;    
}

private final function @NULL GetTurokPawn()
{
    return TurokPawn(Owner);
    //return ReturnValue;    
}

private final function @NULL GetGraphSet()
{
    return GetTurokPawn().mClimbingGraphSet;
    //return ReturnValue;    
}

private final function bool CanClimbOffTop()
{
    local @NULL edgePos, edgeRot;
    local float buffer;

    buffer = 10.0000000;
    GetLadder().GetTopEdgeLocationRotation(edgePos, edgeRot);
    return ((GetTurokPawn().Location.Z + GetTurokPawn().Mesh.Translation.Z) + mClimbOffTopVerticalMotion) > (edgePos.Z - buffer);
    //return ReturnValue;    
}

private final function bool CanClimbOffBottom()
{
    local @NULL edgePos, edgeRot;
    local float buffer;

    buffer = 10.0000000;
    GetLadder().GetBottomEdgeLocationRotation(edgePos, edgeRot);
    return ((GetTurokPawn().Location.Z + GetTurokPawn().Mesh.Translation.Z) + mClimbOffBottomVerticalMotion) < (edgePos.Z + buffer);
    //return ReturnValue;    
}

private final function bool CanClimbUp()
{
    local @NULL currentRestingRung, destinationRung;
    local bool CollisionOK;

    currentRestingRung = mStartActionLoc + (float(mCurrentRungFromStart) * mNormVectorBetweenRungs);
    destinationRung = currentRestingRung + mNormVectorBetweenRungs;
    destinationRung.Z += GetTurokPawn().GetCollisionHeight();
    CollisionOK = CanMoveWithoutLadderCollision(Owner.Location, destinationRung, GetLadder());
    // End:0xD6
    if(CollisionOK && CanClimbOffTop())
    {
        destinationRung += mNormVectorBetweenRungs;
        CollisionOK = CanMoveWithoutLadderCollision(destinationRung, destinationRung + (vect(100.0000000, 0.0000000, 0.0000000) >> GetLadder().WallDir), GetLadder());
    }
    return CollisionOK;
    //return ReturnValue;    
}

private final function bool CanClimbDown()
{
    local @NULL currentRestingRung, destinationRung, bottomEdge, Unused;
    local bool CollisionOK;

    currentRestingRung = mStartActionLoc + (float(mCurrentRungFromStart) * mNormVectorBetweenRungs);
    destinationRung = currentRestingRung - (mNormVectorBetweenRungs * 2.0000000);
    destinationRung.Z += GetTurokPawn().GetCollisionHeight();
    CollisionOK = CanMoveWithoutLadderCollision(Owner.Location, destinationRung, GetLadder());
    // End:0x114
    if(CollisionOK && CanClimbOffBottom())
    {
        GetLadder().GetBottomEdgeLocationRotation(bottomEdge, Unused);
        bottomEdge.Z += GetTurokPawn().GetCollisionHeight();
        CollisionOK = CanMoveWithoutLadderCollision(bottomEdge, bottomEdge + (vect(-20.0000000, 0.0000000, 0.0000000) >> GetLadder().WallDir), GetLadder());
    }
    return CollisionOK;
    //return ReturnValue;    
}

private final function bool CanMoveWithoutLadderCollision(@NULL TraceStart, @NULL TraceEnd, @NULL Ladder)
{
    local @NULL HitLocation, HitNormal, pawnIdleLoc, ClimbOffset, TP, Pawn;

    TP = GetTurokPawn();
    ClimbOffset.X = TP.GetCollisionRadius();
    ClimbOffset = ClimbOffset >> Ladder.WallDir;
    TraceStart = TraceStart - ClimbOffset;
    TraceEnd = TraceEnd - ClimbOffset;
    // End:0x147
    foreach TP.TraceActors(Class'TurokPawn', Pawn, HitLocation, HitNormal, TraceEnd, TraceStart, TP.GetCollisionExtent() * 0.8000000)
    {
        // End:0x143
        if((Pawn.OnLadder != none) && TP.OnLadder != none)
        {
            pawnIdleLoc = Pawn.mLadderController.mStartActionLoc + (float(Pawn.mLadderController.mCurrentRungFromStart) * mNormVectorBetweenRungs);
            // End:0x140
            if(VSize(pawnIdleLoc - TraceEnd) <= VSize(mNormVectorBetweenRungs * 2.0000000))
            {                
                return false;
            }
            // End:0x146
            continue;
        }        
        return false;        
    }    
    return true;
    //return ReturnValue;    
}

private final function bool IsMovingUp()
{
    // End:0x1B
    if(int(Owner.Role) != int(ROLE_Authority))
    {
        return false;
    }
    return (Owner.Acceleration Dot mLadderClimbUpDirection) > 0.0000000;
    //return ReturnValue;    
}

private final function bool IsMovingDown()
{
    // End:0x1B
    if(int(Owner.Role) != int(ROLE_Authority))
    {
        return false;
    }
    return (Owner.Acceleration Dot mLadderClimbDownDirection) > 0.0000000;
    //return ReturnValue;    
}

private final function @NULL GetLadder()
{
    return TurokLadderVolume(TurokPawn(Owner).OnLadder);
    //return ReturnValue;    
}

private final function DetermineStateFromGraphName(name graphName)
{
    // End:0x26
    if(graphName == 'climbonbottom')
    {
        mLadderState = 5;
        mbRightFoot = true;        
    }
    else
    {
        // End:0x61
        if((graphName == 'climbontop') || graphName == 'climbontopvine')
        {
            mLadderState = 6;
            mbRightFoot = true;            
        }
        else
        {
            // End:0x87
            if(graphName == 'climbcycleleft')
            {
                mLadderState = 1;
                mbRightFoot = true;                
            }
            else
            {
                // End:0xAD
                if(graphName == 'climbcycleright')
                {
                    mLadderState = 1;
                    mbRightFoot = false;                    
                }
                else
                {
                    // End:0xD3
                    if(graphName == 'climbcycledownleft')
                    {
                        mLadderState = 2;
                        mbRightFoot = true;                        
                    }
                    else
                    {
                        // End:0xF9
                        if(graphName == 'climbcycledownright')
                        {
                            mLadderState = 2;
                            mbRightFoot = false;                            
                        }
                        else
                        {
                            // End:0x134
                            if((graphName == 'climbofftop') || graphName == 'climbofftopvine')
                            {
                                mLadderState = 4;
                                mbRightFoot = true;                                
                            }
                            else
                            {
                                // End:0x15A
                                if(graphName == 'climboffbottom')
                                {
                                    mLadderState = 3;
                                    mbRightFoot = true;                                    
                                }
                                else
                                {
                                    // End:0x180
                                    if(graphName == 'climbidleleft')
                                    {
                                        mLadderState = 7;
                                        mbRightFoot = false;                                        
                                    }
                                    else
                                    {
                                        // End:0x1A6
                                        if(graphName == 'climbidleright')
                                        {
                                            mLadderState = 7;
                                            mbRightFoot = true;                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function CacheAnimData(@NULL Ladder)
{
    local @NULL graphSet, TP, graph, pos, Rot;

    local float Duration;

    TP = GetTurokPawn();
    graphSet = GetGraphSet();
    // End:0x1CF
    if(graphSet != none)
    {
        // End:0x5A
        if(Ladder.mbIsVineLadder)
        {
            graph = graphSet.FindGraph('climbofftopvine');            
        }
        else
        {
            graph = graphSet.FindGraph('climbofftop');
        }
        // End:0xC9
        if(graph != none)
        {
            graph.GetCharacterRootMotionEndPoint(TP.Mesh, pos, Rot, 0);
            mClimbOffTopVerticalMotion = pos.Z;
        }
        graph = graphSet.FindGraph('climboffbottom');
        // End:0x138
        if(graph != none)
        {
            graph.GetCharacterRootMotionEndPoint(TP.Mesh, pos, Rot, 0);
            mClimbOffBottomVerticalMotion = pos.Z;
        }
        graph = graphSet.FindGraph('climbcycleright');
        // End:0x1CF
        if(graph != none)
        {
            graph.GetCharacterRootMotionEndPoint(TP.Mesh, pos, Rot, 0);
            Duration = graph.GetPreviewDuration(TP.Mesh, 0);
            mClimbSpeed = VSize(pos) / Duration;
        }
    }
    //return;    
}

private final function PlayTransitionGraphs(@NULL graph)
{
    local @NULL TP, actionLoc, actionRot;
    local bool bSetActionLocation;

    bSetActionLocation = true;
    actionLoc = vect(0.0000000, 0.0000000, 0.0000000);
    actionRot = rot(0, 0, 0);
    TP = GetTurokPawn();
    DetermineStateFromGraphName(graph.mName);
    switch(mLadderState)
    {
        // End:0x98
        case 5:
            GetLadder().GetBottomEdgeLocationRotation(mStartActionLoc, mStartActionRot);
            actionLoc = mStartActionLoc;
            actionRot = mStartActionRot;
            mCurrentRungFromStart = 0;
            // End:0x1AC
            break;
        // End:0xBE
        case 3:
            GetLadder().GetBottomEdgeLocationRotation(actionLoc, actionRot);
            // End:0x1AC
            break;
        // End:0x105
        case 6:
            GetLadder().GetTopEdgeLocationRotation(mStartActionLoc, mStartActionRot);
            actionLoc = mStartActionLoc;
            actionRot = mStartActionRot;
            mCurrentRungFromStart = -2;
            // End:0x1AC
            break;
        // End:0x12B
        case 4:
            GetLadder().GetTopEdgeLocationRotation(actionLoc, actionRot);
            // End:0x1AC
            break;
        // End:0x130
        case 1:
        // End:0x135
        case 2:
        // End:0x194
        case 7:
            actionLoc = mStartActionLoc + (mNormVectorBetweenRungs * float(mCurrentRungFromStart));
            actionRot = mStartActionRot;
            // End:0x17A
            if(int(mLadderState) == int(1))
            {
                ++mCurrentRungFromStart;                
            }
            else
            {
                // End:0x191
                if(int(mLadderState) == int(2))
                {
                    --mCurrentRungFromStart;
                }
            }
            // End:0x1AC
            break;
        // End:0x199
        case 8:
        // End:0x1A9
        case 0:
            bSetActionLocation = false;
            // End:0x1AC
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x1FE
    if(int(TP.Role) == int(ROLE_Authority))
    {
        // End:0x1E7
        if(bSetActionLocation)
        {
            TP.SetActionLocation(actionLoc, actionRot);
        }
        TP.PlayGraphReplicated(graph, self, 0);
    }
    //return;    
}

simulated function NotifyGraphStart(@NULL graph, byte actorType)
{
    local @NULL differentGraph;

    DetermineStateFromGraphName(graph.mName);
    // End:0x57
    if(int(mLadderState) == int(7))
    {
        differentGraph = GetNextGraphFromIdle();
        // End:0x57
        if((differentGraph != none) && differentGraph != graph)
        {
            PlayTransitionGraphs(differentGraph);
        }
    }
    //return;    
}

simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    SetClimbing(false);
    GetTurokPawn().EndClimbing();
    //return;    
}

simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}

defaultproperties
{
    mNormVectorBetweenRungs=(X=0.0000000,Y=0.0000000,Z=48.0000000)
}