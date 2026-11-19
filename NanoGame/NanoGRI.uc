/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoGRI extends GameReplicationInfo
	config(Game)
	dependson(NanoHUD_Base, NanoVehicleSpline)
	native;

// portions of this should be promoted to GameFramework.  (e.g. all of the parts that deal with LOD, testing, gore, etc.)

var transient InterpCurveFloat SlomoCurve;
var transient float CurrentTimeAlongSlomoCurve;

/** This is our global Nano object pool that will hold all of our pools of objects **/
var transient NanoObjectPool NOP;

/** Test bools for the LOD settings**/
var transient bool bAggressiveLOD_Test;
var transient bool bDropDetail_Test;


var bool bAllowFriendlyFire;

/** default val is used in pawn class to control damage text rendering. */
var config bool bDebugShowDamage;

/** This will show all of the debug info for spawning these blood decals **/
var() config bool bShowDebugInfo_Decals;

/**
 * list of smoke grenade fog volumes to specifically check against for PC red crosshair checks, since there's no magic combination of flags
 * that will make them only block that specific trace without engine hackery
 */
var transient array<NanoFogVolume_Spawnable> SmokeVolumes;

/** List of actors that support the NanoInterface_Targetable */
var private transient array<Actor> TargetableActors;

/** List of actors that support the NanoInterface_Grapple */
var transient array<Actor> GrappleActors;

/** List of all city scan audio targets currently in the level */
var transient array<NanoTargetPoint_CityScanBase> CityScanTargets;

/** Array of HeadTrackTargets we maintain for efficiency.  Storing in GRI so clients can have them too (so we don't need to replicate headtrack state in GearPawn). */
var() transient array<HeadTrackTarget>	HeadTrackTargetCache;
/** We update 1 target per frame, this is the index of the next one to update. */
var transient int				NextHeadTrackTargetToUpdate;

/** Manager for all missions currently accepted */
var transient NanoMissionManager TheMissionManager;

/** Array of aim-assist actors we maintain for efficiency. */
var() transient array<NanoAimAssistActor> AimAssistActorCache;

var transient array<Actor> ActorsToAvoid;

/** There is only one of these per "level" **/
var transient ChaosPacifismManager CPM; 

var transient array<RebelMindShareManager> ListOfRebelMindShareManagers;

var transient NanoAIBlackboard AIBlackboard;

var transient NanoProceduralEnemySpawner NPES;

var transient NanoEncounterDirector NED;

var transient NanoProceduralMissionManager NPMM;

var transient AIPlanner AIP;

var transient NanoEffectsManager NEM;

var transient NanoGoreManager NGM;

var transient NanoAutomatedDialogSystem NADS;

var transient NanoRoadManager NRM;

var transient NanoResponseSystemAudioManager NRSAM;

var transient NanoAudioSceneManager NASM;

var transient NanoChallengeManager NCM;

var transient NanoTutorialManager NTM;

/** Handles spawning of ambient flying vehicles as needed  */
var transient NanoVehiclePopulationManager AirVehiclePopMgr;

/** Handles spawning of ambient ground vehicles as needed */
var transient NanoVehiclePopulationManager GroundVehiclePopMgr;



/** How many ticks are currently on cars **/
var transient int CurrTicksOnCars;

/** How many ticks we allow on cars **/
var config int TotalTicksAllowedOnCars;

/** the current overridden time dilation amount **/
var transient float OverriddenTimeDilation;
var transient bool bShouldIterpTimeDilation;
/** Previous time dilation, so we can restore it. **/
var transient float	PreviousTimeDilation;

var transient float GlobalAttackSpeedScalar;

/** We want to be able to change the FOV across a number of gameplay systems.  So NanoGRI is our go to guy again! **/
/** Our interpolators for our FOV changes **/
var transient protected bool bOverrideFOV;
var transient protected bool bReturnToDefaultFOV;
var transient protected float DesiredFOV;
var transient protected float CurrFOV;


/** This is to make it so that you don't spastically move the camera during the death blow. **/
var transient float RightThumbStickScalar;


/**
 * This is going to be used for global affecting "toggles" / "amounts" of "things"
 * Example:  whether or not all AI should be in a "cinematic" mode or not. 
 *           (which will then be checked by an AIAction's utility function and not have to have us put checks everywhere)
 *
 **/
struct native WorldStateSettingsDatum
{
	/** If the AI should be in idle due to there being a cinematic **/
	var() bool bCinematicAndAIShouldBeIdle;

	/** If the AI should shoot on sight for anyone on the rooftops **/
	var() bool bRoofTraversalIsOutlawed;

	/** Whether or not the music manager should be enabled **/
	var() bool bMusicManagerEnabled;


	structdefaultproperties
	{
		bMusicManagerEnabled=TRUE
	}
};

var transient WorldStateSettingsDatum WorldStateSettings;

/** Time Stamp we last checked for those */
var transient FLOAT FootPlacementLineChecksTimeStamp;
/** Configurable maximum foot placement line checks allowed per frame. */
var config const INT MaxFootPlacementLineChecksPerFrame;
/** List of SkelControllers, to tick oldest nodes first. */
var transient const Array<NanoSkelCtrl_FootPlacement> FootPlacementSkelControlList;


/** Our MCP pointer **/
var transient NanoMCP MCP;


var transient bool bTestProcMissions;


var transient ETimeOfDay TimeOfDay;


/** We need a way to have only one AI at a time avoid their teammates otherwise they all just feed off of each other's moves **/
var transient NanoAIBase AILastAvoidedTeammate;


/** The time when we last played a panic sound when a crowd member first became panicked. **/
var transient float LastCrowdPanicSoundOnFirstPanic;



cpptext
{
	virtual void PostScriptDestroyed();
}



