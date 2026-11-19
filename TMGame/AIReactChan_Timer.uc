/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

/** Special polled channel that will call react conditions according to their timer interval **/
class AIReactChan_Timer extends AIReactChannel
	native(TGAI);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// overidden to set last activation time on subscribe (so stuff doesn't fire immediatly always)
native function Subscribe(AIReactCondition_Base Condition);


