/**
 * This guy keeps track of when we should spawn specific types of gore into the world.
 *
 * So we need a combination of things:
 *
 * -how frequent a specific gore effect should fire (e.g. you don't want 5 butterflies in a row nor do you want 5 butterflies in a spam of
 * 30 seconds)
 * -how frequent one should see any death gore effect
 * -special overrides for:  you have just fought 10 guys and this is the last guy OMFG it better die gloriously!
 *
 *
 *
 *
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoGoreManager extends Actor
	native
	config(Game);

var transient NanoGoreEffect LastGoreEffect;

struct native GoreEffectParams
{
	var NanoPawn NP;
	var name OverrideDeathAnimName;
	var vector HitLocation;
	var vector HitNormal;
	var NanoGoreEffect GoreEffect;
};



var config float TimeBetweenGore;
var transient float LastGoreTime;

var protected transient bool bTimedGore;


// gore periodicity

/**
 * Number of AI that have been killed since we started combat.  NanoPCBase.Died() updates this value BEFORE the gore is triggered
 **/
var transient int NumAIKilledSinceCombatStarted;

/** How often we want a gore bit to fly off **/
var config int GoreEveryNKills;

/** How often we want slomo to occur on a death (which is also a gore moment plus slomo **/
var config int SlomoEveryNKills;

/** if user has forced a combo **/
var transient bool bForceSlomoAsComboButtonIsPressed;


var float TimeBetweenDismemberSounds;
var transient float NextTimeToPlayDismemberSound;



simulated function PlayGoreCameraAnim()
{
	local NanoPC NPC;
	NPC = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC();
	NPC.PlayerCamera.PlayCameraAnim(LastGoreEffect.CameraAnimationToPlay,1.f,1.f,0.1,0.3);
}


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}


simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( `TimeSince(LastGoreTime) > TimeBetweenGore )
	{
		bTimedGore = TRUE;
	}
}



/** This will chop off a bone from the skeleton and scale the bone to zero **/
private function ChopOffBone( const out NanoPawn NP, const out name BoneName, const out vector HitLocation, float UpwardsMomentumToApplyToDismemberedBits, float OutwardMomentumToApplyToDismemberedBits )
{
	local name TmpBoneName;
	local vector ForceToApply;

	TmpBoneName = BoneName; //'b_MF_Calf_L';

	// set all bones below to be "physical"
	NP.Mesh.PhysicsAssetInstance.ForceAllBodiesBelowUnfixed( TmpBoneName, NP.Mesh.PhysicsAsset, NP.Mesh, TRUE );

	if( UpwardsMomentumToApplyToDismemberedBits == 0 )
	{
		UpwardsMomentumToApplyToDismemberedBits = 100; // default value
	}

	ForceToApply.X = Rand(2*OutwardMomentumToApplyToDismemberedBits) - OutwardMomentumToApplyToDismemberedBits;
	ForceToApply.Y = Rand(2*OutwardMomentumToApplyToDismemberedBits) - OutwardMomentumToApplyToDismemberedBits;
	ForceToApply.Z = UpwardsMomentumToApplyToDismemberedBits;

	NP.BreakConstraint( ForceToApply, HitLocation, TmpBoneName, TRUE );

	//NP.PlaySound( NP.DismemberSound, TRUE, TRUE, TRUE, NP.Location );
}


protected function DoParticleSpawning( NanoPawn NP, const out array<ParticleSpawnDatum> ParticleData )
{
	local WorldInfo WI;
	local ParticleSpawnDatum PSD;
	local SkeletalMeshSocket SkelMeshSocket;
	local ParticleSystemComponent PSC;

	WI = class'WorldInfo'.static.GetWorldInfo();
	foreach ParticleData( PSD )
	{
		// get a particle system comp
		//PSC = WI.MyEmitterPool.SpawnEmitterCustomLifetime( None );
		PSC = new(NP) class'NanoParticleSystemComponent'; // SpawnEmitterCustomLifetime assumes that you are using the PSC immediately and does crazy stuff.  So just make a new one for now
		PSC.bAutoActivate = FALSE;
		PSC.bJustAttached = TRUE;
		PSC.SetAbsolute( FALSE, FALSE );
		PSC.SetTickGroup( TG_PostUpdateWork );
		PSC.OnSystemFinished = WI.MyEmitterPool.OnParticleSystemFinished;
		PSC.SetTemplate( PSD.EffectToSpawn );

		// find out where to attach.  try sockets first then bone names
		SkelMeshSocket = NP.Mesh.GetSocketByName( PSD.SocketName );
		if( SkelMeshSocket != none )
		{
			NP.Mesh.AttachComponentToSocket( PSC, PSD.SocketName );
		}
		else
		{
			NP.Mesh.AttachComponent( PSC, PSD.SocketName );
		}

		//`log( WorldInfo.TimeSeconds @ "waiting" @ FMax(PSD.DelayBeforeSpawning,0.001f) @ " to fire" @ PSD.EffectToSpawn @ "on" @ PSD.SocketName );
		// set the time on the PSC to activate
		NP.SetTimer( FMax(PSD.DelayBeforeSpawning,0.001f), FALSE, nameof(PSC.ActivateSystem), PSC );

		if( PSD.DurationBeforeDeactivating > 0.0f )
		{
			NP.SetTimer( FMax(PSD.DelayBeforeSpawning,0.001f)+PSD.DurationBeforeDeactivating, FALSE, nameof(PSC.DeactivateSystem), PSC );
		}
	}
}


