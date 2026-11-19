/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGExplosionActor extends GameExplosionActor
	notplaceable
	config(TGWeapon)
	native(TGWeapon);

/** Whether or not this Explosion is from something that has an ActiveReload bonus that is active **/
var bool bActiveReloadBonusActive;

/**
 * Internal.  Extract what data we can from the physical material-based effects system
 * and stuff it into the ExplosionTemplate.
 * Data in the physical material will take precedence.
 *
 * We are also going to be checking for relevance here as when any of these params are "none" / invalid we do not
 * play those effects in Explode().  So this way we avoid any work on looking things up in the physmaterial
 *
 */
simulated protected function UpdateExplosionTemplateWithPerMaterialFX(PhysicalMaterial PhysMaterial)
{
	//local DecalData DecalData;
	//local ParticleSystem ExplosionPS;
	//local SoundCue ExploSound;
	//local FogVolumeSphericalDensityInfo FogVolumeArchetype;
	//local class<Emit_CameraLensEffectBase> CameraEffect;
	//local float CameraEffectRadius;
	//local class<GearDamageType> MyGearDamageType;
	//local GearGRI GRI;

	//GRI = GearGRI(WorldInfo.GRI);
	//MyGearDamageType = class<GearDamageType>(ExplosionTemplate.MyDamageType);


	//if( GRI.IsEffectRelevant( Instigator, Location, 6000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) )
	//{
	//	// so if we are not manually overriding the PS then look it up
	//	if( ExplosionTemplate.bParticleSystemIsBeingOverriddenDontUsePhysMatVersion == FALSE )
	//	{
	//		ExplosionPS = class'GearPhysicalMaterialProperty'.static.DetermineImpactParticleSystem( PhysMaterial, MyGearDamageType, bActiveReloadBonusActive, WorldInfo, InstigatorController != None ? InstigatorController.Pawn : None );
	//		if( ExplosionPS != None )
	//		{
	//			// copy for actual use
	//			ExplosionTemplate.ParticleEmitterTemplate = ExplosionPS;
	//		}
	//	}
	//}
	//else
	//{
	//	ExplosionTemplate.ParticleEmitterTemplate = none;
	//}


	//if( GRI.IsEffectRelevant( Instigator, Location, 6000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) )
	//{
	//	// decal data
	//	DecalData = class'GearPhysicalMaterialProperty'.static.DetermineImpactDecalData( PhysMaterial, MyGearDamageType, bActiveReloadBonusActive, WorldInfo, InstigatorController != None ? InstigatorController.Pawn : None);
	//	if( DecalData.bIsValid )
	//	{
	//		// copy for actual use
	//		ExplosionTemplate.DecalData = DecalData;
	//	}
	//}
	//else
	//{
	//	ExplosionTemplate.DecalData = DecalData;
	//}


	//// this is "always" relevant so the broken sound cue cross faders can be fixed up
	//if( GRI.IsEffectRelevant( Instigator, Location, 100000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistance ) )
	//{
	//	// audio
	//	ExploSound = class'GearPhysicalMaterialProperty'.static.DetermineImpactSound( PhysMaterial, MyGearDamageType, bActiveReloadBonusActive, WorldInfo );
	//	if( ExploSound != None )
	//	{
	//		// copy for actual use
	//		ExplosionTemplate.ExplosionSound = ExploSound;
	//	}
	//}
	//else
	//{
	//	ExplosionTemplate.ExplosionSound = none;
	//}


	//// Fog volumes are always relevant as they have gameplay repercussions in terms of visibility
	//// fog volume
	//if( ExplosionTemplate.bUsePerMaterialFogVolume == TRUE )
	//{
	//	FogVolumeArchetype = class'GearPhysicalMaterialProperty'.static.DetermineFogVolumeArchetype( PhysMaterial, MyGearDamageType, bActiveReloadBonusActive, WorldInfo );
	//	if( FogVolumeArchetype != None )
	//	{
	//		// copy for actual use
	//		ExplosionTemplate.FogVolumeArchetype = FogVolumeArchetype;
	//	}
	//}


	//if( GRI.IsEffectRelevant( Instigator, Location, 2048, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) )
	//{
	//	CameraEffect = class'GearPhysicalMaterialProperty'.static.DetermineImpactCameraEffect( PhysMaterial, MyGearDamageType, bActiveReloadBonusActive, WorldInfo, CameraEffectRadius );
	//	if( CameraEffect != None )
	//	{
	//		// copy for actual use
	//		ExplosionTemplate.CameraEffect = CameraEffect;
	//		ExplosionTemplate.CameraEffectRadius = CameraEffectRadius;
	//	}
	//}
	//else
	//{
	//	ExplosionTemplate.CameraEffect = none;
	//}
}

