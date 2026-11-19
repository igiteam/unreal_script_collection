class SpKrakenPullbackEvaluator extends SpPNodeEvaluator
    native;

// Export USpKrakenPullbackEvaluator::execCanUsePerformance(FFrame&, void* const)
native function bool CanUsePerformance(SPPerformance perf, int Condition);