replication
{
	if( bNetDirty )
		TheMissionManager;  // these are not getting replicated out correctly
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// create the object pool
	NOP = Spawn( class'NanoObjectPool' );
	NEM = Spawn( class'NanoEffectsManager' );
	NGM = Spawn( class'NanoGoreManager' );
	NRM = Spawn( class'NanoRoadManager' );
	NRSAM = Spawn( class'NanoResponseSystemAudioManager' );
	NASM = Spawn( class'NanoAudioSceneManager' );

	MCP = new(self) class'NanoMCP';
	MCP.InitLocalCache();
	DealWithMCPBaseNotBeingAbleToUseSetTimer();
	//SetTimer( 20.0f, FALSE, nameof(MCP.InitLocalCache), MCP );

	if( Role == ROLE_Authority )
	{
		// Spawn all of the Actors that should only exist on the server
		AIP = Spawn( class'AIPlanner' );
		TheMissionManager = Spawn( class'NanoMissionManager');
		AIBlackboard = Spawn( class'NanoAIBlackboard' );
		NPES = Spawn( class'NanoProceduralEnemySpawner' );
		NED = Spawn( class'NanoEncounterDirector' );
		NPMM = Spawn( class'NanoProceduralMissionManager' );
		NADS = Spawn( class'NanoAutomatedDialogSystem' );
		NCM = Spawn( class'NanoChallengeManager' );
		NTM = Spawn( class'NanoTutorialManager' );
		CPM = Spawn( class'ChaosPacifismManager' );
	}

	FindAndAddRebelMindShareManagers();

	DesiredFOV = class'NanoPlayerCamera'.default.DefaultFOV;
	RightThumbStickScalar = 1.0f;
	GlobalAttackSpeedScalar = 1.0f;

	// start up our polling the DB for values! ( maybe only do this when chaos is up)
	SetTimer( 5.0f, TRUE, nameof(PollForValueFromDB_MobileResponse) );
	SetTimer( 5.0f, TRUE, nameof(PollForValueFromDB_LyrikStoreItem) );
	SetTimer( 5.0f, TRUE, nameof(PollForValueFromDB_RebelSuperBomb) );
}


simulated function Tick( float DeltaTime )
{
	local float GameSpeed;
	local float TimeDilationScalar;
	local NanoPC NPC;

	Super.Tick( DeltaTime );

	NPC = NanoGRI(WorldInfo.GRI).GetNanoPC();

	// do none of this code if the player is in CinematicMode
	if( ( NPC != None ) && ( NPC.bCinematicMode == FALSE ) )
	{
		// need to multiply here so we have a constant "realtime" for progression down the curve
		TimeDilationScalar = 1.0f / WorldInfo.TimeDilation;

		if (CurrentTimeAlongSlomoCurve >= 0.f)
		{
			WorldInfo.Game.SetGameSpeed(FMax(0.1f,EvalInterpCurveFloat(SlomoCurve,CurrentTimeAlongSlomoCurve)));

			//`log( WorldInfo.RealTimeSeconds @ `showvar(CurrentTimeAlongSlomoCurve) @ `showvar(DeltaTime * TimeDilationScalar) );

			CurrentTimeAlongSlomoCurve += (DeltaTime * TimeDilationScalar);

			// check for the end
			if (CurrentTimeAlongSlomoCurve > SlomoCurve.Points[SlomoCurve.Points.Length-1].InVal)
			{
				CurrentTimeAlongSlomoCurve = -1.f;
				WorldInfo.Game.SetGameSpeed(1.f);
			}
		}


		// this does our interping of the slomo so we can have a nicer looking slomo instead of insta on
		if( (bShouldIterpTimeDilation == TRUE) && ( WorldInfo.TimeDilation != OverriddenTimeDilation ) )
		{
			GameSpeed = FInterpConstantTo( WorldInfo.TimeDilation, OverriddenTimeDilation, DeltaTime, 4.0f*TimeDilationScalar );
			//`log( `showvar(OverriddenTimeDilation) );
			WorldInfo.Game.SetGameSpeed( GameSpeed );

			if( WorldInfo.TimeDilation == OverriddenTimeDilation )
			{
				//`log( "Done interping OverriddenTimeDilation" @ `showvar(OverriddenTimeDilation) );
				bShouldIterpTimeDilation = FALSE;
			}
		}

		//FIXMEMP:  Assumes there is only one player!
		if (bOverrideFOV || bReturnToDefaultFOV)
		{
			CurrFOV = NPC.GetFOVAngle();
			if( CurrFOV != DesiredFOV )
			{
				CurrFOV = FInterpConstantTo( CurrFOV, DesiredFOV, DeltaTime, 80*TimeDilationScalar );
				//`log(`location@`showvar(CurrFOV)@`showvar(DesiredFOV));
				NPC.FOV( CurrFOV );
			}
			if (CurrFOV == DesiredFOV && bReturnToDefaultFOV)
			{
				//`log("fov unlocked");
				NPC.PlayerCamera.bLockedFOV = FALSE;
				bReturnToDefaultFOV = FALSE;
			}
		}
	}
}


function DealWithMCPBaseNotBeingAbleToUseSetTimer()
{
	SetTimer( 1.0f, TRUE, nameof(MCP.PossiblyUpdatePRI), MCP );
}


/** 
 *  We have to have this terrible hack as the order in which actors get created is not always to our liking.  So when the GRI is created
 *  we look and add and CPMs that we find that we do not alredy have.
 **/
simulated function FindAndAddRebelMindShareManagers()
{
    local RebelMindShareManager RMSM;

	foreach AllActors( class'RebelMindShareManager', RMSM )
	{
        if( ListOfRebelMindShareManagers.Find( RMSM ) == INDEX_NONE )
        {
			//`log( "FindChaosPacifismManagers adding " @ CPM );
			ListOfRebelMindShareManagers.AddItem( RMSM );
        }
	}
}



final simulated delegate bool IsWithinMaxEffectDistance( const out PlayerController PC, const out vector EffectLocation, const float CullDistance )
{
	`log( "IsWithinMaxEffectDistance Delegate was not set" );
	ScriptTrace();
	return FALSE;
}


final simulated function bool CheckEffectDistance_SpawnBehindIfNear( const out PlayerController PC, const out vector EffectLocation, const float CullDistance )
{
	local Vector Loc;
	local Rotator Rot;
	local float Dist;

	// grab camera location/rotation for checking Dist
	PC.GetPlayerViewPoint( Loc, Rot );
	Dist = VSize(EffectLocation - Loc);

	//`log( " Behind us?" @ ( (Normal(EffectLocation- Loc) dot vector(Rot)) < 0.0f ) @ (Dist < 1600.0f));
	//	ScriptTrace();
	if( (Normal(EffectLocation - Loc) dot vector(Rot)) < 0.0f )
	{
		return (Dist < 1600.0f);
	}

	//`log( (Dist * PC.LODDistanceFactor) @ CullDistance );
	// if the effect is is outside our CullDistance
	if( (Dist * PC.LODDistanceFactor) > CullDistance )
	{
		return FALSE;
	}

	return TRUE; // this used to be !BeyondFogDistance() which thunks and then just returns always returns false
}


