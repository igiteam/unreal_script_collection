/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NDT_Explosive extends NanoDamageType
	abstract;

// this should be promoted to GameFramework


/** Distance to skip DBNO and gib directly */
var() config float GibDistance;

/** Overridden to enforce default gibbing for explosive damage. */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}



defaultproperties
{
	//KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Nanos_DeathIcons',U=156,V=90,UL=77,VL=29)

	//DeathScreamEffortID=NanoEffort_SuddenDeathScream
	//DamageHeavyGUDEvent=GUDEvent_DamagedEnemyHeavy

	RadialDamageImpulse=400.0
	bRadialDamageVelChange=TRUE
	bSuppressImpactFX=TRUE

	Begin Object Name=ForceFeedbackWaveform1
	End Object

	DamagedFFWaveform=ForceFeedbackWaveform1
	KilledFFWaveform=ForceFeedbackWaveform1
}


