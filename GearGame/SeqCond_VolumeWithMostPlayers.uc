/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqCond_VolumeWithMostPlayers extends SequenceCondition
	native(Sequence);

cpptext
{
	/** Check the volumes to see which has the most players in it */
	virtual void Activated();

	/**
	 * Check if the volume contains more than MaxPopulation
	 * 
	 * @param Volume - the volume to examine
	 * 
	 * @param VolumeIdx - the index of the volume to examine
	 * 
	 * @param Pawns - the pawns to check inside the volume
	 * 
	 * @param MaxPopulation - the current high water mark for volume populations
	 * 
	 * @param MostPlayersIndex - the index of the volume with the most occupants
	 */
	void CheckForMostPlayers(AVolume* Volume, INT VolumeIdx, TArray<AGearPawn*> const& Pawns, INT& MaxPopulation, INT& MostPlayersIndex);
}

/** Volume 1 to check */
var Volume Volume1;

/** Volume 2 to check */
var Volume Volume2;

/** Volume 3 to check */
var Volume Volume3;

/** Volume 4 to check */
var Volume Volume4;

/** Volume 5 to check */
var Volume Volume5;

/** Volume 6 to check */
var Volume Volume6;

/** Volume 7 to check */
var Volume Volume7;

/** Volume 8 to check */
var Volume Volume8;

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Volume With Most Players"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Players",PropertyName=Players)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 1",PropertyName=Volume1,MaxVars=1)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 2",PropertyName=Volume2,MaxVars=1)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 3",PropertyName=Volume3,MaxVars=1)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 4",PropertyName=Volume4,MaxVars=1)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 5",PropertyName=Volume5,MaxVars=1)
	VariableLinks(6)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 6",PropertyName=Volume6,MaxVars=1)
	VariableLinks(7)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 7",PropertyName=Volume7,MaxVars=1)
	VariableLinks(8)=(ExpectedType=class'SeqVar_Object',LinkDesc="Volume 8",PropertyName=Volume8,MaxVars=1)
		
	OutputLinks(0)=(LinkDesc="None")
	OutputLinks(1)=(LinkDesc="1")
	OutputLinks(2)=(LinkDesc="2")
	OutputLinks(3)=(LinkDesc="3")
	OutputLinks(4)=(LinkDesc="4")
	OutputLinks(5)=(LinkDesc="5")
	OutputLinks(6)=(LinkDesc="6")
	OutputLinks(7)=(LinkDesc="7")
	OutputLinks(8)=(LinkDesc="8")
}