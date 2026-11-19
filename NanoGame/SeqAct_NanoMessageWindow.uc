/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoMessageWindow extends SequenceAction;

/** Top message to show in message window */
var()	string	Message1;
/** Bottom message to show in message window */
var()	string	Message2;
/** How long message should stay up on screen for */
var()	float	MessageTime;
/** Offset from center of the screen to draw the message */
var()	vector2D MessageBoxOffset;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Message Window"
	ObjCategory="Nano"

	MessageTime=3.0

	InputLInks(0)=(LinkDesc="Show")
	InputLInks(1)=(LinkDesc="Hide")
}