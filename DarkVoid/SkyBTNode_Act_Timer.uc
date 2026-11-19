class SkyBTNode_Act_Timer extends SkyBTNode_Leaf_Action
    native;

var(Timer) float Duration;
var(Timer) float RandomVariance;
var transient float StartTime;
var transient float SelectedVariance;
var(Timer) SkyBTNode.BT_STATUS CompletionCode;
