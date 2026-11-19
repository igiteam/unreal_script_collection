/**
 * GearPawnFX:  this is meant to hold all of the "effects" type code
 *
 * Currently this is an object but depending on much further we want to go, it should be turned into an Actor.
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawnFX extends Object within GearPawn
	config(Pawn);


/** This will leave a trail of blood when you are DBNO **/
simulated final function SpawnABloodTrail_DBNO()
{
	if (VSize(Velocity) > 10.0)
	{
		SpawnABloodTrail_Internal( BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_DBNO);
	}
}

/** This will leave a trail of blood when you are MeatBagging **/
simulated final function SpawnABloodTrail_MeatBag()
{
	if (VSize(Velocity) > 10.0)
	{
		if (FRand() > 0.40)
		{
			SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_MeatBag);
		}
		else
		{
			SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_MeatBagHeelScuff);
		}
	}
}

/** This will leave a trail of blood when you are in cover **/
simulated final function SpawnABloodTrail_Wall()
{
	if (VSize(Velocity) > 10.0)
	{
		SpawnABloodTrail_Internal(BloodDecalTrace_CoverBehindPawnMiddleOfBody, BloodDecalChoice_Wall);
	}
}

simulated final function SpawnABloodTrail_GibExplode_Ground()
{
	SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn_Rand, BloodDecalChoice_GibExplode_Ground);
}

/** This will unleash a blast of gore on the walls, ceiling, and floor around the character**/
simulated final function SpawnABloodTrail_GibExplode_360()
{
	local GearGRI GRI;

	if ( bSpawnBloodTrailDecals )
	{
		GRI = GearGRI(WorldInfo.GRI);
		if (GRI != None && GRI.ShouldShowGore())
		{
			GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Forward, BloodDecalChoice_ChainsawSpray_Ground);
			GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Left, BloodDecalChoice_ChainsawSpray_Ground);
			GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Backward, BloodDecalChoice_ChainsawSpray_Ground);
			GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Right, BloodDecalChoice_ChainsawSpray_Ground);

			GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Down, BloodDecalChoice_GibExplode_Ground);

			GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Down, BloodDecalChoice_GibExplode_Ground_SmallSplat);
			GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Down, BloodDecalChoice_GibExplode_Ground_SmallSplat);
			// 50% chance of leaving a third small splat
			if (FRand() > 0.5)
			{
				GRI.LeaveADecal(BloodDecalTrace_360AroundPawn_Down, BloodDecalChoice_GibExplode_Ground_SmallSplat);
			}
		}
	}
}

/** sets parameters for the chainsaw blood decals */
simulated function SetChainsawBloodParams(MaterialInstanceTimeVarying MI_Decal);

/** This will leave a trail of blood on the ground when you chainsaw someone **/
simulated final function SpawnABloodTrail_ChainsawSpray_Ground()
{
	SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowTheWeaponEnd_Rand, BloodDecalChoice_ChainsawSpray_Ground, SetChainsawBloodParams,, true);
}

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated final function SpawnABloodTrail_ChainsawSpray_Wall()
{
	SpawnABloodTrail_Internal(BloodDecalTrace_TraceFromEndOfChainsaw, BloodDecalChoice_ChainsawSpray_Wall, SetChainsawBloodParams,, true);
}

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated final function SpawnABloodTrail_GibImpact( vector HitLoc )
{
	SpawnABloodTrail_Internal(BloodDecalTrace_TraceGibImpact, BloodDecalChoice_GibImpact,, HitLoc);
}

/** This will leave a trail of blood from your headshot stump **/
simulated final function SpawnABloodTrail_HeadShot()
{
	SpawnABloodTrail_Internal(BloodDecalTrace_FromNeck, BloodDecalChoice_HeadShot);
}

simulated final function SpawnABloodTrail_BloodPool()
{
	SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_BloodPool);
}