final simulated function bool CheckEffectDistance_SpawnWithinCullDistanceAndInFront( const out PlayerController PC, const out vector EffectLocation, const float CullDistance )
{
	local Vector Loc;
	local Rotator Rot;
	local float Dist;

	// grab camera location/rotation for checking Dist
	PC.GetPlayerViewPoint( Loc, Rot );

	//`log( " Behind us?" @ ( (Normal(EffectLocation - Loc) dot vector(Rot)) < 0.0f ) );
	//	ScriptTrace();
	if( (Normal(EffectLocation - Loc) dot vector(Rot)) < 0.0f )
	{
		return FALSE;
	}

	Dist = VSize(EffectLocation - Loc);

	//`log( (Dist * PC.LODDistanceFactor) @ CullDistance );
	// if the effect is is outside our CullDistance
	if( (Dist * PC.LODDistanceFactor) > CullDistance )
	{
		return FALSE;
	}

	return TRUE; // this used to be !BeyondFogDistance() which thunks and then just returns always returns false
}


final simulated function bool CheckEffectDistance_SpawnWithinCullDistance( const out PlayerController PC, const out vector EffectLocation, const float CullDistance )
{
	local Vector Loc;
	local Rotator Rot;
	local float Dist;

	// grab camera location/rotation for checking Dist
	PC.GetPlayerViewPoint( Loc, Rot );

	Dist = VSize(EffectLocation - Loc);

	//`log( " " @ (Dist * PC.LODDistanceFactor) @ CullDistance );
	// if the effect is is outside our CullDistance
	if( (Dist * PC.LODDistanceFactor) > CullDistance )
	{
		return FALSE;
	}

	return TRUE; // this used to be !BeyondFogDistance() which thunks and then just returns always returns false
}



/**
* This is our first line of defense for spawning things we don't "need" to spawn.
*
* We check to see if the Effect is going to be relevant to use based on:
*  -Who created the effect (e.g. locally controlled humans the effect should always be "relevant"
*  -Effect Distance to locally controlled humans
*
*
**/
final simulated function bool IsEffectRelevant( const out Pawn InInstigator, const out vector EffectLocation, const float CullDistance, const bool bForceRelevant, delegate<IsWithinMaxEffectDistance> DistanceFunc )
{
	//local bool Retval;
	local PlayerController PC;

	// if we were told to always be relevant
	if( bForceRelevant )
	{
		return TRUE;
	}

	// check right off the bat to see if the Framerate is low for this instigator and then just say this effect is not relevant
	// note: we probably want to just do bAggressive check here???  As the code for particles and such will use the cheaper version of the PS
	// 	if( ShouldDisableEffectsDueToFramerate( InInstigator ) == TRUE )
	// 	{
	// 		`log( "ShouldDisableEffectsDueToFramerate was TRUE" @ "DropDetail:" @ WorldInfo.bDropDetail @ "AggressiveLOD:" @ WorldInfo.bAggressiveLOD @ "HumanControlled:" @ ((InInstigator.IsLocallyControlled() == TRUE) && (InInstigator.IsHumanControlled() == TRUE)) @ WorldInfo.DeltaSeconds @ 1/WorldInfo.DeltaSeconds );
	// 		//ScriptTrace();
	// 		return FALSE;
	// 	}

	// these are are for dummy fire that are "always relevant" ??  (seems not always true if they are on other side of the map)
	// 	if( Instigator == None )
	// 	{
	// 		return TRUE;
	// 	}

	// 1) Additionally, we need to check for Effects that are just staying within a radius of the instigator's location (e.g. footstep effects)
	// (aka poor man's frustum check).  This instigator may never move and thus not have been rendered in a while.
	// We do not want them be relevant by default.
	if( (InInstigator != None) && (VSize(EffectLocation - InInstigator.Location) <= 128.0f) && ( (WorldInfo.TimeSeconds - InInstigator.LastRenderTime) > 2.0f ) )
	{
		//`log( "Have not rendered and effect is close:" @ InInstigator @ VSize(EffectLocation - InInstigator.Location) );
		return FALSE;
	}


	// so if the one making this effect is a human and locally controlled (e.g. oneself or a splitscreen friend) then we want to it to be considered
	// relevant as we just did it and want to be able to see it
	if( (InInstigator != None) && (InInstigator.IsHumanControlled()) && (InInstigator.IsLocallyControlled()) )
	{
		return TRUE;
	}

	// 1) The LastRenderTime check then come in and saves the day for stationary effects.  Saying: if we have been rendered in the last second then
	// our effects are going to be relevant.  Don't even bother to do a distance check
	if( (InInstigator != None) && ( (WorldInfo.TimeSeconds - InInstigator.LastRenderTime) < 1.0f ) )
	{
		return TRUE;
	}


	// so if the instigator has been rendered in the last second then the effect they are causing is _probably_ going to be relevant
	// but we need to check to see if they are within the distance of "relevant" effects
	//
	// 0)) Dummy fire falls through to this.  Where we still want to make certain the effect is within our culldistances.

	IsWithinMaxEffectDistance = DistanceFunc;

	foreach LocalPlayerControllers( class'PlayerController', PC )
	{
		if( IsWithinMaxEffectDistance( PC, EffectLocation, CullDistance ) )
		{
			IsWithinMaxEffectDistance = None;
			return TRUE;
		}
	}
	IsWithinMaxEffectDistance = none;


	return FALSE;
}



//!!!!!!
//
//
//


/**
* This function determines if we should disable effects due to framerate.
* Currently this is:
* used to turn off MuzzleFlashLight on all people if the FPS is super low
* used to turn off the MuzzleFlashLight in low FPS areas on the AI / other non local humans
**/
final simulated function bool ShouldDisableEffectsDueToFramerate( const out Pawn InInstigator )
{
	// show effects from all as the game is not that slowa
	return FALSE;

	// DEMO

	//`log( "ShouldDisableEffectsDueToFramerate" @ WorldInfo.bDropDetail @ (InInstigator == None) @ (InInstigator.IsLocallyControlled() == TRUE) @ (InInstigator.IsHumanControlled() == TRUE)) ;

	// the game is running super slow so start turning off everything to get it back up
	if( ( WorldInfo.bAggressiveLOD ) || bAggressiveLOD_Test )
	{
		//`log( "dropping detail bAggressiveLOD" );
		return TRUE;
	}

	// do not show effects if the effect is NOT from you (or SS friend) and the game is slow
	else if( (( WorldInfo.bDropDetail ) || bDropDetail_Test )
		&& ( (InInstigator == None) || (InInstigator.IsLocallyControlled() == FALSE) || (InInstigator.IsHumanControlled() == FALSE) )
		)
	{
		//`log( "dropping detail bDropDetail" @ WorldInfo.bDropDetail @ (InInstigator == None) @ (InInstigator.IsLocallyControlled() == FALSE) @ (InInstigator.IsHumanControlled() == FALSE)) ;
		return TRUE;
	}

	// show effects from all as the game is not that slowa
	return FALSE;
}


