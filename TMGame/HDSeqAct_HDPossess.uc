/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class HDSeqAct_HDPossess extends SequenceAction
	native(HDSequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var transient	Actor	ActorToPossess;

/** true if should kill old pawn */
var()			bool	bKillOldPawn;

/** Try to leave vehicle if manning one */
var()			bool	bTryToLeaveVehicle;