simulated final function SpawnABloodTrail_PawnIsReallyHurt()
{
	SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_PawnIsReallyHurt);
}

simulated final function SpawnABloodTrail_HitByABullet()
{
	SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_HitByBullet);
}

simulated final function SpawnABloodTrail_LimbBreak( vector InStartLocation )
{
	SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn, BloodDecalChoice_LimbBreak,, InStartLocation);
}

simulated final function SpawnABloodTrail_HeavySniper( vector InStartLocation )
{
	SpawnABloodTrail_Internal(BloodDecalTrace_GroundBelowThePawn, BloodHeavySniperDecalChoiceFunc,, InStartLocation);
}

simulated protected function BloodHeavySniperDecalChoiceFunc( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_HeavySniperBlast, WorldInfo );

	if( out_DecalData.bRandomizeRotation == TRUE )
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

/** This will leave a trail of Headworm decal when you are MeatBagging **/
simulated final function SpawnAHeadwormTrail()
{
	SpawnDecal_Internal(BloodDecalTrace_GroundBelowThePawn, HeadwormDecalChoice);
}

/** Internal. */
simulated private final function SpawnDecal_Internal(delegate<GearGRI.DecalTrace> DecalTraceFunc, delegate<GearGRI.DecalChoice> DecalChoiceFunc, optional delegate<GearGRI.DecalTimeVaryingParams> DecalTimeVaryingParamsFunc, optional vector ForceStartLocation)
{
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		GRI.LeaveADecal(DecalTraceFunc, DecalChoiceFunc, DecalTimeVaryingParamsFunc, ForceStartLocation);
	}
}

/** This will leave a trail of Headworm decal when you are MeatBagging **/
simulated final function SpawnSerapedeSplat()
{
	SpawnDecal_Internal(BloodDecalTrace_SerapedeLastTailSegment, SerapedeDecalChoice);
}

/**
 * This will trace from the pawn to the ground below them.
 **/
simulated final function BloodDecalTrace_SerapedeLastTailSegment( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;
	local GearPawn_LocustSerapedeBase Serapede;

	Serapede = GearPawn_LocustSerapedeBase(Outer);

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn" );
	out_TraceStart = Serapede.LastBlownOffTailLocation() + ( Vect(0,0,15)) + RandomOffsetVect;;
	out_TraceDest = out_TraceStart - ( Vect(0,0,256));
}

/** Internal. */
simulated private final function SpawnABloodTrail_Internal(delegate<GearGRI.DecalTrace> DecalTraceFunc, delegate<GearGRI.DecalChoice> DecalChoiceFunc, optional delegate<GearGRI.DecalTimeVaryingParams> DecalTimeVaryingParamsFunc, optional vector ForceStartLocation, optional bool bForce)
{
	local GearGRI GRI;
	local GearDecal GD;

	//@hack: disable blood trails when the flower effects are on
	if ((bSpawnBloodTrailDecals || bForce) && GearFlowerEmitterPool(WorldInfo.MyEmitterPool) == None)
	{
		GRI = GearGRI(WorldInfo.GRI);
		if (GRI != None && GRI.ShouldShowGore())
		{
			GD = GRI.LeaveADecal(DecalTraceFunc, DecalChoiceFunc, DecalTimeVaryingParamsFunc, ForceStartLocation);
			if (GD != None)
			{
				LocationOfLastBloodTrail = GD.Location;
			}
		}
	}
}


// @ todo pass in a hit normal so we can get hits on walls also
simulated final function BloodDecalTrace_TraceGibImpact( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	out_TraceStart = ForceStartLocation + ( Vect(0,0,15));
	out_TraceDest =  out_TraceStart - ( Vect(0,0,100));
}

