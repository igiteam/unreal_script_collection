//***********************************************************************
// Force the actor to look at a target
// Only works if head tracking is enabled on the target and the target's
// anim tree has the appropriate head track skel control...
//***********************************************************************
class SeqAct_AIForceLookAt extends SequenceAction;

var() bool bEnabledByDefault;

//***********************************************************************
// Default Properties
//***********************************************************************
