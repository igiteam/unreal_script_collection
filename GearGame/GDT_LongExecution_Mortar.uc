/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_LongExecution_Mortar extends GDT_LongExecution_Base;

/** Force the head to gib */
static function bool ShouldHeadShotGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

defaultproperties
{
}

