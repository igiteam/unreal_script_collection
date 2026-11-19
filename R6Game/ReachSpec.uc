class ReachSpec extends Object
    native;

const BLOCKEDPATHCOST = 10000000;

var native const editconst transient Pointer NavOctreeObject;
var int Distance;
var() const NavigationPoint Start;
var() const NavigationPoint End;
var int CollisionRadius;
var int CollisionHeight;
var int reachFlags;
var int MaxLandingVelocity;
var byte bPruned;
var byte PathColorIndex;
var const editconst byte bAddToNavigationOctree;
var const Guid EndGuid;

// Export UReachSpec::execCostFor(FFrame&, void* const)
native function int CostFor(Pawn P);

function bool IsBlockedFor(Pawn P)
{
    return (CostFor(P)) >= 10000000;
    return;
}

defaultproperties
{
    bAddToNavigationOctree=1
}