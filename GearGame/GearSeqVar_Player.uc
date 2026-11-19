/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearSeqVar_Player extends SeqVar_Player
	native(Sequence);

cpptext
{
	UObject** GetObjectRef(INT Idx);
};

function Object GetObjectValue()
{
	local GearGameSP_Base SPGame;
	local Controller C;

	if (bAllPlayers)
	{
		return Super.GetObjectValue();
	}
	else
	{
		// in Campaign use our special slot system instead
		SPGame = GearGameSP_Base(GetWorldInfo().Game);
		if (SPGame != None)
		{
			// we usually want the pawn, so return that if possible
			C = SPGame.PlayerSlots[PlayerIdx - 1].Owner; // -1 because the LDs wanted 1-4
			return (C != None && C.Pawn != None) ? C.Pawn : C;
		}
		else
		{
			return Super.GetObjectValue();
		}
	}
}

defaultproperties
{
	ObjName="All Players"
	ObjCategory="Player"
}
