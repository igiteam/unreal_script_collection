/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearExplosionActor extends GameExplosionActor
	native(Weapon)
	placeable
	dependson(GearMapSpecificInfo,GearPerMapColorConfig);

/** Explosion content to use when this actor is placed in the world and explodes via a trigger. */
var() private editinline GearExplosion ExplosionContent;

/** Enables SetParticleSystemRotation to set this after spawn. */
var transient rotator ExplosionParticleSystemRotation;

/** Repels crowd agents from the explosion */
var transient GearCrowdPanicRepulsor CrowdPanicRepulsor;

/** Whether or not this Explosion is from something that has an ActiveReload bonus that is active **/
var bool bActiveReloadBonusActive;

/** The lens flare object to spawn if delay spawned */
var LensFlare DelayedLensFlare;
/** Holds the lens flare so we can disable it later */
var LensFlareComponent FlareComp;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// explosion actor's rotation by default
	ExplosionParticleSystemRotation = Rotation;

	if( Role == ROLE_Authority )
	{
		CauseCrowdPanic();
	}
}

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
		Retval = Physicalmaterial'GearPhysMats.DefaultPhysMat';
	}

	return Retval;
}

simulated function bool DoFullDamageToActor(Actor Victim)
{
	return (Super.DoFullDamageToActor(Victim) || Victim.IsA('GearProj_Grenade') || Victim.IsA('GearFortification'));
}

/** Return if this particular actor should do a cringe/knockdown */
protected function bool ShouldDoCringeFor(GamePawn Victim)
{
	// only cringe if on opposite team OR you hit yourself and you're human controlled OR the explosion is attached to you
	// but NOT if you are part of the ignored actor class or the ignored actor specified
	return ( ( (InstigatorController == None)
		|| Victim == InstigatorController.Pawn || (!WorldInfo.GRI.OnSameTeam(InstigatorController, Victim) || ExplosionTemplate.bAllowTeammateCringes)
		|| GearGame(WorldInfo.Game).bAllowFriendlyFire
		|| Victim == Attachee
		|| (Instigator == Victim && Instigator.IsHumanControlled())
		)
		&& (GearPawn(Victim) == None || !GearGame(WorldInfo.Game).IsRespawnInvincible(GearPawn(Victim)))
		&& (Victim != ExplosionTemplate.ActorToIgnoreForDamage)
		&& (!ExplosionTemplate.bIgnoreInstigator || Victim != Instigator)
		&& !ClassIsChildOf( Victim.Class, ExplosionTemplate.ActorClassToIgnoreForKnockdownsAndCringes) );
}

/** Called from an InterpTrackToggle matinee track*/
function OnInterpToggle( int ShouldActivate )
{
	if( ShouldActivate == 1 && ExplosionContent != None )
	{
		ExplosionContent.InitFromContentTemplate();
		Explode( ExplosionContent );
	}
}

event DoExplosion(GameExplosion NewExplosionTemplate, optional vector ExploDirection)
{
	Explode(NewExplosionTemplate, ExploDirection);
}

