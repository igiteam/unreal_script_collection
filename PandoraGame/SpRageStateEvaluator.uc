class SpRageStateEvaluator extends SpPNodeEvaluator
    native;

// Export USpRageStateEvaluator::execCanUsePerformance(FFrame&, void* const)
native function bool CanUsePerformance(SPPerformance perf, int Condition);
