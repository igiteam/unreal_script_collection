/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqVar_Squad extends SeqVar_Object
	native(Sequence);

cpptext
{
	UObject** GetObjectRef( INT Idx );

	virtual FString GetValueStr()
	{
		return FString(TEXT("Squad"));
	}

	virtual UBOOL SupportsProperty(UProperty *Property)
	{
		return FALSE;
	}
};

/** Local list of players in the game */
var transient array<Object> Squad;

/** updates the Players array with the list of Controllers in the game that count as players (humans or bot-players) */
native final function UpdateSquadList();

function Object GetObjectValue()
{
	local Controller C;

	UpdateSquadList();

	if( Squad.length > 0 )
	{
		C = Controller(Squad[0]);
	}

	// we usually want the pawn, so return that if possible
	return (C != None && C.Pawn != None) ? C.Pawn : C;
}

defaultproperties
{
	ObjName="Squad"
	ObjCategory="Player"
	SupportedClasses=(class'Controller',class'Pawn')
}