simulated function Explode(GameExplosion NewExplosionTemplate, optional vector ExploDirection)
{
	local GearGRI GRI;
	local GearExplosion GE;

	GE = GearExplosion(NewExplosionTemplate);

	if (!bHasExploded || bExplodeMoreThanOnce )
	{
		GRI = GearGRI(WorldInfo.GRI);
		if (GRI != None)
		{
			// @fixme: this is bad.  for non-instanced GameExplosion objects, this can repeatedly modify the template
			// resulting in progressively larger or smaller explosions!
			NewExplosionTemplate.ExplosionEmitterScale *= GRI.GlobalExplosionScale;
			NewExplosionTemplate.DamageRadius *= GRI.GlobalExplosionScale;
			NewExplosionTemplate.CringeRadius *= GRI.GlobalExplosionScale;
			NewExplosionTemplate.KnockDownRadius *= GRI.GlobalExplosionScale;

			if (GE != None)
			{
				GE.IgnitePawnBlazingRadius *= GRI.GlobalExplosionScale;
			}
		}
	}

	Super.Explode(NewExplosionTemplate, ExploDirection);

	// Spawn the lens flare if specified
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		GE.ContentTemplate != None &&
		GE.ContentTemplate.LensFlareTemplate != None)
	{
		if( FlareComp != None  )
		{
			// Detach existing flare component
			DetachComponent(FlareComp);
		}

		if (GE.ContentTemplate.LensFlareStartTime == 0)
		{
			FlareComp = new(self) class'LensFlareComponent';
			FlareComp.SetTemplate(GE.ContentTemplate.LensFlareTemplate);
			AttachComponent(FlareComp);
		}
		else
		{
			// Delay the spawning
			DelayedLensFlare = GE.ContentTemplate.LensFlareTemplate;
			SetTimer(GE.ContentTemplate.LensFlareStartTime,false,nameof(DelaySpawnLensFlare));
		}
		// Set the ending timer
		SetTimer(GE.ContentTemplate.LensFlareEndTime,false,nameof(DestroyLensFlare));
		// Update the life span if needed
		if( !bExplodeMoreThanOnce )
		{
			LifeSpan = FMax(LifeSpan,GE.ContentTemplate.LensFlareStartTime + GE.ContentTemplate.LensFlareEndTime + 0.1);
		}
	}
}

/** Spawns the lens flare after a delay */
function DelaySpawnLensFlare()
{
	FlareComp = new(self) class'LensFlareComponent';
	FlareComp.SetTemplate(DelayedLensFlare);
	AttachComponent(FlareComp);
}

/** Destroys the lens flare after a delay */
function DestroyLensFlare()
{
	DetachComponent(FlareComp);
}

