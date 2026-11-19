/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAttractMetaCorpTroopsBase extends Actor
	native
	config(Game)
	implements(NanoInterface_Forgeable,NanoInterface_Targetable)
	abstract;

/** Max number of AIs this object can attract. **/
var config int MaxNumCanAttract;

var transient int CurrNumAttracted;

/** How long this will stay effective in attracting AI **/
var config float DurationOfEffectiveAttraction;


var float DurationBetweenAddStimuli;

var transient float NextTickTime;


/** Function to forge the implementing actor.  Actor is responsible for calling the callback when object is forged and ready to use. */
function ForgeActor(optional delegate<NanoPlan.OnForgeActorFinished> OnFinishCallback);




/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return CurrNumAttracted < MaxNumCanAttract;
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}

/** Should we rate this target? (if not just skip in rating loop) */
simulated function bool ShouldRateTarget()
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
	return 90.0f;
}

/** Get location that target should be considered */
simulated event vector GetTargetedLocation()
{
	return Location;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

/** Called when target is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );

/** Called when target struck by ricochet moon hook */
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}



simulated function Tick( float DeltaTime )
{
	local NanoAI AI;
	
	Super.Tick( DeltaTime );

	if( WorldInfo.TimeSeconds > NextTickTime )
	{
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			AI.AddStimulus( self, Location, TRUE, FALSE, TRUE, FALSE );
		}

		NextTickTime = WorldInfo.TimeSeconds + DurationBetweenAddStimuli;
	}
}







defaultproperties
{
	DurationBetweenAddStimuli=1.0f
}