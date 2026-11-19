/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoExplosionActor extends GameExplosionActor
	dependson(NanoMapSpecificInfo);

/** Whether or not this Explosion is from something that has an ActiveReload bonus that is active **/
var bool bActiveReloadBonusActive;

/**
 * Internal. Tries to find a physical material for the surface the explosion occurred upon.
 * @note: It sucks doing an extra trace here.  We could conceivably pass the physical material info around
 * by changing the lower level physics code (e.g. processHitWall), but that's a big engine-level change.
 */
simulated protected function PhysicalMaterial GetPhysicalMaterial()
{
	local PhysicalMaterial Retval;

	Retval = Super.GetPhysicalMaterial();

	if( Retval == None )
	{
		Retval = Physicalmaterial'NanoPhysMats.DefaultPhysMat';
	}

	return Retval;
}

simulated function bool DoFullDamageToActor(Actor Victim)
{
	if ( Super.DoFullDamageToActor(Victim) ||
		Victim.IsA('NanoProj_Grenade') )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}
/** 
  * Handle making pawns cringe or fall down from nearby explosions.  Server only. 
  */
protected function SpecialPawnEffectsFor(GamePawn VictimPawn, float VictimDist)
{
	if ( VictimPawn.bRespondToExplosions )
	{
		if ( ShouldDoCringeFor(VictimPawn) )
		{
			if (VictimDist == 0.f)
			{
				// if explosion is directly on this guy, pretend it's actually 1 unit below him
				// it's an arbitrary convention, but chosen to tend to blow things upward in more spectacular fashion.
				VictimDist = 1.f;
			}

			if (VictimDist < ExplosionTemplate.KnockDownRadius)
			{
				KnockdownPawn(VictimPawn, VictimDist);
			}
			else if (VictimDist < ExplosionTemplate.CringeRadius)
			{
				// outside of knockdown radius, do cringe
				CringePawn(VictimPawn, VictimDist);
			}
		}
	}
}

/** Internal.  Makes pawns cringe down from the explosion.  */
protected function CringePawn(GamePawn Victim, float DistFromExplosion);

/** Return if this particular actor should do a cringe/knockdown */
protected function bool ShouldDoCringeFor(GamePawn Victim)
{
	// only cringe if on opposite team OR you hit yourself and you're human controlled OR the explosion is attached to you

	if ( ( (InstigatorController == None)
		|| (!WorldInfo.GRI.OnSameTeam(InstigatorController, Victim) || ExplosionTemplate.bAllowTeammateCringes)
		|| NanoGame(WorldInfo.Game).bAllowFriendlyFire
		|| Victim == Attachee
		|| (Instigator == Victim && Instigator.IsHumanControlled())
		)
		&& ( ClassIsChildOf( Victim.Class, ExplosionTemplate.ActorClassToIgnoreForKnockdownsAndCringes ) == FALSE )
		&& (Victim.DrivenVehicle == None) )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

/** Internal.  Knocks given pawn down from the explosion.  */
protected function KnockdownPawn(GamePawn Victim, float DistFromExplosion)
{
	local NanoPawn NP;

	NP = NanoPawn(Victim);

	if ( NP != None )
	{
		// Note we double the KnockdownRadius.  This ensures the applied force at the furthest possible
		// knockdown is 50% of the KnockdownStrength.  Going ragdoll with zero explosion force tends to feel odd.
		NP.LastHitBy = InstigatorController; // so proper kill credit is given if this knocks the Pawn outside the world
		NP.ServerKnockdown(, vect(1,1,1), Location, ExplosionTemplate.KnockDownRadius*2.f, ExplosionTemplate.KnockDownStrength);
	}
}

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
	local DecalData DecalData;
	local ParticleSystem ExplosionPS;
	local SoundCue ExploSound;
	local FogVolumeSphericalDensityInfo FogVolumeArchetype;
	local class<Emit_NanoCameraLensEffectBase> CameraEffect;
	local float CameraLensEffectRadius;
	local class<NanoDamageType> MyNanoDamageType;
	local NanoGRI GRI;
	local NanoExplosion NanoExplosionTemplate;

	NanoExplosionTemplate = NanoExplosion(ExplosionTemplate);

	GRI = NanoGRI(WorldInfo.GRI);
	MyNanoDamageType = class<NanoDamageType>(ExplosionTemplate.MyDamageType);


	if( GRI.IsEffectRelevant( Instigator, Location, 6000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) )
	{
		// so if we are not manually overriding the PS then look it up
		if( ExplosionTemplate.bParticleSystemIsBeingOverriddenDontUsePhysMatVersion == FALSE )
		{
			ExplosionPS = class'NanoPhysicalMaterialProperty'.static.DetermineImpactParticleSystem( PhysMaterial, MyNanoDamageType, bActiveReloadBonusActive, WorldInfo, InstigatorController != None ? InstigatorController.Pawn : None );
			if( ExplosionPS != None )
			{
				// copy for actual use
				ExplosionTemplate.ParticleEmitterTemplate = ExplosionPS;
			}
		}
	}
	else
	{
		ExplosionTemplate.ParticleEmitterTemplate = none;
	}


	if( GRI.IsEffectRelevant( Instigator, Location, 6000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) )
	{
		// decal data
		DecalData = class'NanoPhysicalMaterialProperty'.static.DetermineImpactDecalData( PhysMaterial, MyNanoDamageType, bActiveReloadBonusActive, WorldInfo, InstigatorController != None ? InstigatorController.Pawn : None);
		if( DecalData.bIsValid )
		{
			// copy for actual use
			NanoExplosionTemplate.DecalData = DecalData;
		}
	}
	else
	{
		NanoExplosionTemplate.DecalData = DecalData;
	}


	// this is "always" relevant so the broken sound cue cross faders can be fixed up
	if( GRI.IsEffectRelevant( Instigator, Location, 100000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistance ) )
	{
		// audio
		ExploSound = class'NanoPhysicalMaterialProperty'.static.DetermineImpactSound( PhysMaterial, MyNanoDamageType, bActiveReloadBonusActive, WorldInfo );
		if( ExploSound != None )
		{
			// copy for actual use
			ExplosionTemplate.ExplosionSound = ExploSound;
		}
	}
	else
	{
		ExplosionTemplate.ExplosionSound = none;
	}


	// Fog volumes are always relevant as they have gameplay repercussions in terms of visibility
	// fog volume
	if( NanoExplosionTemplate.bUsePerMaterialFogVolume == TRUE )
	{
		FogVolumeArchetype = class'NanoPhysicalMaterialProperty'.static.DetermineFogVolumeArchetype( PhysMaterial, MyNanoDamageType, bActiveReloadBonusActive, WorldInfo );
		if( FogVolumeArchetype != None )
		{
			// copy for actual use
			NanoExplosionTemplate.FogVolumeArchetype = FogVolumeArchetype;
		}
	}


	if( GRI.IsEffectRelevant( Instigator, Location, 2048, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) )
	{
		CameraEffect = class'NanoPhysicalMaterialProperty'.static.DetermineImpactCameraEffect( PhysMaterial, MyNanoDamageType, bActiveReloadBonusActive, WorldInfo, CameraLensEffectRadius );
		if( CameraEffect != None )
		{
			// copy for actual use
			NanoExplosionTemplate.CameraLensEffect = CameraEffect;
			NanoExplosionTemplate.CameraLensEffectRadius = CameraLensEffectRadius;
		}
	}
	else
	{
		NanoExplosionTemplate.CameraLensEffect = none;
	}

}

