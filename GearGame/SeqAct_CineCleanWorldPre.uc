/**
 * This will do the actions needed to help reduce memory footprint before a cine.
 *
 * This allows a centralized location for all Pre Cine actions.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CineCleanWorldPre extends SequenceAction
	native(Sequence);

/** Tell everyone to flush their GUDs and then turn off the GUDsManager's streaming in of new data **/
var() bool bFlushGUDS;
/** Force flush the object pool of all the transient cached objects it holds. */
var() bool bFlushGearObjectPool;
/** Destroy dead GearPawns */
var() bool bDeadBodies;
/** Clear smoke grenade smoke */
var() bool bSmokeGrenades;
/** Destroy dropped weapons and pickups */
var() bool bDroppedPickups;


/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


/** This will do the cleaning of the items in the if check **/
event Activated()
{
	`log( "CLEAN WORLD PRE" );
	if( bFlushGUDS )
	{
		TurnOffAndFlushGUDs();
	}
	CleanWorldOfDetritus();
	if( bFlushGearObjectPool )
	{
		FlushGearObjectPool(); // this will cause a GC to occur so it should always come last in the list of things to do
	}
}

/** This will tell everyone to flush their GUDs and then turn off the GUDsManager's streaming in of new data **/
simulated native function TurnOffAndFlushGUDs();


/** Delete objects we don't want to keep around during cinematics */
simulated function CleanWorldOfDetritus()
{
	local Actor A;

	foreach GetWorldInfo().DynamicActors( class'Actor', A )
	{
		if( ( bDeadBodies		&& A.IsA('GearPawn') && A.bTearOff ) || 
			( bSmokeGrenades	&& ( A.IsA('Emit_SmokeGrenade') || A.IsA('GearFogVolume_SmokeGrenade') ) ) ||
			( bDroppedPickups	&& A.IsA('GearDroppedPickup') ) )
		{
			A.Destroy();
		}
	}
}

// duplicated from  SeqAct_ObjectPoolForceFlush
simulated function FlushGearObjectPool()
{
	local GearPC PC;
	local CoverReplicator CoverReplicator;

	// Flush the cover replicator
	CoverReplicator = GetWorldInfo().Game.GetCoverReplicator();
	if (CoverReplicator != None)
	{
		CoverReplicator.PurgeOldEntries();
	}

	// This will cause the object pool to flush
	foreach GetWorldInfo().AllControllers( class'GearPC', PC )
	{
		PC.ClientResetObjectPool(true);
	}
}



defaultproperties
{
	ObjName="Clean World Pre"
	ObjCategory="Cinematic"

	bFlushGUDS=TRUE
	bFlushGearObjectPool=TRUE
	bDeadBodies=TRUE
	bSmokeGrenades=TRUE
	bDroppedPickups=TRUE

	VariableLinks.Empty
}
