class SpKrakenDistanceEvaluator extends SpPNodeEvaluator
    native;

// Export USpKrakenDistanceEvaluator::execCanUsePerformance(FFrame&, void* const)
native function bool CanUsePerformance(SPPerformance perf, int Condition);