/** Return if this particular actor should do a cringe/knockdown */
protected function bool ShouldIgnitePawn(GamePawn Victim)
{
	// only ignite if on opposite team OR you hit yourself and you're human controlled OR the explosion is attached to you
	if ( ( (InstigatorController == None)
		|| (!WorldInfo.GRI.OnSameTeam(InstigatorController, Victim))
		|| Victim == Attachee
		|| (Instigator == Victim && Instigator.IsHumanControlled())
		)
		&& !IsBehindExplosion(Victim)
		&& (GearPawn(Victim) == None || !GearPawn(Victim).IsAKidnapper() || Normal(Location - Victim.Location) dot vector(Victim.Rotation) < 0.0)
		&& (Victim.Health > 0 || (GearPawn(Victim) != None && GearPawn(Victim).IsDBNO()))
		&& Victim.Role == ROLE_Authority )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

/**
  *  Return the desired radius to check for actors which get effects from explosion
  */
function float GetEffectCheckRadius()
{
	return FMax(Super.GetEffectCheckRadius(), GearExplosion(ExplosionTemplate).IgnitePawnBlazingRadius);
}

/**
  * Handle making pawns ignite, cringe or fall down from nearby explosions.  Server only.
  */
protected function SpecialPawnEffectsFor(GamePawn VictimPawn, float VictimDist)
{
	local GearPawn GP;
	local GearExplosion GE;

	GP = GearPawn(VictimPawn);

	if (VictimPawn.bRespondToExplosions)
	{
		if (ShouldDoCringeFor(VictimPawn))
		{
			if (VictimDist == 0.0)
			{
				// if explosion is directly on this guy, pretend it's actually 1 unit below him
				// it's an arbitrary convention, but chosen to tend to blow things upward in more spectacular fashion.
				VictimDist = 1.0;
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
			// Otherwise play a near miss cringe.
			else if (GP != None && VictimDist < ExplosionTemplate.DamageRadius * 1.25)
			{
				GP.TryPlayNearMissCringe();
			}
		}
		// Otherwise play a near miss cringe.
		else if (GP != None && VictimDist < ExplosionTemplate.DamageRadius * 1.25)
		{
			GP.TryPlayNearMissCringe();
		}
	}

	GE = GearExplosion(ExplosionTemplate);

	if (VictimDist < GE.IgnitePawnBlazingRadius)
	{
		if (GP != None && ShouldIgnitePawn(GP))
		{
			GP.IgnitePawn(POF_Blazing, InstigatorController, GE.IgnitePawnDamageType);
		}
	}
}

/** Spawn repulsor to make npcs run away from explosion */
simulated function CauseCrowdPanic()
{
	if ( !WorldInfo.bHaveActiveCrowd )
	{
		// FIXME - bHaveActiveCrowd is set when an agent is spawned - might be worth also checking if any current crowd agents active if bHaveActiveCrowd=true
		return;
	}
	if(CrowdPanicRepulsor == None)
	{
		CrowdPanicRepulsor = Spawn(class'GearCrowdPanicRepulsor', self,,Location,Rotation,,TRUE);
		CrowdPanicRepulsor.SetBase(self);
		CrowdPanicRepulsor.CausePanic();
	}
	else
	{
		CrowdPanicRepulsor.SetLocation(Location);
	}

	// Panic will subside after some time
	CrowdPanicRepulsor.LifeSpan = 10.0;
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
	local class<Emit_CameraLensEffectBase> CameraEffect;
	local float CameraLensEffectRadius;
	local class<GearDamageType> MyGearDamageType;
	local GearExplosion GearExplosionTemplate;

	GearExplosionTemplate = GearExplosion(ExplosionTemplate);

	MyGearDamageType = class<GearDamageType>(ExplosionTemplate.MyDamageType);

	// audio
	ExploSound = class'GearPhysicalMaterialProperty'.static.DetermineImpactSound(PhysMaterial, MyGearDamageType);
	if (ExploSound != None)
	{
		ExplosionTemplate.ExplosionSound = ExploSound;
	}

	// Fog volumes are always relevant as they have gameplay repercussions in terms of visibility
	// fog volume
	if( GearExplosionTemplate.bUsePerMaterialFogVolume == TRUE )
	{
		FogVolumeArchetype = class'GearPhysicalMaterialProperty'.static.DetermineFogVolumeArchetype(PhysMaterial, MyGearDamageType);
		if( FogVolumeArchetype != None )
		{
			// copy for actual use
			GearExplosionTemplate.FogVolumeArchetype = FogVolumeArchetype;
		}
	}
	// this actor isn't rendered, so need to use slightly offset location for relevancy test to avoid false negative
	if( EffectIsRelevant(Location+vect(0,0,1), false, 6000, FMax(350.f, GearExplosionTemplate.DamageRadius * 2.f) ) )
	{
		// so if we are not manually overriding the PS then look it up
		if( ExplosionTemplate.bParticleSystemIsBeingOverriddenDontUsePhysMatVersion == FALSE )
		{
			ExplosionPS = class'GearPhysicalMaterialProperty'.static.DetermineImpactParticleSystem( PhysMaterial, MyGearDamageType, bActiveReloadBonusActive, WorldInfo, InstigatorController != None ? InstigatorController.Pawn : None );
			if( ExplosionPS != None )
			{
				// copy for actual use
				ExplosionTemplate.ParticleEmitterTemplate = ExplosionPS;
			}
		}

		// decal data
		DecalData = class'GearPhysicalMaterialProperty'.static.DetermineImpactDecalData
			(PhysMaterial,
			MyGearDamageType,
			bActiveReloadBonusActive,
			WorldInfo,
			InstigatorController != None ? InstigatorController.Pawn : None,
			(GearExplosionTemplate.ContentTemplate != None && GearExplosionTemplate.ContentTemplate.Decals.length > 0)
			);
		if (DecalData.bIsValid)
		{
			// copy for actual use
			GearExplosionTemplate.DecalData = DecalData;
		}
		else
		{
			GearExplosionTemplate.DecalData.bIsValid = false;
		}

		// camera effect if close enough
		if ( EffectIsRelevant(Location+vect(0,0,1), false, 2000.0, 1000.0) )
		{
			CameraEffect = class'GearPhysicalMaterialProperty'.static.DetermineImpactCameraEffect(PhysMaterial, MyGearDamageType, CameraLensEffectRadius);
			if( CameraEffect != None )
			{
				// copy for actual use
				GearExplosionTemplate.CameraLensEffect = CameraEffect;
				GearExplosionTemplate.CameraLensEffectRadius = CameraLensEffectRadius;
			}
		}
		else
		{
			GearExplosionTemplate.CameraLensEffect = none;
		}
	}
	else
	{
		ExplosionTemplate.ParticleEmitterTemplate = None;
		GearExplosionTemplate.DecalData.bIsValid = false;
		GearExplosionTemplate.CameraLensEffect = none;
	}
}

simulated function SpawnExplosionParticleSystem(ParticleSystem Template)
{
	local GearMapSpecificInfo GSI;
	local ParticleSystemComponent ExplosionEmitter;
	local EffectParam EP;
	local VectorParam VP;
	local FloatParam FP;
	local Actor AttachToActor;
	local float EmitterScale;
	// attach the emitter to the attachee if available and if we were asked to actually attach this
	if (Attachee != None && ExplosionTemplate.bAttachExplosionEmitterToAttachee)
	{
		AttachToActor = Attachee;
	}

	// spawn particle effect
	ExplosionEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionTemplate.ParticleEmitterTemplate, Location + GearExplosion(ExplosionTemplate).EffectOffset, ExplosionParticleSystemRotation, AttachToActor);

	if (ExplosionEmitter != None)
	{
		EmitterScale = ExplosionTemplate.ExplosionEmitterScale;
		if( EmitterScale == 1.0f )
		{
			EmitterScale = DrawScale;
		}

		ExplosionEmitter.TranslucencySortPriority = GearExplosion(ExplosionTemplate).ContentTemplate.ParticleSortPriority;
		ExplosionEmitter.SetScale(EmitterScale);
		ExplosionEmitter.KillParticlesForced();
		ExplosionEmitter.ActivateSystem(true);
		// now check to see if this Explosion is using the per map values
		if (ExplosionTemplate.bUseMapSpecificValues)
		{
			GSI = GearMapSpecificInfo(WorldInfo.GetMapInfo());
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
							foreach EP.VectorParams(VP)
							{
								ExplosionEmitter.SetVectorParameter(VP.Name, VP.Value);
								//`log( "Setting Vect:" @ VP.Name @ VP.Value );
							}

							foreach EP.FloatParams(FP)
							{
								ExplosionEmitter.SetFloatParameter(FP.Name, FP.Value);
								//`log( "Setting Float:" @ FP.Name @ FP.Value );
							}
						}
					}
				}
			}
		}
	}
}

