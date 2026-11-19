class SkyBTNode_Parallel extends SkyBTNode_Blend
    native;

enum BT_COMPLETION_POLICY
{
    BT_COMPLETE_WHEN_ALL_SUCCEED,   // 0
    BT_COMPLETE_WHEN_ONE_SUCCEEDS,  // 1
    BT_COMPLETE_WHEN_MAX            // 2
};

enum BT_FAILURE_POLICY
{
    BT_FAIL_WHEN_ALL_FAIL,          // 0
    BT_FAIL_WHEN_ONE_FAILS,         // 1
    BT_FAIL_WHEN_MAX                // 2
};

var() SkyBTNode_Parallel.BT_COMPLETION_POLICY CompletionPolicy;
var() SkyBTNode_Parallel.BT_FAILURE_POLICY FailurePolicy;
