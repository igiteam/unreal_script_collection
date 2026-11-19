/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CraneControl extends SequenceAction;

var float PayloadSpeed;

defaultproperties
{
	ObjName="Crane Control"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Get Payload Speed")
	InputLinks(1)=(LinkDesc="Payload Blocked")
	InputLinks(2)=(LinkDesc="Payload UnBlocked")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Payload Speed",PropertyName=PayloadSpeed)
}
