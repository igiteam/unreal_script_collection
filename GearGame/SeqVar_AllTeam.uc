/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqVar_AllTeam extends SeqVar_Object
	native(Sequence);

cpptext
{
	UObject** GetObjectRef( INT Idx );

	virtual FString GetValueStr()
	{
		if( Team == TEAM_COG )
		{
			return FString(TEXT("COG"));
		}
		else if( Team == TEAM_LOCUST )
		{
			return FString(TEXT("Locust"));
		}
		else if( Team == TEAM_LAMBENT )
		{
			return FString(TEXT("Lambent"));
		}
		else /* if( Team == TEAM_EVERYONE ) */
		{
			return FString(TEXT("Everyone"));
		}
	}

	virtual UBOOL SupportsProperty(UProperty *Property)
	{
		return FALSE;
	}
};

/** Local list of team members in the game */
var transient array<Object> Members;

var() EGearTeam Team;

/** updates the Players array with the list of Controllers in the game that count as players (humans or bot-players) */
native final function UpdateTeamList();

function Object GetObjectValue()
{
	local Controller C;

	UpdateTeamList();

	if( Members.length > 0 )
	{
		C = Controller(Members[0]);
	}

	// we usually want the pawn, so return that if possible
	return (C != None && C.Pawn != None) ? C.Pawn : C;
}

defaultproperties
{
	ObjName="Team"
	ObjCategory="Player"
	SupportedClasses=(class'Controller',class'Pawn')
}