/** helper for SpawnExplosionDecal() to perform the actual creation of the object */
simulated function GearDecal CreateDecal(const out DecalData DecalData, Actor HitActor, vector HitLocation, vector HitNormal, const out TraceHitInfo HitInfo)
{
	local float RandomScale, Width, Height;
	local GearDecal GD;
	local bool bIsHorde, bIsSplitScreen;

	RandomScale = GetRangeValueByPct(DecalData.RandomScalingRange, FRand());
	Width = DecalData.Width * RandomScale;
	Height = DecalData.Height * RandomScale;

	// if horde or splitscren then fade decals out instead of leaving them around for ever
	bIsHorde = WorldInfo.GRI.IsCoopMultiplayerGame();
	bIsSplitScreen = class'Engine'.static.IsSplitScreen();
	if (WorldInfo.MyDecalManager != None)
	{
		GD = GearDecalManager(WorldInfo.MyDecalManager).SpawnDecalMinimal(HitLocation, DecalData.LifeSpan, true);
	}
	if (GD != None)
	{
		GD.MITV_Decal.SetParent(DecalData.DecalMaterial);

		// @TODO:  pass in a struct with the decal params you want to use
		WorldInfo.MyDecalManager.SetDecalParameters(
			GD,
			GD.MITV_Decal,
			HitLocation,
			rotator(-HitNormal),
			bIsHorde ? (Width * 0.80) : Width,
			bIsHorde ? (Height * 0.80) : Height,
			Max(DecalData.Thickness, class'GearDecal'.default.MinExplosionThickness),
			!bIsHorde && !bIsSplitScreen && !DecalData.ClipDecalsUsingFastPath,
			(FRand() * 360.0),
			HitInfo.HitComponent,
			true,
			false,
			HitInfo.BoneName,
			INDEX_NONE,
			INDEX_NONE,
			INDEX_NONE,
			class'GearDecal'.default.DepthBias,
			DecalData.BlendRange
			);

		HitActor.AttachComponent(GD);
	}
	return GD;
}

