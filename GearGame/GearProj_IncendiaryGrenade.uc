/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_IncendiaryGrenade extends GearProj_Grenade
	native(Weapon);

var protected transient vector LastVel;

/** On impact, bias fire spray downwards somewhat. */
var() protected const float BouncyFireSpawnDownwardBias;

/** Smaller dots than this get the circular pattern.  Wedge pattern otherwise. */
var() protected const float CircularPatternDotThreshold;
var() protected const float CircularMinDistanceFromInstigator;

var protected const class<Emit_BouncyFire> BouncyEmitterClass;





simulated function Tick(float DeltaTime)
{
	// track last velocity
	LastVel = (TagVictim != None) ? TagVictim.Velocity : Velocity;

//	DrawDebugLine(Location, Location+GetHeadFacingDir()*128, 255, 255, 255, FALSE);

	super.Tick(DeltaTime);
}



simulated protected function bool ShouldDoCircularPattern(vector HitNormal, vector HitLocation, GearPawn HitGP)
{
	if (HitGP != None || (TagVictim != None && HitNormal.Z >= 1.0))
	{
		return TRUE;
	}

	if ( ((Normal(LastVel) dot HitNormal) < CircularPatternDotThreshold)        // direct-enough of a hit
		 && ( (Instigator == None) || (VSize(HitLocation - Instigator.Location) > CircularMinDistanceFromInstigator) ) )      // and not too close to thrower
	{
		return TRUE;
	}

	return FALSE;
}

simulated protected native function rotator GetExplosionParticleSystemRot(vector IncidentDir, vector HitNormal) const;

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local GearPawn HitGP;
	local GearExplosionActor GEA;
	local GearFireInfo GFI;

	if (!bIsSimulating && !bGrenadeHasExploded)
	{
		if (BouncyEmitterClass.default.bDrawDebug)
		{
			// debug rendering, don't do explosion particles
			ExplosionTemplate.ParticleEmitterTemplate = None;
		}

		if (Role == ROLE_Authority)
		{
			HitGP = GearPawn(HitActor);
			// redirect to kill the hostage if appropriate
			if (HitGP != None && HitGP.IsAKidnapper() && Normal(HitLocation - HitGP.Location) dot vector(HitGP.Rotation) > 0.0)
			{
				HitGP = HitGP.InteractionPawn;
			}

			// if we have no velocity (stuck to wall or nonmoving player), just use the HitNormal
			if (IsZero(LastVel))
			{
				LastVel = -HitNormal;
				LastVel.Z = -0.5;
				LastVel = Normal(LastVel) * Speed;
			}
			else if (VSize(LastVel) < Speed * 0.5)
			{
				// ensure velocity is high enough that we get a reasonable spread
				LastVel = Normal(LastVel) * (Speed * 0.5);
			}

			// skew LastVel downward
			LastVel += vect(0,0,-1) * VSize(LastVel) * BouncyFireSpawnDownwardBias;

			if (ShouldDoCircularPattern(HitNormal, HitLocation, HitGP))
			{
				GFI = Spawn(class'GearFireInfo_Circular');
				if (GFI != None)
				{
					if (HitGP != None)
					{
						// for pawn hits, throw fire straight downward at half speed
						LastVel = vect(0,0,-1) * VSize(LastVel) * 0.5f;
					}

					GFI.InstigatorController = InstigatorController;
					GFI.TagVictim = TagVictim;
					GFI.TaggedDamageType = TaggedDamageType;
					GFI.PawnTaggedDamageType = PawnTaggedDamageType;
					GFI.SpawnFire(HitLocation, HitNormal, LastVel);
				}

				// this is ok, since ExplosionTemplate is instanced
				ExplosionTemplate.bDirectionalExplosion = false;
			}
			else
			{
				GFI = Spawn(class'GearFireInfo_Wedge');
				if (GFI != None)
				{
					GFI.InstigatorController = InstigatorController;
					GFI.TagVictim = TagVictim;
					GFI.TaggedDamageType = TaggedDamageType;
					GFI.PawnTaggedDamageType = PawnTaggedDamageType;
					GFI.SpawnFire(HitLocation, HitNormal, LastVel);
				}

				// this is ok, since ExplosionTemplate is instanced
				ExplosionTemplate.bDirectionalExplosion = true;
			}

			// if we hit a pawn directly, set it on fire
			if (HitGP != None)
			{
				if (!WorldInfo.GRI.OnSameTeam(InstigatorController, HitGP) || HitGP.IsAHostage() || HitGP == Instigator)
				{
					// direct damage here because the delayed death is confusing to unsuspecting victims
					HitGP.TakeDamage(1500, InstigatorController, HitLocation, -HitNormal, (HitGP == TagVictim) ? PawnTaggedDamageType : class'GDT_IncendiaryGrenade',, self);
				}
			}

			// set martyring guy on fire
			if (GearPawn(MartyrVictim) != None)
			{
				GearPawn(MartyrVictim).IgnitePawn(POF_Blazing, InstigatorController, MartyrDamageType);
			}

			// set tagged guy on fire
			if (GearPawn(TagVictim) != None)
			{
				GearPawn(TagVictim).IgnitePawn(POF_Blazing, InstigatorController, PawnTaggedDamageType, 5.0);
			}

			//DrawDebugCoordinateSystem(GEA.Location, GetExplosionParticleSystemRot(LastVel, HitNormal), 32.f, TRUE);
		}

		// this needs to happen last
		GEA = Super.TriggerExplosion(HitLocation, HitNormal, HitActor);
	}

	return GEA;
}

