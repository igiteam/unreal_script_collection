/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_LevianthanTentackle_Release extends SequenceAction;

/** List of destinations */
var() array<Object> Destinations;

defaultproperties
{
	ObjName="Levianthan Tentacle Release Pawn"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Release Spawned")

	VariableLinks(0)=(LinkDesc="Spawner")
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Dest",PropertyName=Destinations)
}