// @todo when GamePawnFX.LeaveADecal is promoted to global object update this
simulated function SpawnExplosionDecal()
{
	local Actor HitActor;
	local GearExplosion GearExplosionTemplate;
	local vector TraceExtent, X, Y, Z, TraceDir, HitLocation, HitNormal;
	local TraceHitInfo HitInfo;
	local int i;
	local GearDecal GD;
	local GearDecalParam Param;

	GearExplosionTemplate = GearExplosion(ExplosionTemplate);
	if (GearExplosionTemplate.DecalData.bIsValid && ExplosionTemplate.bAllowPerMaterialFX)
	{
		// use the decal from the physical material
		HitActor = Trace(HitLocation, HitNormal, (Location + (-ExplosionTemplate.HitNormal * GearExplosionTemplate.DecalTraceDistance)), Location, false, TraceExtent, HitInfo, TRACEFLAG_Bullet);
		if (HitActor != None)
		{
			GD = CreateDecal(GearExplosionTemplate.DecalData, HitActor, HitLocation, HitNormal, HitInfo);
		}
	}
	else
	{
		// do content defined traces to determine what decals to create
		GearExplosionTemplate = GearExplosion(ExplosionTemplate);
		if (GearExplosionTemplate.ContentTemplate != None && GearExplosionTemplate.ContentTemplate.Decals.length > 0)
		{
			GetAxes(ExplosionParticleSystemRotation, X, Y, Z);
			// look for one in the content archetype
			for (i = 0; i < GearExplosionTemplate.ContentTemplate.Decals.length; i++)
			{
				if (GearExplosionTemplate.ContentTemplate.Decals[i].bWorldSpaceDir)
				{
					switch (GearExplosionTemplate.ContentTemplate.Decals[i].Dir)
					{
						case DECALTRACE_PosX:
							TraceDir = vect(1,0,0);
							break;
						case DECALTRACE_NegX:
							TraceDir = vect(-1,0,0);
							break;
						case DECALTRACE_PosY:
							TraceDir = vect(0,1,0);
							break;
						case DECALTRACE_NegY:
							TraceDir = vect(0,-1,0);
							break;
						case DECALTRACE_PosZ:
							TraceDir = vect(0,0,1);
							break;
						case DECALTRACE_NegZ:
							TraceDir = vect(0,0,-1);
							break;
					}
				}
				else
				{
					switch (GearExplosionTemplate.ContentTemplate.Decals[i].Dir)
					{
						case DECALTRACE_PosX:
							TraceDir = X;
							break;
						case DECALTRACE_NegX:
							TraceDir = -X;
							break;
						case DECALTRACE_PosY:
							TraceDir = Y;
							break;
						case DECALTRACE_NegY:
							TraceDir = -Y;
							break;
						case DECALTRACE_PosZ:
							TraceDir = Z;
							break;
						case DECALTRACE_NegZ:
							TraceDir = -Z;
							break;
					}
				}
				HitActor = Trace(HitLocation, HitNormal, Location + TraceDir * GearExplosionTemplate.ContentTemplate.Decals[i].TraceDistance, Location, false,, HitInfo);
				if (HitActor != None)
				{
					GearExplosionTemplate.DecalData = GearExplosionTemplate.ContentTemplate.Decals[i].Decal;
					GD = CreateDecal(GearExplosionTemplate.DecalData, HitActor, HitLocation, HitNormal, HitInfo);
					// Set each artist param with a random value between the specified range
					foreach GearExplosionTemplate.ContentTemplate.Decals[i].Params(Param)
					{
						GD.MITV_Decal.SetScalarParameterValue(Param.ParamName,RandRange(Param.Min,Param.Max));
					}
				}
			}
		}
	}
}

