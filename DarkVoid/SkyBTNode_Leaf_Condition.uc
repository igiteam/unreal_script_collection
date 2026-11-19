class SkyBTNode_Leaf_Condition extends SkyBTNode_Leaf
    abstract
    native;

enum EConditionType
{
    ECOND_ReturnImmediately,        // 0
    ECOND_RunUntilConditionIsFalse, // 1
    ECOND_RunUntilConditionIsTrue,  // 2
    ECOND_RunUntilFalseForDuration, // 3
    ECOND_RunUntilTrueForDuration,  // 4
    ECOND_MAX                       // 5
};

var(Conditional) SkyBTNode_Leaf_Condition.EConditionType ConditionType;
var(Conditional) float DurationTunable;
var transient float MonitorTimer;