simulated protected function PrepareExplosionActor(GearExplosionActor GEA)
{
	super.PrepareExplosionActor(GEA);

	GEA.SetParticleSystemRotation(GetExplosionParticleSystemRot(LastVel, LastHitNormal));
}

// avoidance cylinder lives on the emitter
function SetupAvoidanceCylinder();

static function float GetAIEffectiveRadius()
{
	// rough estimate of fire spread.  can vary significantly.
	return 250.f;
}

simulated function vector GetExplosionDirection(vector HitNormal)
{
	return LastVel - HitNormal * (LastVel Dot HitNormal);
}


defaultproperties
{
	InFlightSoundTemplate=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_InAirLoop_Cue'
	GrenadeAttachingToFoeSound=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_StickEnemy_Cue'
	GrenadeAttachingToWorldSound=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_StickSurface_Cue'
	BeepBeepAboutToExplodeSound=SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_Warning_Cue'
	GrenadeBounceSound=None

	Begin Object Class=SkeletalMeshComponent Name=GrenadeMesh0
		SkeletalMesh=SkeletalMesh'COG_IncendiaryGrenade.Mesh.SK_Incendiary_Grenade'
		PhysicsAsset=PhysicsAsset'COG_Bolo_Grenade.Frag_Grenade_Physics'
		AnimTreeTemplate=AnimTree'COG_Bolo_Grenade.Animations.AT_BoloGrenade'
		AnimSets(0)=AnimSet'COG_Bolo_Grenade.GrenadeAnims'
		BlockActors=false
		bCastDynamicShadow=false
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		CollideActors=true
		BlockRigidBody=true
		RBCollideWithChannels=(Default=true,Untitled2=true)
		Scale=1.5
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=false
	End Object
	Mesh=GrenadeMesh0
	Components.Add(GrenadeMesh0)

	TrailTemplate=ParticleSystem'COG_IncendiaryGrenade.Effects.P_Incendiary_Trail'

//	SmokeEmitterClass=class'Emit_IncendiaryGrenade'

	MartyrDamageType=class'GDT_IncendiaryMartyr'	// Martyr explosion
	TaggedDamageType=class'GDT_IncendiarySticky'	// Stuck to wall explosion
	PawnTaggedDamageType=class'GDT_IncendiaryTag'	// Stuck to player explosion

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_IncendiaryGrenade'
		MomentumTransferScale=0.0	// Scale momentum defined in DamageType

		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.IncendiaryGrenade.IncendiaryGrenade_Proj_Explo'

		bCausesFracture=false
		bUseMapSpecificValues=true
	End Object
	ExplosionTemplate=ExploTemplate0

	BouncyFireSpawnDownwardBias=0.2f

	CircularPatternDotThreshold=-0.55f
	CircularMinDistanceFromInstigator=512

	BouncyEmitterClass=class'Emit_BouncyFire'
	GrenadeTagPreExplosionSmokeEffectPlanted=ParticleSystem'COG_IncendiaryGrenade.Effects.P_Incendiary_WallTag_Smoke'
}
