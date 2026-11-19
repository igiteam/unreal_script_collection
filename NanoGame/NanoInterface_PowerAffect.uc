/**
 *	Implemented by things that can be affected by your nano powers
 *
 *	Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

interface NanoInterface_PowerAffect extends Interface
	DependsOn(NanoTypes);

/** Used to change the nano state of an object */
simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
}

/** Used to restore the nano state of an object to default */
simulated function RestoreDefaultNanoState()
{
}

simulated function bool CanBeDusted()
{
	return TRUE;
}

simulated function bool CanBeDensed()
{
	return TRUE;
}

simulated function bool CanBeChanged( ENanoState NewState )
{
	if( NewState == ENS_Dust )
	{
		return CanBeDusted();
	}
	if( NewState == ENS_Dense )
	{
		return CanBeDensed();
	}
	return TRUE;
}

simulated function bool IsDusted()
{
	return FALSE;
}

simulated function bool IsDensed()
{
	return FALSE;
}

simulated function OnModifyNanoAffectedActor( SeqAct_ModifyNanoAffectedActor InAction )
{
}
