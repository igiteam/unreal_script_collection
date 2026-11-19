/**
 * This needs to be a base class and then the cop be a specific one of a MetaCorp guy
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCrowd_Metacorp extends NanoCrowd_Pedestrian
		implements( NanoInterface_CanAffectChaos )
		placeable;

var private transient bool bSpawnedAnAI;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	NanoGRI(WorldInfo.GRI).RegisterTargetableActor( self );
}



/** When civilians would normally take damage, they dodge */
simulated event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local NanoPC NPC;

	if( bShouldSpawnAnAIWhenShot == TRUE )
	{
		//FIXMEMP:  Assumes there is only one player!
		foreach WorldInfo.AllControllers( class'NanoPC', NPC )
		{
			break;
		}

		NanoGRI(WorldInfo.GRI).ModifyChaosLevel( NanoPawn(NPC.Pawn).GetChaosZone(), none, class'NanoCausingChaosValues'.default.CrowdCopAttacked );

		PossiblySpawnAIFromCrowd();
	}
	else
	if(`TimeSince(LastDodgeTime) > 1.5)
	{
		DoDodge();
		LastDodgeTime = WorldInfo.TimeSeconds;
	}
}


function PossiblySpawnAIFromCrowd()
{
	if( bSpawnedAnAI == FALSE )
	{
		if( SoundToPlayWhenTransformingToAI != None )
		{
			PlaySound( SoundToPlayWhenTransformingToAI );
		}


		//we will have the class here: ClassToSpawnWhenShot   so we need to parse that

		// tell the NPES to attempt to spawn a trooper here immediately
		NanoGRI(WorldInfo.GRI).NPES.SpawnAIType( 'NanoPawn_MetaCorp_RiotCop', ESM_CrowdMemberTransformation, TRUE, Location, None ); // hard code the name for now

		PanicVanish();

		bSpawnedAnAI = TRUE;
	}

}



/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return TRUE;
}

/** Should this targetable actor ignore distance checks in rating calculations (caution...use with care!) */
simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	if( !IsTargetable() )
	{
		return INDEX_NONE;
	}
	else
	{
		return 10.0f;
	}
}

/** Get location that target should be considered */
simulated event vector GetTargetedLocation()
{
	return Location;
}

/** Called when target is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword )
{
	PossiblySpawnAIFromCrowd();
}

/** Called when target struck by ricochet moon hook */
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook )
{
	PossiblySpawnAIFromCrowd();
	return TRUE;
}

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return TRUE;
}





defaultproperties
{
	DodgeVel=500.0
	MiniMapDotColor=(R=255,G=64,B=64,A=255)

	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)


	Begin Object Name=SkeletalMeshComponent0
	    BlockNonZeroExtent=TRUE  // needed for sword damaging code
	End Object
}