/**
* This will determine which LOD to use based off the specific ParticleSystem passed in
* and the distance to where that PS is being displayed.
*
* NOTE:  This is distance based LOD not perf based.  Perf and distance are orthogonal concepts.
*        We use the _ForSlowPerf effects when perf is slow.
**/
final simulated function int GetLODLevelToUse(ParticleSystem PS, vector EffectLocation)
{
	local int				Retval;
	local int				LODIdx;
	local PlayerController	PC;
	local Vector			POVLoc;
	local Rotator			POVRot;
	local float				DistanceToEffect, LODDistance;

	// No particle system, ignore
	if( PS == None )
	{
		return 0;
	}

	// Run this for all local player controllers.
	// If several are found (split screen?). Take the closest for highest LOD.
	ForEach LocalPlayerControllers(class'PlayerController', PC)
	{
		PC.GetPlayerViewPoint(POVLoc, POVRot);

		DistanceToEffect = VSize(POVLoc - EffectLocation);

		//`log( PS @ "LODDistanceFactor: " $ PC.LODDistanceFactor $ " POVLoc: " $ POVLoc $ " DistanceToEffect: " $ DistanceToEffect );

		// Take closest
		if( LODDistance == 0.f || DistanceToEffect < LODDistance )
		{
			LODDistance = DistanceToEffect;
		}
	}

	// Find appropriate LOD based on distance
	Retval = PS.LODDistances.Length - 1;
	for( LODIdx = 1; LODIdx < PS.LODDistances.Length; ++LODIdx )
	{
		if( DistanceToEffect < PS.LODDistances[LODIdx] )
		{
			Retval = LODIdx-1;
			break;
		}
	}

	//`log( PS @ "GetLODLevelToUse" @ Retval );

	return Retval;
}


/**
* Determines if gore should be Shown.  We need to look at all PlayerControllers as a gore sensitive person
* may be playing splitscreen.
**/
simulated function bool ShouldShowGore()
{
	local PlayerController			PC;
	local NanoPRI					PRI;

	// Check gore settings for local pc
	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		PRI = NanoPRI(PC.PlayerReplicationInfo);
		//`log( "ShouldShowGore: PC" @ PC @ "PRI: " $ PRI @ PRI.bShowGore  );
		if( PRI != None && !PRI.bShowGore )
		{
			// If any player controller on this machine should not show gore
			// NO GORE
			return FALSE;
		}
	}

	return TRUE;
}



// we should move all of these into the EffectsManager and have a LeaveADecalWorld and a LeaveADecalMesh

/** This is the Delegate for the Tracing Policy for LeaveADecal **/
simulated delegate DecalTrace( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	`log( "DecalTrace Delegate was not set" );
	ScriptTrace();
}

/** This is the Delegate for the Decal Choice Policy for LeaveADecal **/
simulated delegate DecalChoice( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	`log( "DecalChoice Delegate was not set" );
	ScriptTrace();
}

/** This is the Delegate for the MITV Params Policy for LeaveADecal **/
simulated delegate DecalTimeVaryingParams( out MaterialInstance MI_Decal )
{
	`log( "DecalTimeVaryingParams Delegate was not set" );
	ScriptTrace();
}


/** return as a random XY vector based on the inputs **/
simulated final function vector GetRandomOffsetVector_XY( float MinVal, float MaxVal )
{
	local vector2d RandomOffset;
	local vector RandomOffsetVect;

	RandomOffset.X = MinVal;
	RandomOffset.Y = MaxVal;

	RandomOffsetVect.X = GetRangeValueByPct(RandomOffset,FRand());
	RandomOffsetVect.Y = GetRangeValueByPct(RandomOffset,FRand());
	RandomOffsetVect.Z = 0.0f;

	return RandomOffsetVect;
}



simulated final function BloodDecalChoice_GibExplode_Ground( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'NanoPhysicalMaterialProperty'.static.GetBloodDecalData( Physicalmaterial'NanoPhysMats.DefaultPhysMat', NDTT_SwordSliceBloodDrops, WorldInfo );
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_6' );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}


/**
 * This will trace from the pawn to the ground below them. Randomly spread out around them.
 **/
simulated final function BloodDecalTrace_GroundBelowThePawn_Rand( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -128.0f, 128.0f );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = ForceStartLocation + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart - Vect(0,0,256);

	//`log( out_TraceStart );
}

/**
 * This will set the params for typical blood decals.
 **/
simulated final function BloodDecalTimeVaryingParams_Default( out MaterialInstance out_MI_Decal )
{
	MaterialInstanceTimeVarying(out_MI_Decal).SetDuration( 45.0f );
}


simulated final function SpawnABloodTrail_GibExplode_Ground( const out vector LocationToTraceFrom )
{
	SpawnABloodTrail_Internal( BloodDecalTrace_GroundBelowThePawn_Rand, BloodDecalChoice_GibExplode_Ground, BloodDecalTimeVaryingParams_Default, LocationToTraceFrom );
}

/** Internal. */
simulated final function SpawnABloodTrail_Internal( delegate<NanoGRI.DecalTrace> DecalTraceFunc, delegate<NanoGRI.DecalChoice> DecalChoiceFunc, delegate<NanoGRI.DecalTimeVaryingParams> DecalTimeVaryingParamsFunc, optional vector ForceStartLocation, optional SoundCue InSoundToPlayOnImpact )
{
	local NanoGRI GRI;

	GRI = NanoGRI(WorldInfo.GRI);
	if( (GRI != None) && GRI.ShouldShowGore() ) 
	{
		GRI.LeaveADecalWorld(DecalTraceFunc, DecalChoiceFunc, DecalTimeVaryingParamsFunc, ForceStartLocation, InSoundToPlayOnImpact);
	}
}


