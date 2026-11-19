class SkyBTNode_Selector_ExternalEvent extends SkyBTNode_Blend
    native;

var(ExternalEvents) editfixedsize array<string> EventNames;
var(ExternalEvents) bool bDontPreemptHigherPriority;
var transient int NextSubtreeToActivate;
