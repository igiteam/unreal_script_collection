/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward_SmashInto extends NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward within NanoAI;


function DoMovementShoutOut()
{
	if( NanoPawn_MetaCorp_BullRamBase(Pawn) != None )
	{
		NanoPawn_MetaCorp_BullRamBase(Pawn).PlaySound( NanoPawn_MetaCorp_BullRamBase(Pawn).StartMovingSound );
	}
}



defaultproperties
{
	bUseMoveToActor=TRUE
}