simulated final function BloodDecalTrace_FromNeck( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector				Loc;
	local rotator				Rot;

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


simulated final function BloodDecalTrace_FromNeckForFacePunch( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector				Loc;
	local rotator				Rot;

	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	if( Mesh.GetSocketWorldLocationAndRotation( 'HeadShotBloodPS', Loc, Rot ) )
	{
		//`log( "BloodDecalTrace_FromNeck" );
		out_TraceStart = Loc;

		// move this down some number of units so we intersect the floor and leave nice blood spurts
		out_TraceDest = (out_TraceStart + (vector(Rot) * 128.0f)) + vect(0,0,-100) + RandomOffsetVect;

		//DrawDebugLine( out_TraceStart, out_TraceDest, 255, 1, 1, TRUE );
		//DrawDebugCoordinateSystem( out_TraceStart, Rot, 7.0f, TRUE );
		//`log( out_TraceStart );
	}
}



/**
 * This will look at the previous blood trail decal and then figure out what the rotation of the next decal needs to be to look
 * like the current one "trailed" from the previous one.
 **/
simulated final function float DetermineRotationOfBloodTrailDecal()
{
	local float Retval;

	if( Rotator(Location - LocationOfLastBloodTrail).Yaw >= 0 )
	{
		Retval = abs((Rotator(Location - LocationOfLastBloodTrail).Yaw)/65535.0f) * -360.0f;
	}
	else
	{
		Retval = abs((Rotator(Location - LocationOfLastBloodTrail).Yaw)/65535.0f) * 360.0f;
	}

	//`log( "Rotation: " $ Rotation.Yaw @ Retval );

	return Retval;
}


/**
 * This will trace from the pawn to the ground below them.
 **/
simulated final function BloodDecalTrace_GroundBelowThePawn( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn" );
	out_TraceStart = Location + ( Vect(0,0,15)) + RandomOffsetVect;;
	out_TraceDest = out_TraceStart - ( Vect(0,0,256));
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



/**
 * This will trace from the pawn to the ground below them. Randomly spread out around them.
 **/
simulated final function BloodDecalTrace_GroundBelowThePawn_Rand( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -128.0f, 128.0f );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = Location + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart - Vect(0,0,256);

	//`log( out_TraceStart );
}


/** This is "forward" trace from the pawn **/
simulated final function BloodDecalTrace_360AroundPawn_Forward( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = Location + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart + Vect(0,256,0);

	//`log( out_TraceStart );
}

/** This is "left" trace from the pawn **/
simulated final function BloodDecalTrace_360AroundPawn_Left( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = Location + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart + Vect(-256,0,0);

	//`log( out_TraceStart );
}

/** This is "right" trace from the pawn **/
simulated final function BloodDecalTrace_360AroundPawn_Right( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = Location + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart + Vect(256,0,0);

	//`log( out_TraceStart );
}

/** This is "backward" trace from the pawn **/
simulated final function BloodDecalTrace_360AroundPawn_Backward( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = Location + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart + Vect(0,-256,0);

	//`log( out_TraceStart );
}

/** This is "up" trace from the pawn **/
simulated final function BloodDecalTrace_360AroundPawn_Up( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = Location + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart + Vect(0,0,256);

	//`log( out_TraceStart );
}

/** This is "down" trace from the pawn **/
simulated final function BloodDecalTrace_360AroundPawn_Down( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RandomOffsetVect;

	RandomOffsetVect = GetRandomOffsetVector_XY( -1.0f*RandomOffsetRadius, RandomOffsetRadius );

	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	out_TraceStart = Location + Vect(0,0,15) + RandomOffsetVect;
	out_TraceDest = out_TraceStart + Vect(0,0,-256);

	//`log( out_TraceStart );
}


/** This will trace from the pawn to the ground below them. Randomly spread out around them. **/
simulated final function BloodDecalTrace_GroundBelowTheWeaponEnd_Rand(out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation)
{
	local SkeletalMeshComponent WeapMesh;
	local vector Loc;
	local rotator Rot;
	local vector2d RandomOffset;
	local vector RandomOffsetVect;

	if (MyGearWeapon != None && MyGearWeapon.MuzzleFlashArchetype != None)
	{
		WeapMesh = SkeletalMeshComponent(MyGearWeapon.Mesh);

		if (WeapMesh != None && WeapMesh.GetSocketWorldLocationAndRotation(MyGearWeapon.MuzzleFlashArchetype.MuzzleSocketName, Loc, Rot))
		{
			//`log( "BloodDecalTrace_GroundBelowTheWeaponEnd_Rand" );
			RandomOffset.X = -128;
			RandomOffset.Y = 128;

			RandomOffsetVect.X = GetRangeValueByPct(RandomOffset,FRand());
			RandomOffsetVect.Y = GetRangeValueByPct(RandomOffset,FRand());
			RandomOffsetVect.Z = 0.0f;

			//`log( "BloodDecalTrace_GroundBelowTheWeaponEnd_Rand" );
			out_TraceStart = Loc + Vect(0,0,15) + RandomOffsetVect;
			out_TraceDest =  out_TraceStart + Vect(0,0,-256);

			//`log( out_TraceStart );
		}
	}
}


/**
 * This will determine where to trace for the wall smear bood trail.
 **/
simulated final function BloodDecalTrace_CoverBehindPawnMiddleOfBody( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector SocketLocation;

	//`log( "BloodDecalTrace_CoverBehindPawnMiddleOfBody" );

	SocketLocation = Mesh.GetBoneLocation( PelvisBoneName );
	out_TraceStart = SocketLocation;
	out_TraceStart.Z = SocketLocation.Z;

	out_TraceDest = SocketLocation - ((GetCollisionRadius() + 50) * AcquiredCoverInfo.Normal);
	out_TraceDest.Z = SocketLocation.Z;

	//DrawDebugCoordinateSystem( out_TraceStart, rot(0,0,0), 2.0f, TRUE );
	//DrawDebugLine( out_TraceStart, out_TraceDest, 255, 0, 0, TRUE );
}


/** This will trace from the pawn to the ground below them. **/
simulated final function BloodDecalTrace_TraceFromEndOfChainsaw(out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation)
{
	local SkeletalMeshComponent WeapMesh;
	local vector Loc;
	local rotator Rot;

	if (MyGearWeapon != None && MyGearWeapon.MuzzleFlashArchetype != None)
	{
		WeapMesh = SkeletalMeshComponent(MyGearWeapon.Mesh);
		if (WeapMesh != None && WeapMesh.GetSocketWorldLocationAndRotation(MyGearWeapon.MuzzleFlashArchetype.MuzzleSocketName, Loc, Rot))
		{
			out_TraceStart = Loc;
			out_TraceDest = out_TraceStart + (Vector(Rot) * 512.0f);
		}
	}
}


/**
 * This will choose the Decals to use for the generic blood splatter
 **/
simulated final function BloodDecalChoice_HeadShot( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_NeckSpurt, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}

	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
}


