class SPClubStateEvaluator extends SpPNodeEvaluator
    native;

// Export USPClubStateEvaluator::execCanUsePerformance(FFrame&, void* const)
native function bool CanUsePerformance(SPPerformance perf, int Condition);