simulated function DoExplosionCameraEffects()
{
	local GearExplosion GearExplosionTemplate;
	local PlayerController PC;

	Super.DoExplosionCameraEffects();

	// play rumble if desired
	GearExplosionTemplate = GearExplosion(ExplosionTemplate);
	if (GearExplosionTemplate != None && GearExplosionTemplate.ContentTemplate != None && GearExplosionTemplate.ContentTemplate.RumbleData != None)
	{
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			if (VSize(PC.PlayerCamera.Location - Location) < GearExplosionTemplate.ContentTemplate.MaxRumbleRange)
			{
				PC.ClientPlayForceFeedbackWaveform(GearExplosionTemplate.ContentTemplate.RumbleData);
			}
		}
	}
}

/**
 * Selects the camera shake setting to use and initializes the values for it
 *
 * @param Epicenter the location the explosion is emanating from
 * @param PC the PlayerController affected
 */
protected simulated function CameraShake ChooseCameraShake(vector Epicenter, PlayerController PC)
{
	local GearExplosion GearExplosionTemplate;

	GearExplosionTemplate = GearExplosion(ExplosionTemplate);
	if (GearExplosionTemplate == None || GearExplosionTemplate.ContentTemplate == None)
	{
		return Super.ChooseCameraShake(Epicenter, PC);
	}
	// Use the native version for perf reasons
	return ChooseCameraShake_Native(Epicenter,PC);
}

/**
 * Selects the camera shake setting to use and initializes the values for it
 *
 * @param Epicenter the location the explosion is emanating from
 * @param PC the PlayerController affected
 */
native protected simulated function CameraShake ChooseCameraShake_Native(vector Epicenter, PlayerController PC);


