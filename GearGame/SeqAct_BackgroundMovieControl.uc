/**
 * This class allows the background movie in GearStart to be jumped to any state, for debugging and camera alignment
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_BackgroundMovieControl extends SequenceAction;

defaultproperties
{
	bCallHandler=TRUE

	ObjName="Background Movie Control"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Start Screen")
	InputLinks(1)=(LinkDesc="Transition to Menu")
	InputLinks(2)=(LinkDesc="Jump To Menu")

	// define the base output link that this action generates (always assumed to generate at least a single output)
	OutputLinks(0)=(LinkDesc="Out")
}