protected function PlayNanoGoreEffect( const out GoreEffectParams InParams )
{
	local int Idx;
	local name BoneName;
	local vector foo;
	local NanoPawn NP;
	local NanoPC NPC;
	local float AnimTime;
	local float SlomoResetTime;
	local NanoGRI NGRI;
	local NanoGoreEffect GoreEffect;
	local NanoPawn_MetaCorp_NanoInfantry RiotCop;
	local GoreMaterialParams GMP;
	local DecalDatum DD;
	local DelayedSpawning_DecalComponent DelayedDecalComp;
	local name CameraFocusBone;
	local bool bShouldDueSlomoDueToPeriodicity;

	NP = InParams.NP;
	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	NPC = NGRI.GetNanoPC();
	GoreEffect = InParams.GoreEffect;


	NP.bDidGoreEffectDeath = TRUE;

	//`log( "PlayNanoGoreEffect" @ `showvar(InParamsGoreEffect.GoreType) );

	// play animation
	if( GoreEffect.PawnAnimationToPlay != '' )
	{
		NP.DeathReaction.AnimName = GoreEffect.PawnAnimationToPlay;
		AnimTime = NP.PlayDeathAnim( None, NPC.MyNP.FullBodySlot.GetCustomAnimNodeSeq().CurrentTime );
	}

	// break all of the bones that want to be broken
	for( Idx = 0; Idx < GoreEffect.BoneNamesToBreak.Length; ++Idx )
	{
		BoneName = GoreEffect.BoneNamesToBreak[Idx];

		if( NP.GoreBreakableJoints.Find('ConstraintName', BoneName) == INDEX_NONE )
		{
			`log( "PossiblyChopOffBone returning as InBoneName not found" @ BoneName );
			continue;
		}

		// @todo: hack for vect(0,0,0)
		ChopOffBone( NP, BoneName, foo, GoreEffect.UpwardsMomentumToApplyToDismemberedBits, GoreEffect.OutwardMomentumToApplyToDismemberedBits );
	}


	// play an effect sound
	if( GoreEffect.EffectSoundForPawnToPlay != none )
	{
		NP.DeathSoundForPawnToPlay = TRUE;
		NP.PlaySound( GoreEffect.EffectSoundForPawnToPlay );
	}

	// play a specialized death sound ( e.g. "ohhh god my aaarmmm!!" )
	if( ( GoreEffect.DeathSoundForPawnToPlay != none )
		&& ( NextTimeToPlayDismemberSound < WorldInfo.TimeSeconds )
		)
	{
		NP.DeathSoundForPawnToPlay = TRUE;
		NP.PlaySound( GoreEffect.DeathSoundForPawnToPlay );
		NextTimeToPlayDismemberSound = WorldInfo.TimeSeconds + TimeBetweenDismemberSounds;
	}

	// spawn the camera effect
	// @todo prob need to put a distance check in here
	if( GoreEffect.CameraEffect != none )
	{
		// if we are within range for the camera effect then play it
		if( VSize( NPC.Pawn.Location - NP.Location ) < GoreEffect.DistanceToPlayCameraEffect )
		{
			NPC.ClientSpawnCameraLensEffect( GoreEffect.CameraEffect );
		}
	}


	//`log( `showvar(GoreEffect) @ `showvar(GoreEffect.DelegateToCall)  );

	if( GoreEffect.DelegateToCall != '' )
	{
		CallGoreManagerEventByName( GoreEffect.DelegateToCall, InParams );
	}


	// check to see if the last AI has died.  (if we are getting a gore event and none are left then we just killed them)
	// we only do slomo on the last guy

	bShouldDueSlomoDueToPeriodicity = TimeForGoreSlomoDueToPeriodicity();

	if( ( GoreEffect.bCanDoSlomo == TRUE )
		&&	( ( bShouldDueSlomoDueToPeriodicity == TRUE ) || ( AIAliveInMeleeCombat() == FALSE )  || ( bForceSlomoAsComboButtonIsPressed == TRUE ) )
		)
	{
		if( GoreEffect.SlomoValue != 1.0f )
		{
			if ( GoreEffect.SlomoCurve.Points.Length > 0)
			{
				NGRI.GameSlomoCurve( GoreEffect.SlomoCurve );
			}
			else
			{
				NGRI.GameSlomo( GoreEffect.SlomoValue );
	
				if( GoreEffect.SlomoTime > 0.0f )
				{
					SlomoResetTime = GoreEffect.SlomoTime;
				}
				else if( AnimTime > 0.0f )
				{
					SlomoResetTime = AnimTime;
				}
				// safety
				else
				{
					SlomoResetTime = 1.0f;
				}
	
				//`log( `showvar(SlomoResetTime) @ WorldInfo.RealTimeSeconds );
				NGRI.SetTimer( SlomoResetTime*GoreEffect.SlomoValue, FALSE, nameof(NGRI.ResetGameSlomo) );
			}

			NPC.Pawn.PlaySound( SoundCue'Weapon_Sword.Sword_Impact.Sword_SlomoAttack_Stereo_01Cue' ); // DEMO HACK
			NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_SlowMotionDeath );
			NanoGRI(WorldInfo.GRI).GetNanoPC().SetSoundMode( 'CombatSlowMotion' );
		}

		if (GoreEffect.CameraAnimationToPlay == None)
		{
			if( GoreEffect.DesiredFOV > 0 )
			{
				NGRI.RightThumbStickScalar = 0.10f;
	
				//CurrFOV = NPC.GetFOVAngle();
				//`log( `showvar(CurrFOV));
				//NPC.FOV( GoreEffect.DesiredFOV );
				// zoom in on the broken bones
				NGRI.SetOverrideFOV(GoreEffect.DesiredFOV);
				NGRI.SetTimer( SlomoResetTime*GoreEffect.SlomoValue + 1.0f, FALSE, nameof(NGRI.ResetFOV) );
			}
	
			// Have to use a "central" bone here as if you use the last BoneName that could be none and/or it could be sent flying
			// off into the level (which while cool to track is not what we want to do here)
			if( GoreEffect.CameraFocusBone != '' )
			{
				CameraFocusBone = GoreEffect.CameraFocusBone;
			}
			else
			{
				CameraFocusBone = 'b_MF_Spine_03';
			}

  			NPC.SetGoreCameraTarget( NP, CameraFocusBone );
  			// this reset needs to be a bit longer than the animation to allow the camera to move back to a "pulled" back
  			// spot or you will get obscene popping
  			NPC.SetTimer(SlomoResetTime*GoreEffect.SlomoValue, FALSE, nameof(NPC.ClearGoreCameraTarget));
  			
			//NPC.SetFocusPoint( FALSE, NP, vect2d(3.f, 3.f), vect2d(1.f, 1.f), 0.f, TRUE, TRUE, FALSE, CameraFocusBone, FALSE );
			//NPC.SetTimer(SlomoResetTime*GoreEffect.SlomoValue,FALSE,nameof(NPC.ClearFocusPoint_LeaveRotation));
		}
		else
		{
			NPC.SetRotation(rotator(NP.Location - NPC.MyNP.Location));
			SetTimer(0.1f,FALSE,nameof(PlayGoreCameraAnim));
		}
	}


	// check for post death effects
	if( ( GoreEffect.PostDeathPersistentDeathWails != none )
		|| ( GoreEffect.PostDeathPersistentAnimationToPlay != '' )
		)
	{
		NP.NanoPawnFX.PostDeathPersistentDeathWails = GoreEffect.PostDeathPersistentDeathWails;
		NP.NanoPawnFX.PostDeathPersistentAnimationToPlay = GoreEffect.PostDeathPersistentAnimationToPlay;

		SetTimer( GoreEffect.TimeToWaitBeforePostDeathEffects, FALSE, nameof(NP.NanoPawnFX.DoPostDeathEffects), NP.NanoPawnFX );
	}

	RiotCop = NanoPawn_MetaCorp_NanoInfantry(NP);

	if( RiotCop != none )
	{
		if( GoreEffect.DurationOfGlow > 0.0f )
		{
			RiotCop.DoGoreGlowEffect( GoreEffect.DurationOfGlow );
		}
		
		if( GoreEffect.MI_GoreMaterial0_GoreMask != none )
		{
			RiotCop.MITV_GoreOverLay.SetTextureParameterValue( 'BloodSpillMask', GoreEffect.MI_GoreMaterial0_GoreMask );
		}

		foreach GoreEffect.GoreMaterial0( GMP )
		{
			RiotCop.DoGoreParam( RiotCop.MITV_GoreOverLay, GMP.GoreMaterial1_Name, GMP.GoreMaterial1_Duration, GMP.GoreMaterial1_Delay, GMP.bFadeBackToZero, GMP.FadeBackDownToZeroAfterReachingOne_Delay, GMP.FadeBackDownToZeroAfterReachingOne_Duration );
		}


		foreach GoreEffect.GoreMaterial1( GMP )
		{
			RiotCop.DoGoreParam( RiotCop.MITV_Gore, GMP.GoreMaterial1_Name, GMP.GoreMaterial1_Duration, GMP.GoreMaterial1_Delay, GMP.bFadeBackToZero, GMP.FadeBackDownToZeroAfterReachingOne_Delay, GMP.FadeBackDownToZeroAfterReachingOne_Duration );
		}
	}


	DoParticleSpawning( NP, GoreEffect.ParticleSpawnData );
	DoParticleSpawning( NP, GoreEffect.ArterialSpurting );

	
	foreach GoreEffect.DecalData( DD )
	{
		DelayedDecalComp = new(NP) class'DelayedSpawning_DecalComponent';
		DelayedDecalComp.NP = NP;
		DelayedDecalComp.DecalToSpawn = DD.Decal;
		DelayedDecalComp.WhereToTraceFrom = DD.WhereToTraceFrom;
		NP.AttachComponent( DelayedDecalComp );

		//`log( WorldInfo.TimeSeconds @ "waiting" @ FMax(DD.Delay,0.001f) @ " to fire" @ DD.Decal.DecalMaterial @ "on" @ DD.WhereToTraceFrom );
		NP.SetTimer( FMax(DD.Delay,0.001f), FALSE, nameof(DelayedDecalComp.DoDecalSpawning), DelayedDecalComp );
	}
	

	// do blood effects on weapons and characters
	if( NPC != none )
	{
		if( NanoWeap_Sword(NPC.Pawn.Weapon) != none )
		{
			NanoWeap_Sword(NPC.Pawn.Weapon).SetBladeFullBlood();
		}
	}

	NanoPawn(NPC.Pawn).SetFullBlood();


	// do the post physics impulse on the pawn
	if( ( GoreEffect.ForceToImpartAfterDeathAndRagdolled > 0.0f ) )
	{
		NP.PostDeathImpulseVector = -Normal(NPC.Pawn.Location - NP.Location);

		//DrawDebugLine( NPC.Pawn.Location, NPC.Pawn.Location+(NP.PostDeathImpulseVector*256), 255, 0, 0, TRUE );

		NP.PostDeathImpulseVector *= GoreEffect.ForceToImpartAfterDeathAndRagdolled;

		NP.PostDeathImpulseBoneName = GoreEffect.PostDeathImpulseBoneName;
	}


	NP.SetTimer( 60.0, FALSE, nameof(NP.GoreAroundTooLong), NP );

	LastGoreEffect = InParams.GoreEffect;
}


function CheckValidityOfPassedInGoreType( const Name GoreType, NanoPawn NP )
{
	local int Idx;
	local bool bFound;

	if( GoreType == 'None' )
	{
		return;
	}


	for( Idx = 0; Idx < NP.GoreEffects.ListOfGoreEffects.Length; ++Idx )
	{
		if( NP.GoreEffects.ListOfGoreEffects[Idx].GoreType == GoreType )
		{
			bFound = TRUE;
		}
	}

	if( bFound == FALSE )
	{
		`warn( "CheckValidityOfPassedInGoreType: could not find" @ `showvar(GoreType) );
		ScriptTrace();
	}

}