/**
* This function takes a number of delegates that are used to control the core behavior of leaving a decal.
*
* DecalTrace:  What to trace against to get the Actor that has been hit.  (e.g. down from some location / out from a gun / etc.)
* DecalChoice:  Which decal to actually use.  This could involve getting it from some list or determining based on LOD, etc.
* TimeVaryingParms:  What params to modifiy over time (for fading in/out, having an over time effect, etc.)
*
* To use this just pass in the delegates/policies you want to use and voila a decal shall be placed into the world.
*
* @todo move this to some global object that exists so we can use the same code from anywhere
**/
simulated final function NanoDecal LeaveADecalWorld( delegate<DecalTrace> DecalTraceFunc, delegate<DecalChoice> DecalChoiceFunc, delegate<DecalTimeVaryingParams> DecalTimeVaryingParamsFunc, optional vector ForceStartLocation, optional SoundCue InSoundToPlayOnImpact )
{
	local NanoDecal GD;
	local DecalData DecalData;
	local float RotationToUseForDecal;

	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;

	local float RandomScale;

	local bool bIsHorde;
	local bool bIsSplitScreen;
	local float DecalLifeSpan;


	DecalChoice = DecalChoiceFunc;
	DecalChoice( HitInfo, RotationToUseForDecal, DecalData );
	DecalChoice = None;

	if( DecalData.DecalMaterial == None )
	{
		//`warn( "DecalMaterial was none!!" );
		//ScriptTrace();
		return None;
	}

	DecalTrace = DecalTraceFunc;
	DecalTrace( TraceStart, TraceDest, DecalData.RandomRadiusOffset, ForceStartLocation );
	DecalTrace = None;

	TraceActor = Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, FALSE, TraceExtent, HitInfo, TRACEFLAG_Bullet );

	`if(`notdefined(FINAL_RELEASE))
		if( bShowDebugInfo_Decals )
		{
			DrawDebugLine( TraceStart, TraceDest , 255, 1, 1, TRUE );
			`log( "About to spawn a decal: " $ DecalData.DecalMaterial );
			ScriptTrace();
		}
	`endif

	if( TraceActor != None )
	{
		//`log( "Blood DecalMaterial: " $ DecalData.DecalMaterial );
		//`log( Material(MaterialInstanceTimeVarying(DecalData.DecalMaterial).Parent).bUsedWithDecals );

		RandomScale = GetRangeValueByPct( DecalData.RandomScalingRange, FRand() );
		DecalData.Width *= RandomScale;
		DecalData.Height *= RandomScale;

		//GD = NanoGRI(WorldInfo.GRI).NOP.GetDecal_Blood( out_HitLocation );
		//GD = new(self) class'NanoDecal';
		//GD.MITV_Decal = new(GD) class'MaterialInstanceTimeVarying';

		// @todo:  this work should be done once and not every time
		bIsHorde = WorldInfo.GRI.IsCoopMultiplayerGame();
		bIsSplitScreen = class'Engine'.static.IsSplitScreen();
		DecalLifeSpan = DecalData.LifeSpan; //(bIsHorde|| bIsSplitScreen) ? DecalData.LifeSpan : 999999.0;

		//`log( `showvar(DecalLifeSpan) );

		GD = NanoDecalManager(WorldInfo.MyDecalManager).SpawnDecalMinimal( out_HitLocation, DecalLifeSpan, DecalData.CanSpawnDistance ); // hack for the size

		//`log( "ahhh" @ GD );

		if( GD != none )
		{
			GD.MITV_Decal.SetParent( DecalData.DecalMaterial );
			// @TODO:  pass in a struct with the decal params you want to use
			WorldInfo.MyDecalManager.SetDecalParameters(
				GD,
				GD.MITV_Decal,
				out_HitLocation,
				rotator(-out_HitNormal),
				bIsHorde ? (DecalData.Width*0.80f) : DecalData.Width,
				bIsHorde ? (DecalData.Height*0.80f) : DecalData.Height,
				Max(DecalData.Thickness,class'NanoDecal'.default.MinExplosionThickness),
				(bIsHorde || bIsSplitScreen) ? FALSE : !DecalData.ClipDecalsUsingFastPath,
				RotationToUseForDecal,
				HitInfo.HitComponent,
				TRUE,
				FALSE,
				HitInfo.BoneName,
				INDEX_NONE,
				INDEX_NONE,
				INDEX_NONE,
				class'NanoDecal'.default.DepthBias,
				DecalData.BlendRange
				);

			TraceActor.AttachComponent( GD );
			//LocationOfLastBloodTrail = out_HitLocation;

			if( InSoundToPlayOnImpact != none )
			{
				PlaySound( InSoundToPlayOnImpact, TRUE, TRUE, TRUE, out_HitLocation, TRUE );
			}

			GD.MITV_Decal.SetDuration( DecalLifeSpan ); // this will turn on the MITV

			//DecalTimeVaryingParams = DecalTimeVaryingParamsFunc;
			//DecalTimeVaryingParams( GD.MITV_Decal );
			//DecalTimeVaryingParams = None;

			`if(`notdefined(FINAL_RELEASE))
				if( bShowDebugInfo_Decals )
				{
					`log( "  SPAWNED " );
					//FlushPersistentDebugLines();
					//DrawDebugCoordinateSystem( out_HitLocation, rotator(-out_HitNormal), 3.0f, TRUE );
				}
			`endif
		}
	}

	return GD;
}


/** Look for FSMAs in radius and break parts off. */
simulated function BreakFracturedMeshes(vector ExploOrigin, class<DamageType> DmgType, float FractureRadius, bool bInDisableCollision, optional float OverrideRBStrength )
{
	local FracturedStaticMeshActor FracActor;
	local byte bWantPhysChunksAndParticles;

	foreach CollidingActors( class'FracturedStaticMeshActor', FracActor, FractureRadius, ExploOrigin, TRUE )
	{
		if((FracActor.Physics == PHYS_None) && FracActor.IsFracturedByDamageType(DmgType))
		{
			// Make sure the impacted fractured mesh is visually relevant
			if( FracActor.FractureEffectIsRelevant( FALSE, Instigator, bWantPhysChunksAndParticles ) )
			{
				FracActor.BreakOffPartsInRadius(
					ExploOrigin,
					FractureRadius,
					OverrideRBStrength > 0.0f ? OverrideRBStrength : DmgType.default.RadialDamageImpulse,
					bWantPhysChunksAndParticles == 1 ? TRUE : FALSE);
			}

			FracActor.SetCollision( FracActor.bCollideActors, bInDisableCollision, FracActor.bIgnoreEncroachers );
		}
	}
}


/** Look for cars and then dense them so they fall fall to the ground and affected by impulses */
simulated function AffectFlyingCars(vector ExploOrigin, class<DamageType> DmgType, float FractureRadius, optional float OverrideRBStrength )
{
	local NanoVehicleAgent ActorToAffect;

	foreach CollidingActors( class'NanoVehicleAgent', ActorToAffect, FractureRadius, ExploOrigin, TRUE )
	{
		// if this car is flying we want to affect it
		if( ActorToAffect.Physics == PHYS_Interpolating )
		{
			// FIX ME! ActorToAffect.SetNanoState( ENS_Dense, None );
		}
	}
}


simulated function SmashDownTeslaCoils(vector ExploOrigin, class<DamageType> DmgType, float FractureRadius, optional float OverrideRBStrength )
{
	local TeslaCoil ActorToAffect;

	foreach CollidingActors( class'TeslaCoil', ActorToAffect, FractureRadius, ExploOrigin, TRUE )
	{
		ActorToAffect.DropTheHammerImpact();
	}
}

/** This will add the actor to the Targetable Octree. **/
native private function AddToTargetableActorToOctree( Actor InTarget );

