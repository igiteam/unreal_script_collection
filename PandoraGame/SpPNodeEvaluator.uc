class SpPNodeEvaluator extends SPAnimNodeConnectableBase
    native;

// Export USpPNodeEvaluator::execCanUsePerformance(FFrame&, void* const)
native function bool CanUsePerformance(SPPerformance perf, int Condition);
