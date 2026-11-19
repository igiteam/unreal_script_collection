class SpVelocityEvaluator extends SpPNodeEvaluator
    native;

// Export USpVelocityEvaluator::execCanUsePerformance(FFrame&, void* const)
native function bool CanUsePerformance(SPPerformance perf, int Condition);