simulated function SpawnExplosionParticleSystem(ParticleSystem Template)
{
	local Emitter ExplosionEmitter;

	ExplosionEmitter = TGGRI(WorldInfo.GRI).GOP.GetImpactEmitter( ExplosionTemplate.ParticleEmitterTemplate, Location, Rotation );
	if (ExplosionEmitter != None)
	{
		// attach the emitter to the attachee if available and if we were asked to actually attach this
		if( (/*ExplosionTemplate.*/Attachee != None) && (ExplosionTemplate.bAttachExplosionEmitterToAttachee) )
		{
			ExplosionEmitter.SetBase(/*ExplosionTemplate.*/Attachee);
		}

		ExplosionEmitter.SetDrawScale(ExplosionTemplate.ExplosionEmitterScale);

		// now check to see if this Explosion is using the per map values
		//if( ExplosionTemplate.bUseMapSpecificValues == TRUE )
		//{
		//	GSI = GearMapSpecificInfo(WorldInfo.GetMapInfo());
		//	if( GSI != none )
		//	{
		//		if( GSI.ColorConfig != none )
		//		{
		//			// look over all of the effects
		//			foreach GSI.ColorConfig.EffectParams( EP )
		//			{
		//				// if there are any for my damage type
		//				if( ExplosionTemplate.MyDamageType == EP.DamageType )
		//				{
		//					// do all of the setting
		//					foreach EP.VectorParams( VP )
		//					{
		//						ExplosionEmitter.ParticleSystemComponent.SetVectorParameter( VP.Name, VP.Value );
		//						//`log( "Setting Vect:" @ VP.Name @ VP.Value );
		//					}

		//					foreach EP.FloatParams( FP )
		//					{
		//						ExplosionEmitter.ParticleSystemComponent.SetFloatParameter( FP.Name, FP.Value );
		//						//`log( "Setting Float:" @ FP.Name @ FP.Value );
		//					}
		//				}
		//			}
		//		}
		//	}
		//}

		ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
	}
}

simulated function SpawnExplosionDecal()
{
//	// spawn a decal
//	// @todo when GearPawnFX.LeaveADecal is promoted to global object update this
//	if( ExplosionTemplate.DecalData.bIsValid )
//	{
//		TraceActor = Trace( out_HitLocation, out_HitNormal, (Location + (-ExplosionTemplate.HitNormal * ExplosionTemplate.DecalTraceDistance)), Location, FALSE, TraceExtent, HitInfo, TRACEFLAG_Bullet );
//		//DrawDebugLine( Location, (Location + (-ExplosionTemplate.HitNormal * ExplosionTemplate.DecalTraceDistance)) , 255, 1, 1, TRUE );
//		if( TraceActor != None )
//		{
//
//			RandomScale = GetRangeValueByPct( ExplosionTemplate.DecalData.RandomScalingRange, FRand() );
//			ExplosionTemplate.DecalData.Width *= RandomScale;
//			ExplosionTemplate.DecalData.Height *= RandomScale;
//
//			GD = GearGRI(WorldInfo.GRI).GOP.GetDecal_Explosion( out_HitLocation );
//			if( GD != none )
//			{
//				bIsHorde = WorldInfo.GRI.IsCoopMultiplayerGame();
//				bIsSplitScreen = class'Engine'.static.IsSplitScreen();
//				DecalLifeSpan = (bIsHorde || bIsSplitScreen) ? ExplosionTemplate.DecalData.LifeSpan : 999999.0;
//
//				//`log( "Explo DM: " $ ExplosionTemplate.DecalData.DecalMaterial );
//				GD.MITV_Decal.SetParent( ExplosionTemplate.DecalData.DecalMaterial );
//
//				// @TODO:  pass in a struct with the decal params you want to use
//				WorldInfo.MyDecalManager.SetDecalParameters(
//					GD,
//					GD.MITV_Decal,
//					out_HitLocation,
//					rotator(-out_HitNormal),
//					bIsHorde ? (ExplosionTemplate.DecalData.Width*0.80f) : ExplosionTemplate.DecalData.Width,
//					bIsHorde ? (ExplosionTemplate.DecalData.Height*0.80f) : ExplosionTemplate.DecalData.Height,
//					Max(ExplosionTemplate.DecalData.Thickness,class'GearDecal'.default.MinExplosionThickness),
//					(bIsHorde || bIsSplitScreen) ? FALSE : !ExplosionTemplate.DecalData.ClipDecalsUsingFastPath,
//					(FRand() * 360.0f),
//					HitInfo.HitComponent,
//					TRUE,
//					FALSE,
//					HitInfo.BoneName,
//					INDEX_NONE,
//					INDEX_NONE,
//					DecalLifeSpan,
//					INDEX_NONE,
//				class'GearDecal'.default.DepthBias,
//					ExplosionTemplate.DecalData.BlendRange
//					);
//
//				TraceActor.AttachComponent( GD );
//
//				// if horde or splitscren then fade decals out instead of leaving them around for ever
//				GD.MITV_Decal.SetDuration( DecalLifeSpan );
//
//				//DrawDebugCoordinateSystem( out_HitLocation, rotator(-out_HitNormal), 3.0f, TRUE );
//			}
//		}
//	}
}

