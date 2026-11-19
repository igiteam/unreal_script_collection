
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_Evade extends SequenceAction;

// List of special moves usable in Kismet.
enum EEvadeDirection
{
	EED_Forward,
	EED_Backward,
	EED_Left,
	EED_Right,
};

var()	EEvadeDirection	Direction;