simulated function SpawnExplosionParticleSystem(ParticleSystem Template)
{
	local NanoMapSpecificInfo GSI;
	local Emitter ExplosionEmitter;
	local EffectParam EP;
	local VectorParam VP;
	local FloatParam FP;

	// spawn particle effect
	ExplosionEmitter = NanoGRI(WorldInfo.GRI).NOP.GetImpactEmitter( ExplosionTemplate.ParticleEmitterTemplate, Location, Rotation );
	if (ExplosionEmitter != None)
	{
		// attach the emitter to the attachee if available and if we were asked to actually attach this
		if (Attachee != None && ExplosionTemplate.bAttachExplosionEmitterToAttachee)
		{
			ExplosionEmitter.SetBase(Attachee);
		}

		ExplosionEmitter.SetDrawScale(ExplosionTemplate.ExplosionEmitterScale);

		// now check to see if this Explosion is using the per map values
		if( ExplosionTemplate.bUseMapSpecificValues == TRUE )
		{
			GSI = NanoMapSpecificInfo(WorldInfo.GetMapInfo());
			if( GSI != none )
			{
				if( GSI.ColorConfig != none )
				{
					// look over all of the effects
					foreach GSI.ColorConfig.EffectParams( EP )
					{
						// if there are any for my damage type
						if( ExplosionTemplate.MyDamageType == EP.DamageType )
						{
							// do all of the setting
							foreach EP.VectorParams( VP )
							{
								ExplosionEmitter.ParticleSystemComponent.SetVectorParameter( VP.Name, VP.Value );
								//`log( "Setting Vect:" @ VP.Name @ VP.Value );
							}

							foreach EP.FloatParams( FP )
							{
								ExplosionEmitter.ParticleSystemComponent.SetFloatParameter( FP.Name, FP.Value );
								//`log( "Setting Float:" @ FP.Name @ FP.Value );
							}
						}
					}
				}
			}
		}

		ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
	}
}