simulated function SpawnExplosionFogVolume()
{
	//// spawn a fog volume
	//if( ( ExplosionTemplate.bUsePerMaterialFogVolume == TRUE ) && ( ExplosionTemplate.FogVolumeArchetype != none ) )
	//{
	//	FogVolume = Spawn( class'TGFogVolume_Spawnable',,,, rot(0,0,0) );
	//	FogVolume.FogVolumeArchetype = ExplosionTemplate.FogVolumeArchetype;
	//	FogVolume.LifeSpan = 6.0f;
	//	//`log( "just spawned:" @ ExplosionTemplate.FogVolumeArchetype );

	//	// now check to see if we have an MITV and then start it
	//	if( MaterialInstanceTimeVarying(FogVolume.DensityComponent.FogMaterial) != none )
	//	{
	//		//`log( "MITV! " $ FogVolume.DensityComponent.FogMaterial );
	//		MITV = new(outer) class'MaterialInstanceTimeVarying';
	//		MITV.SetParent( FogVolume.DensityComponent.FogMaterial );
	//		FogVolumeDuration = MITV.GetMaxDurationFromAllParameters();
	//		if( FogVolumeDuration == 0.0f )
	//		{
	//			FogVolumeDuration = 6.0f;
	//		}

	//		FogVolumeDuration = Min( FogVolumeDuration, 30.0f ); // safeguard
	//		//`log( "MITV! setting duration " @ FogVolumeDuration);
	//		FogVolume.DensityComponent.FogMaterial = MITV;

	//		MITV.SetDuration( FogVolumeDuration );
	//		FogVolume.LifeSpan = FogVolumeDuration;
	//	}

	//	FogVolume.StartFogVolume();
	//}
}

simulated function DoExplosionCameraEffects()
{
	local CameraShake Shake;
	local float ShakeScale;
	local HDPlayerController PC;

	// do camera shake(s)
	// note: intentionally letting directional explosions still shake everything
	foreach WorldInfo.LocalPlayerControllers(class'HDPlayerController', PC)
	{
		//if (PC.PlayerCamera != None)
		//{
			Shake = ChooseCameraShake(Location, PC);
			if (Shake != None)
			{
				ShakeScale = PC.CalcRadialShakeScale(Location, ExplosionTemplate.CamShakeInnerRadius, ExplosionTemplate.CamShakeOuterRadius, ExplosionTemplate.CamShakeFalloff);
				PC.ClientPlayCameraAnim(Shake.Anim, ShakeScale, Shake.AnimPlayRate, Shake.AnimBlendInTime, Shake.AnimBlendOutTime);//, ExplosionTemplate.bAutoControllerVibration);
			}
		//}
	}

	// do lens effects
	if (ExplosionTemplate.CameraLensEffect != None)
	{
		foreach WorldInfo.LocalPlayerControllers(class'HDPlayerController', PC)
		{
			// splatter some blood on their camera if they are a human and decently close
			if ( PC.Pawn != None &&
				VSize(PC.Pawn.Location - Location) < ExplosionTemplate.CameraLensEffectRadius &&
				PC.IsAimingAt(self, 0.1f) &&    // if we are semi looking in the direction of the explosion
				!IsBehindExplosion(PC.Pawn) )
			{
				PC.ClientSpawnCameraLensEffect(ExplosionTemplate.CameraLensEffect);
			}
		}
	}
}