/** This will remove the actor to the Targetable Octree. **/
native private function RemoveFromTargetableActorToOctree( Actor InTarget, const out OctreeElementId InTargetableID );

/** This will remove the actor to the Targetable Octree by using the ID **/
native private function RemoveFromTargetableActorToOctreeByID( out OctreeElementId InTargetableID );


simulated final function RegisterTargetableActor(Actor InTarget)
{
	// here we need to change this to be inserting into the octree
	if( NanoInterface_Targetable(InTarget) != None )
	{
		//`log( "UC UC =======> RegisterTargetableActor Adding" @ InTarget );
		AddToTargetableActorToOctree( InTarget );
	}

//	if (NanoInterface_Targetable(InTarget) != None && TargetableActors.Find(InTarget) == INDEX_NONE)
//	{
//	//	TargetableActors.AddItem(InTarget);
//	}
}

simulated final function RegisterGrappleActor(Actor TheActor)
{
	if( NanoInterface_Grapple(TheActor) != None && GrappleActors.Find(TheActor) == INDEX_NONE )
	{
		GrappleActors.AddItem(TheActor);
	}
}

/**
* Notification that we have a new headtrackactor, add it to out list.
* Server and client both.
*/
simulated function RegisterHeadTrackTarget(HeadTrackTarget HTT)
{
	local int Idx;

	// clean up list here to make sure it doesn't run away
	for (Idx=0; Idx<HeadTrackTargetCache.Length; ++Idx)
	{
		if (HeadTrackTargetCache[Idx] == None)
		{
			HeadTrackTargetCache.Remove(Idx, 1);
			Idx--;
		}
	}

	// add our new one
	HeadTrackTargetCache[HeadTrackTargetCache.Length] = HTT;
}

simulated function HeadTrackTarget GetNextHeadTrackTargetToUpdate()
{
	if (HeadTrackTargetCache.Length == 0)
	{
		return None;
	}

	if ( (NextHeadTrackTargetToUpdate >= HeadTrackTargetCache.Length) || (NextHeadTrackTargetToUpdate < 0) )
	{
		// back to beginning of cycle
		NextHeadTrackTargetToUpdate = 0;
	}

	return HeadTrackTargetCache[NextHeadTrackTargetToUpdate];
}

function bool AttemptToPlayLine(EDialogueLine LineToPlay, Actor ActorToPlayOn)
{
	return NADS.AttemptToPlayLine( LineToPlay, ActorToPlayOn );
}


/** Easily accesible wrapper function to then modify the correct chaosmanager of the specific NanoVolume_ChaosZone **/
simulated final function ModifyChaosLevel( const NanoVolume_ChaosZone InChaosZone, const Actor InInstigator, const NanoCausingChaosValueDatum Datum )
{
	local ChaosPacifismManager CM;

	if( ( InChaosZone != none ) && ( InChaosZone.bShouldAffectChaos == TRUE ) && ( InChaosZone.MyNanoChaosZoneInfo != none) )
	{
		InChaosZone.MyNanoChaosZoneInfo.ChaosManager.ModifyChaosLevel( InInstigator, Datum );
	}
	else if( InChaosZone == none ) 
	{
		 CM = GetCurrentChaosManager();
		 if( CM != none )
		 {
			CM.ModifyChaosLevel( InInstigator, Datum );
		 }
	}
}


/** This will get the "current" ChaosManager where current is the ChaosManager where the player currently is located **/
simulated final event ChaosPacifismManager GetCurrentChaosManager()
{
	return CPM;
}


simulated final event EChaosTier GetCurrentChaosLevel()
{
	local ChaosPacifismManager CM;

	CM = GetCurrentChaosManager();

	if( CM != None )
	{
		return CM.GetChaosTier();
	}

	return ECT_Tier0;
}


/** This will get the "current" RebelMindShareManager where current is the RebelMindShareManager where the player currently is located **/
simulated final event RebelMindShareManager GetCurrentRebelMindShareManager()
{
	local PlayerController PC;
	local NanoPawn NP;
	local NanoVolume_RebelMindShareZone Vol_MS;

	foreach WorldInfo.LocalPlayerControllers( class'PlayerController', PC )
	{
		break;
	}

	if( PC != none )
	{
		NP = NanoPawn(PC.Pawn);

		if( NP != None ) 
		{
			Vol_MS = NP.GetRebelMindShareZone();

			if( ( Vol_MS != None ) && ( Vol_MS.MyNanoRebelMindShareZoneInfo != None ) )
			{
				return Vol_MS.MyNanoRebelMindShareZoneInfo.MindShareManager;
			}
		}
	}

	if( ListOfRebelMindShareManagers.Length > 0 )
	{
		return ListOfRebelMindShareManagers[0];
	}

	return None;
}



/** 
 * This will return the locations of all of the classTypes within the radius of the TargetLocation.  
 *
 * Checking the returned array .Length > 0 is a quick way to see if there are any classTypes near the location passed in.
 **/
simulated function array<vector> GetAllClassTypesAroundLocation( const class<Actor> ClassToCheck, const Vector TargetLocation, const float RadiusToSearch )
{
	local array<vector> Retval;
	local Actor ActorToAffect;

	foreach CollidingActors( ClassToCheck, ActorToAffect, RadiusToSearch, TargetLocation, TRUE )
	{
		Retval.AddItem( ActorToAffect.Location );
	}

	return Retval;
}


/** This will make a curve which is start to end and then stop there. And it will then start the MITV **/
function ParameterizeAMITV( out MaterialInstanceTimeVarying out_MITV, name InParamName, float StartValue, float EndValue, float Duration )
{
	local InterpCurveFloat Points;
	local InterpCurvePointFloat Point;

	//`log( "Setting MITV params" @ out_MITV @ InParamName @ StartValue @ EndValue @ Duration );

	Points.Points.length = 2;

	Point.InVal = 0.0f;
	Point.OutVal = StartValue;
	Points.Points[0] = Point; // start

	Point.InVal = Duration;
	Point.OutVal = EndValue;
	Points.Points[1] = Point; // end


	out_MITV.SetScalarCurveParameterValue( InParamName, Points );
	out_MITV.SetScalarStartTime( InParamName, 0.0f ); // start now
}


/** This will spawn a nano absorb orb so that**/
simulated function NanoAbsorbOrb SpawnANanoOrb( class<NanoAbsorbOrb> OrbClass, Actor InActorToAttachTo, bool bAttach )
{
	local vector LocToSpawn;
	local vector RandVect;
	local NanoAbsorbOrb Orb;
	
	LocToSpawn = InActorToAttachTo.Location;

	RandVect = VRand();
	RandVect.Z = 0;
	LocToSpawn += 64 * RandVect; // off set the spawn a bit so if we have multiple orbs they all spawn a lil apart

	Orb = Spawn( OrbClass,,, LocToSpawn,,, TRUE );

	Orb.ActorThisBelongsTo = InActorToAttachTo;

	if( bAttach == TRUE )
	{
		Orb.SetHardAttach( TRUE );
		Orb.SetBase( InActorToAttachTo );
	}

	return Orb;
}


