class ProscribedReachSpec extends ReachSpec
    native;

// Export UProscribedReachSpec::execCostFor(FFrame&, void* const)
native function int CostFor(Pawn P);

defaultproperties
{
    bAddToNavigationOctree=0
}