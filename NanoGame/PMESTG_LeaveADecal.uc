/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class PMESTG_LeaveADecal extends PMESTG_LeaveADecalBase
	hidecategories(Object);


/** Type to leave */

var() ENanoDecalType DecalType;

var() EImpactTypeBallistic BallisticType;

var() EImpactTypeExplosion ExplosionType;


var private transient vector CollideDirection;

var private transient vector AHitLocation;




function DoEvent( const out vector InCollideDirection, const out vector InHitLocation, const out vector InHitNormal, const out name InBoneName )
{
	//`log( InCollideDirection @ Normal(InCollideDirection) @ -normal(InCollideDirection) );
	AHitLocation = InHitLocation;
	CollideDirection = -InCollideDirection;
	// so now this guy needs to spray some decals on the ground
	//NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).bShowDebugInfo_Decals = TRUE;

	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).SpawnABloodTrail_Internal( DecalTrace_GroundBelowThePawn_Rand, DecalChoice_Trace_Ground, DecalTimeVaryingParams_Default, InHitLocation, SoundCue'Foley_Body.MetaCorps.Gore_BloodSplatter_Cue' );

	//NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).bShowDebugInfo_Decals = FALSE;
}



simulated final function DecalChoice_Trace_Ground( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	local float RotationFromYaw;
//	local rotator foo;

	//`log( "I was called sweet!" @ DecalType );
	//ScriptTrace();

	out_DecalData = class'NanoPhysicalMaterialProperty'.static.GetBloodDecalData( Physicalmaterial'NanoPhysMats.DefaultPhysMat', DecalType, class'WorldInfo'.static.GetWorldInfo() );
	//out_MI_Decal.SetParent( MaterialInstance'Gear_Blood.Materials.DM_BloodSmear_Var01_Spot_6' );


	RotationFromYaw = ((CollideDirection.Y ) * 360.0f);

	//`log( CollideDirection @ RotationFromYaw );

	out_DecalRotation = RotationFromYaw;


	//foo.Yaw = CollideDirection.Y*32767.0f;


//	foo = rotator(CollideDirection);

	//class'WorldInfo'.static.GetWorldInfo().DrawDebugCoordinateSystem( AHitLocation, foo, 50.0f, TRUE);


	if (out_DecalData.bRandomizeRotation)
	{
		//out_DecalRotation = FRand() * 360.0f;
	}
}


/**
 * This will trace from the pawn to the ground below them. Randomly spread out around them.
 **/
simulated final function DecalTrace_GroundBelowThePawn_Rand( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	//`log( "BloodDecalTrace_GroundBelowThePawn_Rand" );
	//out_TraceStart = ForceStartLocation + (15 * CollideDirection);
	//out_TraceDest = out_TraceStart - ( 128 * CollideDirection);

	// we can trace short distances here as we know we just collided with something to get this event
	out_TraceStart = ForceStartLocation + (CollideDirection * 8); //Vect(0,0,15);// + RandomOffsetVect;
	out_TraceDest = out_TraceStart - (CollideDirection * 16); //Vect(0,0,256);
	//class'WorldInfo'.static.GetWorldInfo().DrawDebugCoordinateSystem( out_TraceStart, rot(0,0,0), 3.0f, TRUE );



	//`log( out_TraceStart );
}

/**
 * This will set the params for typical blood decals.
 **/
simulated final function DecalTimeVaryingParams_Default( out MaterialInstance out_MI_Decal )
{
	MaterialInstanceTimeVarying(out_MI_Decal).SetDuration( 45.0f );

	//`log( MaterialInstanceTimeVarying(out_MI_Decal).ScalarParameterValues.Length );
}







defaultproperties
{
	PhysicalMaterialPropertyClass=class'NanoPhysicalMaterialProperty'
}