final simulated function NanoMusicManager GetMusicManager()
{
	return GetNanoPC().MusicManager;
}


final simulated function NanoPC GetNanoPC()
{
	local NanoPC PC;

	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
        return PC;
	}

	//`warn( "Oh!! no valid player controller!!" );
	return none;
}



final simulated function Pawn GetPlayerPawn()
{
	local NanoPC PC;

	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
        return PC.Pawn;
	}

	`warn( "Oh!! no valid player pawn!!" );
	return none;
}


/** This will look and see if the player can see the point passed in **/
simulated function bool CanPlayerSeeThisLocation( const Vector LocationToBeSeen )
{
	local Pawn PlayerPawn;
	local bool bInFront;

	local Actor HitA;
	local vector HitN, HitL;
	local TraceHitInfo HitInfo;

	local Vector Loc;
	local Rotator Rot;


    PlayerPawn = GetPlayerPawn();

	// grab camera location/rotation for checking Dist
    PlayerPawn.Controller.GetPlayerViewPoint( Loc, Rot );

	// a decent epsilon value is 0.98f as that allows a for a little bit of slop
	// NOTE: if you want to aim DIRECTLY at something then you would want ~= 1.0f
	if( (Normal(LocationToBeSeen - Loc) dot vector(Rot)) >= 0.2f )
	{
		//`log( " CanPlayerSeeThisLocation Point is in front of player!!" );
		bInFront = TRUE;
	}


	// so if the target is in front we need to trace and see if anything is blocking our sight
	if( bInFront == TRUE )
	{
   	 	HitA = Trace( HitL, HitN, PlayerPawn.Location, LocationToBeSeen, FALSE,, HitInfo, TRACEFLAG_Bullet );
		//DrawDebugLine( PlayerPawn.Location, LocationToBeSeen, 128, 128, 128, TRUE );

		// if we hit nothing
		if( HitA == none )
	    {
			//`log( " CanPlayerSeeThisLocation we hit nothing so we can prob see this" );
			//`log( " CanPlayerSeeThisLocation TRUE!!" );
			return TRUE;
	    }
	}



	//`log( " CanPlayerSeeThisLocation FALSE!!" @ HitA @ (Normal(LocationToBeSeen - Loc) dot vector(Rot)) @ "TraceHitDistance:" @ TraceHitDistance @ "DistanceToLocation:" @ DistanceToLocation );
	return FALSE;
}




/**
 * Allows arbitrary gameplay code to cause the game to "slomo" 
 *
 * @todo Need to look into how we might be able to generalize this to take delegates to call for the "on" / "off" cases
 **/
simulated function GameSlomo( float SlomoVal )
{
	if( Role != ROLE_Authority )
	{
		return;
	}

	// prob need to check here for OverriddenTimeDilation also so we don't go slower or faster (which one!)
	if( WorldInfo.TimeDilation != SlomoVal )
	{
		// reset to the previous TimeDialation
		if( SlomoVal == 1.0f )
		{
			WorldInfo.Game.SetGameSpeed( PreviousTimeDilation );
			OverriddenTimeDilation = WorldInfo.TimeDilation;
			bShouldIterpTimeDilation = TRUE;

			// maybe have slomo soundmode reset here
			// NanoGRI(WorldInfo.GRI).GetNanoPC().SetSoundMode( 'Default' );
		}
		// only allow one slomo setting at once
		else if( WorldInfo.TimeDilation == 1.0f )
		{
			//`log( "GameSlomoGameSlomoGameSlomo" @ `showvar(SlomoVal) );
			//Scripttrace();
			PreviousTimeDilation = WorldInfo.TimeDilation;
			OverriddenTimeDilation = SlomoVal;
			bShouldIterpTimeDilation = TRUE;

			//WorldInfo.Game.SetGameSpeed( SlomoVal );

			// maybe have slomo soundmode here
			// NanoGRI(WorldInfo.GRI).GetNanoPC().SetSoundMode( 'CombatSlowMotion' );
		}		
	}
}

function GameSlomoCurve(const out InterpCurveFloat NewSlomoCurve)
{
	CurrentTimeAlongSlomoCurve = 0.f;
	SlomoCurve = NewSlomoCurve;
}

/** This will reset the Game Slomo value to what it ws previously **/
simulated function ResetGameSlomo()
{
	//`log( "ResetGameSlomo" @ WorldInfo.RealTimeSeconds );
	GameSlomo( 1.0f );
}


function SetOverrideFOV(float NewFOV)
{
	bOverrideFOV = TRUE;
	DesiredFOV = NewFOV;
}

/** This will restore the FOV to the default **/
function ResetFOV()
{
	RightThumbStickScalar = 1.0f;
	bOverrideFOV = FALSE;
	bReturnToDefaultFOV = TRUE;
	DesiredFOV = class'NanoPlayerCamera'.default.DefaultFOV;
	//NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().FOV( class'NanoPlayerCamera'.default.DefaultFOV );
}


final function float GetDesiredFOV()
{
	return DesiredFOV;
}

/**
 * This will look at all of the dead bodies around us and find the center.
 **/
native function vector FindLocationToSpawnPostBattleGunSmoke( const out vector CurrLocation, const float DistToSearch );


/**
 * This will return all of the NanoPawns around the playerpawn
 *
 **/
native function array<NanoPawn> FindAllNanoPawnsAroundPlayerPawn( NanoPawn PlayerPawn, const float RadiusToCheck );

/**
 * This will return all of the NanoInterface_Targetable around the playerpawn
 *
 **/
native function array<Actor> FindAllNanoInterface_TargetableAroundPlayerPawn( NanoPawn PlayerPawn, const float RadiusToCheck );

/**
 * This will return all of the ProceduralMissionHints around the playerpawn
 *
 **/
native function array<NanoProceduralMissionHint> FindAllProceduralMissionHintsAroundPlayerPawn( NanoPawn PlayerPawn, const float RadiusToCheck );




/** Helper function to give all AI within a radius some stimuli **/
function AddStimuliInARadiusAroundEvent( float RadiusAroundEvent, Actor StimulusActor, vector StimulusLocation, bool bVisible, bool bIsFriendly, bool bCombative, bool bDamaged )
{
	local NanoAI AI;
	local float DistanceToMetaCorpUnit;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI.Pawn != none
			&& StimulusActor != none
			)
		{
			DistanceToMetaCorpUnit = VSize(AI.Pawn.Location - StimulusLocation);
		}

		if( DistanceToMetaCorpUnit < RadiusAroundEvent )
		{
			AI.AddStimulus( StimulusActor, StimulusLocation, bVisible, bIsFriendly, bCombative, bDamaged );
		}
	}
}