/**
 * This will choose the Decals to use for the generic blood splatter
 **/
simulated final function BloodDecalChoice_Splat( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood_DecalStaticSwitch.MITV_UsefadingYes' );
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood_DecalStaticSwitch.Decals.MITV_UsefadingNo' );
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Decals.MITV_BloodSplatter02' );

	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_Blood_GenericSplat, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}

	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Decals.BloodSplatter02' );
}

/**
* This will choose the Decals to use for the generic blood splatter
**/
simulated final function BloodDecalChoice_GibImpact( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood_DecalStaticSwitch.MITV_UsefadingYes' );
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood_DecalStaticSwitch.Decals.MITV_UsefadingNo' );
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Decals.MITV_BloodSplatter02' );

	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_GibImpact, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}

	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
}



/**
 * This will choose the Decals to use for the generic blood splatter
 **/
simulated function BloodDecalChoice_ChainsawSpray_Wall( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_Chainsaw_Wall, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

simulated function BloodDecalChoice_ChainsawSpray_Ground( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_Chainsaw_Ground, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

simulated final function BloodDecalChoice_GibExplode_Ground( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_GibExplode_Ground, WorldInfo );
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_6' );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

/**
 * This will choose the Decals to use for the wall trail.  Data will be moved to PhysicalMaterial System / Content Driven.
 **/
simulated final function BloodDecalChoice_Wall( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	if( LocationOfLastBloodTrail == Vect(0,0,0) )
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_Wall_SlammingIntoCover, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
	}
	else
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_Wall_Smear, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstanceConstant'Gear_Blood.Materials.DM_BloodSmear_Wall_Straight_01' );
	}

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
	else
	{
		out_DecalRotation = 0.0f;
	}
}