simulated function SpawnExplosionFogVolume()
{
	local GearFogVolume_Spawnable FogVolume;
	local MaterialInstanceTimeVarying MITV;
	local float FogVolumeDuration;
	local GearExplosion GearExplosionTemplate;

	GearExplosionTemplate = GearExplosion(ExplosionTemplate);

	// spawn a fog volume
	if( ( GearExplosionTemplate.bUsePerMaterialFogVolume == TRUE ) && ( GearExplosionTemplate.FogVolumeArchetype != none ) )
	{
		FogVolume = Spawn( class'GearFogVolume_Spawnable',,,, rot(0,0,0) );
		FogVolume.FogVolumeArchetype = GearExplosionTemplate.FogVolumeArchetype;
		FogVolume.LifeSpan = 6.0f;
		//`log( "just spawned:" @ ExplosionTemplate.FogVolumeArchetype );

		// now check to see if we have an MITV and then start it
		if( MaterialInstanceTimeVarying(FogVolume.DensityComponent.FogMaterial) != none )
		{
			//`log( "MITV! " $ FogVolume.DensityComponent.FogMaterial );
			MITV = new(outer) class'MaterialInstanceTimeVarying';
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

protected function CringePawn(GamePawn Victim, float DistFromExplosion)
{
	local GearPawn GP;
	local float CringeTime;
	local GearExplosion GearExplosionTemplate;
	local class<GearDamageType> DamageTypeClass;

	GP = GearPawn(Victim);
	if (GP != None && GP.Role == ROLE_Authority)
	{
		GP.LastHitBy = InstigatorController; // for crediting meatbag releases and such
		// pretend this caused a small amount of damage for purposes of assist scoring
		if (InstigatorController != None && GearPRI(InstigatorController.PlayerReplicationInfo) != None && GearPRI(GP.PlayerReplicationInfo) != None && InstigatorController.Pawn != Victim)
		{
			DamageTypeClass = (ExplosionTemplate.MyDamageType == None) ? class'GDT_SmokeGrenade' : class<GearDamageType>(ExplosionTemplate.MyDamageType);
			GearPRI(GP.PlayerReplicationInfo).AddPlayerDamage(GearPRI(InstigatorController.PlayerReplicationInfo), 70.0, DamageTypeClass);
		}

		GearExplosionTemplate = GearExplosion(ExplosionTemplate);

		CringeTime = GetRangeValueByPct( ExplosionTemplate.CringeDuration, FClamp(DistFromExplosion / ExplosionTemplate.CringeRadius, 0.f, 1.f) );

		if (GearExplosionTemplate.bAllowMovementDuringCringe)
		{
			GP.PlayHeadCoverAnim(CringeTime, true);
		}
		else if (GP.MyGearAI != None && CringeTime > 0.0 && GearAI_TDM(GP.MyGearAI) == None && ((Location - GP.Location) Dot vector(GP.Rotation) < 0.f))
		{
			GP.Stumble();
		}
		else
		{
			GP.Cringe(CringeTime);
		}
	}
}

protected function KnockdownPawn(GamePawn Victim, float DistFromExplosion)
{
	local GearPawn GP;
	local GearExplosion GearExplosionTemplate;

	GP = GearPawn(Victim);
	if (GP != None && GP.Role == ROLE_Authority)
	{
		// Note we double the KnockdownRadius.  This ensures the applied force at the furthest possible
		// knockdown is 50% of the KnockdownStrength.  Going ragdoll with zero explosion force tends to feel odd.
		GP.LastHitBy = InstigatorController; // so proper kill credit is given if this knocks the Pawn outside the world
		GP.Knockdown(, vect(1,1,1), Location, ExplosionTemplate.KnockDownRadius * 2.0, ExplosionTemplate.KnockDownStrength);

		GearExplosionTemplate = GearExplosion(ExplosionTemplate);

		// do any desired knockdown effort
		if (GearExplosionTemplate.PawnKnockdownEffort != GearEffort_None)
		{
			GP.SoundGroup.PlayEffort(GP, GearExplosionTemplate.PawnKnockdownEffort);
		}
	}
}

/**
 *  Enables setting a custom rotation on the particle system.  Will be actor's rotation otherwise.
 *  Note: call this before explode(), has to effect afterwards.
 */
simulated function SetParticleSystemRotation(rotator NewRot)
{
	// set this so it will spawn properly
	ExplosionParticleSystemRotation = NewRot;
}

/**
 * Spawns the camera lens effect(s) if needed by this explosion
 */
simulated function SpawnCameraLensEffects()
{
	local PlayerController PC;
	local GearExplosion GE;
	local GearCameraLensEffect LensEffect;
	local float Distance;

	GE = GearExplosion(ExplosionTemplate);

	if (GE.CameraLensEffect != None)
	{
		// Do the old behavior for physical material compatibility reasons
		Super.SpawnCameraLensEffects();
	}

	if (GE.ContentTemplate != None)
	{
		// Check each local players for the effect
		foreach WorldInfo.LocalPlayerControllers(class'PlayerController', PC)
		{
			// Splatter some blood on their camera if they are a human and decently close
			if (PC.Pawn != None &&
				PC.IsAimingAt(self, 0.1f) &&
				!IsBehindExplosion(PC.Pawn))
			{
				// Calc this once per pawn
				Distance = VSize(PC.Pawn.Location - Location);
				// Walk the list of potential effects and see which to use
				foreach GE.ContentTemplate.CameraLensEffects(LensEffect)
				{
					if (Distance >= LensEffect.MinRange &&
						Distance <= LensEffect.MaxRange &&
						LensEffect.Effect != None)
					{
						PC.ClientSpawnCameraLensEffect(LensEffect.Effect);
					}
				}
			}
		}
	}
}

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)

	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(R=0,G=255,B=128)
		ArrowSize=1.5
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		bTreatAsASprite=True
	End Object
	Components.Add(Arrow)


}
