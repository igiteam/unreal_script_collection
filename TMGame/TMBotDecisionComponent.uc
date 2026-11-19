/**
 * when this component gets triggered, it calls its owner TMBot's ExecuteWhatToDoNext() in its next tick
 * this is so the AI's state code, timers, etc happen in TG_PreAsyncWork while the decision logic happens
 * in TG_DuringAsyncWork
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMBotDecisionComponent extends ActorComponent
	native(AI);

var bool bTriggered;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

