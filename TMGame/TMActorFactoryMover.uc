/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */


class TMActorFactoryMover extends ActorFactoryDynamicSM
	config(Editor)
	collapsecategories
	hidecategories(Object)
	native;

/** if true, also create a Kismet event and hook it up to the spawned actor */
var() bool bCreateKismetEvent;
/** the class of Kismet event to create if bCreateKismetEvent is true */
var class<SequenceEvent> EventClass;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

