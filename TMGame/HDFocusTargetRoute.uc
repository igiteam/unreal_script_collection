//-----------------------------------------------------------
// ??????????????????
//-----------------------------------------------------------
class HDFocusTargetRoute extends Route;

var()  array<Actor>       FocusActor;

/** Force the AI to shoot at the target? */
//var()  bool bForceFireAtTarget;
/** Force the AI to fire at the target even when we have no LOS? (doesn't mean anythying unless bForceFireAtTarget is also on) */
//var()  bool bForceFireEvenWhenNoLOS;

var SeqAct_AISetTarget AgentAction;

//???????????????????(SetTarget->AIMove)
//event PostBeginPlay()
//{
//    AgentAction.bForceFireAtTarget = bForceFireAtTarget;
//    AgentAction.bForceFireEvenWhenNoLOS = bForceFireEvenWhenNoLOS;
//}