final function bool IsWithinHotZone( const out vector LocationToCheck )
{
	return ( VSize(LocationToCheck-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) < NanoGRI(WorldInfo.GRI).NPES.GetHotZoneRadius() );
}



function GiveReward( const out RewardDatum Reward, NanoPawn Receiver )
{
	local NanoHUD_Base TheHUD;

	TheHUD = NanoHUD_Base(NanoGRI(Receiver.WorldInfo.GRI).GetNanoPC().myHUD);


	if( Reward.CurrencyGained != 0 )
	{
		TheHUD.SlideTextMessage( Reward.CurrencyGained @ "Currency Gained!", 2.0f, class'Engine'.static.GetMediumFont(), None );
		Receiver.AddCurrency( Reward.CurrencyGained );
	}		

	if( Reward.NanoPowerBucketsGained != 0 )
	{
		TheHUD.SlideTextMessage( Reward.NanoPowerBucketsGained @ "Nano Absorbed!", 2.0f, class'Engine'.static.GetMediumFont(), None  );
		Receiver.AddNanoBuckets( Reward.NanoPowerBucketsGained );
	}

	if( Reward.NanoPowerForgeCoreBucketsGained != 0 )
	{
		TheHUD.SlideTextMessage( Reward.NanoPowerForgeCoreBucketsGained @ "Nano Forge Core Absorbed!", 2.0f, class'Engine'.static.GetMediumFont(), None  );
		Receiver.AddNanoForgeCoreBuckets( Reward.NanoPowerForgeCoreBucketsGained );
	}


	if( Reward.RebelMindShareGained != 0 )
	{
		TheHUD.SlideTextMessage( Reward.RebelMindShareGained @ "RebelMindShare Gained!", 2.0f, class'Engine'.static.GetMediumFont(), None  );
		NanoGRI(Receiver.WorldInfo.GRI).GetCurrentRebelMindShareManager().AddRebelMindShareLevel( Reward.RebelMindShareGained );
	}		

	if( Reward.XPGained != 0 )
	{
		TheHUD.SlideTextMessage( Reward.XPGained @ "XP Gained!", 2.0f, class'Engine'.static.GetMediumFont(), None  );
		Receiver.AddXP( Reward.XPGained );
	}		

	if( Reward.DataPlan != None )
	{
		TheHUD.SlideTextMessage( Reward.DataPlan @ "Plan Gained!", 2.0f, class'Engine'.static.GetMediumFont(), None  );

		Receiver.GetPRI().GiveNanoPlan( Reward.DataPlan, Reward.bShouldUnlockPlan );

		NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_AcquiredANewDataPlan ); // I think this it the best place to put it
	}

}


/** This function just constantly polls the DB for a set of values that we care about **/
function PollForValueFromDB_MobileResponse()
{
	local string UserName;
	local String CurrValueString;
	
	//`log( self @ GetFuncName() );

	UserName = class'NanoMCPKeys'.default.MobileUserID; // class'NanoMobileTypes'.static.GetLocalPlayerUserName();

	MCP.DownloadFromMCP( UserName, class'NanoMCPKeys'.default.RespondedToCallForHelp_Type, CurrValueString, MCP, nameof(MCP.UpdateFromMCP) );

	MCP.DownloadFromMCP( UserName, class'NanoMCPKeys'.default.RespondedToCallForHelp_Color, CurrValueString, MCP, nameof(MCP.UpdateFromMCP) );
}


/** This function just constantly polls the DB for a set of values that we care about **/
function PollForValueFromDB_LyrikStoreItem()
{
	local string UserName;
	local String CurrValueString;

	//`log( self @ GetFuncName() );

	UserName = class'NanoMCPKeys'.default.MobileUserID; // class'NanoMobileTypes'.static.GetLocalPlayerUserName();

	MCP.DownloadFromMCP( UserName, class'NanoMCPKeys'.default.LyrikStoreItem, CurrValueString, MCP, nameof(MCP.UpdateFromMCP) );
}


function PollForValueFromDB_RebelSuperBomb()
{
	local string UserName;
	local String CurrValueString;

	//`log( self @ GetFuncName() );

	UserName = ""; //class'NanoMCPKeys'.default.MobileUserID; // class'NanoMobileTypes'.static.GetLocalPlayerUserName();

	MCP.DownloadFromMCP( UserName, class'NanoMCPKeys'.default.RebelSuperBombForge_FoundBy, CurrValueString, MCP, nameof(MCP.UpdateFromMCP) );
	MCP.DownloadFromMCP( UserName, class'NanoMCPKeys'.default.RebelSuperBombForge_UnlockedBy, CurrValueString, MCP, nameof(MCP.UpdateFromMCP) );
	MCP.DownloadFromMCP( UserName, class'NanoMCPKeys'.default.RebelSuperBombForge_BombState, CurrValueString, MCP, nameof(MCP.UpdateFromMCP) );
}




function SendForMobileHelp()
{
	local string UserName;

	`log( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	`log( "Chaos Tier 3 Reached We need help!" );
	`log( self @ GetFuncName() );
	`log( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );

	UserName = class'NanoMCPKeys'.default.MobileUserID;

	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.LyrikNeedsMobileHelp, "RequestNormal" );

	NanoGRI(WorldInfo.GRI).GetNanoPC().PlaySound( class'NanoProceduralEnemySpawner'.default.MobileRequest_Request_Normal );
}

function SendForMobileHelp_Urgent()
{
	local string UserName;

	`log( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	`log( "Chaos Tier 3 Reached We need help!" );
	`log( self @ GetFuncName() );
	`log( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );

	UserName = class'NanoMCPKeys'.default.MobileUserID;

	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.LyrikNeedsMobileHelp, "RequestUrgent" );

	NanoGRI(WorldInfo.GRI).GetNanoPC().PlaySound( class'NanoProceduralEnemySpawner'.default.MobileRequest_Request_Urgent );
}



function ResetMobileHelp()
{
	local string UserName;

	//`log( self @ GetFuncName() );

	UserName = class'NanoMCPKeys'.default.MobileUserID;

	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.LyrikNeedsMobileHelp, "" );

	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.RespondedToCallForHelp_Type, "" );

	NPES.ResetMobileHelpVars();
}



defaultproperties
{
	OverriddenTimeDilation=1
	CurrentTimeAlongSlomoCurve=-1
	TickGroup=TG_PreAsyncWork
}
