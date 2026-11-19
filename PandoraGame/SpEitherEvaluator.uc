class SpEitherEvaluator extends SpPNodeEvaluator
    native;

// Export USpEitherEvaluator::execCanUsePerformance(FFrame&, void* const)
native function bool CanUsePerformance(SPPerformance perf, int Condition);
