/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoEffectsManager extends Actor
	config(Game);


/** This will show all of the debug info for spawning these blood decals **/
var() config bool bShowDebugInfo_Decals;


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
simulated final function NanoDecal LeaveADecalMesh( Actor HitActor, const out SkeletalMeshComponent HitMesh, delegate<DecalTrace> DecalTraceFunc, delegate<DecalChoice> DecalChoiceFunc, delegate<DecalTimeVaryingParams> DecalTimeVaryingParamsFunc, optional vector ForceStartLocation )
{
	local NanoDecal GD;
	local DecalData DecalData;
	local float RotationToUseForDecal;

	local Actor TraceActor;
	local bool bHitComp;
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


	// needs to be trace component
	TraceExtent = vect(6,6,6);
	bHitComp = TraceComponent( out_HitLocation, out_HitNormal, HitMesh, TraceDest, TraceStart, TraceExtent, HitInfo );

	//TraceActor = Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, TRUE, TraceExtent, HitInfo, TRACEFLAG_Bullet );

	`if(`notdefined(FINAL_RELEASE))
		if( ( bShowDebugInfo_Decals ) ) // && ( bHitComp == TRUE ) )
		{
			`log( `showvar(bHitComp) @ `showvar(HitMesh) );
			DrawDebugLine( TraceStart, TraceDest, 255, 1, 1, TRUE );
			DrawDebugLine( out_HitLocation, out_HitLocation + (out_HitNormal*128.0f), 1, 1, 255, TRUE );
			//`log( "About to spawn a decal: " $ DecalData.DecalMaterial );
			//ScriptTrace();
		}
	`endif

	//if( TraceActor != None )
	if( bHitComp == TRUE )
	{
		TraceActor = HitActor;
		//`log( "Blood DecalMaterial: " $ DecalData.DecalMaterial );
		//`log( Material(MaterialInstanceTimeVarying(DecalData.DecalMaterial).Parent).bUsedWithDecals );

		RandomScale = GetRangeValueByPct( DecalData.RandomScalingRange, FRand() );
		DecalData.Width *= RandomScale;
		DecalData.Height *= RandomScale;

		//GD = NanoGRI(WorldInfo.GRI).NOP.GetDecal_Blood( out_HitLocation );
		GD = new(self) class'NanoDecal';
		GD.MITV_Decal = new(GD) class'MaterialInstanceTimeVarying';

		if( GD != none )
		{
			bIsHorde = WorldInfo.GRI.IsCoopMultiplayerGame();
			bIsSplitScreen = class'Engine'.static.IsSplitScreen();
			DecalLifeSpan = (bIsHorde|| bIsSplitScreen) ? DecalData.LifeSpan : 999999.0;

			GD.MITV_Decal.SetParent( DecalData.DecalMaterial );
			// @TODO:  pass in a struct with the decal params you want to use
			WorldInfo.MyDecalManager.SetDecalParameters(
				GD,
				GD.MITV_Decal,
				out_HitLocation,
				rotator(-out_HitNormal),
				bIsHorde ? (DecalData.Width*0.80f) : DecalData.Width,
				bIsHorde ? (DecalData.Height*0.80f) : DecalData.Height,
				DecalData.Thickness,
				(bIsHorde || bIsSplitScreen) ? FALSE : !DecalData.ClipDecalsUsingFastPath,
				RotationToUseForDecal,
				HitInfo.HitComponent,
				TRUE,
				TRUE,
				HitInfo.BoneName,
				INDEX_NONE,
				INDEX_NONE,
				INDEX_NONE,
				class'NanoDecal'.default.DepthBias,
				DecalData.BlendRange
				);

			TraceActor.AttachComponent( GD );
			//LocationOfLastBloodTrail = out_HitLocation;

			// if horde or splitscren then fade decals out instead of leaving them around for ever
			GD.MITV_Decal.SetDuration( DecalLifeSpan );

			//DecalTimeVaryingParams = DecalTimeVaryingParamsFunc;
			//DecalTimeVaryingParams( GD.MITV_Decal );
			//DecalTimeVaryingParams = None;

			`if(`notdefined(FINAL_RELEASE))
				if( bShowDebugInfo_Decals )
				{
					//`log( "  SPAWNED " );
					//FlushPersistentDebugLines();
					//DrawDebugCoordinateSystem( out_HitLocation, rotator(-out_HitNormal), 3.0f, TRUE );
				}
			`endif
		}
	}

	return GD;
}



defaultproperties
{
}