/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqCond_IsCarryingFlag extends SequenceCondition;

var Actor Target;
var() TMGameObjective FlagBase;

event Activated()
{
	local TMPlayerReplicationInfo PRI;
	local Pawn P;
	local Controller C;
	local TMCarriedObject Flag;
	
	P = Pawn(Target);
	if (P != None)
	{
		PRI = TMPlayerReplicationInfo(P.PlayerReplicationInfo);
	}
	else
	{
		C = Controller(Target);
		if (C != None)
		{
			PRI = TMPlayerReplicationInfo(C.PlayerReplicationInfo);
		}
	}
	if (PRI == None)
	{
		ScriptLog("Invalid target specified for" @ self);
	}
	else
	{
		if (FlagBase != None)
		{
			Flag = FlagBase.GetFlag();
		}

		OutputLinks[(PRI.bHasFlag && (Flag == None || PRI.GetFlag() == Flag)) ? 0 : 1].bHasImpulse = true;
	}
}