function bool ShouldPlayNanoGoreEffect( bool bActuallyPlay, Name GoreType, NanoPawn NP, const out vector HitLocation, const out vector HitNormal, optional bool bForce, optional out name OverrideDeathAnimName, optional bool bForceSlomoDueToComboButton )
{
	local int Idx;
	local GoreEffectParams Params; 
	local NanoGoreEffect GoreEffect;
	local bool bForceFire;
	local bool bAIIsInCinematicSoHeShouldExplode;
	local bool bLastAIJustDied;
	local bool bGorePeriodicity;

	if( NP.GoreEffects == None )
	{
		return FALSE;
	}

/*	if( TRUE )
		return FALSE;
*/

`if(`notdefined(FINAL_RELEASE))
	CheckValidityOfPassedInGoreType( GoreType, NP );
`endif

	// here we need to iterate over all ListOfGoreEffects and see if any of them are bForceTest_AlwaysUseOnDeathHit
	for( Idx = 0; Idx < NP.GoreEffects.ListOfGoreEffects.Length; ++Idx )
	{
		GoreEffect = NP.GoreEffects.ListOfGoreEffects[Idx];

		if( GoreEffect.bForceTest_AlwaysUseOnDeathHit == TRUE )
		{
			GoreType = GoreEffect.GoreType;
		}
	}




	for( Idx = 0; Idx < NP.GoreEffects.ListOfGoreEffects.Length; ++Idx )
	{
		GoreEffect = NP.GoreEffects.ListOfGoreEffects[Idx];

		bAIIsInCinematicSoHeShouldExplode = (NanoAIBase(NP.Controller) != none) ? ((NanoAIBase(NP.Controller).CurrCinematicAITargetPoint != none)) : FALSE;

		// here we also want to have a timer / bucket mechanic that can force a gore fire
		bForceFire = bAIIsInCinematicSoHeShouldExplode || GoreEffect.bForceTest_AlwaysUseOnDeathHit || GoreEffect.bForceTest; // || TRUE;

		// check to see if the last AI has died.  (if we are getting a gore event and none are left then we just killed them)
		bLastAIJustDied = AIAliveInMeleeCombat() == FALSE;


		//`log( `showvar(GoreEffect.GoreType ) @ `showvar(bAIIsInCinematicSoHeShouldExplode) @ `showvar(bLastAIJustDied) @ `showvar(GoreEffect.bForceTest_AlwaysUseOnDeathHit) @ `showvar(bForce) @ `showvar(GoreEffect.bForceTest) @ `showvar(bLastAIJustDied) );

		if( ( GoreEffect.GoreType != GoreType ) && ( bForceFire == FALSE ) )
		{
			continue;
		}

		bGorePeriodicity = TimeForGoreSlomoDueToPeriodicity(); // || bTimedGore

		// so now test to see if we want to fire this specific gore effect even if we are not at the WillSpawnAtGoal
		bForceFire = bForceFire || bLastAIJustDied || bGorePeriodicity || bForce;

		// sheeeeeettttt
		// if user has forced a combo
		if( bForceSlomoDueToComboButton == TRUE )
		{
			//`log( "bForceSlomoDueToComboButton" );
			bForceSlomoAsComboButtonIsPressed = TRUE;
		}

		if( bActuallyPlay == FALSE )
		{
			if( ( bForceFire == TRUE )
				|| ( (GoreEffect.WillSpawnAtCurr + GoreEffect.IncrementValue) > GoreEffect.WillSpawnAtGoal )
				)
			{
				OverrideDeathAnimName = GoreEffect.PawnAnimationToPlay;
				return TRUE;
			}
			return FALSE;
		}

		//`log( `showvar(GoreEffect) @ `showvar(GoreEffect.WillSpawnAtCurr) @ `showvar(GoreEffect.WillSpawnAtGoal) );




		NP.GoreEffects.ListOfGoreEffects[Idx].WillSpawnAtCurr += GoreEffect.IncrementValue;
		if( ( bForceFire == TRUE )
			|| ( GoreEffect.WillSpawnAtCurr > GoreEffect.WillSpawnAtGoal )
			)
		{
			NP.GoreEffects.ListOfGoreEffects[Idx].WillSpawnAtCurr = 0;
			Params.NP = NP;
			Params.OverrideDeathAnimName = OverrideDeathAnimName;
			Params.HitLocation = HitLocation;
			Params.HitNormal = HitNormal;
			Params.GoreEffect = GoreEffect;

			bTimedGore = FALSE;
			LastGoreTime = WorldInfo.TimeSeconds;

			PlayNanoGoreEffect( Params );
			return TRUE;
		}
		
	}

	return FALSE;
}


