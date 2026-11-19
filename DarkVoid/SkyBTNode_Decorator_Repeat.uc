class SkyBTNode_Decorator_Repeat extends SkyBTNode_Decorator
    native;

enum RepeatConditions
{
    REPEAT_SuccessOrFailure,        // 0
    REPEAT_SuccessOnly,             // 1
    REPEAT_FailureOnly,             // 2
    REPEAT_MAX                      // 3
};

var(Repeat) int NumTimesToRepeatSubtree;
var transient int CurrentExecutionCount;
var(Repeat) SkyBTNode_Decorator_Repeat.RepeatConditions RepeatWhile;
