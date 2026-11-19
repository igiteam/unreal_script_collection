/**
 * NanoPawnFX:  this is meant to hold all of the "effects" type code
 *
 * Currently this is an object but depending on much further we want to go, it should be turned into an Actor.
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawnFX extends Object within NanoPawnBase
	config(Pawn);

/** Location of the last blood trail decal.  Needed to orient the decal correctly**/
var protected transient vector LocationOfLastBloodTrail;

/** Bone that we spawned from/at **/
var transient name BoneNameSpawnedFrom;


var(PostDeath) transient SoundCue PostDeathPersistentDeathWails;

/** Special animation to play on the camera when this gore effect fires. **/
var(PostDeath) transient name PostDeathPersistentAnimationToPlay;



/** Internal. */
final simulated private function SpawnABloodTrail_Internal(delegate<NanoGRI.DecalTrace> DecalTraceFunc, delegate<NanoGRI.DecalChoice> DecalChoiceFunc, delegate<NanoGRI.DecalTimeVaryingParams> DecalTimeVaryingParamsFunc, optional vector ForceStartLocation)
{
	local NanoGRI GRI;
	local NanoDecal GD;

	if ( bSpawnBloodTrailDecals )
	{
		GRI = NanoGRI(WorldInfo.GRI);
		if ( (GRI != None) && GRI.ShouldShowGore() ) 
		{
			GD = GRI.LeaveADecalWorld(DecalTraceFunc, DecalChoiceFunc, DecalTimeVaryingParamsFunc, ForceStartLocation);
			if (GD != None)
			{
				LocationOfLastBloodTrail = GD.Location;
			}
		}
	}
}

/** return as a random XY vector based on the inputs **/
final simulated function vector GetRandomOffsetVector_XY( float MinVal, float MaxVal )
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




/**
 * This will trace from the pawn to the ground below them.
 **/
simulated final function BloodDecalTrace_GroundBelowThePawn( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;
	local vector StartLoc;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	if( VSize(ForceStartLocation) > 0.0f )
	{
		StartLoc = ForceStartLocation;
	}
	else
	{
		StartLoc = Location;
	}

	//`log( "BloodDecalTrace_GroundBelowThePawn" );
	out_TraceStart = StartLoc + ( Vect(0,0,15)) + RandomOffsetVect;;
	out_TraceDest = out_TraceStart - ( Vect(0,0,256));
}


simulated final function BloodDecalChoice_LimbBreak( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'NanoPhysicalMaterialProperty'.static.GetBloodDecalData( class'NanoPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), NDTT_LimbBreak, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}


/**
 * This will set the params for typical blood decals.
 **/
simulated final function BloodDecalTimeVaryingParams_Default( out MaterialInstance out_MI_Decal )
{
	MaterialInstanceTimeVarying(out_MI_Decal).SetDuration( 45.0f );
}

simulated final function SpawnABloodTrail_LimbBreak( vector InStartLocation )
{
	SpawnABloodTrail_Internal( BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_LimbBreak, BloodDecalTimeVaryingParams_Default, InStartLocation );
}



/** This will spawn some delayed effects.  We do this as we need to keep some state around somewhere and each bit broken off works well **/
simulated function SpawnDelayedSpurtEffects()
{
	local NanoPawn NP;
	//local vector BoneRelativeLocation;
	//local rotator DirectionToSprayParticles, BoneRelativeRotation;
	local SoundCue SpurtSound;


	NP = NanoPawn(Outer);

	if( NP != none )
	{
		// sound
		if( NP.HeadBoneNames.Find(BoneNameSpawnedFrom) != INDEX_NONE )
		{
			SpurtSound = NP.DismemberSpurtingDecapitateSound;
		}
		else
		{
			SpurtSound = NP.DismemberSpurtingSound;
		}

		PlaySound( SpurtSound, TRUE, TRUE, TRUE, Location  );

		// spurting fluid effect
		//PawnToSpawnDelayedSpurtEffectsOn.Mesh.TransformToBoneSpace( BoneNameSpawnedFrom, InHitLocation, DirectionToSprayParticles, BoneRelativeLocation, BoneRelativeRotation );

		if( BoneNameSpawnedFrom != 'None' )
		{
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( NP.DismemberSpurtingEffect, Mesh, BoneNameSpawnedFrom, FALSE );
		}
	}

}


simulated final function BloodDecalTrace_FromNeck( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector				Loc;
	local rotator				Rot;

	if( Mesh == none )
	{
		return;
	}

	if( Mesh.GetSocketWorldLocationAndRotation( 'HeadShotBloodPS', Loc, Rot ) )
	{
		//`log( "BloodDecalTrace_FromNeck" );
		out_TraceStart = Loc;

		// move this down some number of units so we intersect the floor and leave nice blood spurts
		out_TraceDest = (out_TraceStart + (vector(Rot) * 128.0f)) + vect(0,0,-50);

		//DrawDebugLine( out_TraceStart, out_TraceDest, 255, 1, 1, TRUE );
		//DrawDebugCoordinateSystem( out_TraceStart, Rot, 7.0f, TRUE );
		//`log( out_TraceStart );
	}
}


/**
 * This will choose the Decals to use for the generic blood splatter
 **/
simulated final function BloodDecalChoice_HeadShot( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'NanoPhysicalMaterialProperty'.static.GetBloodDecalData( class'NanoPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), NDTT_NeckSpurt, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}
	


/** This will leave a trail of blood from your headshot stump **/
simulated final function SpawnABloodTrail_HeadShot()
{
	SpawnABloodTrail_Internal( BloodDecalTrace_FromNeck, BloodDecalChoice_HeadShot, BloodDecalTimeVaryingParams_Default );
}

/** This will stop the head shot spurting blood trail @see PlayHeadShotDeath **/
simulated final function StopBloodTrail_HeadShot()
{
	ClearTimer( nameof(SpawnABloodTrail_HeadShot) );
}



simulated final function SpawnABloodTrail_BloodPool()
{
	local vector HipLocation;

	HipLocation = Mesh.GetBoneLocation( 'b_MF_Pelvis', 0 );

	SpawnABloodTrail_Internal( BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_BloodPool, BloodDecalTimeVaryingParams_Default, HipLocation );
}


simulated final function BloodDecalChoice_BloodPool( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'NanoPhysicalMaterialProperty'.static.GetBloodDecalData( class'NanoPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), NDTT_BloodPool, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}


simulated function DoPostDeathEffects()
{
	if( PostDeathPersistentDeathWails != none )
	{
		PlaySound( PostDeathPersistentDeathWails );
	}

	if( PostDeathPersistentAnimationToPlay != '' )
	{
		NanoAnimNodeSlot(Mesh.FindAnimNode('FullBodySlot')).PlayCustomAnim( PostDeathPersistentAnimationToPlay, 1.0, 0.1, -1.f, FALSE, TRUE );
	}
	
}




defaultproperties
{
}

