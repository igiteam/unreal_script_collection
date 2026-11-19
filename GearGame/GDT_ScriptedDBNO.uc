/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_ScriptedDBNO extends GDT_Environment;

simulated static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return TRUE;
}

static function bool IsScriptedDamageType()
{
	return TRUE;
}

