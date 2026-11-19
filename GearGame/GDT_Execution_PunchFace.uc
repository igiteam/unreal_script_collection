/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_Execution_PunchFace extends GDT_LongExecution_Base;

/** Should the Pawn play the special head shot death? */
static function bool ShouldHeadShotGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

defaultproperties
{
	KillGUDEvent=GUDEvent_KilledEnemyMelee
}