/**
 * This will choose the Decals to use for DBNO.  Data will be moved to PhysicalMaterial System / Content Driven.
 **/
simulated final function BloodDecalChoice_DBNO( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalRotation = DetermineRotationOfBloodTrailDecal();

	if( LocationOfLastBloodTrail == Vect(0,0,0) )
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_DBNO_BodyHittingFloor, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
	}
	else
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_DBNO_Smear, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Straight_8' );
	}
}

/**
 * This will choose the Decals to use for the splatter blood trail.  Data will be moved to PhysicalMaterial System / Content Driven.
 **/
simulated final function BloodDecalChoice_MeatBag( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	if( LocationOfLastBloodTrail == Vect(0,0,0) )
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_MeatBag_FirstGrabbing, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );
	}
	else
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_MeatBag_BloodSplatter, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Decals.MITV_BloodSplatter02' );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Decals.BloodSplatter02' );
	}

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

/**
 * This will choose the Decals to use for the MeatBag heel scuff.   Data will be moved to PhysicalMaterial System / Content Driven.
 **/
simulated final function BloodDecalChoice_MeatBagHeelScuff( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalRotation = DetermineRotationOfBloodTrailDecal();

	if( LocationOfLastBloodTrail == Vect(0,0,0) )
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_MeatBag_FirstGrabbing, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_1' );

		if (out_DecalData.bRandomizeRotation)
		{
			out_DecalRotation = FRand() * 360.0f;
		}
	}
	else
	{
		out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_MeatBag_HeelScuff, WorldInfo );
		//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Straight_5' );
	}
}

simulated final function BloodDecalChoice_BloodPool( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_BloodPool, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

simulated final function BloodDecalChoice_GibExplode_Ground_SmallSplat( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_GibExplode_Ground_SmallSplat, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

simulated final function BloodDecalChoice_PunchFace( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_ExecutionLong_PunchFace, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}


simulated final function BloodDecalChoice_PawnIsReallyHurt( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_PawnIsReallyHurtSmallSplat, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

simulated final function BloodDecalChoice_HitByBullet( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_HitByBulletSmallSplat, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}


simulated final function BloodDecalChoice_LimbBreak( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_LimbBreak, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}


/**
 * This will choose the Decals to use for the splatter blood trail.  Data will be moved to PhysicalMaterial System / Content Driven.
 **/
simulated final function HeadwormDecalChoice( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_DrudgeHeadWormTrail, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

/**
 * This will choose the Decals to use for the splatter blood trail.  Data will be moved to PhysicalMaterial System / Content Driven.
 **/
simulated final function SerapedeDecalChoice( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_SerapedeTailBlownOffSplat, WorldInfo );

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

simulated function SpawnChainsawCameraBlood(PlayerController PC)
{
	if (SpecialMove == SM_ChainsawVictim)
	{
		PC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Chainsaw');
	}
}

simulated function SpawnBayonetCameraBlood(PlayerController PC)
{
	if (SpecialMove == SM_BayonetVictim || SpecialMove == SM_BayonetDraw_Follower ||  SpecialMove == SM_BayonetDraw_Leader)
	{
		PC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Bayonet');
	}
}

defaultproperties
{
}
