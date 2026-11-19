class TurokLadderReachSpec extends TurokReachSpec
    native;

// Export UTurokLadderReachSpec::execCostFor(FFrame&, void* const)
native function int CostFor(@NULL P);

defaultproperties
{
    bCanCutCorners=false
}