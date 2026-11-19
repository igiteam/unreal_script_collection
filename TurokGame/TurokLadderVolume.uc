class TurokLadderVolume extends LadderVolume
    native
    hidecategories(Navigation,Object,Movement,Display,Attachment,Advanced,Brush,Volume,Collision,PhysicsVolume)
    autoexpandcategories(TurokLadderVolume);

var() @NULL mBottomEdge;
var() @NULL mTopEdge;
var() bool mbIsVineLadder;
var bool mbInitialized;
var export editinline @NULL mBottomEdgeSphere;
var export editinline @NULL mTopEdgeSphere;
var @NULL mTopNavPoint;
var @NULL mBottomNavPoint;

// Export UTurokLadderVolume::execEncompasses(FFrame&, void* const)
native function bool Encompasses(@NULL Other);

// Export UTurokLadderVolume::execCompletelyOut(FFrame&, void* const)
native function bool CompletelyOut(@NULL Other);

// Export UTurokLadderVolume::execIsPositionCloserToTop(FFrame&, void* const)
native function bool IsPositionCloserToTop(@NULL Position);

// Export UTurokLadderVolume::execIsPusingTowardsLadder(FFrame&, void* const)
native function bool IsPusingTowardsLadder(@NULL Pawn);

// Export UTurokLadderVolume::execIsPawnAbleToClimb(FFrame&, void* const)
native function bool IsPawnAbleToClimb(@NULL Pawn);

// Export UTurokLadderVolume::execIsPawnJumpingIntoLadder(FFrame&, void* const)
native function bool IsPawnJumpingIntoLadder(@NULL Pawn);

// Export UTurokLadderVolume::execGetStartRotationFromPawnPosition(FFrame&, void* const)
native function @NULL GetStartRotationFromPawnPosition(@NULL Pawn);

// Export UTurokLadderVolume::execGetTopEdgeLocationRotation(FFrame&, void* const)
native function GetTopEdgeLocationRotation(out @NULL pos, out @NULL Rot);

// Export UTurokLadderVolume::execGetBottomEdgeLocationRotation(FFrame&, void* const)
native function GetBottomEdgeLocationRotation(out @NULL pos, out @NULL Rot);

// Export UTurokLadderVolume::execInUse(FFrame&, void* const)
native function bool InUse(@NULL Ignored);

// Export UTurokLadderVolume::execMarkLadderInUse(FFrame&, void* const)
native function MarkLadderInUse(@NULL Pawn);

// Export UTurokLadderVolume::execMarkLadderNotInUse(FFrame&, void* const)
native function MarkLadderNotInUse(@NULL Pawn);

simulated function PostBeginPlay()
{
    mbInitialized = true;
    super.PostBeginPlay();
    //return;    
}

simulated event PawnEnteredVolume(@NULL P)
{
    local @NULL TP;

    TP = TurokPawn(P);
    // End:0x25
    if(!mbInitialized)
    {
        PostBeginPlay();
    }
    super(PhysicsVolume).PawnEnteredVolume(P);
    // End:0xC3
    if(TP != none)
    {
        // End:0xC3
        if((int(TP.Role) == int(ROLE_Authority)) && (TP.Controller == none) || TurokAIController(TP.Controller) != none)
        {
            // End:0xC3
            if(TP.CanGrabLadder() && !TP.bDeleteMe)
            {
                __NFUN_278__(Class'TurokPotentialClimbWatcher', TP);
            }
        }
    }
    //return;    
}

simulated event PawnLeavingVolume(@NULL P)
{
    local @NULL TP;

    TP = TurokPawn(P);
    super(PhysicsVolume).PawnLeavingVolume(P);
    // End:0x26
    if(TP != none)
    {
    }
    //return;    
}

simulated event PhysicsChangedFor(@NULL P)
{
    local @NULL TP;

    TP = TurokPawn(P);
    super(PhysicsVolume).PhysicsChangedFor(P);
    // End:0x26
    if(TP != none)
    {
    }
    //return;    
}

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokLadderVolume.BottomEdgeSphere'
    begin object name=BottomEdgeSphere class=Class'Engine.DrawSphereComponent'
        SphereRadius=5.0000000
        AbsoluteScale=true
    end object
    mBottomEdgeSphere=BottomEdgeSphere
    // Reference: DrawSphereComponent'Default__TurokLadderVolume.TopEdgeSphere'
    begin object name=TopEdgeSphere class=Class'Engine.DrawSphereComponent'
        SphereRadius=5.0000000
        AbsoluteScale=true
    end object
    mTopEdgeSphere=TopEdgeSphere
    bAllowLadderStrafing=false
    mSetVolumeFlags=4
    // Reference: BrushComponent'Default__TurokLadderVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    // Reference: ArrowComponent'Default__TurokLadderVolume.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=BottomEdgeSphere
    Components[3]=TopEdgeSphere
    CollisionComponent=BrushComponent0
}