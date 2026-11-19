/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_InkGrenade extends GearProj_Grenade;

var() const protected float FloorZExplosionThreshold;
var protected transient vector LastVel;
var protected const class<Emit_BouncyFire> BouncyEmitterClass;

/** Smaller dots than this get the circular pattern.  Wedge pattern otherwise. */
var() protected const float CircularPatternDotThreshold;
var() protected const float CircularMinDistanceFromInstigator;



simulated protected function bool ShouldDoCircularPattern(vector HitNormal, vector HitLocation, GearPawn HitGP)
{
	if (HitGP != None || TagVictim != None)
	{
		return TRUE;
	}

//	`log("dot"@Normal(LastVel) dot HitNormal);
	if ( ((Normal(LastVel) dot HitNormal) < CircularPatternDotThreshold)        // direct-enough of a hit
		 && ( (Instigator != None) && (VSize(HitLocation - Instigator.Location) > CircularMinDistanceFromInstigator) ) )      // and not too close to thrower
	{
		return TRUE;
	}

	return FALSE;
}

simulated function Tick(float DeltaTime)
{
	// track last velocity
	LastVel = (TagVictim != None) ? TagVictim.Velocity : Velocity;

	Super.Tick(DeltaTime);
}

simulated function vector GetHeadFacingDir()
{
	// ink grenade mesh is reversed
	return -Super.GetHeadFacingDir();
}

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local GearPawn HitGP;
	local GearExplosionActor GEA;
	local GearFireInfo GII;
	local vector InkSpawnLoc, ImpactVel;

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

			// place core effect at impact (do in gearinkinfo)
			InkSpawnLoc = HitLocation;

			if (TagVictim != None)
			{
				ImpactVel = vect(0,0,-1) * Speed;
				HitNormal = vect(0,0,1);

				if ( Pawn(TagVictim) == None )
				{
					// world tagged, move out from wall
					InkSpawnLoc += GetHeadFacingDir() * 80;
				}

			}
			else if (MartyrVictim != None)
			{
				ImpactVel = vect(0,0,-1) * Speed;
				HitNormal = vect(0,0,1);
			}
			else
			{
				// using hitnormal
				ImpactVel = -HitNormal;
				ImpactVel.Z = -0.5;
				ImpactVel = Normal(ImpactVel) * Speed;
			}

			// spawn ink cloud
			if (ShouldDoCircularPattern(HitNormal, HitLocation, HitGP))
			{
				GII = Spawn(class'GearInkInfo_Circular');
				if (GII != None)
				{
					GII.InstigatorController = InstigatorController;
					GII.TagVictim = TagVictim;
					GII.TaggedDamageType = TaggedDamageType;
					GII.PawnTaggedDamageType = PawnTaggedDamageType;
					GII.SpawnFire(InkSpawnLoc, HitNormal, ImpactVel);
				}
			}
			else
			{
				// go ahead and use real last velocity
				ImpactVel = LastVel;

				GII = Spawn(class'GearInkInfo_Wedge');
				if (GII != None)
				{
					GII.InstigatorController = InstigatorController;
					GII.TagVictim = TagVictim;
					GII.TaggedDamageType = TaggedDamageType;
					GII.PawnTaggedDamageType = PawnTaggedDamageType;
					GII.SpawnFire(InkSpawnLoc, HitNormal, ImpactVel);
				}

				// this is ok, since ExplosionTemplate is instanced
				ExplosionTemplate.bDirectionalExplosion = true;
			}

			// if we hit a pawn directly, set it on fire
			if (HitGP != None)
			{
				if ( !WorldInfo.GRI.OnSameTeam(InstigatorController, HitGP) || (HitGP == Instigator) )
				{
					HitGP.IgnitePawn(POF_BlazingInk, InstigatorController, (HitGP == TagVictim) ? PawnTaggedDamageType : class'GDT_InkGrenade', 5.0);
				}
			}

			// set martyring guy on fire
			if (GearPawn(MartyrVictim) != None)
			{
				GearPawn(MartyrVictim).IgnitePawn(POF_BlazingInk, InstigatorController, MartyrDamageType);
			}

			// set tagged guy on fire
			if (GearPawn(TagVictim) != None)
			{
				GearPawn(TagVictim).IgnitePawn(POF_BlazingInk, InstigatorController, PawnTaggedDamageType, 5.0);
			}
		}
	}

	// this needs to happen last
	GEA = Super.TriggerExplosion(HitLocation, HitNormal, HitActor);

	return GEA;
}

// avoidance cylinder lives on the emitter
function SetupAvoidanceCylinder();

static function float GetAIEffectiveRadius()
{
	return 350.f;
}


simulated function Bounce(Vector HitLocation, Vector HitNormal, Actor Other)
{
	// if hit floor, explode
	if ( (HitNormal.Z > FloorZExplosionThreshold)       // hit floor
		|| (GearPawn(Other) != None)                  // hit GearPawn
		)
	{
		StopBounce(HitNormal);
		return;
	}

	super.Bounce(HitLocation, HitNormal, Other);
}


defaultproperties
{
	MartyrDamageType=class'GDT_InkMartyr'	// Martyr explosion
	TaggedDamageType=class'GDT_InkSticky'	// Stuck to wall explosion
	PawnTaggedDamageType=class'GDT_InkTag'	// Stuck to player explosion

	BouncyEmitterClass=class'Emit_BouncyInk'
	FloorZExplosionThreshold=0.7f

	CircularPatternDotThreshold=-0.4f
	CircularMinDistanceFromInstigator=400
}


