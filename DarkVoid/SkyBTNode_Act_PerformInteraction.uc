class SkyBTNode_Act_PerformInteraction extends SkyBTNode_Leaf_Action
    native;

var(Interaction) bool bRetryUntilSuccess;
var(Interaction) bool bAbortInteractionIfInterrupted;
var transient bool bInteractionIsRunning;
var(Interaction) class<SkyInteraction> InteractionType;