/** Checks to see if any AI are alive and engaged in melee combat. **/
function bool AIAliveInMeleeCombat()
{
	local NanoAI AI;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( ( AI.Pawn != none ) 
			&& ( AI.Pawn.Health > 0 )
			&& ( AI.CommandList != None )
			&& ( AI.FindCommandOfClass( class'NanoAIAction_EngageThreatBase' ) != None )
			)
		{
			return TRUE;
		}
	}
		
		
	return FALSE;
}


/** 
 * This is our function which will call an event via a passed in name. 
 **/
final private native function CallGoreManagerEventByName( const out name DelegateName, GoreEffectParams InParams );



event ButterFlySplit( const out GoreEffectParams InParams )
{
	//local ParticleSystemComponent PSC_SplitSpray;

	NanoPawn_Infantry(InParams.NP).TurnOffSpineSkelControllers();
	NanoPawn_Infantry(InParams.NP).TurnOffDualSpineConstraints();

	//PSC_SplitSpray = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'Nano_Blood.Effects.P_Nano_SmallLimb_Spurt', (InParams.NP.Mesh), 'b_MF_Pelvis',, , );
	//PSC_SplitSpray.SetScale3D( vect( 1.5f, 1.5f, 4.0f) );

}

event ChopInHalfHorizontally( const out GoreEffectParams InParams )
{

}

