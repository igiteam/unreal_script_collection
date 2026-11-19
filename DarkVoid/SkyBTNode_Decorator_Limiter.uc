class SkyBTNode_Decorator_Limiter extends SkyBTNode_Decorator
    native;

var(Limit) int MaxExecutionCount;
var(Limit) float IntervalBetweenExecutions;
var(LimitMetaVar) string LastExecutionTimeMetaVariable;
var(LimitMetaVar) bool bMetaVariableIsGlobal;
var transient int CurrentExecutionCount;
var transient float LastExecutionTime;
