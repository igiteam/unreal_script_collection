class SkyBTNode_Leaf extends SkyBTNode
    abstract
    native;

var(Scheduler) float QoS_ExecutionInterval;
var transient float QoS_LastExecutionTime;
var bool bRunLatent;
