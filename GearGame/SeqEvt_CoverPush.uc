/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_CoverPush extends SequenceEvent;


/** Let's the interp actor that is being pushed that it is disabled from movement */
event Toggled()
{
	local InterpActor_MovableCover InterpActorMoveCover;

	InterpActorMoveCover = InterpActor_MovableCover(Originator);
	if (InterpActorMoveCover != None)
	{
		InterpActorMoveCover.bIsMovable = bEnabled;
	}
}


defaultproperties
{
	ObjName="Cover Push"
	ObjCategory="Gear"

	MaxTriggerCount=0
}