event ChopInHalfVertically( const out GoreEffectParams InParams )
{
	NanoPawn_Infantry(InParams.NP).TurnOffSpineSkelControllers();
	NanoPawn_Infantry(InParams.NP).TurnOffDualSpineConstraints();
}

event GoreExplosion( const out GoreEffectParams InParams )
{
	InParams.NP.GoreExplosion( vect(0,0,750), InParams.NP.Location, class'NDT_NanoSword', TRUE );
}

event PlayDecapitationEffects( const out GoreEffectParams InParams )
{

}

event SliceOffMoreThanOneLimb( const out GoreEffectParams InParams )
{
	local array<ImpactInfo> BoneHits;
	local name BoneName;
	local int Idx;
	local vector HitLocation;
	local vector HitNormal;


	HitLocation = InParams.HitLocation;
	HitNormal = InParams.HitNormal;


	DrawDebugLine( HitLocation, HitLocation+((-HitNormal)*256), 255, 0, 0, TRUE );
	DrawDebugCoordinateSystem( HitLocation, rot(0,0,0), 5.0f, TRUE);

	if( TraceAllPhysicsAssetInteractions( InParams.NP.Mesh, HitLocation+((-HitNormal)*256), HitLocation, BoneHits ) == TRUE )
	{
		for( Idx = 0; Idx < BoneHits.Length; ++Idx )
		{
			BoneName = BoneHits[Idx].HitInfo.BoneName;

			if( InParams.NP.GoreBreakableJoints.Find('ConstraintName', BoneName) != INDEX_NONE )
			{
				// prob can look for these and maybe term them?  NanoPawn_Infantry(NP).TurnOffDualSpineConstraints();
				`log( "PossiblySliceOffMoreThanOneLimb:" @ BoneName);
				ChopOffBone( InParams.NP, BoneName, BoneHits[Idx].HitLocation, 0, 0 );
			}
		}
	}
}


event HeadShotEffects( const out GoreEffectParams InParams )
{
	local NanoPawn_Infantry NPI;
	local array<name> BoneNames;
	local int Idx;

	NPI = NanoPawn_Infantry(InParams.NP);

	if( NPI == none )
	{
		return;
	}

	NPI.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( NPI.PS_HeadShotBloodSpray, NPI.Mesh, NPI.HeadShotBloodSpraySocket, TRUE );

	if( NPI.bSpawnBloodTrailDecals )
	{
		// start up the blood spurting from the neck
		SetTimer( 0.2f, TRUE, nameof(NPI.NanoPawnFX.SpawnABloodTrail_HeadShot), NPI.NanoPawnFX );
		SetTimer( 3.5f, FALSE, nameof(NPI.NanoPawnFX.StopBloodTrail_HeadShot), NPI.NanoPawnFX );
	}


	BoneNames = InParams.GoreEffect.BoneNamesToBreak;

	for( Idx = 0; Idx < BoneNames.Length; ++Idx )
	{
		NPI.TurnOffSpineSkelController( BoneNames[Idx] );
		NPI.TurnOffDualSpineConstraint( BoneNames[Idx] );
	}	

}


event PossiblyChopOffBone()
{
	//ChopOffBone( NP, BoneName, HitLocation );
}


final function bool CanCauseDismemberedAndDying( NanoPawn NP, const name InGoreType )
{
	local int Idx;

	if( NP.GoreEffects != none )
	{
		for( Idx = 0; Idx < NP.GoreEffects.ListOfGoreEffects.Length; ++Idx )
		{
			if( NP.GoreEffects.ListOfGoreEffects[Idx].GoreType == InGoreType )
			{
				return NP.GoreEffects.ListOfGoreEffects[Idx].bAllowDismemberedAndDying;
			}
		}
	}

	return FALSE;
}


final function bool NextHitIsDismemberedAndDying()
{
	// don't ever do a DismemberedAndDying if no one has died
	if( NumAIKilledSinceCombatStarted == 0 )
	{
		return FALSE;
	}

	if( (NumAIKilledSinceCombatStarted % GoreEveryNKills) == 0 )
	{
		return TRUE;
	}

	return FALSE;
}


final function PossiblyDoDismemberedAndDying( NanoPawn NP, const name GoreType, const out vector HitLocation, const out vector HitNormal )
{
	// don't ever do a DismemberedAndDying if no one has died
	if( NumAIKilledSinceCombatStarted == 0 )
	{
		return;
	}

	if( ( (NumAIKilledSinceCombatStarted % GoreEveryNKills) == 0 ) || ( NP.bDismemberedAndDying == TRUE ) )
	{
		if( CanCauseDismemberedAndDying( NP, GoreType ) == TRUE )
		{
			//`log( "FORCED bDismemberedAndDying" @ `showvar(NumAIKilledSinceCombatStarted) @ `showvar(NP.bDismemberedAndDying) );
			ShouldPlayNanoGoreEffect( TRUE, GoreType, NP, HitLocation, HitNormal, TRUE, NP.DeathReaction.AnimName );
			NP.bDismemberedAndDying = TRUE;
			NumAIKilledSinceCombatStarted++;
		}
	}
}


function ResetGorePeriodicity()
{
	NumAIKilledSinceCombatStarted = 0;
}


function NotifyANewAIHasDied( const NanoAIBase InAI, class<DamageType> DamageType )
{
	if( DamageType == class'NDT_KilledByProceduralSpawner' )
	{
		return;
	}

	NumAIKilledSinceCombatStarted++;

	// tricky.  Since we are "killing them" above in the PossiblyDoDismemberedAndDying we need need to
	// actually not count their actual death here as we alredy tallied it
	if( DamageType == class'NDT_BledOutDueToDismemberment' )
	{
		NumAIKilledSinceCombatStarted--;
	}


}


function bool TimeForGoreSlomoDueToPeriodicity()
{
	local bool Retval;


	// So since we want gore at the "start" and "end" of every battle we can do some trickiness here
	// If NumAIKilledSinceCombatStarted is 1 then we know we are at the start of a combat
	// first kill means we do gore
	if( NumAIKilledSinceCombatStarted == 1 )
	{
		return TRUE;
	}

	if( (NumAIKilledSinceCombatStarted % SlomoEveryNKills) == 0 )
	{
		Retval = TRUE;
	}

	//`log( `showvar(NumAIKilledSinceCombatStarted) @ `showvar(Retval) );



	return Retval;
}



defaultproperties
{
	TimeBetweenDismemberSounds=10.0f
}