/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
class Path_Occupied extends PathConstraint
	native(TG);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

static function bool Occupied(Pawn P)
{
	local Path_Occupied Con;

	if( P != None)
	{
		Con = Path_Occupied(P.CreatePathConstraint(default.class));
		if( Con != None )
		{
			P.AddPathConstraint( Con );
			return TRUE;
		}
	}

	return FALSE;
}