// @todo when GamePawnFX.LeaveADecal is promoted to global object update this
simulated function SpawnExplosionDecal()
{
	local Actor TraceActor;
	local float RandomScale;
	local NanoDecal GD;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;
	local float DecalLifeSpan;
	local bool bIsHorde;
	local bool bIsSplitScreen;
	local NanoExplosion NanoExplosionTemplate;

	NanoExplosionTemplate = NanoExplosion(ExplosionTemplate);

	if( !NanoExplosionTemplate.DecalData.bIsValid )
	{
		return;
	}

	TraceActor = Trace( out_HitLocation, out_HitNormal, (Location + (-ExplosionTemplate.HitNormal * NanoExplosionTemplate.DecalTraceDistance)), Location, FALSE, TraceExtent, HitInfo, TRACEFLAG_Bullet );
	//DrawDebugLine( Location, (Location + (-ExplosionTemplate.HitNormal * NanoExplosionTemplate.DecalTraceDistance)) , 255, 1, 1, TRUE );
	if( TraceActor != None )
	{
		RandomScale = GetRangeValueByPct( NanoExplosionTemplate.DecalData.RandomScalingRange, FRand() );
		NanoExplosionTemplate.DecalData.Width *= RandomScale;
		NanoExplosionTemplate.DecalData.Height *= RandomScale;

		GD = NanoGRI(WorldInfo.GRI).NOP.GetDecal_Explosion( out_HitLocation );
		if( GD != none )
		{
			bIsHorde = WorldInfo.GRI.IsCoopMultiplayerGame();
			bIsSplitScreen = class'Engine'.static.IsSplitScreen();
			DecalLifeSpan = (bIsHorde || bIsSplitScreen) ? NanoExplosionTemplate.DecalData.LifeSpan : 999999.0;

			//`log( "Explo DM: " $ NanoExplosionTemplate.DecalData.DecalMaterial );
			GD.MITV_Decal.SetParent( NanoExplosionTemplate.DecalData.DecalMaterial );

			// @TODO:  pass in a struct with the decal params you want to use
			WorldInfo.MyDecalManager.SetDecalParameters(
				GD,
				GD.MITV_Decal,
				out_HitLocation,
				rotator(-out_HitNormal),
				bIsHorde ? (NanoExplosionTemplate.DecalData.Width*0.80f) : NanoExplosionTemplate.DecalData.Width,
				bIsHorde ? (NanoExplosionTemplate.DecalData.Height*0.80f) : NanoExplosionTemplate.DecalData.Height,
				Max(NanoExplosionTemplate.DecalData.Thickness,class'NanoDecal'.default.MinExplosionThickness),
				(bIsHorde || bIsSplitScreen) ? FALSE : !NanoExplosionTemplate.DecalData.ClipDecalsUsingFastPath,
				(FRand() * 360.0f),
				HitInfo.HitComponent,
				TRUE,
				FALSE,
				HitInfo.BoneName,
				INDEX_NONE,
				INDEX_NONE,
				INDEX_NONE,
				class'NanoDecal'.default.DepthBias,
				NanoExplosionTemplate.DecalData.BlendRange
				);

			TraceActor.AttachComponent( GD );

			// if horde or splitscren then fade decals out instead of leaving them around for ever
			GD.MITV_Decal.SetDuration( DecalLifeSpan );

			//DrawDebugCoordinateSystem( out_HitLocation, rotator(-out_HitNormal), 3.0f, TRUE );
		}
	}
}


simulated function SpawnExplosionFogVolume()
{
	local NanoFogVolume_Spawnable FogVolume;
	local MaterialInstanceTimeVarying MITV;
	local float FogVolumeDuration;
	local NanoExplosion NanoExplosionTemplate;

	NanoExplosionTemplate = NanoExplosion(ExplosionTemplate);

	// spawn a fog volume
	if( ( NanoExplosionTemplate.bUsePerMaterialFogVolume == TRUE ) && ( NanoExplosionTemplate.FogVolumeArchetype != none ) )
	{
		FogVolume = Spawn( class'NanoFogVolume_Spawnable',,,, rot(0,0,0) );
		FogVolume.FogVolumeArchetype = NanoExplosionTemplate.FogVolumeArchetype;
		FogVolume.LifeSpan = 6.0f;
		//`log( "just spawned:" @ ExplosionTemplate.FogVolumeArchetype );

		// now check to see if we have an MITV and then start it
		if( MaterialInstanceTimeVarying(FogVolume.DensityComponent.FogMaterial) != none )
		{
			//`log( "MITV! " $ FogVolume.DensityComponent.FogMaterial );
			MITV = new(self) class'MaterialInstanceTimeVarying';
			MITV.SetParent( FogVolume.DensityComponent.FogMaterial );
			FogVolumeDuration = MITV.GetMaxDurationFromAllParameters();
			if( FogVolumeDuration == 0.0f )
			{
				FogVolumeDuration = 6.0f;
			}

			FogVolumeDuration = Min( FogVolumeDuration, 30.0f ); // safeguard
			//`log( "MITV! setting duration " @ FogVolumeDuration);
			FogVolume.DensityComponent.FogMaterial = MITV;

			MITV.SetDuration( FogVolumeDuration );
			FogVolume.LifeSpan = FogVolumeDuration;
		}

		FogVolume.StartFogVolume();
	}
}


defaultproperties
{
}
