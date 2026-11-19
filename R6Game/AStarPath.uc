class AStarPath extends Object
    native;

var float PartialPathCost;
var float EstimateCost;
var array<NavigationPoint> NavList;

// Export UAStarPath::execDumpPath(FFrame&, void* const)
native function DumpPath();
